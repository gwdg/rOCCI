##############################################################################
#  Copyright 2011 Service Computing group, TU Dortmund
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##############################################################################

##############################################################################
# Description: OpenNebula Backend
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'rubygems'
require 'uuidtools'
require 'opennebula/OpenNebula'
require 'opennebula/CloudServer'
require 'opennebula/Configuration'
require 'occi/ActionDelegator'
require 'occi/backend/opennebula/Image'
require 'occi/backend/opennebula/Network'
require 'occi/backend/opennebula/VirtualMachine'
require 'occi/mixins/Reservation'

##############################################################################
# Include OpenNebula Constants
##############################################################################

include OpenNebula

module OCCI
  module Backend
    class OpenNebulaBackend < CloudServer
      def initialize(configfile)
        $categoryRegistry.register_mixin(OCCI::Backend::OpenNebula::Image::MIXIN)
        $categoryRegistry.register_mixin(OCCI::Backend::OpenNebula::Network::MIXIN)
        $categoryRegistry.register_mixin(OCCI::Backend::OpenNebula::VirtualMachine::MIXIN)
        $categoryRegistry.register_mixin(OCCI::Mixins::Reservation::MIXIN)
        super(configfile)
        network_get_all()
        storage_get_all()
        compute_get_all()
        
        # create action delegator
        delegator = OCCI::ActionDelegator.instance

        # register methods for compute actions
        delegator.register_method_for_action(OCCI::Infrastructure::Compute::ACTION_START, self, :compute_start)
        delegator.register_method_for_action(OCCI::Infrastructure::Compute::ACTION_STOP,  self, :compute_stop)
        delegator.register_method_for_action(OCCI::Infrastructure::Compute::ACTION_RESTART, self, :compute_restart)
        delegator.register_method_for_action(OCCI::Infrastructure::Compute::ACTION_SUSPEND, self, :compute_suspend)
        
        # register methods for network actions
        delegator.register_method_for_action(OCCI::Infrastructure::Network::ACTION_UP, self, :network_up)
        delegator.register_method_for_action(OCCI::Infrastructure::Network::ACTION_DOWN, self, :network_down)
        
        # register methods for storage actions
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_ONLINE, self, :storage_online)
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_OFFLINE, self, :storage_offline)
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_BACKUP, self, :storage_backup)
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_SNAPSHOT, self, :storage_snapshot)
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_RESIZE, self, :storage_resize)
      end

      TEMPLATECOMPUTERAWFILE = 'occi_one_template_compute.erb'
      TEMPLATENETWORKRAWFILE = 'occi_one_template_network.erb'
      TEMPLATESTORAGERAWFILE = 'occi_one_template_storage.erb'

      ########################################################################
      # Virtual Machine methods

      # CREATE VM
      def create_compute_instance(computeObject)
        storage_ids = []
        network_ids = []
        attributes = computeObject.attributes
        links = computeObject.links
        if links != nil
          links.each do
            |link|
            target = $locationRegistry.get_object_by_location(link.attributes['occi.core.target'])
            case target.kind.term
            when "storage"
              storage_ids << target.backend_id
            when "network"
              network_ids << target.backend_id
            end
          end
        end
        vm=VirtualMachine.new(VirtualMachine.build_xml, @one_client)
        @templateRaw = @config["TEMPLATE_LOCATION"] + TEMPLATECOMPUTERAWFILE
        template = ERB.new(File.read(@templateRaw)).result(binding)
        $log.debug("Parsed template #{template}")
        rc = vm.allocate(template)
        $log.debug("Return code from OpenNebula #{rc}") if rc != nil
        computeObject.backend_id = vm.id
        $log.debug("OpenNebula ID of virtual machine: #{computeObject.backend_id}")
      end

      # DELETE VM
      def delete_compute_instance(computeObject)
        vm=VirtualMachine.new(VirtualMachine.build_xml(computeObject.backend_id), @one_client)
        rc = vm.delete
        $log.debug("Return code from OpenNebula #{rc}") if rc != nil
      end

      # GET ALL VMs
      def compute_get_all()
        vmpool=VirtualMachinePool.new(@one_client)
        vmpool.info
        vmpool.each do |vm|
          attributes = {}
          # parse all parameters from OpenNebula to OCCI
          attributes['occi.core.id'] = vm['TEMPLATE/OCCI_ID']
          attributes['occi.core.title'] = vm['NAME']
          attributes['occi.core.summary'] = vm['TEMPLATE/DESCRIPTION']
          attributes['occi.compute.cores'] = vm['TEMPLATE/CPU']
          if vm['TEMPLATE/ARCHITECTURE'] == "x86_64"
            attributes['occi.compute.architecture'] = "x64"
          else
            attributes['occi.compute.architecture'] = "x86"
          end
          attributes['occi.compute.memory'] = vm['TEMPLATE/MEMORY']
          attributes["opennebula.vm.vcpu"] = vm['TEMPLATE/VCPU']
          attributes["opennebula.vm.boot"] = vm['TEMPLATE/BOOT']

          mixins = [OCCI::Backend::OpenNebula::VirtualMachine::MIXIN]

          resource = OCCI::Infrastructure::Compute.new(attributes,mixins)
          resource.backend_id = vm.id
          $log.debug("Backend ID: #{resource.backend_id}")
          $locationRegistry.register_location(resource.get_location, resource)

          # create links for all images
          vm['TEMPLATE/DISK/IMAGE_ID'].each do |image_id|
            attributes = {}
            target = nil
            $log.debug("Image ID: #{image_id}")
            OCCI::Infrastructure::Storage::KIND.entities.each do |storage|
              $log.debug("Storage Backend ID: #{storage.backend_id}")
              $log.debug(storage.backend_id.to_i == image_id.to_i)
              target = storage if storage.backend_id.to_i == image_id.to_i
            end
            break if target == nil
            source = resource
            attributes["occi.core.target"] = target.get_location
            attributes["occi.core.source"] = source.get_location
            link = OCCI::Core::Link.new(attributes)
            source.links << link
            target.links << link
            $locationRegistry.register_location(link.get_location, link)
            $log.debug("Link successfully created")
          end if vm['TEMPLATE/DISK/IMAGE_ID']

          #create links for all networks
          $log.debug("NETWORK_ID #{vm['TEMPLATE/NIC/NETWORK_ID']}")
          vm.retrieve_elements('TEMPLATE/NIC/NETWORK_ID').each do |network_id|
            attributes = {}
            $log.debug("Network ID: #{network_id}")
            target = nil
            OCCI::Infrastructure::Network::KIND.entities.each do |network|
              $log.debug("Network Backend ID: #{network.backend_id}")
              $log.debug(network.backend_id.to_i == network_id.to_i)
              target = network if network.backend_id.to_i == network_id.to_i
              $log.debug(target.kind.term) if target != nil
            end
            break if target == nil
            source = resource
            attributes["occi.core.target"] = target.get_location
            attributes["occi.core.source"] = source.get_location
            link = OCCI::Core::Link.new(attributes)
            source.links << link
            target.links << link
            $locationRegistry.register_location(link.get_location, link)
            $log.debug("Link successfully created")
          end if vm['TEMPLATE/NIC/NETWORK_ID']
        end

        # Action start
        def compute_start(action, parameters, resource)
          $log.debug("compute_start: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
          vm=VirtualMachine.new(VirtualMachine.build_xml(resource.backend_id), @one_client)
          vm.resume
          $log.debug("VM Info: #{vm.info}")
        end

        # Action stop
        def compute_stop(action, parameters, resource)
          $log.debug("compute_stop: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
          vm=VirtualMachine.new(VirtualMachine.build_xml(resource.backend_id), @one_client)
          case parameters
          when "graceful"
            vm.shutdown
          when "acpioff"
            vm.shutdown
          when "poweroff"
            vm.cancel
          end
          $log.debug("VM Info: #{vm.info}")
        end

        # Action restart
        def compute_restart(action, parameters, resource)
          $log.debug("compute_restart: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
          vm=VirtualMachine.new(VirtualMachine.build_xml(resource.backend_id), @one_client)
          case parameters
          when "graceful"
            vm.restart
          when "warm"
            vm.restart
          when "cold"
            vm.cancel
            vm.resubmit
          end
          $log.debug("VM Info: #{vm.info}")
        end

        # Action suspend
        def compute_suspend(action, parameters, resource)
          $log.debug("compute_suspend: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
          vm=VirtualMachine.new(VirtualMachine.build_xml(resource.backend_id), @one_client)
          vm.suspend
          $log.debug("VM Info: #{vm.info}")
        end

      end

      ########################################################################
      # Network methods

      # CREATE VNET
      def create_network_instance(networkObject)
        attributes = networkObject.attributes
        network=VirtualNetwork.new(VirtualNetwork.build_xml(), @one_client)
        @templateRaw = @config["TEMPLATE_LOCATION"] + TEMPLATENETWORKRAWFILE
        template = ERB.new(File.read(@templateRaw)).result(binding)
        $log.debug("Parsed template #{template}")
        rc = network.allocate(template)
        $log.debug("Return code from OpenNebula #{rc}") if rc != nil
        networkObject.backend_id = network.id
        $log.debug("OpenNebula ID of virtual network: #{networkObject.backend_id}")
      end

      # DELETE VNET
      def delete_network_instance(networkObject)
        network=VirtualNetwork.new(VirtualNetwork.build_xml(networkObject.backend_id), @one_client)
        rc = network.delete
        $log.debug("Return code from OpenNebula #{rc}") if rc != nil
      end

      # GET ALL VNETs
      def network_get_all()
        vnetpool=VirtualNetworkPool.new(@one_client)
        vnetpool.info
        vnetpool.each do |vnet|
          attributes = {}
          # parse all parameters from OpenNebula to OCCI
          attributes['occi.core.id'] = vnet['TEMPLATE/OCCI_ID']
          attributes['occi.core.title'] = vnet['NAME']
          attributes['occi.core.summary'] = vnet['TEMPLATE/DESCRIPTION']
          attributes['opennebula.network.bridge'] = vnet['TEMPLATE/BRIDGE']
          attributes['opennebula.network.public'] = vnet['TEMPLATE/PUBLIC']
          attributes['opennebula.network.type'] = vnet['TEMPLATE/TYPE']
          attributes['opennebula.network.address'] = vnet['TEMPLATE/NETWORK_ADDRESS']
          attributes['opennebula.network.size'] = vnet['TEMPLATE/NETWORK_SIZE']
          attributes['opennebula.network.leases'] = vnet['TEMPLATE/LEASES']

          mixins = [OCCI::Backend::OpenNebula::Network::MIXIN]

          resource = OCCI::Infrastructure::Network.new(attributes,mixins)
          resource.backend_id = vnet.id
          $log.debug("Backend ID: #{resource.backend_id}")
          $locationRegistry.register_location(resource.get_location, resource)

        end
      end

      # Action up
      def network_up(action, parameters, resource)
        $log.debug("network_up: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        network=VirtualNetwork.new(VirtualNetwork.build_xml(networkObject.backend_id), @one_client)
        network.publish
        $log.debug("VM Info: #{network.info}")
      end

      # Action down
      def network_down(action, parameters, resource)
        $log.debug("network_down: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        network=VirtualNetwork.new(VirtualNetwork.build_xml(networkObject.backend_id), @one_client)
        network.unpublish
        $log.debug("VM Info: #{network.info}")
      end

      ########################################################################
      # Storage methods

      # CREATE STORAGE
      def create_storage_instance(storageObject)
        attributes = storageObject.attributes
        image=Image.new(Image.build_xml, @one_client)
        raise "No image provided" if $image_path == ""
        @templateRaw = @config["TEMPLATE_LOCATION"] + TEMPLATESTORAGERAWFILE
        template = ERB.new(File.read(@templateRaw)).result(binding)
        $log.debug("Parsed template #{template}")
        rc = ImageRepository.new.create(image,template)
        $log.debug("Return code from OpenNebula #{rc}") if rc != nil
        storageObject.backend_id = image.id
        $log.debug("OpenNebula ID of image: #{storageObject.backend_id}")
      end

      # DELETE STORAGE / IMAGE
      def delete_storage_instance(storageObject)
        storage=Image.new(Image.build_xml(storageObject.backend_id), @one_client)
        rc = storage.delete
        $log.debug("Return code from OpenNebula #{rc}") if rc != nil
      end

      # GET ALL IMAGEs
      def storage_get_all()
        imagepool=ImagePool.new(@one_client)
        imagepool.info
        imagepool.each do |image|
          attributes = {}
          # parse all parameters from OpenNebula to OCCI
          attributes['occi.core.id'] = image['TEMPLATE/OCCI_ID']
          attributes['occi.core.title'] = image['NAME']
          attributes['occi.core.summary'] = image['TEMPLATE/DESCRIPTION']
          attributes['opennebula.image.type'] = image['TEMPLATE/TYPE']
          attributes['opennebula.image.public'] = image['TEMPLATE/PUBLIC']
          attributes['opennebula.image.persistent'] = image['TEMPLATE/PERSISTENT']
          attributes['opennebula.image.dev_prefix'] = image['TEMPLATE/DEV_PREFIX']
          attributes['opennebula.image.bus'] = image['TEMPLATE/BUS']
          if image['TEMPLATE/SIZE'] != nil
            attributes['occi.storage.size'] = image['TEMPLATE/SIZE']
          end
          if image['TEMPLATE/FSTYPE'] != nil
            attributes['occi.storage.fstype']
          end

          mixins = [OCCI::Backend::OpenNebula::Image::MIXIN]

          resource = OCCI::Infrastructure::Storage.new(attributes,mixins)
          resource.backend_id = image.id
          $log.debug("Backend ID: #{resource.backend_id}")
          $locationRegistry.register_location(resource.get_location, resource)
        end
      end

      # Action online
      def storage_online(action, parameters, resource)
        $log.debug("storage_online: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        storage=Image.new(Image.build_xml(storageObject.backend_id), @one_client)
        storage.enable
        $log.debug("VM Info: #{network.info}")
      end

      # Action offline
      def storage_offline(action, parameters, resource)
        $log.debug("storage_offline: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        storage=Image.new(Image.build_xml(storageObject.backend_id), @one_client)
        storage.disable
        $log.debug("VM Info: #{network.info}")
      end

      # Action backup
      def storage_backup(action, parameters, resource)
        $log.debug("storage_backup: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        $log.debug("not yet implemented")
      end

      # Action snapshot
      def storage_snapshot(action, parameters, resource)
        $log.debug("storage_snapshot: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        $log.debug("not yet implemented")
      end

      # Action resize
      def storage_resize(action, parameters, resource)
        $log.debug("storage_resize: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        $log.debug("not yet implemented")
      end

    end
  end
end