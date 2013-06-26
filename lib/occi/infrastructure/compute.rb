module Occi
  module Infrastructure
    class Compute < Occi::Core::Resource

      start = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
                                     term='start',
                                     title='start compute instance'

      stop = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
                                    term='stop',
                                    title='stop compute instance'
      stop.attributes['method'] = {:mutable => true,
                                   :pattern => 'graceful|acpioff|poweroff',
                                   :default => 'poweroff'}

      restart = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
                                       term='restart',
                                       title='restart compute instance'
      restart.attributes['method'] = {:mutable => true,
                                      :pattern => 'graceful|warm|cold',
                                      :default => 'cold'}

      suspend = Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/infrastructure/compute/action#',
                                       term='suspend',
                                       title='suspend compute instance'
      suspend.attributes['metod'] = {:mutable => true,
                                     :pattern => 'hibernate|suspend',
                                     :default => 'suspend'}

      self.actions = Occi::Core::Actions.new << start << stop << restart << suspend

      self.attributes = Occi::Core::AttributeProperties.new
      self.attributes['occi.compute.architecture'] = {:mutable => true,
                                                      :pattern => 'x86|x64'}
      self.attributes['occi.compute.cores'] = {:type => 'number',
                                               :mutable => true}
      self.attributes['occi.compute.hostname'] = {:mutable => true,
                                                  :pattern => '(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*'}
      self.attributes['occi.compute.memory'] = {:type => 'number',
                                                :mutable => true}
      self.attributes['occi.compute.state'] = {:pattern => 'inactive|active|suspended|error',
                                               :default => 'inactive'}

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