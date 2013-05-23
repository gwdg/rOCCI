module Occi
  module Core
    class Attribute < Occi::Core::AttributeProperty

      attr_accessor :_value

      # @param [Hash] properties
      # @param [Hash] default
      def initialize(properties={})
        case properties
          when Occi::Core::AttributeProperty
            self._value = properties._value if properties.respond_to?('_value')
          else
            self._value = properties[:value] if properties[:value]
        end
        super(properties)
      end

      def _value=(value)
        raise "value #{value} can not be assigned as the attribute is not mutable" unless self._mutable if self._value
        case self._type
          when 'number'
            raise "value #{value} from class #{value.class.name} does not match attribute property type #{self._type}" unless value.kind_of?(Numeric)
          when 'boolean'
            raise "value #{value} from class #{value.class.name} does not match attribute property type #{self._type}" unless !!value == value
          when 'string'
            raise "value #{value} from class #{value.class.name} does not match attribute property type #{self._type}" unless value.kind_of?(String)
          else
            raise "property type #{self._type} is not one of the allowed types number, boolean or string"
        end
        raise "value #{value} does not match pattern #{self._pattern}" if value.to_s.scan(Regexp.new(self._pattern)).empty?
        @_value = value
      end

      def inspect
        self._value
      end

    end
  end
end
