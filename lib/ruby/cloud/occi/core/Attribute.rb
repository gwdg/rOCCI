module OCCI
  module Core
    class Attribute
      
      attr_reader :name
      attr_reader :mutable
      attr_reader :mandatory
      attr_reader :unique
      
      def initialize(name,mutable,mandatory,unique)
        @name = name
        @mutable = mutable
        @mandatory = mandatory
        @unique = unique
      end

      def to_s()
        @name
      end
    end
  end
end