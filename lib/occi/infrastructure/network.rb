module Occi
  module Infrastructure
    class Network < Occi::Core::Resource

      require 'occi/infrastructure/network/ipnetwork'

      def self.mixins
        Occi::Core::Mixins.new << Occi::Infrastructure::Network::Ipnetwork.new
      end

      class Up < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/network/action#',
            term='up',
            title='activate network')
          super
        end
      end

      class Down < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/network/action#',
            term='down',
            title='deactivate network')
          super
        end
      end

      def self.actions
        Occi::Core::Actions.new << Up.new << Down.new
      end

      begin
        @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'network')

        @kind.title = "network resource"

        @kind.related << Occi::Core::Resource.kind

        @kind.attributes.occi!.network!.vlan = Occi::Core::AttributeProperties.new(
            { :type    => 'number',
              :mutable => true,
              :pattern => 'x86|x64' })

        @kind.attributes.occi!.network!.label = Occi::Core::AttributeProperties.new(
            { :mutable => true })

        @kind.attributes.occi!.network!.state = Occi::Core::AttributeProperties.new(
            { :pattern => 'active|inactive|error',
              :default => 'inactive' })

        @kind.location = '/network/'

        @kind.actions = self.actions

        @kind
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

      # IPNetwork Mixin attributes

      def address
        @attributes.occi.network.address if @attributes.occi.network if @attributes.occi
      end

      def address=(address)
        if @mixins.select { |mixin| mixin.kind_of? Occi::Infrastructure::Network::Ipnetwork }.empty?
          Occi::Log.info 'Adding mixin IPNetwork mixin'
          @mixins << Occi::Infrastructure::Network::Ipnetwork.new
        end
        @attributes.occi!.network!.address = address
      end

      def gateway
        @attributes.occi.network.gateway if @attributes.occi.network if @attributes.occi
      end

      def gateway=(gateway)
        if @mixins.select { |mixin| mixin.kind_of? Occi::Infrastructure::Network::Ipnetwork }.empty?
          Occi::Log.info 'Adding mixin IP network'
          @mixins << Occi::Infrastructure::Network::Ipnetwork.new
        end
        @attributes.occi!.network!.gateway = gateway
      end

      def allocation
        @attributes.occi.network.allocation if @attributes.occi.network if @attributes.occi
      end

      def allocation=(allocation)
        if @mixins.select { |mixin| mixin.kind_of? Occi::Infrastructure::Network::Ipnetwork }.empty?
          Occi::Log.info 'Adding mixin IPNetwork mixin'
          @mixins << Occi::Infrastructure::Network::Ipnetwork.new
        end
        @attributes.occi!.network!.allocation = allocation
      end

    end
  end
end