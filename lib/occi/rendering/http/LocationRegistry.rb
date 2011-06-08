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
# Description: Registry to store all category and entitiy locations
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/core/Category'
require 'occi/core/Entity'
require 'occi/core/Resource'

module OCCI
  module Rendering
    module HTTP
      
      class LocationRegistry

        # ---------------------------------------------------------------------------------------------------------------------
        private
        # ---------------------------------------------------------------------------------------------------------------------
        
        HASH_SUFFIX = "_/hash/"

        # ---------------------------------------------------------------------------------------------------------------------
        def get_context(contexts)
          return @context_root if contexts.length <= 1
          current_context = @context_root
          contexts[0..-2].each do |context|
            $log.debug("Searching context: " + context)
            if current_context.has_key?(context + HASH_SUFFIX)
              # Matching context already exists => search there
              current_context = current_context[context + HASH_SUFFIX]
              next
            end
            # Create new context and continue there
            current_context[context + HASH_SUFFIX] = {}
            current_context = current_context[context + HASH_SUFFIX] 
          end
          return current_context
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def dump_context(context, padding)
          context.each {|key, value|
            if context[key].kind_of?(Hash)
              $log.debug("#{padding} context: #{key}")
              dump_context(context[key], padding + "   ")
              next
            end
            $log.debug("#{padding} location: #{key} : object: #{value}")
          }
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def generate_key(object)
          return object.scheme + object.term        if object.kind_of? OCCI::Core::Category
          return object.attributes["occi.core.id"]  if object.kind_of? OCCI::Core::Entity
          raise "Unsupported object type: #{object.class}"
        end

        # ---------------------------------------------------------------------------------------------------------------------        
        public
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------
        def initialize
          # Hash based representation of http namespace
          @context_root = {}
          
          # Object -> location map
          @locations    = {}
          
          # Location -> object map
          @objects      = {}
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def register_location(location, object)

          raise "Location [#{@locations[generate_key(object)]}] already registered for object [#{object}]"  if @locations[generate_key(object)] != nil
          raise "Object [#{@objects[location]}] already registered for location [#{location}]"              if @objects[location] != nil
          raise "Only absolute paths (starting with '/') are supported: location provided: [#{location}])"  unless location.start_with?("/") 

          location_elements = location[1..-1].split('/')
          context = get_context(location_elements)
          context[location_elements[-1]] = object

          @locations[generate_key(object)]  = location
          @objects[location]                = object
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def unregister_location(location)

          raise "Location [#{location}] not registered to any object" if @objects[location] == nil

          location_elements = location.split('/')
          context = get_context(location_elements[1..-1])
          context.delete(location_elements[-1])

          @locations.delete(generate_key(@objects[location]))
          @objects.delete(location)
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def get_location_of_object(object)
          return @locations[generate_key(object)]
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def get_absolute_location_of_object(object)
          return $config["server"] + ':' + $config["port"] + @locations[generate_key(object)]
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def get_object_by_location(location)
          return @objects[location]
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def get_context_for_location(location)
          return get_context(location.split('/'))
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def get_resources_below_location(location)
          context_elements_list = get_context_for_location(location).values
          resources = []
          begin
            context_element = context_elements_list.shift
            if context_element.kind_of? Hash
              context_elements_list += context_element.values
              next
            end
            # Only resources must be returned
            resources << context_element if context_element.kind_of?(OCCI::Core::Entity)
          end until context_elements_list.empty?
          # Test if there is an object directly under the requested location
          entity = get_object_by_location(location)
          resources << entity if entity != nil && entity.kind_of?(OCCI::Core::Entity)
          return resources
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def dump_contexts()
          dump_context(@context_root, "* ")
        end

        # ---------------------------------------------------------------------------------------------------------------------
        
      end
    end
  end
end