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
require 'tree'

module OCCI
  module Rendering
    module HTTP
      module LocationRegistry

        # ---------------------------------------------------------------------------------------------------------------------
        private
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------
        def self.generate_key(object)
          return object.type_identifier if object.kind_of? OCCI::Core::Category
          return object.attributes["occi.core.id"] if object.kind_of? OCCI::Core::Entity
          raise "Unsupported object type: #{object.class}"
        end

        # ---------------------------------------------------------------------------------------------------------------------
        public
        # ---------------------------------------------------------------------------------------------------------------------

        # Tree like representation of http namespace
        @@registry = {}
        # Hash mapping resource keys to locations (for lookup of locations)
        @@locations = {}

        # ---------------------------------------------------------------------------------------------------------------------
        def self.register(location, object)

          raise OCCI::LocationAlreadyRegisteredException, "Location [#{@@locations[generate_key(object)]}] already registered for object [#{object}]" if @@locations[generate_key(object)] != nil
          #raise OCCI::LocationAlreadyRegisteredException, "Object [#{@@objects[location]}] already registered for location [#{location}]"              if @@objects[location] != nil
          raise "Only absolute paths (starting with '/') are supported: location provided: [#{location}])" unless location.start_with?("/")

          @@locations[generate_key(object)] = location

          @@registry[location] = {:children => [], :object => nil} if @@registry[location].nil?
          @@registry[location][:object] = object
          child = [ @@registry[location] ]
          $log.debug("### location before #{location}")
          until location == '/'
            location = location[0..location.rindex('/',-2)]
            $log.debug("### location after #{location}")
            @@registry[location] = {:children => [], :object => nil} if @@registry[location].nil?
            @@registry[location][:children] = child | @@registry[location][:children]
            child = [ @@registry[location] ]
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.unregister(location)
          raise OCCI::LocationNotRegisteredException if @@registry[location].nil?

          @@locations.delete(generate_key(@@registry[location][:object]))

          child = @@registry[location]
          @@registry.delete(location)

          until location == '/'
            location = location[0..location.rindex('/',-2)]
            @@registry[location][:children].delete(child)
            if @@registry[location][:children].empty? and @@registry[location][:object].nil?
              child = @@registry[location]
              @@registry.delete(location)
            else
              break
            end
          end

        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.get_location_of_object(object)
          return @@locations[generate_key(object)]
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.get_absolute_location_of_object(object)
          location = get_location_of_object(object)
          return $config[:server].chomp('/') + ':' + $config[:port] + location if location
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.get_object_by_location(location)
          return @@registry[location][:object] unless @@registry[location].nil?
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.get_resources_below_location(location, categories)

          resources = []
          elements = []

          elements << @@registry[location] unless @@registry[location].nil?
          until elements.empty?
            element = elements.pop
            unless element[:object].nil?
              resource = element[:object]
              resources << resource if resource.kind_of?(OCCI::Core::Entity) and categories.include?(resource.kind)
            end
            elements = element[:children] | elements
          end

          return resources
        end

        # ---------------------------------------------------------------------------------------------------------------------

      end
    end
  end
end