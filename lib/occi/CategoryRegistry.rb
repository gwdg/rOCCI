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

# OCCI Infrastructure classes
require 'occi/infrastructure/Compute'
require 'occi/infrastructure/Storage'
require 'occi/infrastructure/Network'
require 'occi/infrastructure/Networkinterface'
require 'occi/infrastructure/StorageLink'
require 'occi/infrastructure/Ipnetworking'
require 'occi/mixins/Reservation'


# OCCI Core classes
require 'occi/core/Action'
require 'occi/core/Category'
require 'occi/core/Entity'
require 'occi/core/Kind'
require 'occi/core/Link'
require 'occi/core/Mixin'
require 'occi/core/Resource'

# OCCI HTTP parsing
require 'occi/parser/OCCIParser'

module OCCI

  # ---------------------------------------------------------------------------------------------------------------------
  class CategoryRegistry

    # ---------------------------------------------------------------------------------------------------------------------
    # initialize and register all kinds and mixins of the OCCI Core document
    def initialize()
      @kinds = {}
      @mixins = {}
      @actions = {}
      register_kind(Core::Entity::KIND)
      register_kind(Core::Resource::KIND)
      register_kind(Core::Link::KIND)
      
      # register OCCI Infrastructure kinds
      
      register_kind(OCCI::Infrastructure::Compute::KIND)
      register_kind(OCCI::Infrastructure::Storage::KIND)
      register_kind(OCCI::Infrastructure::Network::KIND)
      register_kind(OCCI::Infrastructure::Networkinterface::KIND)
      register_kind(OCCI::Infrastructure::StorageLink::KIND)

      # register all mixins provided by this implementation

      register_mixin(OCCI::Infrastructure::Ipnetworking::MIXIN)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def register_kind(kind)
      key = kind.scheme + kind.term
      @kinds[key] = kind
      register_actions(kind.actions)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def register_mixin(mixin)
      key = mixin.scheme + mixin.term
      @mixins[key] = mixin
      register_actions(mixin.actions)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def register_actions(actions)
      actions.each do |action|
        key = action.category.scheme + action.category.term
        @actions[key] = action
      end
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def unregister(category)
      key = category.scheme + category.term
      deleted = false
      deleted = @kinds.delete(key)
      deleted = @mixins.delete(key)
      deleted = @actions.delete(key)
      $log.error("Category could not be deleted") if deleted == false
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def getKinds()
      return @kinds.values
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def getMixins()
      return @mixins.values
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def getActions()
      return @actions.values
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def getCategories()
      categories = @kinds.values + @mixins.values
      return categories
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def getKind(key)
      @kinds.fetch(key, nil)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def getMixin(key)
      @mixins.fetch(key, nil)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def getAction(key)
      @actions.fetch(key, nil)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def get_category(key)
      categories = {}
      categories.merge!(@kinds)
      categories.merge!(@mixins)
      categories.fetch(key) { raise "Category " + key + " not found" }
    end

    # ---------------------------------------------------------------------------------------------------------------------
    # Find corresponding Kind to given category string
    def get_categories_by_category_string(categoryString, filter="all")

      all_categories      = OCCI::Parser.new(categoryString).category_values
      filtered_categories = []

      all_categories.each do |category_data|
        if category_data.term != nil && category_data.scheme != nil
          key = category_data.scheme + category_data.term
          category = 
            case filter
              when "kinds"    then $categoryRegistry.getKind(key)
              when "mixins"   then $categoryRegistry.getMixin(key)
              when "actions"  then $categoryRegistry.getAction(key)
            else
              $categoryRegistry.get_category(key)
            end
          # Do not add nil values to categories array
          if category != nil
            filtered_categories << category
            $log.debug("Category found: #{category.scheme}#{category.term}")
          end
        end
      end
      return filtered_categories
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def get_mixin_by_location(location)
      getMixins().each do |mixin|
        return mixin if mixin.get_location() == location
      end
      $log.debug("mixin with location #{location} not found")
      return nil
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def get_entities_by_location(location)
      entities = []
      getCategories().each do |category|
        category.entities.each do |entity|
          entities << entity if entity.get_location()  == location
        end
      end
      return entities
    end

  end
end