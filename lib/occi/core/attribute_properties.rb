require 'hashie/mash'

module OCCI
  module Core
    class AttributeProperties < Hashie::Mash

      # @param [Hashie::Mash] attributes
      # @param [Hash] default
      def initialize(attributes = nil, default = nil)
        if [:Type, :Required, :Mutable, :Pattern, :Default, :Minimum, :Maximum, :Description].any? { |k| attributes.key?(k) }
          attributes[:Type]   ||= "string"
          attributes[:Required] ||= false
          attributes[:Mutable]  ||= false
          attributes[:Pattern]  ||= ".*"
        end if attributes
        super(attributes, default)
      end

      # @return [Array] list of full attribute names
      def combine
        array = []
        self.each_key do |key|
          if self[key].key? 'Type'
            array << key
          else
            attribute = self[key]
            attribute.combine.each { |attr| array << key + '.' + attr }
          end
        end
        array
      end


      # @return [Hash] key value pairs of attribute names with their defaults set
      def combine_with_defaults
        hash = { }
        self.each_key do |key|
          if self[key].include? 'Type'
            hash[key] = self[key]['Default']
          else
            self[key].combine_with_defaults.each { |k, v| hash[key + '.' + k] = v }
          end
        end
        hash
      end

      def convert_value(val, duping=false) #:nodoc:
        case val
          when self.class
            val.dup
          when ::Hash
            val = val.dup if duping
            self.class.subkey_class.new(val)
          when Array
            val.collect { |e| convert_value(e) }
          else
            val
        end
      end

      # Overrides method of hashie mash to check if one of the attribute properties has been set
      def method_missing(method_name, *args, &blk)
        return self.[](method_name, &blk) if key?(method_name)
        match = method_name.to_s.match(/(.*?)([?=!]?)$/)
        case match[2]
          when "="
            key = match[1]
            self[key] = args.first
            if %w|Type Required Mutable Pattern Default Minimum Maximum Description|.any? { |k| key.to_s == k }
              self["Type"] = "string" unless key?("Type")
              self["Required"] = false unless key?("Required")
              self["Mutable"] = false unless key?("Mutable")
              self["Pattern"] = ".*" unless key?("Pattern")
            end
          when "?"
            !!self[match[1]]
          when "!"
            initializing_reader(match[1])
          else
            default(method_name, *args, &blk)
        end
      end

      # Sets an attribute in the Mash. Key will be converted to
      # a string before it is set, and Hashes will be converted
      # into Mashes for nesting purposes.
      def []=(key, value) #:nodoc:
        regular_writer(convert_key(key), convert_value(value))
        if %w|Type Required Mutable Pattern Default Minimum Maximum Description|.any? { |k| key.to_s == k }
          self["Type"] = "string" unless key?("Type")
          self["Required"] = false unless key?("Required")
          self["Mutable"] = false unless key?("Mutable")
          self["Pattern"] = ".*" unless key?("Pattern")
        end
      end

      def inspect
        JSON.pretty_generate(JSON.parse(to_json))
      end

    end
  end
end
