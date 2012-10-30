module Occi
  module Infrastructure
    class Storagelink < Occi::Core::Link

      extend Occi

      @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'storagelink')

      @kind.title = "storage link"

      @kind.related << Occi::Core::Link.type_identifier

      @kind.attributes.occi!.storagelink!.deviceid = Occi::Core::AttributeProperties.new(
          { :mutable => true })

      @kind.attributes.occi!.storagelink!.mountpoint = Occi::Core::AttributeProperties.new(
          { :mutable => true })

      @kind.attributes.occi!.storagelink!.state = Occi::Core::AttributeProperties.new(
          { :pattern => 'active|inactive|error',
            :default => 'inactive' })

      @kind.location = '/storagelink/'

      @kind.actions = [
          "http://schemas.ogf.org/occi/infrastructure/storagelink/action#online",
          "http://schemas.ogf.org/occi/infrastructure/storagelink/action#offline"
      ]

      def self.actions
        online = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/storagelink/action#',
                                        'online',
                                        'activate storagelink')

        offline = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/storagelink/action#',
                                         'offline',
                                         'deactivate storagelink')

        [online, offline]
      end

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