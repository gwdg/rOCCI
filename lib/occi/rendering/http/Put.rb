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
      module Put

        module_function

        # ---------------------------------------------------------------------------------------------------------------------
        def self.create_mixin(request)

          $log.info("Creating user defined mixin...")
  
          mixin   = $categoryRegistry.get_categories_by_category_string(request['HTTP_CATEGORY'], filter="mixins")[0]
  
          raise OCCI::MixinAlreadyExistsError, "Mixin [#{mixin}] already exists!" unless mixin == nil
  
          mixin_category_data = OCCI::Parser.new(request['HTTP_CATEGORY']).category_value
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
        def self.add_resource_to_mixin(request, location)

          mixin = $locationRegistry.get_object_by_location(location)

          OCCI::Parser.new(request["HTTP_X_OCCI_LOCATION"]).location_values.each do |entity_location|

            entity_uri = URI.parse(entity_location)
            entity = $locationRegistry.get_object_by_location(entity_uri.path)
  
            raise "No entity found at location: #{entity_location}"                                       if entity == nil
            raise "Object referenced by uri [#{entity_location}] is not a OCCI::Core::Resource instance!" if !entity.kind_of?(OCCI::Core::Resource)
  
            $log.debug("Associating entity [#{entity}] at location #{entity_location} with mixin #{mixin}")
  
            entity.mixins << mixin
          end

        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.update_resource(request, location)
          
          # Determine set of resources to be updated
          if $locationRegistry.get_object_by_location(location).kind_of?(OCCI::Core::Resource)
            entities = [$locationRegistry.get_object_by_location(location)]
          else
            entities = $locationRegistry.get_resources_below_location(location)
          end          
          $log.info("Updating [#{entities.size}] entities...")
  
          # Update / add mixins
          if request['HTTP_CATEGORY'] != nil
            mixins = $categoryRegistry.get_categories_by_category_string(request['HTTP_CATEGORY'], filter="mixins") 
            entities.each do |entity|
              entity.mixins = mixins
            end
          end
  
          # Update / add attributes
          if request['HTTP_X_OCCI_ATTRIBUTE'] != nil
            attributes = OCCI::Parser.new(request["HTTP_X_OCCI_ATTRIBUTE"]).attributes_attr
            entities.each do |entity|
              entity.attributes.merge!(attributes)
            end          
          end
  
          # Update / add links
          if request['HTTP_LINK'] != nil
  
            links = OCCI::Parser.new(request['HTTP_LINK']).link_values
            
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

      end
    end
  end
end