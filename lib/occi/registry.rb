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
# Description: registry for all Category/Kind/Mixin instances currently
#              known to the OCCI server
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/log'

module OCCI
  # ---------------------------------------------------------------------------------------------------------------------
  module Registry

    @@categories = {}
    @@locations = {}

    def self.reset()
      @@categories.each_value.each {|category| category.entities = [] if category.entities}
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def self.register(category)
      OCCI::Log.debug("### Registering category #{category.type_identifier}")
      @@categories[category.type_identifier] = category
      @@locations[category.location] = category.type_identifier unless category.kind_of?(OCCI::Core::Action)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def self.unregister(category)
      OCCI::Log.debug("### Unregistering category #{category.type_identifier}")
      @@categories.delete(category.type_identifier)
      @@locations.delete(category.location) unless category.kind_of?(OCCI :Core::Action)
    end

    # Returns the category corresponding to a given type identifier
    #
    # @param [URI] type identifier of a category
    def self.get_by_id(id)
      @@categories.fetch(id) { OCCI::Log.debug("Category with id #{id} not found"); nil }
    end

    # Returns the category corresponding to a given location
    #
    # @param [URI] Location of a category
    def self.get_by_location(location)
      id = @@locations.fetch(location) { OCCI::Log.debug("Category with location #{location} not found"); nil }
      self.get_by_id(id)
    end

    # Return all categories from category registry. If filter is present, return only the categories specified by filter
    #
    # @param [Hashie:Hash] filter
    # @return [Hashie::Mash] collection
    def self.get(filter = [])
      collection = Hashie::Mash.new({:kinds => [], :mixins => [], :actions => []})
      filter.each do |cat|
        category = get_by_id(cat.type_identifier)
        collection.kinds << category if category.kind_of?(OCCI::Core::Kind)
        collection.mixins << category if category.kind_of?(OCCI::Core::Mixin)
        collection.actions << category if category.kind_of?(OCCI::Core::Action)
      end
      if filter.empty?
        @@categories.each_value do |category|
          collection.kinds << category if category.kind_of? OCCI::Core::Kind
          collection.mixins << category if category.kind_of? OCCI::Core::Mixin
          collection.actions << category if category.kind_of? OCCI::Core::Action
        end
      end
      return collection
    end
  end
end