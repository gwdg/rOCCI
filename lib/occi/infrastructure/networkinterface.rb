module Occi
  module Infrastructure
    class Networkinterface < Occi::Core::Link

      extend Occi

      def self.mixins
        require 'occi/infrastructure/networkinterface/ipnetworkinterface'
        Occi::Infrastructure::Networkinterface::Ipnetworkinterface.mixins
      end

      def self.kind
        kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'networkinterface')

        kind.title = "networkinterface link"

        kind.related << Occi::Core::Link.type_identifier

        kind.attributes.occi!.networkinterface!.interface = Occi::Core::AttributeProperties.new(
            { :mutable => true })

        kind.attributes.occi!.networkinterface!.mac = Occi::Core::AttributeProperties.new(
            { :mutable => true,
              :pattern => '^([0-9a-fA-F]{2}[:-]){5}([0-9a-fA-F]{2})$' })

        kind.attributes.occi!.networkinterface!.state = Occi::Core::AttributeProperties.new(
            { :pattern => 'active|inactive|error',
              :default => 'inactive' })

        kind.location = '/networkinterface/'

        kind.actions = [
            "http://schemas.ogf.org/occi/infrastructure/networkinterface/action#up",
            "http://schemas.ogf.org/occi/infrastructure/networkinterface/action#down"
        ]

        kind
      end

      def self.actions
        up = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/networkinterface/action#',
                                    'up',
                                    'activate networkinterface')

        down = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/networkinterface/action#',
                                      'down',
                                      'deactivate networkinterface')

        [up, down]
      end

      def ipnetworkinterface(boolean=true)
        if boolean
          require 'occi/infrastructure/networkinterface/ipnetworkinterface'
          self.class.send(:include, Occi::Infrastructure::Networkinterface::Ipnetworkinterface)
          mixins << Occi::Infrastructure::Networkinterface::Ipnetworkinterface.mixin.type_identifier
        else
          mixins.delete Occi::Infrastructure::Networkinterface::Ipnetworkinterface.mixin.type_identifier
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
    end
  end
end