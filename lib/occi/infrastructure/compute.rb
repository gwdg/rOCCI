module Occi
  module Infrastructure
    class Compute < Occi::Core::Resource

      class Start < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
            term='start',
            title='start compute instance')
          super
        end
      end

      class Stop < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
            term='stop',
            title='stop compute instance')
          super
          @attributes.method = Occi::Core::AttributeProperties.new(
              { :mutable => true,
                :pattern => 'graceful|acpioff|poweroff',
                :default => 'poweroff' })
        end
      end

      class Restart < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
            term='restart',
            title='restart compute instance')
          super
          @attributes.method = Occi::Core::AttributeProperties.new(
              { :mutable => true,
                :pattern => 'graceful|warm|cold',
                :default => 'cold' })
        end
      end

      class Suspend < Occi::Core::Action
        def initialize(scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
            term='suspend',
            title='suspend compute instance')
          super
          @attributes.method = Occi::Core::AttributeProperties.new(
              { :mutable => true,
                :pattern => 'hibernate|suspend',
                :default => 'suspend' })
        end
      end

      def self.mixins
        Occi::Core::Mixins.new << Occi::Infrastructure::Resource_tpl.new << Occi::Infrastructure::Os_tpl.new
      end

      def self.actions
        Occi::Core::Actions.new << Start.new << Stop.new << Restart.new << Suspend.new
      end

      begin
        @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#', 'compute')

        @kind.title = "compute resource"

        @kind.related << Occi::Core::Resource.kind

        @kind.attributes.occi!.compute!.architecture = Occi::Core::AttributeProperties.new(
            { :mutable => true,
              :pattern => 'x86|x64' })

        @kind.attributes.occi!.compute!.cores = Occi::Core::AttributeProperties.new(
            { :type    => 'number',
              :mutable => true })

        @kind.attributes.occi!.compute!.hostname = Occi::Core::AttributeProperties.new(
            { :mutable => true,
              :pattern => '(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*' })

        @kind.attributes.occi!.compute!.speed = Occi::Core::AttributeProperties.new(
            { :type    => 'number',
              :mutable => true })

        @kind.attributes.occi!.compute!.memory = Occi::Core::AttributeProperties.new(
            { :type    => 'number',
              :mutable => true })

        @kind.attributes.occi!.compute!.state = Occi::Core::AttributeProperties.new(
            { :pattern => 'inactive|active|suspended|error',
              :default => 'inactive' })

        @kind.location = '/compute/'

        @kind.actions = self.actions
      end

      def architecture
        @attributes.occi.compute.architecture if @attributes.occi.compute if @attributes.occi
      end

      def architecture=(architecture)
        @attributes.occi!.compute!.architecture = architecture
      end

      def cores
        @attributes.occi.compute.cores if @attributes.occi.compute if @attributes.occi
      end

      def cores=(cores)
        @attributes.occi!.compute!.cores = cores
      end

      def hostname
        @attributes.occi.compute.hostname if @attributes.occi.compute if @attributes.occi
      end

      def hostname=(hostname)
        @attributes.occi!.compute!.hostname = hostname
      end

      def speed
        @attributes.occi.compute.speed if @attributes.occi.compute if @attributes.occi
      end

      def speed=(speed)
        @attributes.occi!.compute!.speed = speed
      end

      def memory
        @attributes.occi.compute.memory if @attributes.occi.compute if @attributes.occi
      end

      def memory=(memory)
        @attributes.occi!.compute!.memory = memory
      end

      def state
        @attributes.occi.compute.state if @attributes.occi.compute if @attributes.occi
      end

      def state=(state)
        @attributes.occi!.compute!.state = state
      end

      def storagelink(target, mixins=[], attributes=Occi::Core::Attributes.new)
        link(target, Occi::Infrastructure::Storagelink.kind, mixins, attributes, rel=Occi::Infrastructure::Storage.type_identifier)
      end

      def networkinterface(target, mixins=[], attributes=Occi::Core::Attributes.new)
        link(target, Occi::Infrastructure::Networkinterface.kind, mixins, attributes)
      end

      def storagelinks
        @links.select { |link| link.kind == Occi::Infrastructure::Storagelink.kind }
      end

      def networkinterfaces
        @links.select { |link| link.kind == Occi::Infrastructure::Networkinterface.kind }
      end

    end
  end
end