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
      $log.error("Invalid request url: #{location}")
      response.status = HTTP_STATUS_CODE["Bad Request"]

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

      if request.env['HTTP_CATEGORY'] != nil
        
        # Test grammer based parsing
        category = OCCI::Parser.new(request.env['HTTP_CATEGORY']).category_values
        $log.debug("*** Parsed category: " + category.to_s)
        
        # Get first kind from supplied category string
        kind    = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="kinds")[0]
        action  = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="actions")[0]
        raise "Kind/Action not found in category!" if kind == nil && action == nil
      else
        raise "No Category provided in request!"
      end

      $log.debug("Kind found: #{kind.term}") if kind != nil
      $log.debug("Action found: #{action.category.title}") if action != nil

      if request.query_string() != ""
        regexp = Regexp.new(/action=([^&]*)/)
        action_params = regexp.match(request.query_string())

        if action_params != ""
          $log.debug("Action from query string: #{action_params}")
          entities = $locationRegistry.get_resources_below_location(location)
          method = request.env["HTTP_X_OCCI_ATTRIBUTE"]
          if entities != nil
            # TODO trigger action!
            #            action.trigger(entities,method)
            $log.debug("Action [#{action}] to be triggered on [#{entities.length}] entities:")
            delegator = OCCI::ActionDelegator.instance
            entities.each do |entity|
              delegator.delegate_action(action, method, entity)
            end
          else
            raise "No entities corresponding to location [#{location}] could be found!"
          end
        else
          raise "Action matching failed!"
        end

      elsif kind == OCCI::Core::Link::KIND or kind.related.include?(OCCI::Core::Link::KIND) # if kind is a link and no actions specified then create link
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
        request.env['HTTP_LINK'].split(',').each do |link_string|
          $log.debug("Requested link: #{link_string}")
          attributes = {}
          target_location = link_string.scan(/<([^>]*)>;/).transpose.to_s
          related = link_string.scan(/rel="([^"]*)";/).transpose.to_s
          self_string = link_string.scan(/self="([^"]*)";/).transpose.to_s
          category_string = link_string.scan(/category="([^"]*)";/).transpose.to_s
          link_attributes = link_string.scan(/category="[^"]*";\s*([^$]*)/).transpose.to_s
          link_attributes.split(';').each do |attribute_string|
            key, value = attribute_string.split('=')
            attributes[key] = value
          end if link_attributes != ""
          $log.debug("target: #{target_location}")
          $log.debug("category: #{category_string}")
          if target_location != "" && category_string != ""
            kind = $categoryRegistry.getKind(category_string)
            $log.debug("Link kind found: #{kind.scheme}#{kind.term}") if kind != nil

            if kind != nil
              target = $locationRegistry.get_object_by_location(target_location)
              raise "Target not found" if target == nil
              source = resource
              attributes["occi.core.target"] = target_location
              attributes["occi.core.source"] = source.get_location()
              link = kind.entity_type.new(attributes)
              source.links << link
              target.links << link
              $locationRegistry.register_location(link.get_location(), link)
              $log.debug("Link successfully created")
            else
              raise "Kind not found in category!"
            end

          else
            raise "Extracting information from Link failed!"
          end
        end if request.env['HTTP_LINK'] != nil

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

        if kind == nil && action == nil && action == nil && location != "/-/"
          $log.error("Kind/Action not found in category")
          response.status  = HTTP_STATUS_CODE["Bad Request"]
          break
        end
      end

      if location == "/-/" # create user defined mixin
        if mixin == nil
          term, scheme, kind, params = Regexp.new(/(\w+);\s*scheme="([^"]+)";\s*class="([^"]+)";(.*)/).match(request.env['HTTP_CATEGORY']).captures
          $log.debug(term + scheme + kind + params)
          title_match = Regexp.new(/title="([^"]*)"/).match(params)
          title = title_match.captures[0] if title_match != nil
          related_match = Regexp.new(/rel="([^"]*)"/).match(params)
          related = related_match.captures[0] if related_match != nil
          loc_match = Regexp.new(/location=([^;]*)/).match(params)
          loc = loc_match.captures[0] if loc_match != nil
          attributes_match = Regexp.new(/attributes="([^"]*)"/).match(params)
          attributes = attributes_match.captures[0] if attributes_match != nil
          actions_match = Regexp.new(/actions="([^"]*)"/).match(params)
          actions = actions_match.captures[0] if actions_match != nil
          entities = []

          rel = $categoryRegistry.get_categories_by_category_string(related, filter="mixins")[0] if related != nil
          if rel == nil
            $log.error("Related Mixin could not be found")
            response.status  = HTTP_STATUS_CODE["Bad Request"]
          end

          $log.debug("Params matched from category:")
          $log.debug("Title: #{title}")
          $log.debug("Related: #{related}")
          $log.debug("Location: #{loc}")
          $log.debug("Attributes: #{attributes}")
          $log.debug("Actions: #{actions}")

          if term != nil && scheme != nil && kind != nil && loc != nil
            mixin = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, rel, entities)
            $categoryRegistry.register_mixin(mixin)
            $locationRegistry.register_location(mixin.get_location(), mixin)
          else
            $log.error("Mixin definition contains errors")
            response.status  = HTTP_STATUS_CODE["Bad Request"]
            break
          end
        else
          $log.debug("Mixin #{mixin}")
          $log.error("Mixin already exists")
          response.status  = HTTP_STATUS_CODE["Conflict"]
          break
        end
      else # operation on resource
        mixin = $locationRegistry.get_object_by_location(location)
        if mixin != nil && mixin.kind_of?(OCCI::Core::Mixin)
          request.env["HTTP_X_OCCI_LOCATION"].split(",").each do |entity_location|

            entity_uri = URI.parse(entity_location)
            entity = $locationRegistry.get_object_by_location(entity_uri.path)

            raise "No entity found at location: #{entity_location}"                                       if entity == nil
            raise "Object referenced by uri [#{entity_location}] is not a OCCI::Core::Resource instance!" if !entity.kind_of?(OCCI::Core::Resource)

            $log.debug("Associating entity [#{entity}] at location #{entity_location} with mixin #{mixin}")

            entity.mixins << mixin
          end if request.env["HTTP_X_OCCI_LOCATION"] != nil
        else
          entities, exact_match = get_entities_by_location_from_categories(location,$categoryRegistry.getKinds)
          $log.debug("Put Attributes/Links/Mixins to entities")
          $log.debug(entities)
          if entities != []
            # update/add mixins
            mixins = []
            mixins = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="mixins") if request.env['HTTP_CATEGORY'] != nil
            entities.each do |entity|
              entity.mixins << mixins if mixins != []
            end
            # update/add attributes
            attributes = request.env['HTTP_X_OCCI_ATTRIBUTE'].split(',') if request.env['HTTP_X_OCCI_ATTRIBUTE'] != nil
            attributes.each do |attribute|
              key, value = attribute.split('=')
              entities.each do |entity|
                $log.debug("Entity #{entity}")
                entity.attributes[key] = value
              end
            end
            # update/add links
            request.env['HTTP_LINK'].split(',').each do |link_string|
              $log.debug("Requested link: #{link_string}")
              attributes = {}
              regexp = Regexp.new(/<([^>]*)>;\s*rel="([^"]*)";\s*category="([^"]*)";\s*([^$]*)/)
              match_link = regexp.match(link_string)
              if match_link != nil
                target_location, related, source_location, category_string, params = match_link.captures
                kind = $categoryRegistry.get_categories_by_category_string(category_string, filter="kinds")[0]

                regexp = Regexp.new(/([^;]*;\s*)/)
                match_params = regexp.match(params)
                if match_params != nil
                  match.each do |attribute_string|
                    key, value = attribute_string.split('=')
                    attributes[key] = value
                  end
                  if kind != nil
                    target = $locationRegistry.get_object_by_location(target_location)
                    attributes["occi.core.target"] = target_location
                    attributes["occi.core.source"] = source_location
                    link = kind.entity_type.new(attributes)
                    $locationRegistry.register_location(link.get_location(), link)
                    entities.each do |entity|
                      entity.links << link
                    end
                    target.links << link
                    $log.debug("Link successfully created!")
                  else
                    raise "Kind not found in category!"
                  end
                else
                  raise "Could not extract parameters from request!"
                end
              else
                raise "Extracting information from Link failed"
              end
            end if request.env['HTTP_LINK'] != nil
          else
            raise "Putting resources is currently not allowed"
          end
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
