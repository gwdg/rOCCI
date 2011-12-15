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
# Require Ruby Gems

# gems
require 'rubygems'
require 'sinatra'
require 'logger'

# Ruby standard library
require 'uri'
require 'fileutils'

# Server configuration
require 'occi/Configuration'

##############################################################################
# Initialize logger

$stdout.sync = true
$log = Logger.new(STDOUT)

##############################################################################
# Read configuration file and set loglevel

CONFIGURATION_FILE = 'etc/occi-server.conf'

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

if !$config["NFS_SUPPORT"].nil? && ["true"].include?($config["NFS_SUPPORT"].downcase)
  $log.info("Enabling NFS storage support...")
  $nfs_support = true
else
  $log.info("Disabling NFS storage support...")
  $nfs_support = false 
end

##############################################################################
# initialize backend, currently only Dummy and OpenNebula are supported

begin
  $backend = case $config["backend"]
  when "opennebula"
    require 'occi/backend/OpenNebula'
    OCCI::Backend::OpenNebula.new()
  when "dummy" then
    require 'occi/backend/Dummy'
    OCCI::Backend::Dummy.new()
  else raise "Backend '" + $config["backend"] + "' not found"
  end
rescue RuntimeError => e
  $log.fatal "#{e}: #{e.backtrace}"
  exit 1
end

##############################################################################
# Require OCCI classes

# Exceptions
require 'occi/Exceptions'

# Category registry
require 'occi/CategoryRegistry'

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
require 'occi/infrastructure/OSTemplate'
require 'occi/infrastructure/ResourceTemplate'

# OCCI extensions
require 'occi/extensions/Reservation'
require 'occi/extensions/NFSStorage'

# OCCI HTTP rendering
require 'occi/rendering/http/Renderer'
require 'occi/rendering/http/LocationRegistry'
require 'occi/rendering/http/OCCIParser'
require 'occi/rendering/http/OCCIRequest'

##############################################################################
# Configuration of HTTP Authentication

if $config['username'] != nil and $config['password'] != nil
  use Rack::Auth::Basic, "Restricted Area" do |username, password|
    [username, password] == [$config['username'], $config['password']]
  end
end

##############################################################################
# Get existing resources from backend

$log.debug("Get existing resources from backend")
$backend.register_existing_resources

##############################################################################
# Sinatra methods for handling HTTP requests

begin
  ############################################################################
  # GET request

  get '*' do
    begin
      # render general OCCI response
      tmp = OCCI::Rendering::HTTP::Renderer.render_response(response,request)
      response = tmp

      occi_request = OCCI::Rendering::HTTP::OCCIRequest.new(request,params)

      location = request.path_info
      $log.debug("Requested location: #{location}")

      # Query interface: return all supported kinds + mixins
      if location == "/-/" or location == "/.well-known/org/ogf/occi/-/"
        $log.info("Listing all kinds and mixins ...")
        response = OCCI::Rendering::HTTP::Renderer.render_category_type(occi_request.categories,response)
        response.status = HTTP_STATUS_CODE["OK"]
        break
      end

      object = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)

      # Render exact matches referring to kinds / mixins
      if object != nil and (object.kind_of?(OCCI::Core::Kind) or object.kind_of?(OCCI::Core::Mixin))
        raise "Only mixins / kinds are supported for exact match rendering: location: #{location}; object: #{object}" if !object.instance_variable_defined?(:@entities)
        $log.info("Listing all entities for kind/mixin #{object.type_identifier} ...")
        locations = []
        object.entities.each do |entity|
          # skip entity if kind is not in requested categories
          next unless occi_request.categories.include?(entity.kind) or (occi_request.categories & entity.mixins) == occi_request.categories
          # skip entity if it doesn't contain requested attributes
          next unless (entity.attributes.keys & occi_request.attributes.keys) == occi_request.attributes.keys
          loc = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(entity)
          $log.debug("Rendering location: #{loc}")
          locations << loc
        end
        response = OCCI::Rendering::HTTP::Renderer.render_locations(locations,response)
        response.status = HTTP_STATUS_CODE["OK"]
        $log.debug(response)
        break
      end

      # Render exact matches referring to an entity
      if object != nil and object.kind_of?(OCCI::Core::Entity)
        $log.info("Rendering entity [#{object.type_identifier}] for location [#{location}] ...")
        object.refresh if object.kind_of?(OCCI::Core::Resource)
        response = OCCI::Rendering::HTTP::Renderer.render_entity(object,response)
        break
      end

      # Render locations ending with "/", which are not exact matches
      if location.end_with?("/")
        $log.info("Listing all resource instances below location: #{location}")
        #TODO: fix get_resources_below_location !
        resources = OCCI::Rendering::HTTP::LocationRegistry.get_resources_below_location(location, occi_request.categories)

        # When no resources found, return Not Found
        if resources.nil?
          response.status = HTTP_STATUS_CODE["Not Found"]
          break
        end
        locations = []
        resources.each do |resource|
          resource.refresh if resource.kind_of?(OCCI::Core::Resource)
          locations << OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(resource)
        end
        response_header = OCCI::Rendering::HTTP::Renderer.render_locations(locations,response)
        break
      end

      response.status = HTTP_STATUS_CODE["Not Found"]
      # This must be the last statement in this block, so that sinatra does not try to respond with random body content
      # (or fail utterly while trying to do that!)
      nil

    rescue Exception => e

      $log.error(e)
      response.status = HTTP_STATUS_CODE["Bad Request"]

    end
  end

  ############################################################################
  # POST request

  # Create an instance appropriate to category field and optinally link an instance to another one
  post '*' do
    begin
      # render general OCCI response

      tmp = OCCI::Rendering::HTTP::Renderer.render_response(response,request)
      response = tmp

      occi_request = OCCI::Rendering::HTTP::OCCIRequest.new(request,params)

      location = request.path_info
      $log.debug("Requested location: #{location}")

      # Create user defined mixin
      if location == "/-/" or location == "/.well-known/org/ogf/occi/-/"
        $log.info("Creating user defined mixin...")
        $log.info(occi_request.mixin)

        raise OCCI::MixinAlreadyExistsError, "Mixin already exists!" unless occi_request.mixins.empty?

        begin
          related_mixin = OCCI::CategoryRegistry.get_by_id(occi_request.mixin.related) unless occi_request.mixin.related.nil?
        rescue OCCI::CategoryNotFoundException => e
          $log.warn(e.message)
        end
        mixin = OCCI::Core::Mixin.new(occi_request.mixin.term, occi_request.mixin.scheme, occi_request.mixin.title, nil, [], related_mixin, [])
        raise OCCI::MixinCreationException, 'Cannot create mixin' if mixin.nil?
        OCCI::CategoryRegistry.register(mixin)
        OCCI::Rendering::HTTP::LocationRegistry.register(URI.parse(occi_request.mixin.location.chomp('"').reverse.chomp('"').reverse).path,mixin)
        $log.info("Mixin successfully created")
        break
      end

      # Trigger action on resource(s)
      unless occi_request.action_category.nil?
        $log.info("Triggering action on resource(s) below location #{location}")
        resources = OCCI::Rendering::HTTP::LocationRegistry.get_resources_below_location(location, OCCI::CategoryRegistry.get_all)
        method = request.env["HTTP_X_OCCI_ATTRIBUTE"]

        raise "No entities corresponding to location [#{location}] could be found!" if resources.nil?

        $log.debug("Action [#{occi_request.action_category.type_identifier}] to be triggered on [#{resources.length}] entities:")
        delegator = OCCI::ActionDelegator.instance
        resources.each do |resource|
          # TODO: check why networkinterface is showing up under /compute/
          next unless resource.kind_of?(OCCI::Core::Resource)
          resource.refresh if resource.kind_of?(OCCI::Core::Resource)
          action = nil
          resource.kind.actions.each do |existing_action|
            action = existing_action if existing_action.category == occi_request.action_category
          end
          raise "No action found for action #{occi_request.action_category.type_identifier} and resource {#{resource.kind.type_identifier}" if action.nil?
          delegator.delegate_action(action, method, resource)
        end
        break
      end

      # If kind is a link and no actions specified then create link
      if occi_request.kind.entity_type.ancestors.include?(OCCI::Core::Link)
        $log.info("Creating link...")
        target_uri = URI.parse(occi_request.attributes["occi.core.target"].chomp('"').reverse.chomp('"').reverse)
        target = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(target_uri.path)

        source_uri = URI.parse(occi_request.attributes["occi.core.source"].chomp('"').reverse.chomp('"').reverse)
        source = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(source_uri.path)

        link = occi_request.kind.entity_type.new(occi_request.attributes)
        source.links << link
        target.links << link

        link_location = link.get_location()
        OCCI::Rendering::HTTP::LocationRegistry.register(link_location, link)
        $log.debug("Link created with location: #{link_location}")
        response['Location'] = OCCI::Rendering::HTTP::LocationRegistry.get_absolute_location_of_object(link)
        break
      end unless occi_request.kind.nil?

      # Create resource
      unless occi_request.kind.nil?
        # If kind is not link and no actions specified, then create resource
        $log.info("Creating resource...")
        resource = occi_request.kind.entity_type.new(occi_request.attributes, occi_request.mixins)
        $log.debug("Resource attributes #{resource.attributes}")

        occi_request.links.each do |link|
          $log.debug(link)

          link_attributes = {}
          link_attributes = link.attributes unless link.attributes.nil?

          link_attributes["occi.core.target"] = link.target.chomp('"').reverse.chomp('"').reverse
          link_attributes["occi.core.source"] = resource.get_location

          link_mixins = []   
          link_kind = nil
          link.category.split(' ').each do |link_category|
            begin
              cat = OCCI::CategoryRegistry.get_by_id(link_category)
            rescue OCCI::CategoryNotFoundException => e
              $log.info("Category #{link_category} not found")
              next
            end
            link_kind = cat if cat.kind_of?(OCCI::Core::Kind)
            link_mixins << cat if cat.kind_of?(OCCI::Core::Mixin)
            raise "No kind found for link category #{link_category}" if link_kind.nil?
          end
            
          occi_link = link_kind.entity_type.new(link_attributes,link_mixins)
          $log.debug("Link Mixins: #{occi_link.mixins}")

          if URI.parse(link.target).relative?
            target = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(link.target)
            raise "target #{link.target} not found" if target.nil?
            target.links << occi_link
          end

          resource.links << occi_link

          OCCI::Rendering::HTTP::LocationRegistry.register(occi_link.get_location, occi_link)
        end

        resource.deploy

        $log.debug('Location:' + resource.get_location)

        OCCI::Rendering::HTTP::LocationRegistry.register(resource.get_location, resource)

        OCCI::Rendering::HTTP::Renderer.render_location(OCCI::Rendering::HTTP::LocationRegistry.get_absolute_location_of_object(resource),response)
        break
      end

      # Update resource instance(s) at the given location
      if not OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location).nil?
        entities = []
        # Determine set of resources to be updated
        if OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Resource)
          entities = [OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)]
        elsif not OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Category)
          entities = OCCI::Rendering::HTTP::LocationRegistry.get_resources_below_location(location, OCCI::CategoryRegistry.get_all)
        elsif OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Category)
          object = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)
          occi_request.locations.each do |loc|
            entities << OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(URI.parse(loc.chomp('"').reverse.chomp('"').reverse).path)
          end
        end
        $log.info("Updating [#{entities.size}] entities...")

        # add mixins
        entities.each do |entity|
          $log.debug("Adding entity: #{entity.get_location} to mixin #{object.type_identifier}")
          entity.mixins.push(object).uniq!
          object.entities.push(entity).uniq!
        end if object.kind_of?(OCCI::Core::Mixin)

        # Update / add attributes
        entities.each do |entity|
          # refresh information from backend for entities of type resource
          entity.refresh if entity.kind_of?(OCCI::Core::Resource)
          $log.debug("Adding the following attribute to mixin: #{occi_request.attributes}")
          entity.attributes.merge!(occi_request.attributes)
        end unless occi_request.attributes.empty?

        # Update / add links

        occi_request.links.each do |link_data|
          $log.debug("Extracted link data: #{link_data}")
          raise "Mandatory information missing (related | target | category)!" unless link_data.related != nil && link_data.target != nil && link_data.category != nil

          kind = OCCI::CategoryRegistry.get_categories_by_category_string(link_data.category, filter="kinds")[0]
          raise "No kind for category string: #{link_data.category}" unless kind != nil

          target_location = link_data.target_attr
          target = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(target_location)

          entities.each do |entity|

            source_location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(entity)

            attributes = link_data.attributes.clone
            attributes["occi.core.target"] = target_location.chomp('"').reverse.chomp('"').reverse
            attributes["occi.core.source"] = source_location

            link = kind.entity_type.new(attributes)
            OCCI::Rendering::HTTP::LocationRegistry.register_location(link.get_location(), link)

            target.links << link
            entity.links << link
          end
        end
        break
      end

      response.status  = HTTP_STATUS_CODE["Not Found"]
      # This must be the last statement in this block, so that sinatra does not try to respond with random body content
      # (or fail utterly while trying to do that!)
      nil

    rescue OCCI::LocationAlreadyRegisteredException => e
      $log.error(e.message)
      response.status = HTTP_STATUS_CODE["Conflict"]

    rescue OCCI::MixinCreationException => e
      $log.error(e.message)

    rescue Exception => e

      $log.error(e)
      response.status  = HTTP_STATUS_CODE["Bad Request"]

    end
  end

  ############################################################################
  # PUT request

  put '*' do
    begin
      # render general OCCI response
      tmp = OCCI::Rendering::HTTP::Renderer.render_response(response,request)
      response = tmp

      occi_request = OCCI::Rendering::HTTP::OCCIRequest.new(request,params)

      location = request.path_info
      $log.debug("Requested location: #{location}")

      # Add an resource instance to a mixin
      unless occi_request.mixins.empty?
        mixin = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)

        occi_request.locations.each do |location|
          entity = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(URI.parse(location).path)

          raise "No entity found at location: #{entity_location}"                                       if entity == nil
          raise "Object referenced by uri [#{entity_location}] is not a OCCI::Core::Resource instance!" if !entity.kind_of?(OCCI::Core::Resource)

          $log.debug("Associating entity [#{entity}] at location #{entity_location} with mixin #{mixin}")

          entity.mixins << mixin
        end
        break
      end

      # Update resource instance(s) at the given location
      if not OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location).nil?
        entities = []
        # Determine set of resources to be updated
        if OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Resource)
          entities = [OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)]
        elsif not OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Category)
          entities = OCCI::Rendering::HTTP::LocationRegistry.get_resources_below_location(location, OCCI::CategoryRegistry.get_all)
        elsif OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Category)
          object = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)
          occi_request.locations.each do |loc|
            entities << OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(URI.parse(loc.chomp('"').reverse.chomp('"').reverse).path)
          end
        end
        $log.info("Full update for [#{entities.size}] entities...")

        # full update of mixins
        object.entities.each do |entity|
          entity.mixins.delete(object)  
          object.entities.delete(entity)
        end if object.kind_of?(OCCI::Core::Mixin)
        
        entities.each do |entity|
          $log.debug("Adding entity: #{entity.get_location} to mixin #{object.type_identifier}")
          entity.mixins.push(object).uniq!
          object.entities.push(entity).uniq!
        end if object.kind_of?(OCCI::Core::Mixin)

        # full update of attributes
        entities.each do |entity|
          # refresh information from backend for entities of type resource
          # TODO: full update
          entity.attributes.merge!(occi_request.attributes)
          # TODO: update entity in backend
        end unless occi_request.attributes.empty?

        # full update of links
        # TODO: full update e.g. delete old links first
        occi_request.links.each do |link_data|
          $log.debug("Extracted link data: #{link_data}")
          raise "Mandatory information missing (related | target | category)!" unless link_data.related != nil && link_data.target != nil && link_data.category != nil

          link_mixins = []  
          link_kind = nil 
          link_data.category.split(' ').each do |link_category|
            begin
              cat = OCCI::CategoryRegistry.get_by_id(link_category)
            rescue OCCI::CategoryNotFoundException => e
              $log.info("Category #{link_category} not found")
              next
            end
            link_kind = cat if cat.kind_of?(OCCI::Core::Kind)
            link_mixins << cat if cat.kind_of?(OCCI::Core::Mixin)
          end
            
          raise "No kind for link category #{link_data.category} found" if link_kind.nil?

          target_location = link_data.target_attr
          target = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(target_location)

          entities.each do |entity|

            source_location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(entity)

            link_attributes = link_data.attributes.clone
            link_attributes["occi.core.target"] = target_location.chomp('"').reverse.chomp('"').reverse
            link_attributes["occi.core.source"] = source_location

            link = link_kind.entity_type.new(link_attributes,link_mixins)
            OCCI::Rendering::HTTP::LocationRegistry.register_location(link.get_location(), link)

            target.links << link
            entity.links << link
          end
        end
        break
      end

      response.status  = HTTP_STATUS_CODE["Not Found"]
      # Create resource instance at the given location
      raise "Creating resources with method 'put' is currently not possible!"

      # This must be the last statement in this block, so that sinatra does not try to respond with random body content
      # (or fail utterly while trying to do that!)
      nil

    rescue OCCI::LocationAlreadyRegisteredException => e
      $log.error(e.message)
      response.status = HTTP_STATUS_CODE["Conflict"]

    rescue OCCI::MixinAlreadyExistsError => e

      $log.error(e.message)
      response.status  = HTTP_STATUS_CODE["Conflict"]

    rescue Exception => e

      $log.error(e)
      response.status = HTTP_STATUS_CODE["Bad Request"]

    end
  end

  ############################################################################
  # DELETE request

  delete '*' do
    begin
      tmp = OCCI::Rendering::HTTP::Renderer.render_response(response,request)
      response = tmp

      occi_request = OCCI::Rendering::HTTP::OCCIRequest.new(request,params)

      location = request.path_info
      $log.debug("Requested location: #{location}")

      # Location references query interface => delete provided mixin
      if location == "/-/" or location == "/.well-known/org/ogf/occi/-/"
        raise OCCI::CategoryMissingException if occi_request.mixin.nil?
        raise OCCI::MixinNotFoundException if occi_request.mixins.empty?
        occi_request.mixins.each do |mixin|
          $log.info("Deleting mixin #{mixin.type_identifier}")
          mixin.entities.each do |entity|
            entity.delete(mixin)
          end
          OCCI::CategoryRegistry.unregister(mixin)
          OCCI::Rendering::HTTP::LocationRegistry.unregister(OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(mixin))
        end
        break
      end

      # Location references a mixin => unassociate all provided resources (by X_OCCI_LOCATION) from it
      object = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)
      if object != nil && object.kind_of?(OCCI::Core::Mixin)
        mixin = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)
        $log.info("Unassociating entities from mixin: #{mixin}")

        occi_request.locations.each do |loc|
          entity = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(URI.parse(loc.chomp('"').reverse.chomp('"').reverse).path)
          mixin.entities.delete(entity)
          entity.mixins.delete(mixin)
        end
        break
      end

      # Determine set of resources to be deleted
      object = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)

      if object.kind_of? OCCI::Core::Entity
        entities = [OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(location)]
      else
        entities = OCCI::Rendering::HTTP::LocationRegistry.get_resources_below_location(location,occi_request.categories)
      end

      if not entities.nil?
        entities.each do |entity|
          location = entity.get_location
          entity.delete
          OCCI::Rendering::HTTP::LocationRegistry.unregister(location)
        end
        break
      end

      response.status = HTTP_STATUS_CODE["Not Found"]
      # This must be the last statement in this block, so that sinatra does not try to respond with random body content
      # (or fail utterly while trying to do that!)
      nil

    rescue OCCI::CategoryMissingException => e
      response.status = HTTP_STATUS_CODE["Bad Request"]

    rescue OCCI::MixinNotFoundException => e
      response.status = HTTP_STATUS_CODE["Not Found"]

    rescue Exception => e

      $log.error(e)
      response.status = HTTP_STATUS_CODE["Bad Request"]
    end
  end
end