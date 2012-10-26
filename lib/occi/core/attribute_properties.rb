require 'hashie/mash'

module Occi
  module Core
    class AttributeProperties < Hashie::Mash

      # @param [Hash] properties
      # @param [Hash] default
      def initialize(properties=nil,default=nil)
        properties ||= {}
        properties[:type] ||= 'string'
        properties[:required] ||= false
        properties[:mutable]  ||= false
        properties[:pattern]  ||= '.*'
        super properties, default
      end

      # @param [Hash] properties
      # @return [Occi::Core::AttributeProperties] parsed Attribute Properties
      def self.parse(properties)
        properties ||= Hashie::Mash.new
        if [:Type, :Required, :Mutable, :Default, :Description, :Pattern, :type, :required, :mutable, :default, :description, :pattern].any? { |k| properties.key?(k) and not properties[k].kind_of? Hash }
          properties[:type]     ||= properties[:Type] ||= "string"
          properties[:required] ||= properties[:Required] ||= false
          properties[:mutable]  ||= properties[:Mutable] ||= false
          properties[:default] = properties[:Default] if properties[:Default]
          properties[:description] = properties[:Description] if properties[:Description]
          properties[:pattern] ||= properties[:Pattern] ||= ".*"
          properties.delete :Type
          properties.delete :Required
          properties.delete :Mutable
          properties.delete :Default
          properties.delete :Description
          properties.delete :Pattern
          return self.new properties
        else
          attributes = Occi::Core::Attributes.new
          properties.each_key do |key|
            attributes[key] = self.parse properties[key]
          end
          return attributes
        end
      end

      # @return [String] json representation
      def inspect
        JSON.pretty_generate(JSON.parse(to_json))
      end

    end
  end
end
