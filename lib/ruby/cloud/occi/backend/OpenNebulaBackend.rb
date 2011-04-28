require 'OpenNebula'
require 'CloudServer'
require 'CloudClient'
require 'Configuration'
require 'occi/backend/VmOcci'
require 'occi/backend/VNetOcci'
require 'occi/backend/VImageOcci'
require 'rexml/document'

##############################################################################
# Include OpenNebula Constants
##############################################################################

include OpenNebula

module OCCI
  module Backend
  class OpenNebulaInterface < CloudServer

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

    TEMPLATECOMPUTERAWFILE = 'OCCI/CloudManagerInterfaces/OpenNebulaInterface/Templates/template_compute_raw.erb'
    TEMPLATENETWORKRAWFILE = 'OCCI/CloudManagerInterfaces/OpenNebulaInterface/Templates/template_network_raw.erb'
    TEMPLATESTORAGERAWFILE = 'OCCI/CloudManagerInterfaces/OpenNebulaInterface/Templates/template_storage_raw.erb'
    @@hashnew = {}

    def initialize(configfile)
      super(configfile)
    end

    # CREATE a VM

    def create_compute_instance(computeObject)
      attr = []
      storageLinks = []
      networkLinks = []
      #attributes = computeObject.attributes
      attributes = computeObject.attributes
      pp "Attrib in backend : #{attributes}"
      attributes.each do |attr_key, attr_value|
        pp "attr_key: #{attr_key} ---- attr_value: #{attr_value}"
      end
      links = attributes["links"]
      if links != nil
        links.each do
          |link|
          case link.getKind().term
          when "storagelink"
            storageLinks << link
          when "networkinterace"
            networkLinks << link
          end
        end
      end
      xmlLoc = VmOcci.build_xml
      vMachine=VmOcci.new(xmlLoc, @one_client)
      @templateRaw = TEMPLATECOMPUTERAWFILE
      template = ERB.new(File.read(@templateRaw)).result(binding)
      rc = vMachine.allocate(template)
      vMachineInfo = vMachine.info_xml
      if rc == nil
        # Formatierte Ausgabe mit ausgewählten Informationen über die Virtuelle-Maschine (da "ausgewählte" Informationen vorhanden)
        # recht übersichtliche Ausgabe -
        begin
          adinfo = vMachine.to_occi(@@occi_vmm)
          doc = REXML::Document.new(adinfo)
          
          xmlLoc = doc.root
          computeObject.attributes["id"] = REXML::XPath.first(doc, "//ID").text
        end
      else
        pp rc.inspect
        raise OCCI::Errors::BackEndError, rc
        error = OpenNebula::Error
      end
    end

    # GET a VM
    def getVmInstance_by_id_ret_name(iD)
      vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
      vMInfo = vM.info
      begin
        doc = REXML::Document.new(vMInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
        xmlDoc = doc.root
        str = ""
        REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
        # puts "\n" + str + "\n "
        vMName = REXML::XPath.first(doc, "//NAME")
      end
    end

    # GET a VM
    def getVmInstance_by_id_ret_attributes(iD)
      attributes = {}
      vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
      vMInfo = vM.info
      if vMInfo.instance_of?(OpenNebula::Error)
        error_bool = true
      else error_bool = false
      end

      if error_bool == false
        vMInfo = vM.info_xml()
        begin
          doc = REXML::Document.new(vMInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
          xmlDoc = doc.root
          str = ""
          REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
          #puts "\n" + str + "\n "
          vm_state = vM.state_str
          vm_id = REXML::XPath.first(doc, "//ID")
          vm_hostname = REXML::XPath.first(doc, "//NAME")
          vm_architecture = REXML::XPath.first(doc, "//TEMPLATE/ARCHITECTURE")
          vm_cores = REXML::XPath.first(doc, "//TEMPLATE/CORES")
          vm_memory = REXML::XPath.first(doc, "//TEMPLATE/MEMORY")
          vm_speed = REXML::XPath.first(doc, "//TEMPLATE/SPEED")
          attributes.merge!('occi.compute.cores'        => vm_cores.text) if vm_cores != nil
          attributes.merge!('occi.compute.architecture' => vm_architecture.text) if vm_architecture != nil
          attributes.merge!('occi.compute.state'        => vm_state) if vm_state != nil
          attributes.merge!('occi.compute.hostname'     => vm_hostname.text) if vm_hostname != nil
          attributes.merge!('occi.compute.memory'       => vm_memory.text) if vm_memory != nil
          attributes.merge!('occi.compute.speed'        => vm_speed.text) if vm_speed != nil
          attributes.merge!('id'                        => vm_id.text) if vm_id != nil
          return attributes
        end
      else
        return vMInfo
      end
    end

    # GET a VM by id ret state
    def getVmInstance_by_id_ret_state(iD)
      vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
      vMInfo = vM.info
      if vMInfo.instance_of?(OpenNebula::Error)
        error_bool = true
      else error_bool = false
      end

      if error_bool == false
        vMInfo = vM.info_xml()
        begin
          doc = REXML::Document.new(vMInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
          xmlDoc = doc.root
          str = ""
          REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
          #puts "\n" + str + "\n "
          vm_state = vM.state_str
          return vm_state
        end
      else
        return vMInfo
      end
    end

    # DELETE / FINALIZE a VM
    def delete_compute_instance(iD)
      vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
      vMInfo = vM.info
      if vMInfo.instance_of?(OpenNebula::Error)
        error_bool = true
      else error_bool = false
      end
      if error_bool == false
        vM.finalize
        return true
      else
        return vMInfo
      end
    end

    # GET ALL VMs - A POOL INSTANCE
    def get_all_vm_ids()
      vm_pool = VirtualMachinePool.new(@one_client, -1)
      rc = vm_pool.info
      if OpenNebula.is_error?(rc)
        raise OCCI::Errors::BackEndError, rc.message
      else
        ids = []
        vm_pool.each do |vm|
          ids << vm.id.to_s
        end
      end
      return ids
    end

    #    # GET ALL VMs - A POOL INSTANCE
    #    def get_all_vm_instances()
    #      vm_pool = VirtualMachinePool.new(@one_client, -1)
    #      rc = vm_pool.info
    #      if OpenNebula.is_error?(rc)
    #        raise OCCI::Errors::BackEndError, rc.message
    #      else
    #        vm_pool.each do |vm|
    #          locations << "#{$url}compute/#{vm.id.to_s},"
    #          locations_plain << "X-OCCI-LOCATION: "
    #          locations_plain << "#{$url}compute/#{vm.id.to_s}\n"
    #        end
    #
    #      end
    #      return rc, locations_occi, locations_plain
    #    end

    # Trigger an action on VM
    def trigger_action_on_vm_instance(iD, actiontype, method=nil)
      vM=VmOcci.new(VmOcci.build_xml(iD), @one_client)
      vMInfo = vM.info
      if vMInfo.instance_of?(OpenNebula::Error)
        error_bool = true
      else error_bool = false
      end
      if error_bool == false
        if actiontype == "start" then
          rc = vM.send("resume")
        elsif actiontype == "restart"
          rc = vM.send("stop")
          vMInfo = vM.info
          thread2 = Thread.new{
            while vM.state_str != "PENDING" do
              vMInfo = vM.info
              rc=vM.send("resume")
              vMInfo = vM.info
            end
          }
        else rc = vM.send(actiontype)
        end
      else
        raise OCCI::Errors::BackEndError, "#{rc.inspect} - ActionType not defined?}"
      end
    end

    # CREATE a VNET
    def createNetworkInstance(networkObject)
      o = []
      attributes = networkObject.attributes

      xmlLoc = VNetOcci.build_xml
      vNET=VNetOcci.new(xmlLoc, @one_client)
      @templateRaw = TEMPLATENETWORKRAWFILE
      template = ERB.new(File.read(@templateRaw)).result(binding)
      rc = vNET.allocate(template)
      vNETInfo = vNET.info

      if rc == nil

        # Formatierte Ausgabe mit ausgewählten Informationen über die Virtuelle-Maschine (da "ausgewählte" Informationen vorhanden)
        # recht übersichtliche Ausgabe -
        begin
          adinfo = vNET.to_occi(@@occi_vnet)
          doc = REXML::Document.new(adinfo)
          networkObject.attributes["id"] = REXML::XPath.first(doc, "//NAME").text
        end
      else
        raise OCCI::Errors::BackEndError, "#{rc.inspect} - VirtualNetworkName already exists?}"
        error = OpenNebula::Error.new(rc)
      end
    end

    # TODO: genau wie bei get VM Fehlerbehandlung einführen
    # GET a VNET RET NAME
    def getNetworkInstance_by_id_ret_name(iD)
      vNET=VNetOcci.new(VNetOcci.build_xml(iD), @one_client)
      vNetInfo = vNET.info
      begin
        doc = REXML::Document.new(vNetInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
        xmlDoc = doc.root
        str = ""
        REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
        # puts "\n" + str + "\n "
        vNetName = REXML::XPath.first(doc, "//NAME")
      end
    end

    # TODO: genau wie bei get VM Fehlerbehandlung einführen
    # GET a VNET RET ID
    def getNetworkInstance_by_id_ret_attributes(iD)
      attributes = {}
      vNET=VNetOcci.new(VNetOcci.build_xml(iD), @one_client)
      vNetInfo = vNET.info
      begin
        doc = REXML::Document.new(vNetInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
        xmlDoc = doc.root
        str = ""
        REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
        # puts "\n" + str + "\n "

        vnet_state = REXML::XPath.first(doc, "//NETSTATE")
        vnet_vlan = REXML::XPath.first(doc, "//VLAN")
        vnet_label = REXML::XPath.first(doc, "//LABEL")
        vnet_id = REXML::XPath.first(doc, "//ID")

        attributes.merge!('occi.network.state'    => vnet_state.text) if vnet_state != nil
        attributes.merge!('occi.network.vlan'     => vnet_vlan.text) if vnet_vlan != nil
        attributes.merge!('occi.network.label'    => vnet_label.text) if vnet_label != nil
        attributes.merge!('id'                    => vnet_id.text) if vnet_id != nil

        return attributes
      end
    end

    # TODO: genau wie bei get VM Fehlerbehandlung einführen
    # GET a VNET RET STATE
    def getNetworkInstance_by_id_ret_state(iD)
      vNET=VNetOcci.new(VNetOcci.build_xml(iD), @one_client)
      vNetInfo = vNET.info
      begin
        doc = REXML::Document.new(vNetInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
        xmlDoc = doc.root
        str = ""
        REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
        # puts "\n" + str + "\n "
        vnet_state = REXML::XPath.first(doc, "//NETSTATE")
        return vnet_state
      end
    end

    #    # GET ALL VNET'S - A POOL INSTANCE
    #    def get_all_vnet_instances()
    #      locations_occi = []
    #      locations_plain = []
    #      vnet_pool = VirtualNetworkPool.new(@one_client, -1)
    #      rc = vnet_pool.info
    #      if OpenNebula.is_error?(rc)
    #        raise OCCI::Errors::BackEndError, rc.message
    #      else
    #        vnet_pool.each do |vnet|
    #          locations_occi << "#{$url}network/#{vnet.id.to_s},"
    #          locations_occi_for_entity = "#{$url}network/#{vnet.id.to_s}"
    #          OCCI::Infrastructure::Network::get_network_kind.addEntity(OCCI::Infrastructure::Network::reverse_initialize(locations_occi_for_entity))
    #          locations_plain << "X-OCCI-LOCATION: "
    #          locations_plain << "#{$url}network/#{vnet.id.to_s}\n"
    #        end
    #        #pp OCCI::Infrastructure::Network::get_network_kind.entities
    #      end
    #      return rc, locations_occi, locations_plain
    #    end

    # GET ALL VNET'S - A POOL INSTANCE
    def get_all_vnet_ids()
      ids = []
      vnet_pool = VirtualNetworkPool.new(@one_client, -1)
      rc = vnet_pool.info
      if OpenNebula.is_error?(rc)
        raise OCCI::Errors::BackEndError, rc.message
      else
        vnet_pool.each do |vnet|
          ids << vnet.id.to_s
        end
      end
      return ids
    end

    # DELETE / FINALIZE a VNET
    def delete_vnet_instance(iD)
      vnet=VNetOcci.new(VNetOcci.build_xml(iD), @one_client)
      vnet_info = vnet.info
      if vnet_info.instance_of?(OpenNebula::Error)
        error_bool = true
      else error_bool = false
      end
      if error_bool == false
        vnet.delete
        return true
      else
        return vnet_info
      end
    end

    # CREATE a STORAGE / IMAGE
    def createStorageInstance(storageObject)
      attributes = storageObject.attributes
      xmlLoc = VImageOcci.build_xml
      vImage=VImageOcci.new(xmlLoc, @one_client)
      @templateRaw = TEMPLATESTORAGERAWFILE
      template = ERB.new(File.read(@templateRaw)).result(binding)
      rc = vImage.allocate(template)
      rc_enable = vImage.enable
      vImageInfo = vImage.info
      if rc == nil
        # Formatierte Ausgabe mit ausgewählten Informationen über die Virtuelle-Maschine (da "ausgewählte" Informationen vorhanden)
        # recht übersichtliche Ausgabe -
        begin
          adinfo = vImage.to_occi(@@occi_vimage)
          doc = REXML::Document.new(adinfo)
          xmlLoc = doc.root
          storageObject.attributes["id"] = REXML::XPath.first(doc, "//NAME").text
        end
      else
        raise OCCI::Errors::BackEndError, "#{rc.inspect} - ImageName already exists?}"
        error = OpenNebula::Error.new(rc)
      end
    end

    # TODO: genau wie bei get VM Fehlerbehandlung einführen
    # GET an IMAGE
    def getStorageInstance_by_id_ret_name(iD)
      vIMAGE=VImageOcci.new(Image.build_xml(iD), @one_client)
      vImageInfo = vIMAGE.info
      begin
        doc = REXML::Document.new(vImageInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
        xmlDoc = doc.root
        str = ""
        REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
        #puts "\n" + str + "\n "
        vImageName = REXML::XPath.first(doc, "//NAME")
      end
    end

    # TODO: genau wie bei get VM Fehlerbehandlung einführen
    # GET an IMAGE
    def getStorageInstance_by_id_ret_id(iD)
      vIMAGE=VImageOcci.new(Image.build_xml(iD), @one_client)
      vImageInfo = vIMAGE.info
      begin
        doc = REXML::Document.new(vImageInfo.to_s) #  to_s wichtig... kann aus array ansonsten kein string erstellen
        xmlDoc = doc.root
        str = ""
        REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
        #puts "\n" + str + "\n "
        vimage_size = REXML::XPath.first(doc, "//SIZE")
        vimage_state = REXML::XPath.first(doc, "//TEMPLATE/STATE")
        return vimage_size, vimage_state
      end
    end

    #    # GET ALL Images - A POOL INSTANCE
    #    def get_all_image_instances()
    #      locations_occi = []
    #      locations_plain = []
    #      image_pool = ImagePool.new(@one_client, -1)
    #      rc = image_pool.info
    #      if OpenNebula.is_error?(rc)
    #        raise OCCI::Errors::BackEndError, rc.message
    #      else
    #        image_pool.each do |image|
    #          locations_occi << "#{$url}image/#{image.id.to_s},"
    #          locations_plain << "X-OCCI-LOCATION: "
    #          locations_plain << "#{$url}image/#{image.id.to_s}\n"
    #        end
    #
    #      end
    #      return rc, locations_occi, locations_plain
    #    end

    # GET ALL Images - A POOL INSTANCE
    def get_all_image_ids()
      ids = []
      image_pool = ImagePool.new(@one_client, -1)
      rc = image_pool.info
      if OpenNebula.is_error?(rc)
        raise OCCI::Errors::BackEndError, rc.message
      else
        image_pool.each do |image|
          ids << image.id.to_s
        end
      end
      return ids
    end

    # TODO: genau wie bei get VM Fehlerbehandlung einführen
    # return: attributes
    def getImageInstance_by_id_ret_attributes(iD)
      attributes = {}
      vImage=VImageOcci.new(VImageOcci.build_xml(iD), @one_client)
      vNetInfo = vImage.info
      begin
        doc = REXML::Document.new(vNetInfo.to_s)
        xmlDoc = doc.root
        str = ""
        REXML::Formatters::Pretty.new(4).write(xmlDoc,str)
        # puts "\n" + str + "\n "

        vimage_size = REXML::XPath.first(doc, "//SIZE")
        vimage_state = REXML::XPath.first(doc, "//TEMPLATE/STATE")
        vimage_id = REXML::XPath.first(doc, "//ID")

        attributes.merge!('occi.storage.size'    => vimage_size.text) if vimage_size != nil
        attributes.merge!('occi.storage.state'   => vimage_state.text) if vimage_state != nil
        attributes.merge!('id'                   => vimage_id.text) if vimage_id != nil

        return attributes
      end
    end

    # TODO: to be implement, but OpenNebula does not yet support linking of two resource instances at runtime
    # CREATE a NETWORKINTERFACE
    def createNetworkInterfaceInstance(network_interface_object)
      puts "DUMMY METHOD createNetworkInterfaceInstance called"
      link_loc = "http://localhost:4567/link/network/link_stor0001"
      #  return nil, "456"

    end

    # DELETE a NETWORKINTERFACE
    def delete_networkinterface_instance(iD)
      puts "NETWORKINTERFACE INSTANCE DELETED"
      true
    end

    # CREATE a StorageLink
    def createStorageLinkInstance(attributes, kind)
      puts "DUMMY METHODE createStorageLinkInstance wurde aufgerufen"
    end
  end
end

class Object
  def get_name
    line_number   = caller[0].split(':')[1].to_i
    line_exectued = File.readlines(__FILE__)[line_number-1]
    line_exectued.match(/(\S+)\.get_name/)[1]
  end
end

#class Hash
#  def self.transform_keys_to_symbols(value)
#    return value if not value.is_a?(Hash)
#    hash = value.inject({}){|memo,(k,v)| memo[k.to_sym] = Hash.transform_keys_to_symbols(v); memo}
#    return hash
#  end
#end
end
