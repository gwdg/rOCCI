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
      module Delete

        module_function

        # ---------------------------------------------------------------------------------------------------------------------
        def self.delete_mixin(request)

          mixin = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="mixins")[0]
          $log.info("Deleting mixin #{mixin.term}")
          $locationRegistry.unregister_location(mixin.get_location())
          $categoryRegistry.unregister(mixin)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.unassociate_resources_from_mixin(request, location)

          object = $locationRegistry.get_object_by_location(location)
          $log.info("Unassociating entities from mixin: #{object}")

          resource_locations = request.env["HTTP_X_OCCI_LOCATION"] != nil ? OCCI::Parser.new(request.env["HTTP_X_OCCI_LOCATION"]).location_values : []
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