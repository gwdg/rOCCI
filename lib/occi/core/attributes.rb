module Occi
  module Core
    class Attributes < Occi::Core::AttributeProperties

      def []=(key, value)
        if key.to_s.include? '.'
          key, string = key.to_s.split('.', 2)
          case self[key]
            when Occi::Core::Attributes
              attributes = self[key]
            else
              attributes = Occi::Core::Attributes.new
          end
          attributes[string] = value
          super(key, attributes)
        else
          case value
            when Occi::Core::Attributes
              super(key, value)
            when Occi::Core::Attribute
              super(key, value)
            when Hash
              super(key, Occi::Core::Attribute.new(value))
            else
              case self[key]
                when Occi::Core::Attribute
                  self[key]._value = value
                else
                  super(key, Occi::Core::Attribute.new(:value => value))
              end
          end
        end
      end

      def method_missing(method_name, *args, &blk)
        return self.[](method_name, &blk) if key?(method_name)
        match = method_name.to_s.match(/(.*?)([?=!_]?)$/)
        case match[2]
          when "="
            case args.first
              when Occi::Core::Attribute
                self[match[1]] = args.first
              when Hash
                self[match[1]] = Occi::Core::Attribute.new(args.first)
              else
                if self[match[1]].kind_of? Occi::Core::Attribute
                  self[match[1]]._value = args.first
                else
                  self[match[1]] = Occi::Core::Attribute.new(:value => args.first)
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
          when Occi::Core::AttributeProperties
            Occi::Core::Attributes.new val
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
            Occi::Core::Attribute.new val
          else
            val
        end
      end

      def to_json(*a)
        as_json(*a).to_json(*a)
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={})
        hash = {}
        self.each_pair do |key, value|
          case value
            when Occi::Core::Attribute
              hash[key] = value._value
            else
              hash[key] = value.as_json options
          end
        end
        hash
      end

    end

  end
end
