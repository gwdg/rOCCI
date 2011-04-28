require 'occi/core/Entity'
require 'occi/core/Kind'

module OCCI
  module Core
    class Resource < Entity

      begin
        actions     = []
        related     = [OCCI::Core::Entity::KIND]
        entity_type = self
        entities    = []

        term    = "resource"
        scheme  = "http://schemas.ogf.org/occi/core#"
        title   = "Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.core.summary', mutable = true, mandatory = false, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'links',             mutable = true, mandatory = false, unique = false)
          
        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)        
      end

      def initialize(attributes)
        attributes['occi.core.summary'] = "" if attributes['occi.core.summary'] == nil
        attributes['links']             = []
        super(attributes)
        @kind_type = "http://schemas.ogf.org/occi/core#resource"
      end

    end
  end
end