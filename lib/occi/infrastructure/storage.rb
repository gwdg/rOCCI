module Occi
  module Infrastructure
    class Storage < Occi::Core::Resource

      extend Occi

      @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'storage')

      @kind.title = "storage resource"

      @kind.related << Occi::Core::Resource.type_identifier

      @kind.attributes.occi!.storage!.size = Occi::Core::AttributeProperties.new(
          { :type    => 'number',
            :mutable => true })

      @kind.attributes.occi!.storage!.state = Occi::Core::AttributeProperties.new(
          { :pattern => 'online|offline|backup|snapshot|resize|degraded',
            :default => 'offline' })

      @kind.location = '/storage/'

      @kind.actions = [
          "http://schemas.ogf.org/occi/infrastructure/storage/action#online",
          "http://schemas.ogf.org/occi/infrastructure/storage/action#offline",
          "http://schemas.ogf.org/occi/infrastructure/storage/action#backup",
          "http://schemas.ogf.org/occi/infrastructure/storage/action#snapshot",
          "http://schemas.ogf.org/occi/infrastructure/storage/action#resize"
      ]

      def self.actions
        online = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/storage/action#', 'online', 'activate storage')

        offline = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/storage/action#', 'offline', 'deactivate storage')

        backup = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/storage/action#', 'backup', 'backup storage')

        snapshot = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/storage/action#', 'snapshot', 'snapshot storage')

        resize = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/storage/action#', 'resize', 'resize storage')

        resize.attributes.size = Occi::Core::AttributeProperties.new(
            { :type    => 'number',
              :mutable => true })

        [online, offline, backup, snapshot]
      end

      def size
        @attributes.occi.storage.size if @attributes.occi.storage if @attributes.occi
      end

      def size=(size)
        @attributes.occi!.storage!.size = size
      end

      def state
        @attributes.occi.storage.state if @attributes.occi.storage if @attributes.occi
      end

      def state=(state)
        @attributes.occi!.storage!.state = state
      end

    end
  end
end