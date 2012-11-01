module Occi
  module Infrastructure
    class Networkinterface < Occi::Core::Link

      require 'occi/infrastructure/networkinterface/ipnetworkinterface'

      def self.mixins
        Occi::Core::Mixins.new << Occi::Infrastructure::Networkinterface::Ipnetworkinterface.new
      end

      class Up < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/networkinterface/action#',
            term='up',
            title='activate networkinterface')
          super
        end
      end

      class Down < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/networkinterface/action#',
            term='down',
            title='deactivate networkinterface')
          super
        end
      end

      def self.actions
        Occi::Core::Actions.new << Up.new << Down.new
      end

      begin
        @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'networkinterface')

        @kind.title = "networkinterface link"

        @kind.related << Occi::Core::Link.kind

        @kind.attributes.occi!.networkinterface!.interface = Occi::Core::AttributeProperties.new(
            { :mutable => true })

        @kind.attributes.occi!.networkinterface!.mac = Occi::Core::AttributeProperties.new(
            { :mutable => true,
              :pattern => '^([0-9a-fA-F]{2}[:-]){5}([0-9a-fA-F]{2})$' })

        @kind.attributes.occi!.networkinterface!.state = Occi::Core::AttributeProperties.new(
            { :pattern => 'active|inactive|error',
              :default => 'inactive' })

        @kind.location = '/networkinterface/'

        @kind.actions = self.actions
      end

      def ipnetworkinterface(boolean=true)
        if boolean
          @mixins << Occi::Infrastructure::Networkinterface::Ipnetworkinterface.type_identifier
        else
          mixins.delete Occi::Infrastructure::Networkinterface::Ipnetworkinterface.type_identifier
        end
      end

      def interface
        @attributes.occi.networkinterface.interface if @attributes.occi.networkinterface if @attributes.occi
      end

      def interface=(interface)
        @attributes.occi!.networkinterface!.interface = interface
      end

      def mac
        @attributes.occi.networkinterface.mac if @attributes.occi.networkinterface if @attributes.occi
      end

      def mac=(mac)
        @attributes.occi!.networkinterface!.mac = mac
      end

      def state
        @attributes.occi.networkinterface.state if @attributes.occi.networkinterface if @attributes.occi
      end

      def state=(state)
        @attributes.occi!.networkinterface!.state = state
      end

      def address
        @attributes.occi.networkinterface.address if @attributes.occi.networkinterface if @attributes.occi
      end

      def address=(address)
        if @mixins.select { |mixin| mixin.kind_of? Occi::Infrastructure::Networkinterface::Ipnetworkinterface }.empty?
          Occi::Log.info 'Adding mixin IP network interface'
          @mixins << Occi::Infrastructure::Networkinterface::Ipnetworkinterface.new
        end
        @attributes.occi!.networkinterface!.address = address
      end

      def gateway
        @attributes.occi.networkinterface.gateway if @attributes.occi.networkinterface if @attributes.occi
      end

      def gateway=(gateway)
        if @mixins.select { |mixin| mixin.kind_of? Occi::Infrastructure::Networkinterface::Ipnetworkinterface }.empty?
          Occi::Log.info 'Adding mixin IP network interface'
          @mixins << Occi::Infrastructure::Networkinterface::Ipnetworkinterface.new
        end
        @attributes.occi!.networkinterface!.gateway = gateway
      end

      def allocation
        @attributes.occi.networkinterface.allocation if @attributes.occi.networkinterface if @attributes.occi
      end

      def allocation=(allocation)
        if @mixins.select { |mixin| mixin.kind_of? Occi::Infrastructure::Networkinterface::Ipnetworkinterface }.empty?
          Occi::Log.info 'Adding mixin IP network interface'
          @mixins << Occi::Infrastructure::Networkinterface::Ipnetworkinterface.new
        end
        @attributes.occi!.networkinterface!.allocation = allocation
      end

    end
  end
end