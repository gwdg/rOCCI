require 'rubygems'
require 'uuidtools'
require 'hashie/mash'
require 'active_support/json'
require 'occi/model'
require 'occi/core/attributes'
require 'occi/core/kind'
require 'occi/core/attribute_properties'

module OCCI
  module Core
    class Entity

      attr_accessor :kind, :mixins, :attributes

      # @return [OCCI::Core::Kind] kind definition of Entity type
      def self.kind_definition
        kind                                        = OCCI::Core::Kind.new('http://schemas.ogf.org/occi/core#','entity')

        kind.title                                  = "Entity"

        kind.attributes.occi!.core!.id!.type        = "string"
        kind.attributes.occi!.core!.id!.pattern     = "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}"
        kind.attributes.occi!.core!.id!.required    = false
        kind.attributes.occi!.core!.id!.mutable     = false

        kind.attributes.occi!.core!.title!.type     = "string"
        kind.attributes.occi!.core!.title!.pattern  = ".*"
        kind.attributes.occi!.core!.title!.required = false
        kind.attributes.occi!.core!.title!.mutable  = true

        kind
      end

      def initialize(kind, mixins=nil, attributes=nil)
        @kind       = kind
        @mixins     = mixins.to_a
        @attributes = OCCI::Core::Attributes.new(attributes)
      end

      def location
        '/' + @kind.term + '/' + @attributes.occi.core.id
      end

      def check(model)
        raise "No kind defined" unless @kind
        definitions = model.get_by_id(@kind).attributes
        @mixins.each do |mixin_id|
          mixin = model.get_by_id(mixin_id)
          next if mixin.nil?
          definitions.merge!(mixin.attributes) if mixin.attributes
        end if @mixins

        @attributes = Entity.check(@attributes, definitions) if definitions
      end

      def self.check(attributes, definitions)
        attributes = OCCI::Core::Attributes.new(attributes)
        definitions.each_key do |key|
          properties = definitions[key]
          value      = attributes[key] ||= properties[:default]
          if properties.include?(:type)
            raise "required attribute #{key} not found" if value.nil? && properties.required
            next if value.nil? && !properties.required
            case properties.type
              when 'number'
                raise "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless value.kind_of?(Numeric)
                raise "attribute #{key} with value #{value} not in range #{properties.minimum}-#{properties.maximum}" unless (properties.minimum..properties.maximum) === value if properties.minimum && properties.maximum
              when 'boolean'
                raise "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless !!value == value
              else
                raise "attribute #{key} with value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless value.kind_of?(String)
                raise "attribute #{key} with length #{value.length} not in range #{properties.minimum}-#{properties.maximum}" unless (properties.minimum..properties.maximum) === value.length if properties.minimum && properties.maximum
            end
            raise "attribute #{key} with value #{value} does not match pattern #{properties.pattern}" if value.to_s.scan(Regexp.new(properties.pattern)).empty? if properties.pattern
            attributes[key] = value
          else
            attributes[key] = check(value, definitions[key])
          end
        end
        attributes.delete_if { |_, v| v.nil? } # remove empty attributes
        return attributes
      end

      def as_json(options={ })
        entity = Hashie::Mash.new
        entity.kind = @kind if @kind
        entity.mixins = @mixins if @mixins.any?
        entity.attributes = @attributes if @attributes.any?
        entity
      end

    end
  end
end
