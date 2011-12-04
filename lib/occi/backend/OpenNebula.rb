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
require 'OpenNebula/OpenNebula'
require 'occi/CategoryRegistry'
require 'occi/rendering/http/LocationRegistry'
require 'occi/ActionDelegator'
require 'occi/backend/one/Image'
require 'occi/backend/one/Network'
require 'occi/backend/one/VirtualMachine'
require 'occi/backend/one/VNC'
require 'occi/extensions/Reservation'

include OpenNebula

module OCCI
  module Backend
    class OpenNebula
      attr_reader :one_client
      def initialize
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::Image::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::Network::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::VirtualMachine::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Mixins::Reservation::MIXIN)

        # TODO: create mixins from existing templates

        # initialize OpenNebula connection
        $log.debug("Initializing connection with OpenNebula")

        # TODO: check for error!
        @one_client = Client.new($config['one_user'] + ':' + $config['one_password'],$config['one_xmlrpc'])
      end

      def register_existing_resources
        # get all compute objects
        OCCI::Backend::OpenNebula::Compute.register_all_instances
        OCCI::Backend::OpenNebula::Compute.register_all_templates
        OCCI::Backend::OpenNebula::Network.register_all_instances
        OCCI::Backend::OpenNebula::Storage.register_all_instances
      end

      def check_rc(rc)
        if rc.class == Error
          raise OCCI::BackendError, "Error message from OpenNebula: #{rc.to_str}"
          # TODO: return failed!
        end
      end

      ########################################################################
      # COMPUTE class

      module Compute

        TEMPLATECOMPUTERAWFILE = 'occi_one_template_compute.erb'
        def deploy
          # initialize backend object as VM or VM template
          # TODO: figure out templates
          # backend_object=Template.new(Template.build_xml, $backend.one_client)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml, $backend.one_client)

          storages = []
          networks = []
          external_storages = []

          if @links != nil
            @links.each do
              |link|
              $log.debug(link.kind)
              target_URI = link.attributes['occi.core.target'] if URI.parse(link.attributes['occi.core.target']).absolute?
              target = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(link.attributes['occi.core.target'])
              case link.kind.term
              when 'storagelink'
                # TODO: incorporate mountpoint here (e.g. occi.storagelink.mountpoint )
                if not target.nil?
                  storages << [target, link]
                elsif not target_URI.nil?
                  external_storages << target_URI
                end
              when 'networkinterface'
                if not target.nil?
                  networks << [target, link]
                end
              when 'link'
                case target.kind.term
                when 'storage'
                  storages << [target, link]
                when 'network'
                  networks << [target, link]
                end unless target.nil?
              end
            end
          end

          @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATECOMPUTERAWFILE
          compute_template = ERB.new(File.read(@templateRaw)).result(binding)
          $log.debug("Parsed template #{compute_template}")
          rc = backend_object.allocate(compute_template)
          $backend.check_rc(rc)
          $log.debug("Return code from OpenNebula #{rc}") if rc != nil
          @backend[:id] = backend_object.id
          $log.debug("OpenNebula ID of virtual machine: #{@backend[:id]}")
          $log.debug("OpenNebula automatically triggers action start for Virtual Machines")
          $log.debug("Changing state to started")
        end

        def refresh
          $log.debug("Refreshing compute object with backend ID: #{@backend[:id]}")
          backend_object = VirtualMachine.new(VirtualMachine.build_xml(@backend[:id]), $backend.one_client)

          backend_object.info

          occi_object = OCCI::Backend::OpenNebula::Compute.parse_backend_object(backend_object)
          if occi_object.nil?
            $log.debug("Problems refreshing backend object")
          else
            # TODO: parse links?

            # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
            @attributes.merge!(occi_object.attributes)
            # concat mixins and remove duplicate mixins
            @mixins.concat(occi_object.mixins).uniq!
            # update state
            update_state
          end
        end

        def update_state
          backend_object = VirtualMachine.new(VirtualMachine.build_xml(@backend[:id]), $backend.one_client)
          backend_object.info
          $log.debug("current VM state is: #{backend_object.lcm_state_str}")
          state = case backend_object.lcm_state_str
          when "PROLOG" , "BOOT" , "RUNNING" , "SAVE_STOP" , "SAVE_SUSPEND" , "SAVE_MIGRATE" , "MIGRATE" , "PROLOG_MIGRATE" , "PROLOG_RESUME" then OCCI::Infrastructure::Compute::STATE_ACTIVE
          when "SUSPENDED" then OCCI::Infrastructure::Compute::STATE_SUSPENDED
          else OCCI::Infrastructure::Compute::STATE_INACTIVE
          end
          @state_machine.set_state(state)
          @attributes['occi.compute.state'] = @state_machine.current_state.name
        end

        def finalize
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend[:id]), $backend.one_client)

          rc = backend_object.finalize
          $backend.check_rc(rc)
          $log.debug("killing NoVNC pipe with pid #@backend[:novnc_pipe].pid") unless @backend[:novnc_pipe].nil?
          Process.kill 'INT', @backend[:novnc_pipe].pid unless @backend[:novnc_pipe].nil?
        end

        # GET ALL COMPUTE INSTANCES
        def self.register_all_instances
          backend_object_pool=VirtualMachinePool.new($backend.one_client)
          backend_object_pool.info_all
          self.register_all_objects(backend_object_pool)
        end

        # GET ALL COMPUTE TEMPLATES
        def self.register_all_templates
          backend_object_pool=TemplatePool.new($backend.one_client)
          backend_object_pool.info_all
          self.register_all_objects(backend_object_pool,template=true)
        end

        # GET ALL COMPUTE OBJECTS
        def self.register_all_objects(backend_object_pool,template=false)
          occi_objects = []
          backend_object_pool.each do |backend_object|
            $log.debug("ONE compute object: #{backend_object}")
            occi_object = OCCI::Backend::OpenNebula::Compute.parse_backend_object(backend_object)
            if occi_object.nil?
              $log.debug("Error creating occi resource from backend")
            else
              $log.debug(occi_object.methods)
              $log.debug("Backend ID: #{occi_object.backend[:id]}")
              $log.debug("OCCI compute object location: #{occi_object.get_location}")
              occi_objects << occi_object
            end
          end
        end

        # PARSE OPENNEBULA COMPUTE OBJECT
        def self.parse_backend_object(backend_object)
          if backend_object['TEMPLATE/OCCI_ID'].nil?
            raise "no backend ID found" if backend_object.id.nil?
            occi_id = UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE,backend_object.id.to_s).to_s
          else
            occi_id = backend_object['TEMPLATE/OCCI_ID']
          end

          mixins = []
          mixins << OCCI::Backend::ONE::VirtualMachine::MIXIN

          attributes = {}
          backend_object.info
          # parse all parameters from OpenNebula to OCCI
          attributes['occi.core.id'] = occi_id
          attributes['occi.core.title'] = backend_object['NAME']
          attributes['occi.core.summary'] = backend_object['TEMPLATE/DESCRIPTION']
          attributes['occi.compute.cores'] = backend_object['TEMPLATE/CPU']
          if backend_object['TEMPLATE/ARCHITECTURE'] == "x86_64"
            attributes['occi.compute.architecture'] = "x64"
          else
            attributes['occi.compute.architecture'] = "x86"
          end
          attributes['occi.compute.memory'] = backend_object['TEMPLATE/MEMORY']
          attributes['opennebula.vm.vcpu'] = backend_object['TEMPLATE/VCPU']
          attributes['opennebula.vm.boot'] = backend_object['TEMPLATE/BOOT']

          # check if object already exists
          occi_object = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location('/compute/' +  occi_id)
          if occi_object.nil?
            occi_object = OCCI::Infrastructure::Compute.new(attributes,mixins)
            occi_object.backend[:id] = backend_object.id
            OCCI::Rendering::HTTP::LocationRegistry.register(occi_object.get_location, occi_object)
          else
            occi_object.attributes.merge!(attributes)
          end

          # VNC handling
          if backend_object['TEMPLATE/GRAPHICS/TYPE'] == 'vnc' \
          and backend_object['HISTORY_RECORDS/HISTORY/HOSTNAME'] \
          and not $config[:novnc_path].nil? \
          and not $config[:vnc_proxy_base_port].nil?

            occi_object.mixins << OCCI::Backend::ONE::VNC::MIXIN

            vnc_host = backend_object['HISTORY_RECORDS/HISTORY/HOSTNAME']
            vnc_port = backend_object['TEMPLATE/GRAPHICS/PORT']

            vnc_proxy_host = URI.parse($config[:server]).host

            # The noVNC proxy_port
            proxy_port = $config[:vnc_proxy_base_port].to_i + vnc_port.to_i

            $log.debug("NOVNC path: #{$config[:novnc_path]}")
            $log.debug("Graphics type: #{backend_object['TEMPLATE/GRAPHICS/TYPE']}")
            $log.debug("VNC base port: #{$config[:vnc_proxy_base_port]}")
            $log.debug("VNC port: #{vnc_port}")
            $log.debug("VNC host: #{vnc_host}")

            if occi_object.attributes['opennebula.vm.vnc'].nil? or occi_object.backend[:novnc_pipe].nil?

              # CREATE PROXY FOR VNC SERVER
              begin
                novnc_cmd = "#{$config[:novnc_path]}/utils/launch.sh"
                pipe = IO.popen("#{novnc_cmd} --listen #{proxy_port} --vnc #{vnc_host}:#{vnc_port}")

                if pipe
                  vnc_url = $config[:server].chomp('/') + ':' + vnc_port + '/vnc_auto.html?host=' + vnc_proxy_host + '&port=' + vnc_port
                  $log.debug("VNC URL: #{vnc_url}")
                  occi_object.backend[:novnc_pipe] = pipe
                  occi_object.attributes['opennebula.vm.vnc'] = vnc_host + ':' + vnc_port
                  occi_object.attributes['opennebula.vm.web_vnc'] = vnc_url
                end
              rescue Exception => e
                $log.error("Error in creating VNC proxy: #{e.message}")
              end
            end
          end

          occi_object.backend[:id] = backend_object.id
          occi_object = self.parse_links(occi_object,backend_object)
          $log.info("OCCI compute object created/updated")
          return occi_object
        end

        # PARSE OPENNEBULA DEPENDENCIES TO E.G. STORAGE AND NETWORK LINKS
        def self.parse_links(occi_object,backend_object)
          # create links for all storage instances
          backend_object['TEMPLATE/DISK/IMAGE_ID'].each do |image_id|
            attributes = {}
            target = nil
            $log.debug("Storage Backend ID: #{image_id}")
            OCCI::Infrastructure::Storage::KIND.entities.each do |storage|
              target = storage if storage.backend[:id].to_i == image_id.to_i
            end
            if target == nil
              backend_object = Image.new(Image.build_xml(image_id), $backend.one_client)
              backend_object.info
              target = OCCI::Backend::OpenNebula::Storage.parse_backend_object(backend_object)
            end
            source = occi_object
            attributes["occi.core.target"] = target.get_location
            attributes["occi.core.source"] = source.get_location
            # check if link already exists
            occi_id = UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE,image_id.to_s).to_s
            storagelink_location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(OCCI::Infrastructure::StorageLink::KIND)
            link = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(storagelink_location + occi_id)
            if link.nil?
              # create new link
              attributes['occi.core.id'] = occi_id
              link = OCCI::Infrastructure::StorageLink.new(attributes)
              OCCI::Rendering::HTTP::LocationRegistry.register(link.get_location, link)
            end
            source.links.push(link).uniq!
            target.links.push(link).uniq!
            $log.debug("Link successfully created")
          end if backend_object['TEMPLATE/DISK/IMAGE_ID']

          #create links for all network instances
          backend_object['TEMPLATE/NIC/NETWORK_ID'].each do |network_id|
            attributes = {}
            $log.debug("Network Backend ID: #{network_id}")
            target = nil
            OCCI::Infrastructure::Network::KIND.entities.each do |network|
              target = network if network.backend[:id].to_i == network_id.to_i
              $log.debug(target.kind.term) if target != nil
            end
            if target.nil?
              backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network_id), $backend.one_client)
              backend_object.info
              target = OCCI::Backend::OpenNebula::Network.parse_backend_object(backend_object)
            end            
            source = occi_object
            attributes["occi.core.target"] = target.get_location
            attributes["occi.core.source"] = source.get_location
            # check if link already exists
            occi_id = UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE,network_id.to_s).to_s
            networkinterface_location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(OCCI::Infrastructure::Networkinterface::KIND)
            link = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(networkinterface_location + occi_id)
            if link.nil?
              # create new link
              attributes['occi.core.id'] = occi_id
              link = OCCI::Infrastructure::Networkinterface.new(attributes)
              OCCI::Rendering::HTTP::LocationRegistry.register(link.get_location, link)
            end
            source.links.push(link).uniq!
            target.links.push(link).uniq!
            $log.debug("Link successfully created")
          end if backend_object['TEMPLATE/NIC/NETWORK_ID']

          return occi_object
        end

        # COMPUTE ACTIONS

        # COMPUTE Action start
        def start(parameters)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend[:id]), $backend.one_client)
          rc = backend_object.resume
          $backend.check_rc(rc)
        end

        # Action stop
        def stop(parameters)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend[:id]), $backend.one_client)
          # TODO: implement parameters when available in OpenNebula
          case parameters
          when 'method="graceful"'
            $log.debug("Trying to stop VM graceful")
            rc = backend_object.shutdown
          when 'method="acpioff"'
            $log.debug("Trying to stop VM via ACPI off")
            rc = backend_object.shutdown
          else # method="poweroff" or no method specified
            $log.debug("Powering off VM")
            rc = backend_object.shutdown
          end
          $backend.check_rc(rc)
        end

        # Action restart
        def restart(parameters)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend[:id]), $backend.one_client)
          # TODO: implement parameters when available in OpenNebula
          case parameters
          when "graceful"
            rc = vm.resubmit
          when "warm"
            rc = vm.resubmit
          else # "cold" or no parameter specified
            rc = vm.resubmit
          end
          $backend.check_rc(rc)
        end

        # Action suspend
        def suspend(parameters)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend[:id]), $backend.one_client)
          rc = vm.suspend
          $backend.check_rc(rc)
        end
      end

      ########################################################################
      # Network class

      module Network

        TEMPLATENETWORKRAWFILE = 'occi_one_template_network.erb'
        # CREATE VNET
        def deploy
          backend_object=VirtualNetwork.new(VirtualNetwork.build_xml(), $backend.one_client)
          @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATENETWORKRAWFILE
          template = ERB.new(File.read(@templateRaw)).result(binding)
          $log.debug("Parsed template #{template}")
          rc = backend_object.allocate(template)
          $backend.check_rc(rc)
          @backend[:id] = backend_object.id
          $log.debug("OpenNebula ID of virtual network: #{@backend[:id]}")
        end

        # REFRESH VNETs
        def refresh
          backend_object=VirtualNetwork.new(VirtualNetwork.build_xml(@backend[:id]), $backend.one_client)

          backend_object.info

          occi_object = OCCI::Backend::OpenNebula::Network.parse_backend_object(backend_object)

          if occi_object.nil? then
            $log.warn("Problem refreshing network with backend id #{@backend[:id]}")
          else

            # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
            @attributes.merge!(occi_object.attributes)
            # concat mixins and remove duplicate mixins
            @mixins.concat(occi_object.mixins).uniq!
            # update state
            update_state
          end
        end

        def update_state
          state = OCCI::Infrastructure::Network::STATE_ACTIVE
          @state_machine.set_state(state)
          @attributes['occi.network.state'] = @state_machine.current_state.name
        end

        # DELETE VNET
        def finalize
          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(@backend[:id]), $backend.one_client)
          rc = backend_object.delete
          $backend.check_rc(rc)
        end

        def self.parse_backend_object(backend_object)
          if backend_object['TEMPLATE/OCCI_ID'].nil?
            raise "no backend ID found" if backend_object.id.nil?
            occi_id = UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE,backend_object.id.to_s).to_s
          else
            occi_id = backend_object['TEMPLATE/OCCI_ID']
          end

          attributes = {}
          mixins = []
          backend_object.info
          attributes = {}
          # parse all parameters from OpenNebula to OCCI
          attributes['occi.core.id'] = occi_id
          attributes['occi.core.title'] = backend_object['NAME']
          attributes['occi.core.summary'] = backend_object['TEMPLATE/DESCRIPTION']
          # attributes['opennebula.network.bridge'] = vnet['TEMPLATE/BRIDGE']
          # attributes['opennebula.network.public'] = vnet['TEMPLATE/PUBLIC']
          if backend_object['TEMPLATE/TYPE'].downcase == 'fixed'
            mixins << OCCI::Backend::ONE::Network::MIXIN
            # attributes['opennebula.network.leases'] = backend_object['TEMPLATE/LEASES']
            mixins << OCCI::Infrastructure::Ipnetworking::MIXIN
            attributes['occi.networkinterface.allocation'] = 'static'
          end
          if backend_object['TEMPLATE/TYPE'].downcase == 'ranged'
            require 'occi/infrastructure/Ipnetworking'
            mixins << OCCI::Infrastructure::Ipnetworking::MIXIN
            attributes['occi.networkinterface.allocation'] = 'dynamic'
            attributes['occi.networkinterface.address'] = backend_object['TEMPLATE/NETWORK_ADDRESS'] + '/' + (32-(Math.log(backend_object['TEMPLATE/NETWORK_SIZE'].to_i)/Math.log(2)).ceil).to_s
          end

          # check if object already exists
          occi_object = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location('/network/' +  occi_id)
          if occi_object.nil?
            occi_object = OCCI::Infrastructure::Network.new(attributes,mixins)
            occi_object.backend[:id] = backend_object.id
            OCCI::Rendering::HTTP::LocationRegistry.register(occi_object.get_location, occi_object)
          else
            occi_object.attributes.merge!(attributes)
          end
          return occi_object
        end

        # GET ALL VNETs
        def self.register_all_instances
          occi_objects = []
          backend_object_pool=VirtualNetworkPool.new($backend.one_client)
          backend_object_pool.info_all
          backend_object_pool.each do |backend_object|
            occi_object = OCCI::Backend::OpenNebula::Network.parse_backend_object(backend_object)
            if occi_object.nil?
              $log.debug("Error creating network from backend")
            else
              occi_object.backend[:id] = backend_object.id
              $log.debug("Backend ID: #{occi_object.backend[:id]}")
              occi_objects << occi_object
            end
          end
          return occi_objects
        end

        # Action up
        def up(parameters)
          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(@backend[:id]), $backend.one_client)
          network.enable
          $backend.check_rc(rc)
        end

        # Action down
        def down(parameters)
          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(@backend[:id]), $backend.one_client)
          network.disable
          $backend.check_rc(rc)
        end

      end

      ########################################################################
      # Storage class

      module Storage

        TEMPLATESTORAGERAWFILE = 'occi_one_template_storage.erb'
        # CREATE STORAGE
        def deploy
          backend_object = Image.new(Image.build_xml, $backend.one_client)

          storagelink = nil

          if @links != nil
            @links.each do |link|
              if link.kind.term == 'storagelink'
                $image_path = link.attributes['occi.core.target']
              end
            end
          end

          # check creation of images
          raise "No image or storagelink provided" if $image_path == ""
          @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATESTORAGERAWFILE
          template = ERB.new(File.read(@templateRaw)).result(binding)
          $log.debug("Parsed template #{template}")
          rc = backend_object.allocate(template)
          $backend.check_rc(rc)
          $log.debug("OpenNebula ID of image: #{@backend[:id]}")
        end

        def update_state
          backend_object = Image.new(Image.build_xml(@backend[:id]), $backend.one_client)
          backend_object.info
          $log.debug("current Image state is: #{backend_object.state_str}")
          state = case backend_object.state_str
          when "READY" , "USED" , "LOCKED" then OCCI::Infrastructure::Storage::STATE_ONLINE
          else OCCI::Infrastructure::Storage::STATE_OFFLINE
          end
          @state_machine.set_state(state)
          @attributes['occi.storage.state'] = @state_machine.current_state.name
        end

        # DELETE STORAGE / IMAGE
        def finalize
          backend_object = Image.new(Image.build_xml(@backend[:id]), $backend.one_client)
          rc = backend_object.delete
          $backend.check_rc(rc)
        end

        # REFRESH IMAGES
        def refresh
          backend_object=Image.new(Image.build_xml(@backend[:id]), $backend.one_client)

          backend_object.info

          occi_object = OCCI::Backend::OpenNebula::Storage.parse_backend_object(backend_object)

          if occi_object.nil? then
            $log.warn("Problem refreshing storage with backend id #{@backend[:id]}")
          else

            # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
            @attributes.merge!(occi_object.attributes)
            # concat mixins and remove duplicate mixins
            @mixins.concat(occi_object.mixins).uniq!
            # update state
            update_state
          end
        end

        def self.parse_backend_object(backend_object)
          if backend_object['TEMPLATE/OCCI_ID'].nil?
            raise "no backend ID found" if backend_object.id.nil?
            occi_id = UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE,backend_object.id.to_s).to_s
          else
            occi_id = backend_object['TEMPLATE/OCCI_ID']
          end

          attributes = {}
          mixins = []
          backend_object.info
          attributes = {}
          # parse all parameters from OpenNebula to OCCI
          attributes['occi.core.id'] = occi_id
          attributes['occi.core.title'] = backend_object['NAME']
          attributes['occi.core.summary'] = backend_object['TEMPLATE/DESCRIPTION']
          attributes['opennebula.image.type'] = backend_object['TEMPLATE/TYPE']
          attributes['opennebula.image.public'] = backend_object['TEMPLATE/PUBLIC']
          attributes['opennebula.image.persistent'] = backend_object['TEMPLATE/PERSISTENT']
          attributes['opennebula.image.dev_prefix'] = backend_object['TEMPLATE/DEV_PREFIX']
          attributes['opennebula.image.bus'] = backend_object['TEMPLATE/BUS']
          if backend_object['TEMPLATE/SIZE'] != nil
            attributes['occi.storage.size'] = backend_object['TEMPLATE/SIZE']
          end
          if backend_object['TEMPLATE/FSTYPE'] != nil
            attributes['occi.storage.fstype']
          end

          mixins = [OCCI::Backend::ONE::Image::MIXIN]

          # check if object already exists
          occi_object = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location('/storage/' +  occi_id)
          if occi_object.nil?
            occi_object = OCCI::Infrastructure::Storage.new(attributes,mixins)
            occi_object.backend[:id] = backend_object.id
            OCCI::Rendering::HTTP::LocationRegistry.register(occi_object.get_location, occi_object)
          else
            occi_object.attributes.merge!(attributes)
          end
          return occi_object
        end

        # GET ALL IMAGEs
        def self.register_all_instances
          occi_objects = []
          backend_object_pool=ImagePool.new($backend.one_client)
          backend_object_pool.info_all
          backend_object_pool.each do |backend_object|
            occi_object = OCCI::Backend::OpenNebula::Storage.parse_backend_object(backend_object)
            if occi_object.nil?
              $log.debug("Error creating storage from backend")
            else
              occi_object.backend[:id] = backend_object.id
              $log.debug("Backend ID: #{occi_object.backend[:id]}")
              occi_objects << occi_object
            end
          end
          return occi_objects
        end

        # Action online
        def online(parameters)
          backend_object = Image.new(Image.build_xml(@backend[:id]), $backend.one_client)
          rc = backend_object.enable
          $backend.check_rc(rc)
        end

        # Action offline
        def offline(parameters)
          backend_object = Image.new(Image.build_xml(@backend[:id]), $backend.one_client)
          rc = backend_object.disable
          $backend.check_rc(rc)
        end

        # Action backup
        def backup(parameters)
          #            @links.each do |link|
          #              link_resource.kind.term = "compute"
          #              compute = VirtualMachine.new(VirtualMachine.build_xml(link_resource.backend[:id]), $backend.one_client)
          #              backup_id = compute.savedisk(resource.backend[:id],"Backup " + Time.now)
          #              attributes = []
          #              backup = OCCI::Infrastructure::Storage.new(attributes)
          #              backup.backend[:id] = backup_id
          #              OCCI::Rendering::HTTP::LocationRegistry.register(backup.get_location, backup)
          #            end
          $log.debug("not yet implemented")
        end

        # Action snapshot
        def snapshot(parameters)
          $log.debug("not yet implemented")
        end

        # Action resize
        def resize(parameters)
          $log.debug("not yet implemented")
        end
      end
    end
  end
end