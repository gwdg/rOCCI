require 'occi/core/Kind'

module OCCI
  module Infrastructure
    class Network < OCCI::Core::Resource

      # Define appropriate kind
      begin
        # Register && define actions
        actions = []
        actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/network/action#", term = "down",      title = "Network Action Down", attributes = [])
        actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/network/action#", term = "up",        title = "Network Action Up", attributes = [])

        related     = [OCCI::Core::Resource::KIND]
        entity_type = self
        entities    = []

        term    = "network"
        scheme  = "http://schemas.ogf.org/occi/infrastructure#"
        title   = "Network Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.vlan',   mutable = true,   mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.label',  mutable = true,   mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.state',  mutable = false,  mandatory = true,   unique = true)
          
        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end

      def initialize(attributes)
        super(attributes)
        @kind_type = "http://schemas.ogf.org/occi/infrastructure#network"
      end
      
      def deploy()
        $backend.create_network_instance(self)
      end
      
      def delete()
        $backend.delete_network_instance(self)
        delete_entity()
      end

    end
  end
end