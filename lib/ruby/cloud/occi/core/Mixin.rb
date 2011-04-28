module OCCI
  module Core

    class Mixin < Category

      attr_accessor :actions
      attr_accessor :related
      attr_accessor :entities

      def initialize(term, scheme, title, attributes, actions, related, entities)
        super(term, scheme, title, attributes)
        @actions  = (actions != nil ? actions : []) 
        @related  = (related != nil ? related : [])
        @entities = (entities != nil ? entities : [])
      end

      def addEntity(entity)
        @entities =[] if @entities == nil
        @entities << entity
        @entities
      end

    end
  end
end
