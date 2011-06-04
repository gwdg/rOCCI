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
require 'occi/rendering/http/Renderer'
require 'occi/rendering/http/LocationRegistry'

# OCCI HTTP parsing
require 'occi/parser/OCCIParser'


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

        actions     = []
        categories  = []

        if request.env['HTTP_CATEGORY'] != nil && request.env['HTTP_CATEGORY'] != ""
          # Find categories corresponding to supplied category string
          categories = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'])
        else
          categories  = $categoryRegistry.getCategories()
          actions     = $categoryRegistry.getActions()
        end

        categories.each do |category|
          OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_category_type(category))
        end

        # Also render actions, which should not be necessary according to the spec, but makes the "test_occy.py" happy
        actions.each do |action|
          OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_category_type(action))
        end

        break
      end

      # Render exact matches referring to kinds / mixins
      if $locationRegistry.get_object_by_location(location) != nil && $locationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Category)

        category = $locationRegistry.get_object_by_location(location)
        raise "Only mixins / kinds are supported for exact match rendering: location: #{location}; object: #{category}" if !category.instance_variable_defined?(:@entities)

        $log.debug("Kind / mixin exact match for location [#{location}]: #{category}")

        locations = []
        category.entities.each do |entity|
          locations << $locationRegistry.get_location_of_object(entity)
        end

        OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_locations(locations))
        break
      end

      # Render exact matches referring to resources
      if $locationRegistry.get_object_by_location(location) != nil && $locationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Resource)

        entity = $locationRegistry.get_object_by_location(location)

        $log.debug("Resource exact match for location [#{location}]: #{entity}")

        OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_resource(entity))
        break
      end

      # Render locations ending with "/", which are not exact matches
      if location.end_with?("/")

        $log.debug("Listing all resource instances below location: #{location}")

        resources = $locationRegistry.get_resources_below_location(location)
        locations = []

        if request.env['HTTP_CATEGORY'] != nil && request.env['HTTP_CATEGORY'] != ""

          # Filtered version
          categories = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'])

          filter = {}
          categories.each do |category|
            filter[category.scheme + category.term] = 1;
          end

          resources.each do |resource|
            locations << $locationRegistry.get_location_of_object(resource) if filter.has_key?(resource.kind.id)
          end

        else
          # Unfiltered version
          resources.each do |resource|
            locations << $locationRegistry.get_location_of_object(resource)
          end
        end

        OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_locations(locations))
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
      # TODO: mixins

      location = request.path_info
      $log.debug("Requested location: #{location}")

      if params['file'] != nil
        $log.debug("Location of Image #{params['file'][:tempfile].path}")
        $image_path = params['file'][:tempfile].path
      end

      headers = {}

      $log.debug("HTTP Category string: #{request.env['HTTP_CATEGORY']}")
      $log.debug("Request Location #{location}")
      $log.debug("Request query string #{request.query_string()}")

      raise "No category header provided in request!" unless request.env['HTTP_CATEGORY'] != nil
        
      # Get first kind from supplied category string
      kind    = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="kinds")[0]
      action  = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="actions")[0]

      raise "No valid kind / action provided in category header!" if kind == nil && action == nil

      $log.debug("Kind found: #{kind.term}")                if kind != nil
      $log.debug("Action found: #{action.category.title}")  if action != nil

      # Trigger action on resources(s)
      if request.query_string() != ""

        regexp        = Regexp.new(/action=([^&]*)/)
        action_params = regexp.match(request.query_string())

        raise "Could not extract action from query-string: #{request.query_string}" if action_params == nil

        $log.debug("Action from query string: #{action_params}")
        
        entities = $locationRegistry.get_resources_below_location(location)
        method = request.env["HTTP_X_OCCI_ATTRIBUTE"]
          
        raise "No entities corresponding to location [#{location}] could be found!" if entities == nil
          
        $log.debug("Action [#{action}] to be triggered on [#{entities.length}] entities:")
        delegator = OCCI::ActionDelegator.instance
        entities.each do |entity|
          delegator.delegate_action(action, method, entity)
        end
        break;
      end  

      # If kind is a link and no actions specified then create link
      if kind == OCCI::Core::Link::KIND or kind.related.include?(OCCI::Core::Link::KIND)
        attributes = {}

        request.env["HTTP_X_OCCI_ATTRIBUTE"].split(%r{,\s*}).each do |attribute_string|
          key, value = attribute_string.split('=')
          attributes[key] = value
        end if request.env["HTTP_X_OCCI_ATTRIBUTE"] != nil

        $log.debug("Attributes from Link: #{attributes}")

        target_uri = URI.parse(attributes["occi.core.target"])
        target = $locationRegistry.get_object_by_location(target_uri.path)
        $log.debug("target entity of Link: #{target}")

        source_uri = URI.parse(attributes["occi.core.source"])
        source = $locationRegistry.get_object_by_location(source_uri.path)
        $log.debug("source entity of Link: #{source}")

        link = kind.entity_type.new(attributes)
        source.links << link
        target.links << link

        link_location = link.get_location()
        $locationRegistry.register_location(link_location, link)
        headers['Location'] = $locationRegistry.get_absolute_location_of_object(link)
        $log.debug("Link with location #{link_location} succesfully created")

      else # if kind is not link and no actions specified, then create resource

        $log.warn("Provided location does not match location of category: #{kind.get_location} vs. #{location}") if kind.get_location != location

        # Add mixins
        mixins = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="mixins") if request.env['HTTP_CATEGORY'] != nil

        attributes = {}
        if request.env["HTTP_X_OCCI_ATTRIBUTE"] != nil

          # split http attributes at coma and remove whitespaces (regexp is used), create hash
          request.env["HTTP_X_OCCI_ATTRIBUTE"].split(%r{,\s*}).each do |attribute_string|
            key, value = attribute_string.split("=")
            # if key already in attributes, then create value list else just add it
            if attributes.has_key?(key)
              attributes[key] = [attributes[key],value]
            else
              attributes[key] = value
            end
          end
          # check for mandatory and unique attributes
          #kind.attributes.check(attributes)
        end

        resource = kind.entity_type.new(attributes,mixins)

        # Add links
        if request.env['HTTP_LINK'] != nil        
          links = OCCI::Parser.new(request.env['HTTP_LINK']).link_values
          
          links.each do |link_data|
            $log.debug("Creating link, extracted link data: #{link_data}")
            raise "Mandatory link information missing (related | target | category | location)!" unless link_data.related != nil && link_data.target != nil && link_data.category != nil && link_data.location != nil
                
            kind = $categoryRegistry.getKind(link_data.category)
            raise "Kind not found in category!" if kind == nil
            $log.debug("Link kind found: #{kind.scheme}#{kind.term}")

            source = resource
            target = $locationRegistry.get_object_by_location(link_data.target)
            raise "Link target not found!" if target == nil

            link_data.attributes["occi.core.target"] = link_data.target
            link_data.attributes["occi.core.source"] = source.get_location()
            
            link = kind.entity_type.new(link_data.attributes)
            
            source.links << link
            target.links << link

            $locationRegistry.register_location(link.get_location(), link)
            $log.debug("Link successfully created!")
          end
        end

        resource.deploy()

        $locationRegistry.register_location(resource.get_location, resource)

        headers['Location'] = $locationRegistry.get_absolute_location_of_object(resource)

      end

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
        mixin   = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="mixins")[0]

        if kind == nil && action == nil && location != "/-/"
          raise "No kind / action provided!"
        end
      end

      # Create user defined mixin
      if location == "/-/"
        
        $log.info("Creating user defined mixin...")

        raise OCCI::MixinAlreadyExistsError, "Mixin [#{mixin}] already exists!" unless mixin == nil

        mixin_category_data = OCCI::Parser.new(request.env['HTTP_CATEGORY']).category_value
        $log.debug("Category data for mixin: #{mixin_category_data}")

        raise "Mandatory information missing (term | scheme | location)!" unless mixin_category_data.term != nil && mixin_category_data.scheme != nil && mixin_category_data.location != nil
        raise "Category class must be set to 'mixin'!"                    unless mixin_category_data.clazz == "mixin"

        raise "Location #{mixin_category_data.location} already used for another object: " + 
              $locationRegistry.get_object_by_location(mixin_category_data.location) unless $locationRegistry.get_object_by_location(mixin_category_data.location) == nil
                                                                          
        related_mixin = $categoryRegistry.get_categories_by_category_string(related, filter="mixins")[0] if mixin_category_data.related != nil
        mixin = OCCI::Core::Mixin.new(mixin_category_data.term, mixin_category_data.scheme, mixin_category_data.title, nil, [], related_mixin, [])
        $categoryRegistry.register_mixin(mixin)
        $locationRegistry.register_location(mixin_category_data.location, mixin)

        break
      end

      # Add an resource instance to a mixin
      mixin = $locationRegistry.get_object_by_location(location)
      if mixin != nil && mixin.kind_of?(OCCI::Core::Mixin) && request.env["HTTP_X_OCCI_LOCATION"] != nil
        request.env["HTTP_X_OCCI_LOCATION"].split(",").each do |entity_location|

          entity_uri = URI.parse(entity_location)
          entity = $locationRegistry.get_object_by_location(entity_uri.path)

          raise "No entity found at location: #{entity_location}"                                       if entity == nil
          raise "Object referenced by uri [#{entity_location}] is not a OCCI::Core::Resource instance!" if !entity.kind_of?(OCCI::Core::Resource)

          $log.debug("Associating entity [#{entity}] at location #{entity_location} with mixin #{mixin}")

          entity.mixins << mixin
        end
        break
      end

      # Update resource instance(s) at the given location
      if $locationRegistry.get_object_by_location(location) != nil

        # Determine set of resources to be updated
        if $locationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Resource)
          entities = [$locationRegistry.get_object_by_location(location)]
        else
          entities = $locationRegistry.get_resources_below_location(location)
        end          
        $log.info("Updating [#{entities.size}] entities...")

        # Update / add mixins
        if request.env['HTTP_CATEGORY'] != nil
          mixins = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="mixins") 
          entities.each do |entity|
            entity.mixins = mixins
          end
        end

        # Update / add attributes
        if request.env['HTTP_X_OCCI_ATTRIBUTE'] != nil
          request.env['HTTP_X_OCCI_ATTRIBUTE'].split(',').each do |attribute|
            key, value = attribute.split('=')
            entities.each do |entity|
              entity.attributes[key] = value
            end
          end
        end

        # Update / add links
        if request.env['HTTP_LINK'] != nil

          links = OCCI::Parser.new(request.env['HTTP_LINK']).link_values
          
          links.each do |link_data|
            $log.debug("Extracted link data: #{link_data}")
            raise "Mandatory information missing (related | target | category)!" unless link_data.related != nil && link_data.target != nil && link_data.category != nil

            kind = $categoryRegistry.get_categories_by_category_string(link_data.category, filter="kinds")[0]
            raise "No kind for category string: #{link_data.category}" unless kind != nil

            entities.each do |entity|
                    
              target          = $locationRegistry.get_object_by_location(target_location)
              source_location = $locationRegistry.get_location_of_object(entity)

              attributes = link_data.attributes.clone
              attributes["occi.core.target"] = target_location
              attributes["occi.core.source"] = source_location

              link = kind.entity_type.new(attributes)
              $locationRegistry.register_location(link.get_location(), link)

              target.links << link
              entity.links << link
            end
          end
        end
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
      $log.debug("DELETE")
      headers = {}

      location          = request.path_info
      request_locations = request.env["HTTP_X_OCCI_LOCATION"]
      occi_locations    = request_locations.split(%r{,\s*}) if request_locations != nil

      $log.debug("Requested location: #{location}")

      categories = $categoryRegistry.getCategories()

      entities, exact_resource_match = get_entities_by_location_from_categories(location,categories)

      $log.debug("exact resource match: #{exact_resource_match}")

      # location is a mixin, unassociate all resources from it
      mixin = $locationRegistry.get_object_by_location(location)
      if mixin != nil && mixin.kind_of?(OCCI::Core::Mixin) then
        $log.debug("Mixin to delete")
        $log.debug(mixin)
        entities.each do |entity|
          mixin.entities.delete(entity) if occi_locations.include?(entity.get_location)
        end
      end

      if location == "/-/" # delete mixins
        mixin = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="mixins")[0]
        $log.debug("Deleting Mixin #{mixin.term}")
        $locationRegistry.unregister_location(mixin.get_location())
        $categoryRegistry.unregister(mixin)

      else # delete all entities at and below the location
        $log.debug("Entities to delete")
        entities.each do |entity|
          entity.delete()
        end
      end

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

def get_entities_by_location_from_categories(location,categories)
  exact_resource_match = false
  entities = []
  categories.each do |category|
    if category.get_location() == location then
      entities.concat(category.entities)
    else
      category.entities.each do |entity|
        exact_resource_match = true if entity.get_location() == location
        entities << entity if entity.get_location().start_with?(location)

      end
    end
  end

  $log.debug("Entities corresponding to location: #{entities.length}")
  #  $log.debug(entities)
  return [entities, exact_resource_match]
end
