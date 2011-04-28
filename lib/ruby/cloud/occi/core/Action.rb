require 'occi/core/Category'

module OCCI
  module Core

    class Action
      
      attr_reader :category
      
      def initialize(scheme, term, title, attributes)
        @category = OCCI::Core::Category.new(term, scheme, title, attributes)
      end
      
    end
  end
end