module Occi
  module Infrastructure
    class Storagelink < Occi::Core::Link

      class Online < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/storagelink/action#',
            term='online',
            title='activate storagelink')
          super
        end
      end

      class Offline < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/storagelink/action#',
            term='offline',
            title='deactivate storagelink')
          super
        end
      end

      def self.actions
        Occi::Core::Actions.new << Online.new << Offline.new
      end

      begin
      @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'storagelink')

      @kind.title = "storage link"

      @kind.related << Occi::Core::Link.kind

      @kind.attributes.occi!.storagelink!.deviceid = Occi::Core::AttributeProperties.new(
          { :mutable => true })

      @kind.attributes.occi!.storagelink!.mountpoint = Occi::Core::AttributeProperties.new(
          { :mutable => true })

      @kind.attributes.occi!.storagelink!.state = Occi::Core::AttributeProperties.new(
          { :pattern => 'active|inactive|error',
            :default => 'inactive' })

      @kind.location = '/storagelink/'

      @kind.actions = self.actions
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