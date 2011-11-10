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

module OCCI
  # ---------------------------------------------------------------------------------------------------------------------
  module CategoryRegistry
    
    @@categories_by_id = {}
    @@categories_by_location = {}

    # ---------------------------------------------------------------------------------------------------------------------
    def self.register(category)
      @@categories_by_id[category.type_identifier] = category
      @@categories_by_location[category.location] = category if category.respond_to?('location')
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def self.unregister(category)
      @@categories_by_id.delete(category.type_identifier)
      @@categories_by_location.delete(category.location)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def self.get_by_id(id)
      @@categories_by_id.fetch(id) { raise OCCI::CategoryNotFoundException, "Category with key " + id + " not found" }
    end

    def self.get_by_location(location)
      @@categories_by_location.fetch(location) { raise "Category with location " + location + " not found" }
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def self.get_all(categories)
      occi_categories = []
      categories.each do |category|
        id = category.scheme + category.term if category.scheme
        id = category.type_identifier if category.type_identifier
        occi_categories << self.get_by_id(id)
      end
      return occi_categories if occi_categories != [] or categories.length > 0
      return @@categories_by_id.values
    end
  end
end