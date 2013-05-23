module Occi
  module Core
    class AttributeProperties < Hashie::Mash

      include Occi::Helpers::Inspect

      def [](key)
        if key.to_s.include? '.'
          key, string = key.to_s.split('.', 2)
          attributes = super(key)
          raise "AttributeProperty with key #{key} not found" unless attributes
          attributes[string]
        else
          super(key)
        end
      end

      def []=(key, value)
        if key.to_s.include? '.'
          key, string = key.to_s.split('.', 2)
          case self[key]
            when Occi::Core::AttributeProperties
              attributes = self[key]
            else
              attributes = Occi::Core::AttributeProperties.new
          end
          attributes[string] = value
          super(key, attributes)
        else
          case value
            when Occi::Core::AttributeProperties
              super(key, value)
            when Occi::Core::AttributeProperty
              super(key, value)
            when Hash
              super(key, Occi::Core::AttributeProperty.new(value))
            else
              case self[key]
                when Occi::Core::AttributeProperty
                  self[key]._value = value
                else
                  super(key, Occi::Core::AttributeProperty.new(:value => value))
              end
          end
        end
      end

      def remove(attributes)
        attributes.keys.each do |key|
          puts key
          if self.keys.include? key
            puts 'includes'
            if self[key].class == Occi::Core::AttributeProperties
              puts self[key]
              self[key].remove attributes[key]
            else
              self.delete(key)
            end
          end
        end
        self
      end


      # TODO: convert combine into names (returning only an array of attribtue names) and move combine to Attributes
      # @return [Array] key value pair of full attribute names with their corresponding values
      def combine
        hash = {}
        self.each_key do |key|
          if self[key].kind_of? Occi::Core::AttributeProperties
            self[key].combine.each_pair { |k, v| hash[key + '.' + k] = v }
          else
            hash[key] = self[key]
          end
        end
        hash
      end

      def method_missing(method_name, *args, &blk)
        return self.[](method_name, &blk) if key?(method_name)
        match = method_name.to_s.match(/(.*?)([?=!_]?)$/)
        case match[2]
          when "="
            case args.first
              when Occi::Core::AttributeProperty
                self[match[1]] = args.first
              when Hash
                self[match[1]] = Occi::Core::AttributeProperty.new(args.first)
              else
                if self[match[1]].kind_of? Occi::Core::AttributeProperty
                  self[match[1]]._value = args.first
                else
                  self[match[1]] = Occi::Core::AttributeProperty.new(:value => args.first)
                end
            end
          when "?"
            !!self[match[1]]
          when "!"
            initializing_reader(match[1])
          when "_"
            underbang_reader(match[1])
          else
            default(method_name, *args, &blk)
        end
      end

      def convert_value(val, duping=false) #:nodoc:
        case val
          when self.class
            val.dup
          when Hash
            duping ? val.dup : val
          when ::Hash
            val = val.dup if duping
            self.class.new(val)
          when Array
            val.collect { |e| convert_value(e) }
          when Occi::Core::AttributeProperty
            val.clone
          else
            val
        end
      end

      #def to_json(*a)
      #  as_json(*a).to_json(*a)
      #end
      #
      ## @param [Hash] options
      ## @return [Hashie::Mash] json representation
      #def as_json(options={})
      #  hash = {}
      #  self.each_pair do |key, value|
      #    case value
      #      when Occi::Core::AttributeProperty
      #        hash[key] = Hashie::Mash.new
      #        hash[key].type = value._type if value._type
      #        hash[key].required = value._required if value._required
      #        hash[key].mutable = value._mutable if value._mutable
      #        hash[key].default = value._default if value._default
      #        hash[key].description = value._description if value._description
      #        hash[key].pattern = value._pattern if value._pattern
      #      else
      #        hash[key] = value.as_json options
      #    end
      #  end
      #  hash
      #end

      # @param [Hash] attributes
      # @return [Occi::Core::AttributeProperties] parsed AttributeProperties
      def self.parse(has)
        attributes ||= Occi::Core::AttributeProperties.new
        hash.each_pair do |key, value|
          if [:Type, :Required, :Mutable, :Default, :Description, :Pattern, :type, :required, :mutable, :default, :description, :pattern].any? { |k| value.key?(k) and not value[k].kind_of? Hash }
            value[:type] ||= value[:Type] ||= "string"
            value[:required] ||= value[:Required] ||= false
            value[:mutable] ||= value[:Mutable] ||= false
            value[:default] = value[:Default] if value[:Default]
            value[:description] = value[:Description] if value[:Description]
            value[:pattern] ||= value[:Pattern] ||= ".*"
            value.delete :Type
            value.delete :Required
            value.delete :Mutable
            value.delete :Default
            value.delete :Description
            value.delete :Pattern
            attributes[key] = value
          else
            attributes[key] = self.parse attributes[key]
          end
        end
        attributes
      end

      # @param [Hash] attributes key value pair of full attribute names with their corresponding values
      # @return [Occi::Core::AttributeProperties]
      def self.split(attributes)
        attribute = AttributeProperties.new
        attributes.each do |name, value|
          Occi::Log.debug "AttributeProperty named #{name}"
          key, _, rest = name.partition('.')
          if rest.empty?
            attribute[key] = value
          else
            attribute.merge! AttributeProperties.new(key => self.split(rest => value))
          end
        end
        return attribute
      end

    end

  end
end
