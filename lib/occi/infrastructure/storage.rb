module Occi
  module Infrastructure
    class Storage < Occi::Core::Resource

      class Online < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
            term='online',
            title='activate storage')
          super
        end
      end

      class Offline < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
            term='offline',
            title='deactivate storage')
          super
        end
      end

      class Backup < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
            term='backup',
            title='backup storage')
          super
        end
      end

      class Snapshot < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
            term='snapshot',
            title='snapshot storage')
          super
        end
      end

      class Resize < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
            term='resize',
            title='resize storage')
          super
          @attributes.size = Occi::Core::AttributeProperties.new(
              { :type    => 'number',
                :mutable => true })
        end
      end

      def self.actions
        Occi::Core::Actions.new << Online.new << Offline.new << Backup.new << Snapshot.new
      end

      begin
        @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'storage')

        @kind.title = "storage resource"

        @kind.related << Occi::Core::Resource.kind

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