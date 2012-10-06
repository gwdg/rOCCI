require 'occi/core/category'

module Occi
  module Core
    class Action < Occi::Core::Category

      # @return [String] text representation
      def to_text
        text = super
        text << ';attributes=' + @attributes.combine.join(' ').inspect if @attributes.any?
        text
      end

      def to_header
        header = super
        header["Category"] << ';attributes=' + @attributes.combine.join(' ').inspect if @attributes.any?
        header
      end

    end
  end
end