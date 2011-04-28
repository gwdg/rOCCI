require 'occi/core/Kind'
#require 'OCCI/Core/Resource'

module OCCI
  module Infrastructure
    class Storage < OCCI::Core::Resource

      # Define appropriate kind
      begin
          # Define actions
          actions = []
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "backup",    title = "Storage Action Backup",    attributes = [])
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "offline",   title = "Storage Action Offline",   attributes = [])
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "online",    title = "Storage Action Online",    attributes = [])
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "resize",    title = "Storage Action Resize",    attributes = ["size"])
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "snapshot",  title = "Storage Action Snapshot",  attributes = [])

          related     = [OCCI::Core::Resource::KIND]
          entity_type = self
          entities    = []

          term    = "storage"
          scheme  = "http://schemas.ogf.org/occi/infrastructure#"
          title   = "Storage Resource"

          attributes = OCCI::Core::Attributes.new()
          attributes << OCCI::Core::Attribute.new(name = 'occi.storage.size',   mutable = true,   mandatory = true, unique = true)
          attributes << OCCI::Core::Attribute.new(name = 'occi.storage.state',  mutable = false,  mandatory = true, unique = true)
          
          KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end

      def initialize(attributes)
        super(attributes)
        @kind_type = "http://schemas.ogf.org/occi/infrastructure#storage"
      end
      
      def deploy()
        $backend.create_storage_Instance(self)
      end
      
      def delete()
        $backend.delete_storage_instance(self)
        delete_entity()
      end

    end
  end
end