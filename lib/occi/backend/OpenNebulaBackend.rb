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
require 'occi/ActionDelegator'
require 'occi/backend/one/Image'
require 'occi/backend/one/Network'
require 'occi/backend/one/VirtualMachine'
require 'occi/backend/one/VNC'
require 'occi/mixins/Reservation'

##############################################################################
# Include OpenNebula Constants
##############################################################################

include OpenNebula

module OCCI
  module Backend
    class OpenNebulaBackend
      def initialize(configfile)
        $categoryRegistry.register_mixin(OCCI::Backend::ONE::Image::MIXIN)
        $categoryRegistry.register_mixin(OCCI::Backend::ONE::Network::MIXIN)
        $categoryRegistry.register_mixin(OCCI::Backend::ONE::VirtualMachine::MIXIN)
        $categoryRegistry.register_mixin(OCCI::Mixins::Reservation::MIXIN)

        # TODO: create mixins from existing templates

        # initialize OpenNebula connection
        $log.debug("Initializing connection with OpenNebula")
        @one_client = Client.new($config['one_user'] + ':' + $config['one_password'],$config['one_xmlrpc'])

        $log.debug("Get existing objects from OpenNebula")
        network_get_all
        storage_get_all
        compute_get_all_instances
        compute_get_all_templates

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
      # Virtual Machine Template methods

      # CREATE COMPUTE INSTANCE
      def create_compute_instance(occi_compute_object)
        one_compute_object=VirtualMachine.new(VirtualMachine.build_xml, @one_client)
        create_compute_object(occi_compute_object,one_compute_object)
      end

      # CREATE COMPUTE TEMPLATE
      def create_compute_template(occi_compute_object)
        one_compute_object=Template.new(Template.build_xml, @one_client)
        create_compute_object(occi_compute_object,one_compute_object)
      end

      # CREATE COMPUTE OBJECT
      def create_compute_object(occi_compute_object,one_compute_object)
        storage_ids = []
        network_ids = []
        attributes = occi_compute_object.attributes
        links = occi_compute_object.links
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
        $log.debug("Storage IDs: #{storage_ids}")
        $log.debug("Network IDs: #{network_ids}")
        @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATECOMPUTERAWFILE
        compute_template = ERB.new(File.read(@templateRaw)).result(binding)
        $log.debug("Parsed template #{compute_template}")
        rc = one_compute_object.allocate(compute_template)
        if OpenNebula.is_error?(rc)
          $log.warn("Problem with creation of compute resource. Error message: #{rc}")
        end
        $log.debug("Return code from OpenNebula #{rc}") if rc != nil
        occi_compute_object.backend_id = one_compute_object.id
        $log.debug("OpenNebula ID of virtual machine: #{occi_compute_object.backend_id}")
        $log.debug("OpenNebula automatically triggers action start for Virtual Machines")
        $log.debug("Changing state to started")
      end

      # DELETE COMPUTE INSTANCE
      def delete_compute_instance(occi_compute_object)
        one_compute_object=VirtualMachine.new(VirtualMachine.build_xml(occi_compute_object.backend_id), @one_client)
        delete_compute_object(occi_compute_object,one_compute_object)
      end

      # DELETE COMPUTE TEMPLATE
      def delete_compute_template(occi_compute_object)
        one_compute_object=Template.new(Template.build_xml(occi_compute_object.backend_id), @one_client)
        delete_compute_object(occi_compute_object,one_compute_object)
      end

      # DELETE COMPUTE OBJECT
      def delete_compute_object(occi_compute_object,one_compute_object)
        rc = one_compute_object.finalize
        $log.debug("Return code from OpenNebula #{rc}") if rc != nil
      end

      # GET ALL COMPUTE INSTANCES
      def compute_get_all_instances()
        compute_object_pool=VirtualMachinePool.new(@one_client)
        $log.debug("Compute object pool: #{compute_object_pool}")
        $log.debug("Compute object pool info: #{compute_object_pool.info_all}")
        compute_get_all_objects(compute_object_pool)
      end

      # GET ALL COMPUTE TEMPLATES
      def compute_get_all_templates()
        compute_template_pool=TemplatePool.new(@one_client)
        compute_template_pool.info
        $log.debug("Compute template pool info: #{compute_template_pool.info_all}")
        compute_get_all_objects(compute_template_pool,template=true)
      end

      # GET ALL COMPUTE OBJECTS
      def compute_get_all_objects(one_compute_object_pool,template=false)
        one_compute_object_pool.each do |one_compute_object|
          $log.debug("ONE compute object: #{one_compute_object}")
          attributes, mixins = compute_parse_object(one_compute_object)
          mixins << OCCI::Infrastructure::ResourceTemplate::MIXIN if template
          $log.debug("Attributes: #{attributes}")
          $log.debug("Mixins: #{mixins}")
          occi_compute_object = OCCI::Infrastructure::Compute.new(attributes,mixins)
          occi_compute_object.backend_id = one_compute_object.id
          $log.debug("Backend ID: #{occi_compute_object.backend_id}")
          $log.debug("OCCI compute object location: #{occi_compute_object.get_location}")
          $locationRegistry.register_location(occi_compute_object.get_location, occi_compute_object)
          compute_parse_links(occi_compute_object,one_compute_object)
        end
      end

      # REFRESH COMPUTE INSTANCE
      def compute_refresh_instance(occi_compute_object)
        $log.debug("Refreshing compute object with backend ID: #{occi_compute_object.backend_id}")
        one_compute_object = VirtualMachine.new(VirtualMachine.build_xml(occi_compute_object.backend_id), @one_client)
        one_compute_object.info
        attributes, mixins = compute_parse_object(one_compute_object,occi_compute_object.attributes)
        $log.debug("Attributes: #{attributes}")
        $log.debug("Mixins: #{mixins}")
        occi_compute_object.attributes.merge!(attributes)
        occi_compute_object.mixins.concat(mixins).uniq!
        compute_update_state(occi_compute_object,one_compute_object)
        occi_compute_object.attributes['occi.compute.state'] = occi_compute_object.state_machine.current_state.name
      end

      # PARSE OPENNEBULA COMPUTE OBJECT
      def compute_parse_object(one_compute_object,attributes={})
        require 'yaml'
        $log.debug("ONE compute object: #{one_compute_object.to_hash.to_yaml}")
        mixins = []
        mixins << OCCI::Backend::ONE::VirtualMachine::MIXIN

        # parse all parameters from OpenNebula to OCCI
        attributes['occi.core.id'] = one_compute_object['TEMPLATE/OCCI_ID']
        attributes['occi.core.title'] = one_compute_object['NAME']
        attributes['occi.core.summary'] = one_compute_object['TEMPLATE/DESCRIPTION']
        attributes['occi.compute.cores'] = one_compute_object['TEMPLATE/CPU']
        if one_compute_object['TEMPLATE/ARCHITECTURE'] == "x86_64"
          attributes['occi.compute.architecture'] = "x64"
        else
          attributes['occi.compute.architecture'] = "x86"
        end
        attributes['occi.compute.memory'] = one_compute_object['TEMPLATE/MEMORY']
        attributes['opennebula.vm.vcpu'] = one_compute_object['TEMPLATE/VCPU']
        attributes['opennebula.vm.boot'] = one_compute_object['TEMPLATE/BOOT']

        $log.debug("NOVNC path: #{$config[:novnc_path]}")
        $log.debug("Graphics type: #{one_compute_object['TEMPLATE/GRAPHICS/TYPE']}")
        $log.debug("VNC base port: #{$config[:vnc_proxy_base_port]}")
        $log.debug("VNC port: #{one_compute_object['TEMPLATE/GRAPHICS/PORT']}")
        $log.debug("VNC host: #{one_compute_object['HISTORY_RECORDS/HISTORY/HOSTNAME']}")

        if one_compute_object['TEMPLATE/GRAPHICS/TYPE'] == 'vnc' \
          and one_compute_object['HISTORY_RECORDS/HISTORY/HOSTNAME'] \
          and not $config[:novnc_path].nil? \
          and not $config[:vnc_proxy_base_port].nil?
          
          mixins << OCCI::Backend::ONE::VNC::MIXIN

          vnc_host = one_compute_object['HISTORY_RECORDS/HISTORY/HOSTNAME']
          vnc_port = one_compute_object['TEMPLATE/GRAPHICS/PORT']

          # The noVNC proxy_port
          proxy_port = $config[:vnc_proxy_base_port].to_i + vnc_port.to_i
            
          if attributes['opennebula.vm.vnc'].nil?

            # CREATE PROXY FOR VNC SERVER
            begin
              novnc_cmd = "#{$config[:novnc_path]}/utils/launch.sh"
              pipe = IO.popen("#{novnc_cmd} --listen #{proxy_port} \
                                            --vnc #{vnc_host}:#{vnc_port}")
                                            
              if pipe
                vnc_url = $config[:server] + ':' + vnc_port + '/vnc_auto.html?host=' + $config[:server] + '&port=' + vnc_port
                $log.debug("VNC URL: #{vnc_url}")
                attributes['opennebula.vm.vnc'] = vnc_host + ':' + vnc_port
                attributes['opennebula.vm.web_vnc'] = vnc_url
              end
            rescue Exception => e
              $log.error("Error in creating VNC proxy: #{e.message}")
            end
          end
        end

        return attributes, mixins
      end

      def compute_parse_links(occi_compute_object,one_compute_object)
        # create links for all storage instances
        one_compute_object['TEMPLATE/DISK/IMAGE_ID'].each do |image_id|
          attributes = {}
          target = nil
          $log.debug("Image ID: #{image_id}")
          OCCI::Infrastructure::Storage::KIND.entities.each do |storage|
            $log.debug("Storage Backend ID: #{storage.backend_id}")
            $log.debug(storage.backend_id.to_i == image_id.to_i)
            target = storage if storage.backend_id.to_i == image_id.to_i
          end
          break if target == nil
          source = occi_compute_object
          attributes["occi.core.target"] = target.get_location
          attributes["occi.core.source"] = source.get_location
          link = OCCI::Core::Link.new(attributes)
          source.links << link
          target.links << link
          $locationRegistry.register_location(link.get_location, link)
          $log.debug("Link successfully created")
        end if one_compute_object['TEMPLATE/DISK/IMAGE_ID']

        #create links for all network instances
        one_compute_object['TEMPLATE/NIC/NETWORK_ID'].each do |network_id|
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
          source = occi_compute_object
          attributes["occi.core.target"] = target.get_location
          attributes["occi.core.source"] = source.get_location
          link = OCCI::Core::Link.new(attributes)
          source.links << link
          target.links << link
          $locationRegistry.register_location(link.get_location, link)
          $log.debug("Link successfully created")
        end if one_compute_object['TEMPLATE/NIC/NETWORK_ID']
      end
      
      # COMPUTE GET STATE
      def compute_update_state(occi_compute_object,one_compute_object)
        $log.debug("current VM state is: #{one_compute_object.state_str}")
        state = case one_compute_object.lcm_state_str
#          LCM_STATE=%w{LCM_INIT PROLOG BOOT RUNNING MIGRATE SAVE_STOP SAVE_SUSPEND
#              SAVE_MIGRATE PROLOG_MIGRATE PROLOG_RESUME EPILOG_STOP EPILOG
#              SHUTDOWN CANCEL FAILURE CLEANUP UNKNOWN}
          when "PROLOG" || "BOOT" || "RUNNING" || "SAVE_STOP" || "SAVE_SUSPEND" || "SAVE_MIGRATE" || "MIGRATE" || "PROLOG_MIGRATE" || "PROLOG_RESUME" then OCCI::Infrastructure::Compute::STATE_ACTIVE
          when "SUSPENDED" then OCCI::Infrastructure::Compute::STATE_SUSPENDED
          else OCCI::Infrastructure::Compute::STATE_INACTIVE 
        end
        occi_compute_object.state_machine.set_state(state)
      end

      # COMPUTE ACTIONS

      # Action start
      def compute_start(action, parameters, resource)
        $log.debug("compute_start: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        vm=VirtualMachine.new(VirtualMachine.build_xml(resource.backend_id), @one_client)
        rc = vm.resume
        $log.debug("VM Info: #{vm.info}")
      end

      # Action stop
      def compute_stop(action, parameters, resource)
        $log.debug("compute_stop: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        vm=VirtualMachine.new(VirtualMachine.build_xml(resource.backend_id), @one_client)
        # TODO: implement parameters when available in OpenNebula
        case parameters
        when 'method="graceful"'
          $log.debug("Trying to stop VM graceful")
          rc = vm.shutdown
        when 'method="acpioff"'
          $log.debug("Trying to stop VM via ACPI off")
          rc = vm.shutdown
        when 'method="poweroff"'
          $log.debug("Powering off VM")
          rc = vm.shutdown
        end
        $log.debug("Error message from shutting down VM: #{rc.message}") if rc.is_error?
      end

      # Action restart
      def compute_restart(action, parameters, resource)
        $log.debug("compute_restart: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        vm=VirtualMachine.new(VirtualMachine.build_xml(resource.backend_id), @one_client)
        # TODO: implement parameters when available in OpenNebula
        case parameters
        when "graceful"
          vm.resubmit
        when "warm"
          vm.resubmit
        when "cold"
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

      ########################################################################
      # Network methods

      # CREATE VNET
      def create_network_instance(networkObject)
        attributes = networkObject.attributes
        network=VirtualNetwork.new(VirtualNetwork.build_xml(), @one_client)
        @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATENETWORKRAWFILE
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

      # REFRESH VNETs
      def network_refresh_instance(occi_network_object)
        $log.debug("Not implemented")
      end

      # GET ALL VNETs
      def network_get_all()
        mixins = []
        vnetpool=VirtualNetworkPool.new(@one_client)
        vnetpool.info_all
        vnetpool.each do |vnet|
          attributes = {}
          # parse all parameters from OpenNebula to OCCI
          attributes['occi.core.id'] = vnet['TEMPLATE/OCCI_ID']
          attributes['occi.core.title'] = vnet['NAME']
          attributes['occi.core.summary'] = vnet['TEMPLATE/DESCRIPTION']
          # attributes['opennebula.network.bridge'] = vnet['TEMPLATE/BRIDGE']
          # attributes['opennebula.network.public'] = vnet['TEMPLATE/PUBLIC']
          if vnet['TEMPLATE/TYPE'].downcase == 'fixed'
            mixins << OCCI::Backend::ONE::Network::MIXIN
            attributes['opennebula.network.leases'] = vnet['TEMPLATE/LEASES']
          end
          if vnet['TEMPLATE/TYPE'].downcase == 'ranged'
            mixins << OCCI::Infrastructure::Ipnetworking::MIXIN
            attributes['occi.network.allocation'] = 'dynamic'
            attributes['occi.network.address'] = vnet['TEMPLATE/NETWORK_ADDRESS'] + '/' + (32-(Math.log(vnet['TEMPLATE/NETWORK_SIZE'].to_i)/Math.log(2)).ceil).to_s
          end

          resource = OCCI::Infrastructure::Network.new(attributes,mixins)
          resource.backend_id = vnet.id
          $log.debug("Backend ID: #{resource.backend_id}")
          $locationRegistry.register_location(resource.get_location, resource)

        end
      end

      # Action up
      def network_up(action, parameters, resource)
        $log.debug("network_up: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        network=VirtualNetwork.new(VirtualNetwork.build_xml(resource.backend_id), @one_client)
        network.enable
        $log.debug("VM Info: #{network.info}")
      end

      # Action down
      def network_down(action, parameters, resource)
        $log.debug("network_down: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        network=VirtualNetwork.new(VirtualNetwork.build_xml(resource.backend_id), @one_client)
        network.disable
        $log.debug("VM Info: #{network.info}")
      end

      ########################################################################
      # Storage methods

      # CREATE STORAGE
      def create_storage_instance(storageObject)
        attributes = storageObject.attributes
        image=Image.new(Image.build_xml, @one_client)
        raise "No image provided" if $image_path == ""
        @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATESTORAGERAWFILE
        template = ERB.new(File.read(@templateRaw)).result(binding)
        $log.debug("Parsed template #{template}")
        rc = image.allocate(template)
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

      # REFRESH IMAGES
      def storage_refresh_instance(occi_storage_object)
        $log.debug("Not implemented")
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

          mixins = [OCCI::Backend::ONE::Image::MIXIN]

          resource = OCCI::Infrastructure::Storage.new(attributes,mixins)
          resource.backend_id = image.id
          $log.debug("Backend ID: #{resource.backend_id}")
          $locationRegistry.register_location(resource.get_location, resource)
        end
      end

      # Action online
      def storage_online(action, parameters, resource)
        $log.debug("storage_online: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        storage=Image.new(Image.build_xml(resource.backend_id), @one_client)
        storage.enable
        $log.debug("VM Info: #{network.info}")
      end

      # Action offline
      def storage_offline(action, parameters, resource)
        $log.debug("storage_offline: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        storage=Image.new(Image.build_xml(resource.backend_id), @one_client)
        storage.disable
        $log.debug("VM Info: #{network.info}")
      end

      # Action backup
      def storage_backup(action, parameters, resource)
        $log.debug("storage_backup: action [#{action}] with parameters [#{parameters}] called for resource [#{resource}]!")
        resource.links.each do |link_resource|
          link_resource.kind.term = "compute"
          compute = VirtualMachine.new(VirtualMachine.build_xml(link_resource.backend_id), @one_client)
          backup_id = compute.savedisk(resource.backend_id,"Backup " + Time.now)
          attributes = []
          backup = OCCI::Infrastructure::Storage.new(attributes)
          backup.backend_id = backup_id
          $locationRegistry.register_location(backup.get_location, backup)
        end
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