require 'hashie/mash'

module OCCI
  module Core
    class AttributeProperties < Hashie::Mash

      def initialize(attributes = nil, default = nil)
        if attributes[:type] || attributes.required || attributes.mutable || attributes.pattern || attributes.minimum || attributes.maximum || attributes.description
          attributes[:type] ||= "string"
          attributes.required ||= false
          attributes.mutable ||= false
          attributes.pattern ||= ".*"
        end unless attributes.nil?
        super(attributes, default)
      end

      def combine
        array = []
        self.each_key do |key|
          puts key
          puts self[key]
          if self[key].include? 'type'
            array << key + "{}"
          else
            self[key].combine.each { |attr| array << key + '.' + attr }
          end
        end
        return array
      end

    end
  end
end
