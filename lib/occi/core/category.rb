require 'json'
require 'hashie/mash'

module OCCI
  module Core
    class Category < Hashie::Mash

      def initialize(category=nil, default = nil)
        category.attributes = OCCI::Core::AttributeProperties.new(category.attributes) if category
        super(category, default)
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

      def type_identifier
        regular_reader("scheme") + regular_reader("term")
      end

      def related_to?(category_id)
        self.related.each do |category|
          return true if category.type_identifier == category_id || category.related_to?(category_id)
        end if self.related
        false
      end

    end
  end
end