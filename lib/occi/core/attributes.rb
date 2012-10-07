require 'hashie/mash'

module Occi
  module Core
    class Attributes < Hashie::Mash

      # @return [Array] key value pair of full attribute names with their corresponding values
      def combine
        hash = { }
        self.each_key do |key|
          if self[key].kind_of? Occi::Core::Attributes
            self[key].combine.each_pair { |k, v| hash[key + '.' + k] = v }
          else
            hash[key] = self[key]
          end
        end
        hash
      end

      def convert_value(val, duping=false) #:nodoc:
        case val
          when self.class
            val.dup
          when Hashie::Mash
            val = val.dup if duping
            val
          when ::Hash
            val = val.dup if duping
            self.class.subkey_class.new.merge(val)
          when Array
            val.collect { |e| convert_value(e) }
          else
            val
        end
      end

      # @return [String] json representation
      def inspect
        JSON.pretty_generate(JSON.parse(to_json))
      end

      # @param [Hash] attributes key value pair of full attribute names with their corresponding values
      # @return [Occi::Core::Attributes]
      def self.split(attributes)
        attribute = Attributes.new
        attributes.each do |name, value|
          Occi::Log.debug "Attribute named #{name}"
          key, _, rest = name.partition('.')
          if rest.empty?
            attribute[key] = value
          else
            attribute.merge! Attributes.new(key => self.split(rest => value))
          end
        end
        return attribute
      end

    end

  end
end
