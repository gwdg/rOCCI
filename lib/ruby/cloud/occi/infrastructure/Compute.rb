require 'occi/core/Action'
require 'occi/core/Kind'
require 'occi/core/Resource'

module OCCI
  module Infrastructure
    class Compute < OCCI::Core::Resource
 
      # Define appropriate kind
      begin
          # Define actions
          actions = []
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/compute/action#", term = "restart",
                      title = "Compute Action Restart",   attributes = ["graceful", "warm", "cold"])

          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/compute/action#", term = "start",
                      title = "Compute Action Start",     attributes = [])

          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/compute/action#", term = "stop",      
                     title = "Compute Action Stop",      attributes = ["graceful", "acpioff", "poweroff"])

          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/compute/action#", term = "suspend",#
                     title = "Compute Action Suspend",   attributes = ["hibernate", "suspend"])

          related = [OCCI::Core::Resource::KIND]
          entity_type = self
          entities = []

          term    = "compute"
          scheme  = "http://schemas.ogf.org/occi/infrastructure#"
          title   = "Compute Resource"

          attributes = OCCI::Core::Attributes.new()
          attributes << OCCI::Core::Attribute.new(name = 'occi.compute.cores',        mutable = true,   mandatory = false,  unique = true)
          attributes << OCCI::Core::Attribute.new(name = 'occi.compute.architecture', mutable = true,   mandatory = false,  unique = true)
          attributes << OCCI::Core::Attribute.new(name = 'occi.compute.state',        mutable = false,  mandatory = true,   unique = true)
          attributes << OCCI::Core::Attribute.new(name = 'occi.compute.hostname',     mutable = true,   mandatory = false,  unique = true)
          attributes << OCCI::Core::Attribute.new(name = 'occi.compute.memory',       mutable = true,   mandatory = false,  unique = true)
          attributes << OCCI::Core::Attribute.new(name = 'occi.compute.speed',        mutable = true,   mandatory = false,  unique = true)
          attributes << OCCI::Core::Attribute.new(name = 'occi.compute.id',           mutable = true,   mandatory = false,  unique = true)
          
          KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end
 
      def initialize(attributes)
        super(attributes)
        @kind_type = "http://schemas.ogf.org/occi/infrastructure#compute"
      end

      def deploy()
        $backend.create_compute_instance(self)
      end
      
      def delete()
        $backend.delete_compute_instance(self)
        delete_entity()
      end

    end
  end
end