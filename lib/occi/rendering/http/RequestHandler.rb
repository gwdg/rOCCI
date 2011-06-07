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

# OCCI HTTP rendering
require 'occi/rendering/http/Renderer'
require 'occi/rendering/http/LocationRegistry'
require 'occi/rendering/http/OCCIParser'

module OCCI
  module Rendering
    module HTTP
      
      # ---------------------------------------------------------------------------------------------------------------------
      class RequestHandler

        # ---------------------------------------------------------------------------------------------------------------------
        def self.query_interface_list_all(request_header)

          $log.info("Triggering action on resource(s)...")

          response_header = {}

          actions     = []
          categories  = []
    
          if request_header['HTTP_CATEGORY'] != nil && request_header['HTTP_CATEGORY'] != ""
            # Find categories corresponding to supplied category string
            categories = $categoryRegistry.get_categories_by_category_string(request_header['HTTP_CATEGORY'])
          else
            categories  = $categoryRegistry.getCategories()
            actions     = $categoryRegistry.getActions()
          end
    
          categories.each do |category|
            OCCI::Rendering::HTTP::Renderer.merge_headers(response_header, OCCI::Rendering::HTTP::Renderer.render_category_type(category))
          end
    
          # Also render actions, which should not be necessary according to the spec, but makes the "test_occy.py" happy
          actions.each do |action|
            OCCI::Rendering::HTTP::Renderer.merge_headers(response_header, OCCI::Rendering::HTTP::Renderer.render_category_type(action))
          end

          return response_header
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.type_list_resources(request_header, location)
        
          category = $locationRegistry.get_object_by_location(location)
          raise "Only mixins / kinds are supported for exact match rendering: location: #{location}; object: #{category}" if !category.instance_variable_defined?(:@entities)
  
          $log.info("Kind / mixin exact match for location [#{location}]: #{category}")
  
          locations = []
          category.entities.each do |entity|
            locations << $locationRegistry.get_location_of_object(entity)
          end
  
          return OCCI::Rendering::HTTP::Renderer.render_locations(locations)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.resource_render(location)
  
          entity = $locationRegistry.get_object_by_location(location)
  
          $log.info("Rendering resource [#{entity}] for location [#{location}]...")
  
          return OCCI::Rendering::HTTP::Renderer.render_resource(entity)
        end
  
        # ---------------------------------------------------------------------------------------------------------------------
        def self.resources_list(request_header, location)
  
          $log.info("Listing all resource instances below location: #{location}")
  
          resources = $locationRegistry.get_resources_below_location(location)
          locations = []
  
          if request_header['HTTP_CATEGORY'] != nil && request_header['HTTP_CATEGORY'] != ""
  
            # Filtered version
            categories = $categoryRegistry.get_categories_by_category_string(request_header['HTTP_CATEGORY'])
  
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
  
          return OCCI::Rendering::HTTP::Renderer.render_locations(locations)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.resources_trigger_action(request_header, location)
          
          $log.info("Triggering action on resource(s)...")
          
          # Unnecessry, if we derive action term from category header
#          regexp        = Regexp.new(/action=([^&]*)/)
#          action_params = regexp.match(request.query_string())
#          raise "Could not extract action from query-string: #{request.query_string}" if action_params == nil
#          $log.debug("Action from query string: #{action_params}")
          
          action  = $categoryRegistry.get_categories_by_category_string(request_header['HTTP_CATEGORY'], filter="actions")[0]
          
          entities  = $locationRegistry.get_resources_below_location(location)
          method    = request_header["HTTP_X_OCCI_ATTRIBUTE"]
            
          raise "No entities corresponding to location [#{location}] could be found!" if entities == nil
            
          $log.debug("Action [#{action}] to be triggered on [#{entities.length}] entities:")
          delegator = OCCI::ActionDelegator.instance
          entities.each do |entity|
            delegator.delegate_action(action, method, entity)
          end
        end
  
        # ---------------------------------------------------------------------------------------------------------------------
        def self.resource_create_link(request_header)
          
          $log.info("Creating link...")
          
          kind        = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="kinds")[0]
          attributes  = request_header["HTTP_X_OCCI_ATTRIBUTE"] != nil ? OCCI::Parser.new(request_header["HTTP_X_OCCI_ATTRIBUTE"]).attributes_attr : {}
  
          $log.debug("Attributes string: " + request_header["HTTP_X_OCCI_ATTRIBUTE"])
          $log.debug("Extracted attributes of link: #{attributes}")
  
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
  
          $log.debug("Link succesfully created at location [#{link_location}]")
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.resource_create(request_header, location)
          
          $log.info("Creating resource...")  

          kind = $categoryRegistry.get_categories_by_category_string(request_header['HTTP_CATEGORY'], filter="kinds")[0]

          $log.warn("Provided location does not match location of category: #{kind.get_location} vs. #{location}") if kind.get_location != location
    
          # Get mixins
          mixins = $categoryRegistry.get_categories_by_category_string(request_header['HTTP_CATEGORY'], filter="mixins") if request_header['HTTP_CATEGORY'] != nil
    
          # Get attributes
          attributes = request_header["HTTP_X_OCCI_ATTRIBUTE"] != nil ? OCCI::Parser.new(request_header["HTTP_X_OCCI_ATTRIBUTE"]).attributes_attr : {}
    
          # Create resource
          resource = kind.entity_type.new(attributes, mixins)
    
          # Add links
          if request_header['HTTP_LINK'] != nil        
            links = OCCI::Parser.new(request_header['HTTP_LINK']).link_values
              
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

          response_header = {}
          response_header['Location'] = $locationRegistry.get_absolute_location_of_object(resource)

          return response_header
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.create_mixin(request_header)

          $log.info("Creating user defined mixin...")
  
          mixin   = $categoryRegistry.get_categories_by_category_string(request_header['HTTP_CATEGORY'], filter="mixins")[0]
  
          raise OCCI::MixinAlreadyExistsError, "Mixin [#{mixin}] already exists!" unless mixin == nil
  
          mixin_category_data = OCCI::Parser.new(request_header['HTTP_CATEGORY']).category_value
          $log.debug("Category data for mixin: #{mixin_category_data}")
  
          raise "Mandatory information missing (term | scheme | location)!" unless mixin_category_data.term != nil && mixin_category_data.scheme != nil && mixin_category_data.location != nil
          raise "Category class must be set to 'mixin'!"                    unless mixin_category_data.clazz == "mixin"
  
          raise "Location #{mixin_category_data.location} already used for another object: " + 
                $locationRegistry.get_object_by_location(mixin_category_data.location) unless $locationRegistry.get_object_by_location(mixin_category_data.location) == nil
                                                                            
          related_mixin = $categoryRegistry.get_categories_by_category_string(related, filter="mixins")[0] if mixin_category_data.related != nil
          mixin = OCCI::Core::Mixin.new(mixin_category_data.term, mixin_category_data.scheme, mixin_category_data.title, nil, [], related_mixin, [])
          $categoryRegistry.register_mixin(mixin)
          $locationRegistry.register_location(mixin_category_data.location, mixin)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.add_resource_to_mixin(request_header, location)

          mixin = $locationRegistry.get_object_by_location(location)

          OCCI::Parser.new(request_header["HTTP_X_OCCI_LOCATION"]).location_values.each do |entity_location|

            entity_uri = URI.parse(entity_location)
            entity = $locationRegistry.get_object_by_location(entity_uri.path)
  
            raise "No entity found at location: #{entity_location}"                                       if entity == nil
            raise "Object referenced by uri [#{entity_location}] is not a OCCI::Core::Resource instance!" if !entity.kind_of?(OCCI::Core::Resource)
  
            $log.debug("Associating entity [#{entity}] at location #{entity_location} with mixin #{mixin}")
  
            entity.mixins << mixin
          end

        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.update_resource(request_header, location)
          
          # Determine set of resources to be updated
          if $locationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Resource)
            entities = [$locationRegistry.get_object_by_location(location)]
          else
            entities = $locationRegistry.get_resources_below_location(location)
          end          
          $log.info("Updating [#{entities.size}] entities...")
  
          # Update / add mixins
          if request_header['HTTP_CATEGORY'] != nil
            mixins = $categoryRegistry.get_categories_by_category_string(request_header['HTTP_CATEGORY'], filter="mixins") 
            entities.each do |entity|
              entity.mixins = mixins
            end
          end
  
          # Update / add attributes
          if request_header['HTTP_X_OCCI_ATTRIBUTE'] != nil
            attributes = OCCI::Parser.new(request_header["HTTP_X_OCCI_ATTRIBUTE"]).attributes_attr
            entities.each do |entity|
              entity.attributes.merge!(attributes)
            end          
          end
  
          # Update / add links
          if request_header['HTTP_LINK'] != nil
  
            links = OCCI::Parser.new(request_header['HTTP_LINK']).link_values
            
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
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.delete_mixin(request_header)

          mixin = $categoryRegistry.get_categories_by_category_string(request_header['HTTP_CATEGORY'], filter="mixins")[0]
          $log.info("Deleting mixin #{mixin.term}")
          $locationRegistry.unregister_location(mixin.get_location())
          $categoryRegistry.unregister(mixin)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.unassociate_resources_from_mixin(request_header, location)

          object = $locationRegistry.get_object_by_location(location)
          $log.info("Unassociating entities from mixin: #{object}")

          resource_locations = request_header["HTTP_X_OCCI_LOCATION"] != nil ? OCCI::Parser.new(request_header["HTTP_X_OCCI_LOCATION"]).location_values : []
          resource_locations.each do |location|
            entity = $locationRegistry.get_object_by_location(location)
            if entity == nil
              $log.error("Could not determine entity for location: #{location}");
              next
            end
            mixin.entities.delete(entity)
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.delete_entities(location)

          object = $locationRegistry.get_object_by_location(location)

          if object.kind_of? OCCI::Core::Entity
            entities = [$locationRegistry.get_object_by_location(location)]
          else
            entities = $locationRegistry.get_resources_below_location(location)
          end

          $log.info("Deleting [#{entities.size}] entities...")
          entities.each do |entity|
            entity.delete()
          end
        end

      end
    end
  end
end
