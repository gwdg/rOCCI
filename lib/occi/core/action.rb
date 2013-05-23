module Occi
  module Core
    class Action < Occi::Core::Category

      # @param [String ] scheme
      # @param [String] term
      # @param [String] title
      # @param [Hash] attributes
      def initialize(scheme='http://schemas.ogf.org/occi/core#',
          term='action',
          title=nil,
          attributes=Occi::Core::AttributeProperties.new)
        super scheme, term, title, attributes
      end

      # @return [String] text representation
      def to_text
        text = super
        text << ';attributes=' + @attributes.combine.join(' ').inspect if @attributes.any?
        text
      end

      # @return [Hash] hash containing the HTTP headers of the text/occi rendering
      def to_header
        header = super
        header["Category"] << ';attributes=' + @attributes.combine.join(' ').inspect if @attributes.any?
        header
      end

    end
  end
end