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

# add OpenNebula Ruby lib to load path
$: << ENV['ONE_LOCATION'] + '/lib/ruby'

require 'rubygems'
require 'uuidtools'
require 'OpenNebula'
require 'CloudServer'
require 'CloudClient'
require 'Configuration'
require 'rexml/document'
require 'occi/ActionDelegator'
require 'occi/backend/opennebula/Image'
require 'occi/backend/opennebula/Network'
require 'occi/backend/opennebula/VirtualMachine'

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
        def compute_start(action, parameters, resource)
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
        def compute_start(action, parameters, resource)
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
        def compute_start(action, parameters, resource)
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
      def network_up(action, parameters, resource)
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

##############################################################################
# ATTIC

######################
# network

## TODO: genau wie bei get VM Fehlerbehandlung einführen
## GET a VNET RET NAME
#def getNetworkInstance_by_id_ret_name(iD)
#  vNET=VNetOcci.new(VNetOcci.build_xml(iD), @one_client)
#  vNetInfo = vNET.info
#  begin
#    doc = REXML::Document.new(vNetInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
#    xmlDoc = doc.root
#    str = ""
#    REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#    # puts "\n" + str + "\n "
#    vNetName = REXML::XPath.first(doc, "//NAME")
#  end
#end
#
## TODO: genau wie bei get VM Fehlerbehandlung einführen
## GET a VNET RET ID
#def getNetworkInstance_by_id_ret_attributes(iD)
#  attributes = {}
#  vNET=VNetOcci.new(VNetOcci.build_xml(iD), @one_client)
#  vNetInfo = vNET.info
#  begin
#    doc = REXML::Document.new(vNetInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
#    xmlDoc = doc.root
#    str = ""
#    REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#    # puts "\n" + str + "\n "
#
#    vnet_state = REXML::XPath.first(doc, "//NETSTATE")
#    vnet_vlan = REXML::XPath.first(doc, "//VLAN")
#    vnet_label = REXML::XPath.first(doc, "//LABEL")
#    vnet_id = REXML::XPath.first(doc, "//ID")
#
#    attributes.merge!('occi.network.state'    => vnet_state.text) if vnet_state != nil
#    attributes.merge!('occi.network.vlan'     => vnet_vlan.text) if vnet_vlan != nil
#    attributes.merge!('occi.network.label'    => vnet_label.text) if vnet_label != nil
#    attributes.merge!('id'                    => vnet_id.text) if vnet_id != nil
#
#    return attributes
#  end
#end
#
## TODO: genau wie bei get VM Fehlerbehandlung einführen
## GET a VNET RET STATE
#def getNetworkInstance_by_id_ret_state(iD)
#  vNET=VNetOcci.new(VNetOcci.build_xml(iD), @one_client)
#  vNetInfo = vNET.info
#  begin
#    doc = REXML::Document.new(vNetInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
#    xmlDoc = doc.root
#    str = ""
#    REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#    # puts "\n" + str + "\n "
#    vnet_state = REXML::XPath.first(doc, "//NETSTATE")
#    return vnet_state
#  end
#end
#
## GET ALL VNET'S - A POOL INSTANCE
#def get_all_vnet_ids()
#  ids = []
#  vnet_pool = VirtualNetworkPool.new(@one_client, -1)
#  rc = vnet_pool.info
#  if OpenNebula.is_error?(rc)
#    raise OCCI::Errors::BackEndError, rc.message
#  else
#    vnet_pool.each do |vnet|
#      ids << vnet.id.to_s
#    end
#  end
#  return ids
#end

############################
# VMs
# GET ALL VMs - A POOL INSTANCE
#def get_all_vm_ids()
#  vm_pool = VirtualMachinePool.new(@one_client, -1)
#  rc = vm_pool.info
#  if OpenNebula.is_error?(rc)
#    raise OCCI::Errors::BackEndError, rc.message
#  else
#    ids = []
#    vm_pool.each do |vm|
#      ids << vm.id.to_s
#    end
#  end
#  return ids
#end
#
## Trigger an action on VM
#def trigger_action_on_vm_instance(iD, actiontype, method=nil)
#  vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
#  vMInfo = vM.info
#  if vMInfo.instance_of?(OpenNebula::Error)
#    error_bool = true
#  else error_bool = false
#  end
#  if error_bool == false
#    if actiontype == "start" then
#      rc = vM.send("resume")
#    elsif actiontype == "restart"
#      rc = vM.send("stop")
#      vMInfo = vM.info
#      thread2 = Thread.new{
#        while vM.state_str != "PENDING" do
#          vMInfo = vM.info
#          rc=vM.send("resume")
#          vMInfo = vM.info
#        end
#      }
#    else rc = vM.send(actiontype)
#    end
#  else
#    raise OCCI::Errors::BackEndError, "#{rc.inspect} - ActionType not defined?}"
#  end
#end
#
## GET a VM
#def getVmInstance_by_id_ret_name(iD)
#  vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
#  vMInfo = vM.info
#  begin
#    doc = REXML::Document.new(vMInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
#    xmlDoc = doc.root
#    str = ""
#    REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#    # puts "\n" + str + "\n "
#    vMName = REXML::XPath.first(doc, "//NAME")
#  end
#end
#
## GET a VM
#def getVmInstance_by_id_ret_attributes(iD)
#  attributes = {}
#  vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
#  vMInfo = vM.info
#  if vMInfo.instance_of?(OpenNebula::Error)
#    error_bool = true
#  else error_bool = false
#  end
#
#  if error_bool == false
#    vMInfo = vM.info_xml()
#    begin
#      doc = REXML::Document.new(vMInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
#      xmlDoc = doc.root
#      str = ""
#      REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#      #puts "\n" + str + "\n "
#      vm_state = vM.state_str
#      vm_id = REXML::XPath.first(doc, "//ID")
#      vm_hostname = REXML::XPath.first(doc, "//NAME")
#      vm_architecture = REXML::XPath.first(doc, "//TEMPLATE/ARCHITECTURE")
#      vm_cores = REXML::XPath.first(doc, "//TEMPLATE/CORES")
#      vm_memory = REXML::XPath.first(doc, "//TEMPLATE/MEMORY")
#      vm_speed = REXML::XPath.first(doc, "//TEMPLATE/SPEED")
#      attributes.merge!('occi.compute.cores'        => vm_cores.text) if vm_cores != nil
#      attributes.merge!('occi.compute.architecture' => vm_architecture.text) if vm_architecture != nil
#      attributes.merge!('occi.compute.state'        => vm_state) if vm_state != nil
#      attributes.merge!('occi.compute.hostname'     => vm_hostname.text) if vm_hostname != nil
#      attributes.merge!('occi.compute.memory'       => vm_memory.text) if vm_memory != nil
#      attributes.merge!('occi.compute.speed'        => vm_speed.text) if vm_speed != nil
#      attributes.merge!('id'                        => vm_id.text) if vm_id != nil
#      return attributes
#    end
#  else
#    return vMInfo
#  end
#end
#
## GET a VM by id ret state
#def getVmInstance_by_id_ret_state(iD)
#  vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
#  vMInfo = vM.info
#  if vMInfo.instance_of?(OpenNebula::Error)
#    error_bool = true
#  else error_bool = false
#  end
#
#  if error_bool == false
#    vMInfo = vM.info_xml()
#    begin
#      doc = REXML::Document.new(vMInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
#      xmlDoc = doc.root
#      str = ""
#      REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#      #puts "\n" + str + "\n "
#      vm_state = vM.state_str
#      return vm_state
#    end
#  else
#    return vMInfo
#  end
#end

#########################
# Storage
#
## TODO: genau wie bei get VM Fehlerbehandlung einführen
## GET an IMAGE
#def getStorageInstance_by_id_ret_name(iD)
#  vIMAGE=VImageOcci.new(Image.build_xml(iD), @one_client)
#  vImageInfo = vIMAGE.info
#  begin
#    doc = REXML::Document.new(vImageInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
#    xmlDoc = doc.root
#    str = ""
#    REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#    #puts "\n" + str + "\n "
#    vImageName = REXML::XPath.first(doc, "//NAME")
#  end
#end
#
## TODO: genau wie bei get VM Fehlerbehandlung einführen
## GET an IMAGE
#def getStorageInstance_by_id_ret_id(iD)
#  vIMAGE=VImageOcci.new(Image.build_xml(iD), @one_client)
#  vImageInfo = vIMAGE.info
#  begin
#    doc = REXML::Document.new(vImageInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
#    xmlDoc = doc.root
#    str = ""
#    REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#    #puts "\n" + str + "\n "
#    vimage_size = REXML::XPath.first(doc, "//SIZE")
#    vimage_state = REXML::XPath.first(doc, "//TEMPLATE/STATE")
#    return vimage_size, vimage_state
#  end
#end
#
## GET ALL Images - A POOL INSTANCE
#def get_all_image_ids()
#  ids = []
#  image_pool = ImagePool.new(@one_client, -1)
#  rc = image_pool.info
#  if OpenNebula.is_error?(rc)
#    raise OCCI::Errors::BackEndError, rc.message
#  else
#    image_pool.each do |image|
#      ids << image.id.to_s
#    end
#  end
#  return ids
#end
#
## TODO: genau wie bei get VM Fehlerbehandlung einführen
## return: attributes
#def getImageInstance_by_id_ret_attributes(iD)
#  attributes = {}
#  vImage=VImageOcci.new(VImageOcci.build_xml(iD), @one_client)
#  vNetInfo = vImage.info
#  begin
#    doc = REXML::Document.new(vNetInfo.to_s)
#    xmlDoc = doc.root
#    str = ""
#    REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
#    # puts "\n" + str + "\n "
#
#    vimage_size = REXML::XPath.first(doc, "//SIZE")
#    vimage_state = REXML::XPath.first(doc, "//TEMPLATE/STATE")
#    vimage_id = REXML::XPath.first(doc, "//ID")
#
#    attributes.merge!('occi.storage.size'    => vimage_size.text) if vimage_size != nil
#    attributes.merge!('occi.storage.state'   => vimage_state.text) if vimage_state != nil
#    attributes.merge!('id'                   => vimage_id.text) if vimage_id != nil
#
#    return attributes
#  end
#end
#
## TODO: to be implement, but OpenNebula does not yet support linking of two resource instances at runtime
## CREATE a NETWORKINTERFACE
#def createNetworkInterfaceInstance(network_interface_object)
#  puts "DUMMY METHOD createNetworkInterfaceInstance called"
#  link_loc = "http://localhost:4567/link/network/link_stor0001"
#  #  return nil, "456"
#
#end
#
## DELETE a NETWORKINTERFACE
#def delete_networkinterface_instance(iD)
#  puts "NETWORKINTERFACE INSTANCE DELETED"
#  true
#end
#
## CREATE a StorageLink
#def createStorageLinkInstance(attributes, kind)
#  puts "DUMMY METHODE createStorageLinkInstance wurde aufgerufen"
#end