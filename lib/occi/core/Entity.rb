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
# Description: OCCI Core Entity
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'rubygems'
require 'uuidtools'
require 'occi/CategoryRegistry'
require 'occi/core/Attribute'
require 'occi/core/Attributes'
require 'occi/core/Kind'

module OCCI
  module Core
    
    # ---------------------------------------------------------------------------------------------------------------------
    class Entity

      # Attributes are hashes and contain key - value pairs as defined by the corresponding kind
      attr_reader   :attributes
      attr_reader   :mixins
      attr_reader   :kind
      attr_reader   :state_machine

      # Define appropriate kind
      begin
        actions     = []
        related     = []
        entity_type = self
        entities    = []

        term    = "entity"
        scheme  = "http://schemas.ogf.org/occi/core#"
        title   = "Entity"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.core.id',    mutable = false,  mandatory = true,   unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.core.title', mutable = true,   mandatory = false,  unique = true)

        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
        OCCI::CategoryRegistry.register(KIND)
      end

      # ---------------------------------------------------------------------------------------------------------------------
      private
      # ---------------------------------------------------------------------------------------------------------------------
      
      # ---------------------------------------------------------------------------------------------------------------------
      def check_attributes(new_attributes, old_attributes = nil)

        # Construct set of all attribute definitions to check against (derived from kind + mixins)
        
        # Attribute name -> attribute def
        attribute_definitions = {}
        
        # Attribute name -> category
        attribute_categories  = {}

        # Attribute definitions from kind + mixins
        categories = Category::Related::get_all_related([kind]) + Category::Related::get_all_related(mixins)

        # Attribute definitions from all mixins
        categories.each do |category|
          category.attributes.each do |name, attribute_def|
            raise "Attribute [#{name}] already defined in category [#{attribute_categories[name]}], redefinition from category [#{category}]!" if attribute_definitions.has_key?(name)
            attribute_definitions[name] = attribute_def
            attribute_categories[name]  = category            
          end
        end
        
        $log.debug("Attributes definitions to check against: #{attribute_definitions.keys}") 
        
        # Check given attributes against set of definitions

        new_attributes.each do |name, value|

          # Check for undefined attribute
          raise "Attribute [#{name}] with value [#{value}] unknown!" unless attribute_definitions.has_key?(name)

          # Check for uniqueness
          # TODO: Multi-valued attributes are currently not supported but also not needed (can easily be added as arrays in the attributes-map later on)
          if value.kind_of?(Array) && value.length > 1
            raise "Attribute [#{name}] not unique: value: [#{value}], definition in: [#{attribute_categories[name]}]!" if attribute_definitions[name].unique
          end
          
          # Check for mutability by client
          if !attribute_definitions[name].mutable && old_attributes != nil && old_attributes.has_key?(name)
            raise "Attribute [#{name}] is not mutable: old value: [#{old_attributes[name]}], new value: [#{value}]" unless old_attributes[name] == value
          end
        end
        
        # Make sure all mandatory attributes are set
        attribute_definitions.each do |name, attribute|
          if attribute.mandatory
            raise "Mandatory attribute [#{name}] not set!" unless new_attributes.has_key?(name) && new_attributes[name] != nil
          end
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------
      public
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------
      def initialize(attributes, kind, mixins)

        # Make sure UUID is UNIQUE for every entity
        # TODO: occi.core.id should not be set by user but may be set by backend during startup
        $log.debug("OCCI ID: #{attributes['occi.core.id']}")
        attributes['occi.core.id']    = UUIDTools::UUID.timestamp_create.to_s if attributes['occi.core.id'] == nil || attributes['occi.core.id'] == ""
        attributes['occi.core.title'] = "" if attributes['occi.core.title'] == nil

        @mixins     = mixins
        @kind       = kind
#        @kind_type  = "http://schemas.ogf.org/occi/core#entity"

        # Must be called AFTER kind + mixins are set
        check_attributes(attributes)

        @attributes = attributes

        kind.entities << self
        
        $log.debug("Mixins in entity #{@mixins}")
      end
      
      def finalize
        # to be implemented in backend
      end

      # ---------------------------------------------------------------------------------------------------------------------
      def delete
        # finalize resource in backend
        finalize
        
        self.mixins.each do |mixin|
          mixin.entities.delete(self)
        end
        # remove all links from this entity and from all linked entities
        links = @links.clone() if @links != []
        links.each do |link|
          $log.debug("occi.core.target #{link.attributes["occi.core.target"]}")
          target_uri = URI.parse(link.attributes["occi.core.target"])
          target = $locationRegistry.get_object_by_location(target_uri.path)
          $log.debug("Target #{target}")
          target.links.delete(link)

          $log.debug("occi.core.source #{link.attributes["occi.core.source"]}")
          source_uri = URI.parse(link.attributes["occi.core.source"])
          source = $locationRegistry.get_object_by_location(source_uri.path)
          $log.debug("Source #{source}")
          source.links.delete(link)
        end if links != nil
        kind.entities.delete(self)
        $locationRegistry.unregister_location(get_location())
      end

      # ---------------------------------------------------------------------------------------------------------------------
      def get_location
        $log.debug("Kind: #{kind}")
        $log.debug("Kind location #{OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(kind)}")
        $log.debug("ID #{attributes['occi.core.id']}")
        location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(kind) + attributes['occi.core.id']
      end

      # ---------------------------------------------------------------------------------------------------------------------
      def get_category_string
        self.kind.get_short_category_string
      end

    end
  end
end
