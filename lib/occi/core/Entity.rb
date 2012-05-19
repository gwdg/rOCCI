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
require 'hashie'
require 'occi/registry'
require 'occi/core/attributes'
require 'occi/core/kind'
require 'occi/core/attribute_properties'

module OCCI
  module Core
    class Entity < Hashie::Mash

      # Define appropriate kind
      def self.register
        data = Hashie::Mash.new
        data[:term] = "entity"
        data[:scheme] = "http://schemas.ogf.org/occi/core#"
        data[:title] = "Entity"
        data.attributes!.occi!.core!.id!.type = "string"
        data.attributes!.occi!.core!.id!.pattern = "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}"
        data.attributes!.occi!.core!.id!.required = false
        data.attributes!.occi!.core!.id!.mutable = false
        data.attributes!.occi!.core!.title!.type = "string"
        data.attributes!.occi!.core!.title!.pattern = ".*"
        data.attributes!.occi!.core!.title!.required = false
        data.attributes!.occi!.core!.title!.mutable = true

        kind = OCCI::Core::Kind.new(data)
        OCCI::Registry.register(kind)
      end

      def id
        return self[:id]
      end

      def id=(id)
        self[:id] = id
        self.attributes!.occi!.core!.id = id
      end

      def title
        return self[:title]
      end

      def title=(title)
        self[:title] = title
        self.attributes!.occi!.core!.title = title
      end

      # ---------------------------------------------------------------------------------------------------------------------
      def location
        '/' + OCCI::Registry.get_by_id(self[:kind]).term + '/' + self[:id]
      end

      # ---------------------------------------------------------------------------------------------------------------------
      private
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------
      def type_identifier
        OCCI::Registry.get_by_id(self.kind).type_identifier
      end

      # ---------------------------------------------------------------------------------------------------------------------
      private
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------
      def check(attributes, definitions)
        attributes ||= OCCI::Core::Attributes.new
        definitions.each_key do |key|
          properties = definitions[key]
          value = attributes[key] ||= properties[:default]
          if properties.include?(:type)
            raise "required attribute #{key} not found" if value.nil? && properties.required
            next if value.nil? && !properties.required
            case properties.type
              when 'string'
                raise "attribute #{key} with value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless value.kind_of?(String)
                raise "attribute #{key} with length #{value.length} not in range #{properties.minimum}-#{properties.maximum}" unless (properties.minimum..properties.maximum) === value.length if properties.minimum && properties.maximum
              when 'number'
                raise "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless value.kind_of?(Numeric)
                raise "attribute #{key} with value #{value} not in range #{properties.minimum}-#{properties.maximum}" unless (properties.minimum..properties.maximum) === value if properties.minimum && properties.maximum
              when 'boolean'
                raise "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless !!value == value
            end
            raise "attribute #{key} with value #{value} does not match pattern #{properties.pattern}" if value.to_s.scan(Regexp.new(properties.pattern)).empty? if properties.pattern
            attributes[key] = value
          else
            attributes[key] = check(value, definitions[key])
          end
        end
        attributes.delete_if { |k, v| v.nil? } # remove empty attributes
        return attributes
      end

      # ---------------------------------------------------------------------------------------------------------------------
      public
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------
      def initialize(entity_data, default = nil)
        entity_data.attributes = OCCI::Core::Attributes.new(entity_data.attributes)
        kind = OCCI::Registry.get_by_id(entity_data.kind)
        entity_data.attributes = check(entity_data.attributes!, kind.attributes)
        raise "kind not found" if kind.nil?
        super(entity_data, default)
      end

      def convert_value(val, duping=false) #:nodoc:
        case val
          when self.class
            val.dup
          when ::Hash
            val = val.dup if duping
            self.class.subkey_class.new.merge(val) unless val.kind_of?(Hashie::Mash)
            val
          when Array
            val.collect { |e| convert_value(e) }
          else
            val
        end
      end

    end
  end
end
