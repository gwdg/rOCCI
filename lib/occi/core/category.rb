require 'active_support/json'
require 'active_support/inflector'
require 'hashie/mash'

module OCCI
  module Core
    class Category

      attr_accessor :model, :scheme, :term, :title, :attributes

      # @param [String ] scheme
      # @param [String] term
      # @param [String] title
      # @param [OCCI::Core::AttributeProperties] attributes
      def initialize(scheme, term, title=nil, attributes=nil)
        @scheme     = scheme
        @term       = term
        @title      = title
        @attributes = OCCI::Core::AttributeProperties.new(attributes)
      end

      # @return [String] Type identifier of the category
      def type_identifier
        @scheme + @term
      end

      # check if category is related to another category
      # @param [String] category_id Type identifier of a related category
      # @return [true,false] true if category is related to category_id else false
      def related_to?(category_id)
        self.related.each do |rel_id|
          return true if rel_id == category_id || @model.get_by_id(rel_id).related_to?(category_id)
        end if self.class.method_defined? 'related'
        false
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        category = Hashie::Mash.new
        category.scheme = @scheme if @scheme
        category.term = @term if @term
        category.title = @title if @title
        category.attributes = @attributes if @attributes.any?
        category
      end

      # @return [String] text representation
      def to_text
        text = @term + ';scheme=' + @scheme.inspect + ';class=' + self.class.name.demodulize.downcase.inspect
        text << ';title=' + @title.inspect if @title
        text
      end

      def inspect
        JSON.pretty_generate(JSON.parse(to_json))
      end

    end
  end
end