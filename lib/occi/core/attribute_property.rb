module Occi
  module Core
    class AttributeProperty

      include Occi::Helpers::Inspect

      attr_accessor :_type, :_required, :_mutable, :_default, :_description, :_pattern

      # @param [Hash] properties
      # @param [Hash] default
      def initialize(properties={})
        case properties
          when Occi::Core::AttributeProperty
            self._default = properties._default
            self._type = properties._type
            self._required = properties._required
            self._mutable = properties._mutable
            self._pattern = properties._pattern
          else
            self._default = properties[:default]
            self._type = properties[:type] ||= 'string'
            self._required = properties[:required] ||= false
            self._mutable = properties[:mutable] ||= false
            self._pattern = properties[:pattern] ||= '.*'
        end
      end

      def required?
        self._required
      end

      def mutable?
        self._mutable
      end

      def as_json(options={})
        hash = Hashie::Mash.new
        hash.type = self._type if self._type
        hash.required = self._required if self._required
        hash.mutable = self._mutable if self._mutable
        hash.default = self._default if self._default
        hash.description = self._description if self._description
        hash.pattern = self._pattern if self._pattern
        hash
      end

    end
  end
end
