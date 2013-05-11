module Occi
  module Infrastructure
    class Storage < Occi::Core::Resource

      online = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
                                      term='online',
                                      title='activate storage'

      offline = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
                                       term='offline',
                                       title='deactivate storage'

      backup = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
                                      term='backup',
                                      title='backup storage'

      snapshot = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
                                        term='snapshot',
                                        title='snapshot storage'

      resize = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/storage/action#',
                                      term='resize',
                                      title='resize storage',
                                      attributes = Occi::Core::Attributes.new('size' => Occi::Core::AttributeProperties.new(:type => 'number',
                                                                                                                            :mutable => true))

      self.actions = Occi::Core::Actions.new << online << offline << backup << snapshot << resize

      self.attributes = Occi::Core::Attributes.split 'occi.storage.size' => Occi::Core::AttributeProperties.new(:type => 'number',
                                                                                                                :mutable => true),
                                                     'occi.storage.state' => Occi::Core::AttributeProperties.new(:pattern => 'online|offline|backup|snapshot|resize|degraded',
                                                                                                                 :default => 'offline')

      self.kind = Occi::Core::Kind.new scheme='http://schemas.ogf.org/occi/infrastructure#',
                                       term='storage',
                                       title = 'storage resource',
                                       attributes = self.attributes,
                                       related = Occi::Core::Related.new << Occi::Core::Resource.kind,
                                       actions = self.actions,
                                       location = '/storage/'

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