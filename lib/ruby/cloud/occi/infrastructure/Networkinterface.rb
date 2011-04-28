require 'occi/core/Kind'
require 'occi/core/Link'

module OCCI
  module Infrastructure
    class Networkinterface < OCCI::Core::Link

      # Define appropriate kind
      begin
        actions = []
        related = [OCCI::Core::Link::KIND]
        entity_type = self
        entities = []

        term    = "networkinterface"
        scheme  = "http://schemas.ogf.org/occi/infrastructure#"
        title   = "Networkinterface"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.interface', mutable = false,  mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.mac',       mutable = true,   mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.state',     mutable = false,  mandatory = true, unique = true)

        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end

      def initialize(attributes)
        super(attributes)
        @kind_type = "http://schemas.ogf.org/occi/infrastructure#networkinterface"
      end

    end
  end
end