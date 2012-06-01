module OCCI
  module Core
    class Collection
      attr_accessor :kinds
      attr_accessor :mixins
      attr_accessor :actions
      attr_accessor :resources
      attr_accessor :links

      def initialize(kinds=[], mixins=[], actions=[], resources=[], links=[])
        @kinds = kinds
        @mixins = mixins
        @actions = actions
        @resources = resources
        @links = links
      end

      def categories
        @kinds + @mixins + @actions
      end

      def entities
        @resources + @links
      end
    end
  end
end