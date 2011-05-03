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
require 'occi/core/Attribute'
require 'occi/core/Attributes'
require 'occi/core/Kind'

module OCCI
  module Core
    class Entity

      # Attributes are hashes and contain key - value pairs as defined by the corresponding kind
      attr_reader   :attributes
      attr_reader   :mixins

      attr_reader   :kind_type
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
      end


      def initialize(attributes)
        # Make sure UUID is UNIQUE for every entity
        attributes['occi.core.id']    = UUIDTools::UUID.timestamp_create.to_s
        attributes['occi.core.title'] = "" if attributes['occi.core.title'] == nil
        @attributes = attributes
        @mixins = []
        @kind_type = "http://schemas.ogf.org/occi/core#entity"
        kind.entities << self
      end
      
      def delete()
        $log.debug("Deleting entity with location #{get_location}")
        delete_entity()
      end
      
      def delete_entity()
        self.mixins.each do |mixin|
          mixin.entities.delete(self)
        end
        # remove all links from this entity and from all linked entities
        links = @attributes['links'].clone() if @attributes['links'] != nil
        links.each do |link|
          $log.debug("occi.core.target #{link.attributes["occi.core.target"]}")
          target_uri = URI.parse(link.attributes["occi.core.target"])
          target = $locationRegistry.get_object_by_location(target_uri.path) 
          $log.debug("Target #{target}")
          target.attributes['links'].delete(link)

          $log.debug("occi.core.source #{link.attributes["occi.core.source"]}")
          source_uri = URI.parse(link.attributes["occi.core.source"])
          source = $locationRegistry.get_object_by_location(source_uri.path) 
          $log.debug("Source #{source}")
          source.attributes['links'].delete(link)
        end if links != nil
        kind.entities.delete(self)
        $locationRegistry.unregister_location(get_location())
      end
      
      def get_location()
        location = $locationRegistry.get_location_of_object(kind) + attributes['occi.core.id']
      end
      
      def get_category_string()
        self.class.getKind.get_short_category_string()
      end

      def kind()
        return $categoryRegistry.getKind(@kind_type)
      end

    end
  end
end