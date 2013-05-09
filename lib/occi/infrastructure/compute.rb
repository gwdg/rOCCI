module Occi
  module Infrastructure
    class Compute < Occi::Core::Resource

      start = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
                                     term='start',
                                     title='start compute instance'

      stop = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
                                    term='stop',
                                    title='stop compute instance',
                                    attributes={:method => Occi::Core::AttributeProperties.new(
                                        {:mutable => true,
                                         :pattern => 'graceful|acpioff|poweroff',
                                         :default => 'poweroff'})}

      restart = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
                                       term='restart',
                                       title='restart compute instance',
                                       attributes={:method => Occi::Core::AttributeProperties.new(
                                           {:mutable => true,
                                            :pattern => 'graceful|warm|cold',
                                            :default => 'cold'})}

      suspend = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
                                       term='suspend',
                                       title='suspend compute instance',
                                       attributes={:method => Occi::Core::AttributeProperties.new(
                                           {:mutable => true,
                                            :pattern => 'hibernate|suspend',
                                            :default => 'suspend'})}


      self.actions = Occi::Core::Actions.new << start << stop << restart << suspend

      self.attributes = Occi::Core::Attributes.split('occi.compute.architecture' => Occi::Core::AttributeProperties.new(:mutable => true,
                                                                                                                        :pattern => 'x86|x64'),
                                                     'occi.compute.cores' => Occi::Core::AttributeProperties.new(:type => 'number',
                                                                                                                 :mutable => true),
                                                     'occi.compute.hostname' => Occi::Core::AttributeProperties.new(:mutable => true,
                                                                                                                    :pattern => '(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*'),
                                                     'occi.compute.memory' => Occi::Core::AttributeProperties.new(:type => 'number',
                                                                                                                  :mutable => true),
                                                     'occi.compute.state' => Occi::Core::AttributeProperties.new(:pattern => 'inactive|active|suspended|error',
                                                                                                                 :default => 'inactive'))

      self.kind = Occi::Core::Kind.new scheme='http://schemas.ogf.org/occi/infrastructure#',
                                       term='compute',
                                       title = 'compute resource',
                                       attributes=self.attributes,
                                       related=Occi::Core::Related.new << Occi::Core::Resource.kind,
                                       actions = self.actions,
                                       location = '/compute/'

      require 'occi/infrastructure/resource_tpl'
      require 'occi/infrastructure/os_tpl'
      self.mixins = Occi::Core::Mixins.new << Occi::Infrastructure::Resource_tpl.mixin << Occi::Infrastructure::Os_tpl.mixin

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