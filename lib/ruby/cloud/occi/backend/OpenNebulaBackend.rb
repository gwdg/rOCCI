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

      ########################################################################
      # Vorlage für die Response einer Virtuellen Maschine
      @@occi_vmm = %q{
                 <COMPUTE href="<%= $URL %>/compute/<%= self.id.to_s  %>">
                     <ID><%= self.id.to_s%></ID>
                     <NAME><%= self.name%></NAME>
                     <MEMORY><%=self['TEMPLATE/MEMORY']%></MEMORY>
                     <ARCHITECTURE><%=self['TEMPLATE/ARCHITECTURE']%></ARCHITECTURE>
                     <CORES><%=self['TEMPLATE/CORES']%></CORES>
                     <% if self['TEMPLATE/INSTANCE_TYPE'] %>
                     <INSTANCE_TYPE><%= self['TEMPLATE/INSTANCE_TYPE'] %></INSTANCE_TYPE>
                     <% end %>
                     <STATE><%= self.state_str %></STATE>
                     <% self.each('TEMPLATE/DISK') do |disk| %>
                     <DISK>
                         <STORAGE href="<http://localhost:4567/storage/<%= disk['IMAGE_ID'] %>" name="<%= disk['IMAGE'] %>" al_name="<%= disk['NAME'] %>" disk="<%= disk['DISK_ID'] %>"/>
                         <TYPE><%= disk['TYPE'] %></TYPE>
                         <TARGET><%= disk['TARGET'] %></TARGET>
                     </DISK>
                     <% end %>
                     <% self.each('TEMPLATE/NIC') do |nic| %>
                     <NIC>
                         <NETWORK href="<http://localhost:4567/network/<%= nic['NETWORK_ID'] %>" name="<%= nic['NETWORK'] %>"/>
                         <% if nic['IP'] %>
                         <IP><%= nic['IP'] %></IP>
                         <% end %>
                         <% if nic['MAC'] %>
                         <MAC><%= nic['MAC'] %></MAC>
                         <% end %>
                     </NIC>
                     <% end %>
                     <% if self['TEMPLATE/CONTEXT'] %>
                     <CONTEXT>
                     <% self.each('TEMPLATE/CONTEXT/*') do |cont| %>
                         <% if cont.text %>
                         <<%= cont.name %>><%= cont.text %></<%= cont.name %>>
                         <% end %>
                     <% end %>
                     </CONTEXT>
                     <% end %>
                 </COMPUTE>
             }

      @@occi_vnet = %q{
<NETWORK href="<%= $URL %>/network/<%= self.id.to_s  %>">
    <ID><%= self.id.to_s %></ID>
    <NAME><%= self.name %></NAME>
    <ADDRESS><%= self['TEMPLATE/NETWORK_ADDRESS'] %></ADDRESS>
    <% if self['TEMPLATE/NETWORK_SIZE'] %>
    <SIZE><%= self['TEMPLATE/NETWORK_SIZE'] %></SIZE>
    <% end %>
</NETWORK>
}

      @@occi_vimage = %q{
        <STORAGE href="<%= $URL %>/storage/<%= self.id.to_s  %>">
            <ID><%= self.id.to_s %></ID>
            <NAME><%= self.name %></NAME>
            <% if self['TEMPLATE/TYPE'] != nil %>
            <TYPE><%= self['TEMPLATE/TYPE'] %></TYPE>
            <% end %>
            <% if self['TEMPLATE/DESCRIPTION'] != nil %>
            <DESCRIPTION><%= self['TEMPLATE/DESCRIPTION'] %></DESCRIPTION>
            <% end %>
            <% if self['TEMPLATE/SIZE'] != nil %>
            <SIZE><%= self['TEMPLATE/SIZE'] %></SIZE>
            <% end %>
            <% if self['TEMPLATE/DEV_PREFIX'] != nil %>
            <DEVICE><%= self['TEMPLATE/DEV_PREFIX'] %></DEVICE>
            <% end %>
            <% if self['SOURCE'] != nil %>
            <SOURCE><%= self['SOURCE'] %></SOURCE>
            <% end %>
        </STORAGE>
    }
    
    
    def initialize(configfile)
      $categoryRegistry.register_mixin(OCCI::Backend::OpenNebula::Image::MIXIN)
      $categoryRegistry.register_mixin(OCCI::Backend::OpenNebula::Network::MIXIN)
      $categoryRegistry.register_mixin(OCCI::Backend::OpenNebula::VirtualMachine::MIXIN)
      super(configfile)
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
        links = attributes["links"]
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