require 'occi/core/Category'

module OCCI
  module Core
    class Kind < Category

      attr_accessor :entity_type
      attr_accessor :related
      attr_accessor :entities
      attr_accessor :actions
      
      def initialize(actions, related, entity_type, entities, term, scheme, title, attributes)
        super(term, scheme, title, attributes)
        @actions      = (actions != nil ? actions : []) 
        @related      = (related != nil ? related : [])
        @entities     = (entities != nil ? entities : [])
        @entity_type  = entity_type
      end
      
    end
  end
end
