module Occi
  module Infrastructure
    class Network < Occi::Core::Resource

      require 'occi/infrastructure/network/ipnetwork'

      extend Occi

      def self.mixins
        Occi::Infrastructure::Network::Ipnetwork.mixins
      end

      def self.kind
        kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'network')

        kind.title = "network resource"

        kind.related << Occi::Core::Resource.type_identifier

        kind.attributes.occi!.network!.vlan = Occi::Core::AttributeProperties.new(
            { :type    => 'number',
              :mutable => true,
              :pattern => 'x86|x64' })

        kind.attributes.occi!.network!.label = Occi::Core::AttributeProperties.new(
            { :mutable => true })

        kind.attributes.occi!.network!.state = Occi::Core::AttributeProperties.new(
            { :pattern => 'active|inactive|error',
              :default => 'inactive' })

        kind.location = '/network/'

        kind.actions = [
            "http://schemas.ogf.org/occi/infrastructure/network/action#up",
            "http://schemas.ogf.org/occi/infrastructure/network/action#down"
        ]

        kind
      end

      def self.actions
        up = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/network/action#',
                                    'up',
                                    'activate network')

        down = Occi::Core::Action.new('http://schemas.ogf.org/occi/infrastructure/network/action#',
                                      'down',
                                      'deactivate network')

        [up, down]
      end

      def ipnetwork(boolean=true)
        if boolean
          require 'occi/infrastructure/network/ipnetwork'
          self.class.send(:include, Occi::Infrastructure::Network::Ipnetwork)
          mixins << Occi::Infrastructure::Network::Ipnetwork.mixin.type_identifier
        else
          mixins.delete Occi::Infrastructure::Network::Ipnetwork.mixin.type_identifier
        end
      end

      def vlan
        @attributes.occi.nework.vlan if @attributes.occi.network if @attributes.occi
      end

      def vlan=(vlan)
        @attributes.occi!.network!.vlan = vlan
      end

      def label
        @attributes.occi.nework.label if @attributes.occi.network if @attributes.occi
      end

      def label=(label)
        @attributes.occi!.network!.label = label
      end

      def state
        @attributes.occi.nework.state if @attributes.occi.network if @attributes.occi
      end

      def state=(state)
        @attributes.occi!.network!.state = state
      end

    end
  end
end