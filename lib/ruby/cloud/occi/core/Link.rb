require 'occi/core/Kind'

module OCCI
  module Core
    class Link < Entity
      
      # Define appropriate kind
      begin
        actions     = []
        related     = [OCCI::Core::Entity::KIND]
        entity_type = self
        entities    = []

        term    = "link"
        scheme  = "http://schemas.ogf.org/occi/core#"
        title   = "Link"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.core.source', mutable = true, mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.core.target', mutable = true, mandatory = true, unique = true)
          
        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end
      
      def initialize(attributes)
        super(attributes)
        @kind_type = "http://schemas.ogf.org/occi/core#link"
      end
      
    end
  end
end