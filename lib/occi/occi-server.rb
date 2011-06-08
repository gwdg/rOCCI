##############################################################################
#  Copyright 2011 Service Computing group, TU Dortmund
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##############################################################################

##############################################################################
# Description: OCCI RESTful Web Service
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

##############################################################################
# Require Ruby Gems and OCCI classes

# gems
require 'rubygems'
require 'sinatra'
require 'logger'

# Ruby standard library
require 'uri'

# Server configuration
require 'occi/Configuration'

# Registry for all OCCI Categories
require 'occi/CategoryRegistry'

# Exceptions
require 'occi/Exceptions'

# OCCI Core classes
require 'occi/core/Action'
require 'occi/core/Category'
require 'occi/core/Entity'
require 'occi/core/Kind'
require 'occi/core/Link'
require 'occi/core/Mixin'
require 'occi/core/Resource'

# OCCI Infrastructure classes
require 'occi/infrastructure/Compute'
require 'occi/infrastructure/Storage'
require 'occi/infrastructure/Network'
require 'occi/infrastructure/Networkinterface'
require 'occi/infrastructure/StorageLink'
require 'occi/infrastructure/Ipnetworking'
require 'occi/mixins/Reservation'

# OCCI HTTP rendering
require 'occi/rendering/http/Get'
require 'occi/rendering/http/Put'
require 'occi/rendering/http/Post'
require 'occi/rendering/http/Delete'
require 'occi/rendering/http/Renderer'
require 'occi/rendering/http/LocationRegistry'
require 'occi/rendering/http/OCCIParser'

##############################################################################
# Initialize logger

$stdout.sync = true
$log = Logger.new(STDOUT)

##############################################################################
# Read configuration file and set loglevel

if ARGV[0] != nil
  CONFIGURATION_FILE = ARGV[0]
else
  $log.error("A configuration file needs to be provided in the arguments for occi-server")
  break
end

## initialize temporary image path
$image_path = ""

$config = OCCI::Configuration.new(CONFIGURATION_FILE)

if $config['LOG_LEVEL'] != nil
  $log.level = case $config['LOG_LEVEL'].upcase
  when 'FATAL' then Logger::FATAL
  when 'ERROR' then Logger::ERROR
  when 'WARN' then Logger::WARN
  when 'INFO' then Logger::INFO
  when 'DEBUG' then Logger::DEBUG
  else
    $log.warn("Invalid loglevel specified. Loglevel set to INFO")
    Logger::INFO
  end
end

##############################################################################
# registry for all categories (e.g. kinds, mixins, actions)
$categoryRegistry = OCCI::CategoryRegistry.new

##############################################################################
# registry for the locations of all OCCI objects
$locationRegistry = OCCI::Rendering::HTTP::LocationRegistry.new

$locationRegistry.register_location("/link/",             OCCI::Core::Link::KIND)

$locationRegistry.register_location("/compute/",          OCCI::Infrastructure::Compute::KIND)
$locationRegistry.register_location("/storage/",          OCCI::Infrastructure::Storage::KIND)
$locationRegistry.register_location("/network/",          OCCI::Infrastructure::Network::KIND)

$locationRegistry.register_location("/networkinterface/", OCCI::Infrastructure::Networkinterface::KIND)
$locationRegistry.register_location("/storagelink/",      OCCI::Infrastructure::StorageLink::KIND)

$locationRegistry.register_location("/ipnetworking/",     OCCI::Infrastructure::Ipnetworking::MIXIN)

##############################################################################
# initialize backend, currently only Dummy and OpenNebula are supported

begin
  $backend = case $config["backend"]
  when "opennebula"
    require 'occi/backend/OpenNebulaBackend'
    OCCI::Backend::OpenNebulaBackend.new($config['OPENNEBULA_CONFIG'])
  when "dummy" then
    require 'occi/backend/DummyBackend'
    OCCI::Backend::DummyBackend.new()
  else raise "Backend '" + $config["backend"] + "' not found"
  end
rescue RuntimeError => e
  $log.fatal "#{e}: #{e.backtrace}"
  exit 1
end
$backend.print_configuration

##############################################################################
# Configuration of Sinatra web application framework

set :host, $config["server"]
set :port, $config["port"]
# use mongrel server
set :server, %w[mongrel]
set :run, true

##############################################################################
# Configuration of HTTP Authentication

if $config['username'] != nil and $config['password'] != nil
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == [$config['username'], $config['password']]
  end
end

##############################################################################
# Sinatra methods for handling HTTP requests

begin

  ############################################################################
  # GET request

  get '*' do
    begin

      headers = {}

      location = request.path_info
      $log.debug("Requested location: #{location}")

      $locationRegistry.dump_contexts

      # Query interface: return all supported kinds + mixins
      if location == "/-/"
        headers = OCCI::Rendering::HTTP::Get.query_interface_list_all(request.env)
        break
      end

      # Render exact matches referring to kinds / mixins
      if $locationRegistry.get_object_by_location(location) != nil && $locationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Category)
        headers = OCCI::Rendering::HTTP::Get.type_list_resources(request.env, location)
        break
      end

      # Render exact matches referring to resources
      if $locationRegistry.get_object_by_location(location) != nil && $locationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Resource)
        headers = OCCI::Rendering::HTTP::Get.resource_render(location)
        break
      end

      # Render locations ending with "/", which are not exact matches
      if location.end_with?("/")
        headers = OCCI::Rendering::HTTP::Get.resources_list(request.env, location)
        break
      end

      # Invalid request url
      raise "Invalid request url: #{location}"

      # This must be the last statement in this block, so that sinatra does not try to respond with random body content
      # (or fail utterly while trying to do that!)
      nil

    rescue Exception => e

      $log.error(e)
      response.status = HTTP_STATUS_CODE["Bad Request"]

    ensure
      OCCI::Rendering::HTTP::Renderer.render_response(headers, response, request)
    end
  end

  ############################################################################
  # POST request

  # Create an instance appropriate to category field and optinally link an instance to another one
  post '*' do
    begin
      headers = {}

      location = request.path_info
      $log.debug("Requested location: #{location}")

      if params['file'] != nil
        $log.debug("Location of Image #{params['file'][:tempfile].path}")
        $image_path = params['file'][:tempfile].path
      end

      $log.debug("HTTP Category string: #{request.env['HTTP_CATEGORY']}")
      $log.debug("Request Location #{location}")
      $log.debug("Request query string #{request.query_string()}")

      raise "No category header provided in request!" unless request.env['HTTP_CATEGORY'] != nil
        
      # Get first category from supplied category string
      kind    = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="kinds")[0]
      action  = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="actions")[0]

      raise "No valid kind / action category provided in category header!" if kind == nil && action == nil

      # Trigger action on resources(s)
      if action != nil
        OCCI::Rendering::HTTP::Post.resources_trigger_action(request.env, location)
        break;
      end  

      # If kind is a link and no actions specified then create link
      if kind == OCCI::Core::Link::KIND or kind.related.include?(OCCI::Core::Link::KIND)
        OCCI::Rendering::HTTP::Post.resource_create_link(request.env)
        break
      end

      # If kind is not link and no actions specified, then create resource
      headers = OCCI::Rendering::HTTP::Post.resource_create(request.env, location)

      # This must be the last statement in this block, so that sinatra does not try to respond with random body content
      # (or fail utterly while trying to do that!)
      nil

    rescue Exception => e

      $log.error(e)
      response.status  = HTTP_STATUS_CODE["Bad Request"]

    ensure
      OCCI::Rendering::HTTP::Renderer.render_response(headers, response, request)
      if $image_path != ""
        File.delete($image_path)
      end
      $image_path = ""
    end
  end

  ############################################################################
  # PUT request

  put '*' do
    begin
      location = request.path_info

      headers = {}

      $log.debug("HTTP Category string: #{request.env['HTTP_CATEGORY']}")
      $log.debug("Request Location #{location}")
      $log.debug("Request query string #{request.query_string()}")

      if request.env['HTTP_CATEGORY'] != nil
        # Get first kind from supplied category string
        kind    = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="kinds")[0]
        action  = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="actions")[0]

        if kind == nil && action == nil && location != "/-/"
          raise "No kind / action provided!"
        end
      end

      # Create user defined mixin
      if location == "/-/"
         OCCI::Rendering::HTTP::Put.create_mixin(request.env)       
         break
      end

      # Add an resource instance to a mixin
      mixin = $locationRegistry.get_object_by_location(location)
      if mixin != nil && mixin.kind_of?(OCCI::Core::Mixin) && request.env["HTTP_X_OCCI_LOCATION"] != nil
         OCCI::Rendering::HTTP::Put.add_resource_to_mixin(request.env, location)
        break
      end

      # Update resource instance(s) at the given location
      if $locationRegistry.get_object_by_location(location) != nil
         OCCI::Rendering::HTTP::Put.update_resource(request.env, location)
        break
      end

      # Create resource instance at the given location
      raise "Creating resources with method 'put' is currently not possible!"

      # This must be the last statement in this block, so that sinatra does not try to respond with random body content
      # (or fail utterly while trying to do that!)
      nil

    rescue OCCI::MixinAlreadyExistsError => e

      $log.error(e)
      response.status  = HTTP_STATUS_CODE["Conflict"]

    rescue Exception => e

      $log.error(e)
      response.status = HTTP_STATUS_CODE["Bad Request"]

    ensure
      OCCI::Rendering::HTTP::Renderer.render_response(headers, response, request)
    end
  end

  ############################################################################
  # DELETE request

  delete '*' do
    begin

      location = request.path_info
      
      # Location references query interface => delete provided mixin
      if location == "/-/"
        OCCI::Rendering::HTTP::Delete.delete_mixin(request.env)
        break
      end 
      
      # Location references a mixin => unassociate all provided resources (by X_OCCI_LOCATION) from it
      object = $locationRegistry.get_object_by_location(location)
      if object != nil && object.kind_of?(OCCI::Core::Mixin)
          OCCI::Rendering::HTTP::Delete.unassociate_resources_from_mixin(request.env, location)
        break
      end
      
      # Determine set of resources to be deleted
      OCCI::Rendering::HTTP::Delete.delete_entities(location)

      # This must be the last statement in this block, so that sinatra does not try to respond with random body content
      # (or fail utterly while trying to do that!)
      nil

    rescue Exception => e

      $log.error(e)
      response.status = HTTP_STATUS_CODE["Bad Request"]

    ensure
      OCCI::Rendering::HTTP::Renderer.render_response({}, response, request)
    end
  end

end

##############################################################################
# attic (old stuff)

def add_instances_from_backend_to_service
  kinds = $categoryRegistry.getKinds()
  kinds.each do |kind|
    if kind.entity_type.respond_to?(:get_ids)
      ids = kind.entity_type.get_ids
      ids.each do |id|
        attributes = kind.entity_type.getInstance_id(id)
        resource = kind.entity_type.new(attributes, nil, false)
        kind.entities << resource
      end
    end
  end
end

# get all Instances of Backend and store it in kind Objects in occi-service
add_instances_from_backend_to_service
