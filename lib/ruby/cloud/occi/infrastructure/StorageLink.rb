require 'occi/core/Kind'
require 'occi/core/Link'

module OCCI
  module Infrastructure
    class StorageLink < OCCI::Core::Link

      # Define appropriate kind
      begin
        actions = []
        related = [OCCI::Core::Link::KIND]
        entity_type = self
        entities = []

        term    = "storagelink"
        scheme  = "http://schemas.ogf.org/occi/infrastructure#"
        title   = "StorageLink"

        attributes = OCCI::Core::Attributes.new()
          
        attributes << OCCI::Core::Attribute.new(name = 'occi.storagelink.deviceid',   mutable = true,   mandatory = true,   unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.storagelink.mountpoint', mutable = true,   mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.storagelink.state',      mutable = false,  mandatory = true,   unique = true)
            
        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end

      def initialize(attributes)
        super(attributes)
        @kind_type = "http://schemas.ogf.org/occi/infrastructure#storagelink"
        $backend.createStorageLinkInstance(self)
      end

    end
  end
end