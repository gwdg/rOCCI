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

      attr_accessor :mixins, :attributes, :actions
      attr_reader :kind

      # @return [OCCI::Core::Kind] kind definition of Entity type
      def self.kind_definition
        kind = OCCI::Core::Kind.new('http://schemas.ogf.org/occi/core#', 'entity')

        kind.title = "Entity"

        kind.attributes.occi!.core!.id!.Type     = "string"
        kind.attributes.occi!.core!.id!.Pattern  = "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}"
        kind.attributes.occi!.core!.id!.Required = false
        kind.attributes.occi!.core!.id!.Mutable  = false

        kind.attributes.occi!.core!.title!.Type     = "string"
        kind.attributes.occi!.core!.title!.Pattern  = ".*"
        kind.attributes.occi!.core!.title!.Required = false
        kind.attributes.occi!.core!.title!.Mutable  = true

        kind
      end

      # @param [String] kind
      # @param [String] mixins
      # @param [OCCI::Core::Attributes] attributes
      def initialize(kind, mixins=nil, attributes=nil, actions=nil)
        @checked = false
        raise "Kind #{kind} not of type String" unless kind.kind_of? String
        @kind                        = kind
        @mixins                      = mixins.to_a
        @attributes                  = OCCI::Core::Attributes.new(attributes)
        @attributes.occi!.core![:id] ||= UUIDTools::UUID.random_create
        @actions                     = actions.to_a
      end

      # @param [Array] mixins
      def mixins=(mixins)
        @checked=false
        @mixins =mixins
      end

      # @param [OCCI::Core::Attributes] attributes
      def attributes=(attributes)
        @checked   =false
        @attributes=attributes
      end

      # @return [UUIDTools::UUID] id of the entity
      def id
        @attributes.occi!.core!.id
      end

      # set title attribute for entity
      # @param [String] title
      def title=(title)
        @attributes.occi!.core!.title = title
      end

      # @return [String] title attribute of entity
      def title
        @attributes.occi!.core!.title
      end

      # @return [String] location of the entity
      def location
        '/' + @kind.split('#').last + '/' + @attributes.occi!.core!.id
      end

      # check attributes against their definitions and set defaults
      # @param [OCCI::Model] model representation of the OCCI model to check the attributes against
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

      # @param [OCCI::Core::Attributes] attributes
      # @param [OCCI::Core::AttributeProperties] definitions
      # @return [OCCI::Core::Attributes] attributes with their defaults set
      def self.check(attributes, definitions)
        attributes = OCCI::Core::Attributes.new(attributes)
        definitions.each_key do |key|
          properties = definitions[key]
          value      = attributes[key] ||= properties.Default
          if properties.key? :Type
            raise "required attribute #{key} not found" if value.nil? && properties.Required
            next if value.nil? && !properties.Required
            case properties.Type
              when 'number'
                raise "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.Type}" unless value.kind_of?(Numeric)
                raise "attribute #{key} with value #{value} not in range #{properties.Minimum}-#{properties.Maximum}" unless (properties.Minimum..properties.Maximum) === value if properties.Minimum && properties.Maximum
              when 'boolean'
                raise "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.Type}" unless !!value == value
              else
                raise "attribute #{key} with value #{value} from class #{value.class.name} does not match attribute property type #{properties.Type}" unless value.kind_of?(String)
                raise "attribute #{key} with length #{value.length} not in range #{properties.Minimum}-#{properties.Maximum}" unless (properties.Minimum..properties.Maximum) === value.length if properties.Minimum && properties.Maximum
            end
            raise "attribute #{key} with value #{value} does not match pattern #{properties.Pattern}" if value.to_s.scan(Regexp.new(properties.Pattern)).empty? if properties.Pattern
            attributes[key] = value
          else
            attributes[key] = check(value, definitions[key])
          end
        end
        attributes.delete_if { |_, v| v.nil? } # remove empty attributes
        @checked = true
        attributes
      end

      # @return [true,false]
      def checked?
        @checked && @attributes.checked?
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        entity = Hashie::Mash.new
        entity.kind = @kind if @kind
        entity.mixins = @mixins if @mixins.any?
        entity.actions = @actions if @actions.any?
        entity.attributes = @attributes if @attributes.any?
        entity
      end

      # @return [String] text representation
      def to_text
        scheme, term = self.kind.split('#')
        text         = term + ';scheme=' + scheme.inspect + ';class="kind"' + "\n"
        @mixins.each do |mixin|
          scheme, term = mixin.split('#')
          text << term + ';scheme=' + scheme.inspect + ';class="mixin"' + "\n"
        end
        @attributes.combine.each_pair do |name, value|
          name = name.inspect if name.kind_of? String
          text << 'X-OCCI-Attribute: ' + name + '=' + value + "\n"
        end
        @actions.each do |action|
          _, term = mixin.split('#')
          text << 'Link: <' + self.location + '?action=' + term + '>;rel=' + action.inspect + "\n"
        end
        text
      end

    end
  end
end
