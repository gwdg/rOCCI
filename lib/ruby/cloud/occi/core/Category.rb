module OCCI
  module Core
    class Category
      attr_accessor :scheme
      attr_accessor :term
      attr_accessor :title
      attr_accessor :attributes
      
      def initialize(term,scheme,title,attributes)
        @term   = term
        @scheme = scheme
        @title  = title
        @attributes = (attributes != nil ? attributes : OCCI::Core::Attributes.new())
      end
      
      def get_location()
        location = '/' + @term + '/'
      end
    end
  end
end