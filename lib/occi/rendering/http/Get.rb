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
      module Get

        module_function

        # ---------------------------------------------------------------------------------------------------------------------
        def query_interface_list_all(request_header)

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
        def type_list_resources(request_header, location)
        
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
        def resource_render(location)
  
          entity = $locationRegistry.get_object_by_location(location)
  
          $log.info("Rendering resource [#{entity}] for location [#{location}]...")
  
          return OCCI::Rendering::HTTP::Renderer.render_resource(entity)
        end
  
        # ---------------------------------------------------------------------------------------------------------------------
        def resources_list(request_header, location)
  
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
        
      end
    end
  end
end