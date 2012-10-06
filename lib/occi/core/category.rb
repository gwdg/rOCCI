require 'active_support/json'
require 'active_support/inflector'
require 'hashie/mash'

module Occi
  module Core
    class Category

      attr_accessor :model, :scheme, :term, :title, :attributes

      # @param [String ] scheme
      # @param [String] term
      # @param [String] title
      # @param [Hash] attributes
      def initialize(scheme, term, title=nil, attributes=nil)
        @scheme     = scheme
        @term       = term
        @title      = title
        @attributes = Occi::Core::AttributeProperties.parse attributes
      end

      def self.get_class(scheme, term, related=['http://schemas.ogf.org/occi/core#entity'])
        if related.to_a.first == 'http://schemas.ogf.org/occi/core#entity' or related.to_a.first.nil?
          parent = Occi::Core::Entity
        else
          scheme, term = related.first.split '#'
          parent       = self.get_class scheme, term
        end

        uri = URI.parse(scheme)

        puts uri.to_s

        namespace = if uri.host == 'schemas.ogf.org'
                      uri.path.reverse.chomp('/').reverse.split('/')
                    else
                      uri.host.split('.').reverse + uri.path.reverse.chomp('/').reverse.split('/')
                    end

        namespace = namespace.inject(Object) do |mod, name|
          if mod.constants.collect{|sym| sym.to_s}.include? name.classify
            mod.const_get name.classify
          else
            mod.const_set name.classify, Module.new
          end
        end

        klass = if namespace.const_defined? term.classify
                  namespace.const_get term.classify
                else
                  namespace.const_set term.classify, Class.new(parent)
                end

        klass.allocate.kind_of? Occi::Core::Entity or raise "OCCI Kind with type identifier #{scheme + term} could not be created as the corresponding class #{klass.to_s} already exists and is not derived from Occi::Core::Entity"

        klass
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

      def to_string_short
        @term + ';scheme=' + @scheme.inspect + ';class=' + self.class.name.demodulize.downcase.inspect
      end

      def to_string
        string = self.to_string_short
        string << ';title=' + @title.inspect if @title
        string
      end

      # @return [String] text representation
      def to_text
        'Category: ' + self.to_string
      end

      def to_header
        { :Category => self.to_string }
      end

      def inspect
        JSON.pretty_generate(JSON.parse(to_json))
      end

      def location
        nil # not implemented
      end

    end
  end
end