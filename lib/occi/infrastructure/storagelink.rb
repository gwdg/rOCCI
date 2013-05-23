module Occi
  module Infrastructure
    class Storagelink < Occi::Core::Link

      online = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/storagelink/action#',
                                      term='online',
                                      title='activate storagelink'

      offline = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/storagelink/action#',
                                       term='offline',
                                       title='deactivate storagelink'

      self.actions = Occi::Core::Actions.new << online << offline

      self.attributes = Occi::Core::AttributeProperties.new
      self.attributes['occi.storagelink.deviceid'] = {:mutable => true}
      self.attributes['occi.storagelink.mountpoint'] = {:mutable => true}
      self.attributes['occi.storagelink.state'] = {:pattern => 'active|inactive|error',
                                                   :default => 'inactive'}

      self.kind = Occi::Core::Kind.new scheme='http://schemas.ogf.org/occi/infrastructure#',
                                       term='storagelink',
                                       title = 'storage link',
                                       attributes = self.attributes,
                                       related = Occi::Core::Related.new << Occi::Core::Link.kind,
                                       actions = self.actions,
                                       location = '/storagelink/'


      def deviceid
        @attributes.occi.storagelink.deviceid if @attributes.occi.storagelink if @attributes.occi
      end

      def deviceid=(deviceid)
        @attributes.occi!.storagelink!.deviceid = deviceid
      end

      def mountpoint
        @attributes.occi.storagelink.mountpoint if @attributes.occi.storagelink if @attributes.occi
      end

      def mountpoint=(mountpoint)
        @attributes.occi!.storagelink!.mountpoint = mountpoint
      end

      def state
        @attributes.occi.storagelink.state if @attributes.occi.storagelink if @attributes.occi
      end

      def state=(state)
        @attributes.occi!.storagelink!.state = state
      end

    end
  end
end