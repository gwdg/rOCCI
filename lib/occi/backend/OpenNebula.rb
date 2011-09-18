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
require 'occi/CategoryRegistry'
require 'occi/rendering/http/LocationRegistry'
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
    class OpenNebula
      attr_reader :one_client
      def initialize(configfile)
        OCCI::CategoryRegistry.register_mixin(OCCI::Backend::ONE::Image::MIXIN)
        OCCI::CategoryRegistry.register_mixin(OCCI::Backend::ONE::Network::MIXIN)
        OCCI::CategoryRegistry.register_mixin(OCCI::Backend::ONE::VirtualMachine::MIXIN)
        OCCI::CategoryRegistry.register_mixin(OCCI::Mixins::Reservation::MIXIN)

        # TODO: create mixins from existing templates

        # initialize OpenNebula connection
        $log.debug("Initializing connection with OpenNebula")
        
        # TODO: check for error!
        @one_client = Client.new($config['one_user'] + ':' + $config['one_password'],$config['one_xmlrpc'])

        $log.debug("Get existing objects from OpenNebula")
        # get all compute objects
        OCCI::Backend::OpenNebula::Compute.register_all_instances
        OCCI::Backend::OpenNebula::Compute.register_all_templates
        OCCI::Backend::OpenNebula::Network.register_all_instances
        OCCI::Backend::OpenNebula::Storage.register_all_instances
      end

      def check_rc(rc)
        if OpenNebula.is_error?(rc)
          $log.warn("Error message from OpenNebula: #{rc.to_str}")
          # TODO: return failed!
        end
      end

      ########################################################################
      # COMPUTE class

      class Compute
        attr_reader :backend_id
        
        TEMPLATECOMPUTERAWFILE = 'occi_one_template_compute.erb'
        
        def create
          # initialize backend object as VM or VM template
          if template
            backend_object=VirtualMachine.new(VirtualMachine.build_xml, $backend.one_client)
          else
            backend_object=Template.new(Template.build_xml, $backend.one_client)
          end

          storage_ids = []
          network_ids = []
          storagelinks = []

          if @links != nil
            @links.each do
              |link|
              target = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(link.attributes['occi.core.target'])
              case target.kind.term
              when 'storage'
                storage_ids << target.backend_id
              when 'network'
                network_ids << target.backend_id
              when 'storagelink'
                storagelinks << link.attributes['occi.core.target']
              end
            end
          end
          $log.debug("Storage IDs: #{storage_ids}")
          $log.debug("Network IDs: #{network_ids}")

          @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATECOMPUTERAWFILE
          compute_template = ERB.new(File.read(@templateRaw)).result(binding)
          $log.debug("Parsed template #{compute_template}")
          rc = backend_object.allocate(compute_template)
          if OpenNebula.is_error?(rc)
            $log.warn("Problem with creation of compute resource. Error message: #{rc}")
          end
          $log.debug("Return code from OpenNebula #{rc}") if rc != nil
          @backend_id = backend_object.id
          $log.debug("OpenNebula ID of virtual machine: #{@backend_id}")
          $log.debug("OpenNebula automatically triggers action start for Virtual Machines")
          $log.debug("Changing state to started")
        end
        
        def refresh
          $log.debug("Refreshing compute object with backend ID: #{@backend_id}")
          if template
            backend_object = VirtualMachine.new(VirtualMachine.build_xml(occi_compute_object.backend_id), $backend.one_client)
          else
            backend_object = Template.new(Template.build_xml(occi_compute_object.backend_id), $backend.one_client)
          end
          backend_object.info

          occi_object = self.parse_backend_object(backend_object,@attributes)
          # TODO: parse links?

          # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
          @attributes.merge!(occi_object.attributesattributes)
          # concat mixins and remove duplicate mixins
          @mixins.concat(occi_object.mixins).uniq!
          # update state
          update_state(backend_object)
        end
        
        def update_state(backend_object)
          $log.debug("current VM state is: #{backend_object.lcm_state_str}")
          state = case backend_object.lcm_state_str
          when "PROLOG" || "BOOT" || "RUNNING" || "SAVE_STOP" || "SAVE_SUSPEND" || "SAVE_MIGRATE" || "MIGRATE" || "PROLOG_MIGRATE" || "PROLOG_RESUME" then OCCI::Infrastructure::Compute::STATE_ACTIVE
          when "SUSPENDED" then OCCI::Infrastructure::Compute::STATE_SUSPENDED
          else OCCI::Infrastructure::Compute::STATE_INACTIVE
          end
          @state_machine.set_state(state)
          @attributes['occi.compute.state'] = @state_machine.current_state.name
        end

        def finalize
          if template
            backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend_id), $backend.one_client)
          else
            backend_object=Template.new(Template.build_xml(@backend_id), $backend.one_client)
          end

          rc = backend_object.finalize
          $backend.check_rc(rc)
        end

        # GET ALL COMPUTE INSTANCES
        def self.register_all_instances
          backend_object_pool=VirtualMachinePool.new(@one_client)
          backend_object_pool.info_all
          self.get_all_objects(backend_object_pool)
        end

        # GET ALL COMPUTE TEMPLATES
        def self.register_all_templates
          backend_object_pool=TemplatePool.new(@one_client)
          backend_object_pool.info_all
          self.get_all_objects(backend_object_pool,template=true)
        end

        # GET ALL COMPUTE OBJECTS
        def self.register_all_objects(backend_object_pool,template=false)
          occi_objects = []
          backend_object_pool.each do |backend_object|
            $log.debug("ONE compute object: #{backend_object}")
            attributes, mixins = self.parse_backend_object(backend_object)
            mixins << OCCI::Infrastructure::ResourceTemplate::MIXIN if template
            $log.debug("Attributes: #{attributes}")
            $log.debug("Mixins: #{mixins}")
            occi_object = OCCI::Infrastructure::Compute.new(attributes,mixins)
            occi_object.backend_id = backend_object.id
            $log.debug("Backend ID: #{occi_object.backend_id}")
            $log.debug("OCCI compute object location: #{occi_object.get_location}")
            OCCI::Rendering::HTTP::LocationRegistry.register_location(occi_object.get_location, occi_object)
            occi_object = self.parse_links(occi_object,backend_object)
            occi_objects << occi_object if not occi_object.nil?
          end
        end

        # PARSE OPENNEBULA COMPUTE OBJECT
        def self.parse_backend_object(backend_object)
          require 'json'
          $log.debug("ONE compute object: #{backend_object.to_hash.to_json}")
          mixins = []
          mixins << OCCI::Backend::ONE::VirtualMachine::MIXIN

          # parse all parameters from OpenNebula to OCCI
          attributes['occi.core.id'] = backend_object['TEMPLATE/OCCI_ID']
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

          if backend_object['TEMPLATE/GRAPHICS/TYPE'] == 'vnc' \
          and backend_object['HISTORY_RECORDS/HISTORY/HOSTNAME'] \
          and not $config[:novnc_path].nil? \
          and not $config[:vnc_proxy_base_port].nil?

            $log.debug("NOVNC path: #{$config[:novnc_path]}")
            $log.debug("Graphics type: #{backend_object['TEMPLATE/GRAPHICS/TYPE']}")
            $log.debug("VNC base port: #{$config[:vnc_proxy_base_port]}")
            $log.debug("VNC port: #{backend_object['TEMPLATE/GRAPHICS/PORT']}")
            $log.debug("VNC host: #{backend_object['HISTORY_RECORDS/HISTORY/HOSTNAME']}")

            mixins << OCCI::Backend::ONE::VNC::MIXIN

            vnc_host = backend_object['HISTORY_RECORDS/HISTORY/HOSTNAME']
            vnc_port = backend_object['TEMPLATE/GRAPHICS/PORT']

            vnc_proxy_host = URI.parse($config[:server]).host

            # The noVNC proxy_port
            proxy_port = $config[:vnc_proxy_base_port].to_i + vnc_port.to_i

            if attributes['opennebula.vm.vnc'].nil?

              # CREATE PROXY FOR VNC SERVER
              begin
                novnc_cmd = "#{$config[:novnc_path]}/utils/launch.sh"
                pipe = IO.popen("#{novnc_cmd} --listen #{proxy_port} \
                                            --vnc #{vnc_host}:#{vnc_port}")

                if pipe
                  vnc_url = $config[:server] + ':' + vnc_port + '/vnc_auto.html?host=' + vnc_proxy_host + '&port=' + vnc_port
                  $log.debug("VNC URL: #{vnc_url}")
                  attributes['opennebula.vm.vnc'] = vnc_host + ':' + vnc_port
                  attributes['opennebula.vm.web_vnc'] = vnc_url
                end
              rescue Exception => e
                $log.error("Error in creating VNC proxy: #{e.message}")
              end
            end
          end

          occi_object = OCCI::Infrastructure::Compute.new(attributes,mixins)
          return occi_object
        end

        # PARSE OPENNEBULA DEPENDENCIES TO E.G. STORAGE AND NETWORK LINKS
        def self.parse_links(occi_object,backend_object)
          # create links for all storage instances
          backend_object['TEMPLATE/DISK/IMAGE_ID'].each do |image_id|
            attributes = {}
            target = nil
            $log.debug("Image ID: #{image_id}")
            OCCI::Infrastructure::Storage::KIND.entities.each do |storage|
              $log.debug("Storage Backend ID: #{storage.backend_id}")
              $log.debug(storage.backend_id.to_i == image_id.to_i)
              target = storage if storage.backend_id.to_i == image_id.to_i
            end
            break if target == nil
            source = occi_object
            attributes["occi.core.target"] = target.get_location
            attributes["occi.core.source"] = source.get_location
            link = OCCI::Core::Link.new(attributes)
            source.links << link
            target.links << link
            OCCI::Rendering::HTTP::LocationRegistry.register_location(link.get_location, link)
            $log.debug("Link successfully created")
          end if backend_object['TEMPLATE/DISK/IMAGE_ID']

          #create links for all network instances
          backend_object['TEMPLATE/NIC/NETWORK_ID'].each do |network_id|
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
            source = occi_object
            attributes["occi.core.target"] = target.get_location
            attributes["occi.core.source"] = source.get_location
            link = OCCI::Core::Link.new(attributes)
            source.links << link
            target.links << link
            OCCI::Rendering::HTTP::LocationRegistry.register_location(link.get_location, link)
            $log.debug("Link successfully created")
          end if backend_object['TEMPLATE/NIC/NETWORK_ID']
        end

        # COMPUTE ACTIONS

        # COMPUTE Action start
        def start(parameters)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend_id), $backend.one_client)
          rc = backend_object.resume
          $backend.check_rc(rc)
        end

        # Action stop
        def stop(parameters)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend_id), $backend.one_client)
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
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend_id), $backend.one_client)
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
        def compute_suspend(action, parameters, resource)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(@backend_id), $backend.one_client)
          rc = vm.suspend
          $backend.check_rc(rc)
        end
      end

      ########################################################################
      # Network class

      class Network
        attr_reader :backend_id
        
        TEMPLATENETWORKRAWFILE = 'occi_one_template_network.erb'

        # CREATE VNET
        def create
          backend_object=VirtualNetwork.new(VirtualNetwork.build_xml(), $backend.one_client)
          @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATENETWORKRAWFILE
          template = ERB.new(File.read(@templateRaw)).result(binding)
          $log.debug("Parsed template #{template}")
          rc = backend_object.allocate(template)
          $backend.check_rc(rc)
          @backend_id = backend_object.id
          $log.debug("OpenNebula ID of virtual network: #{@backend_id}")
        end

        # REFRESH VNETs
        def refresh
          backend_object=VirtualNetwork.new(VirtualNetwork.build_xml(@backend_id), $backend.one_client)

          occi_object = self.parse_backend_object(backend_object,@attributes)

          if occi_object.nil? then
            $log.warn("Problem refreshing network with backend id #{backend_id}")
            break 
          end

            # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
            @attributes.merge!(occi_object.attributesattributes)
            # concat mixins and remove duplicate mixins
            @mixins.concat(occi_object.mixins).uniq!
            # update state
            update_state(backend_object)
          end

          # DELETE VNET
          def finalize
            backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(@backend_id), $backend.one_client)
            rc = network.delete
            $backend.check_rc(rc)
          end

          def self.parse_backend_object(backend_object)
            attributes = {}
            # parse all parameters from OpenNebula to OCCI
            attributes['occi.core.id'] = backend_object['TEMPLATE/OCCI_ID']
            attributes['occi.core.title'] = backend_object['NAME']
            attributes['occi.core.summary'] = backend_object['TEMPLATE/DESCRIPTION']
            # attributes['opennebula.network.bridge'] = vnet['TEMPLATE/BRIDGE']
            # attributes['opennebula.network.public'] = vnet['TEMPLATE/PUBLIC']
            if backend_object['TEMPLATE/TYPE'].downcase == 'fixed'
              mixins << OCCI::Backend::ONE::Network::MIXIN
              # attributes['opennebula.network.leases'] = backend_object['TEMPLATE/LEASES']
              mixins << OCCI::Infrastructure::Ipnetworking::MIXIN
              attributes['occi.network.allocation'] = 'static'
            end
            if backend_object['TEMPLATE/TYPE'].downcase == 'ranged'
              mixins << OCCI::Infrastructure::Ipnetworking::MIXIN
              attributes['occi.network.allocation'] = 'dynamic'
              attributes['occi.network.address'] = backend_object['TEMPLATE/NETWORK_ADDRESS'] + '/' + (32-(Math.log(backend_object['TEMPLATE/NETWORK_SIZE'].to_i)/Math.log(2)).ceil).to_s
            end

            occi_object = OCCI::Infrastructure::Network.new(attributes,mixins)
            return occi_object
          end

          # GET ALL VNETs
          def self.register_all_instances
            occi_objects = []
            backend_object_pool=VirtualNetworkPool.new($backend.one_client)
            vnetpool.info_all
            vnetpool.each do |vnet|
              occi_object = self.parse_backend_object(backend_object)
              occi_object.backend_id = vnet.id
              $log.debug("Backend ID: #{resource.backend_id}")
              OCCI::Rendering::HTTP::LocationRegistry.register_location(occi_object.get_location, occi_object)
              occi_objects << occi_object
            end
            return occi_objects
          end

          # Action up
          def up(parameters)
            backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(@backend_id), $backend.one_client)
            network.enable
            $backend.check_rc(rc)
          end

          # Action down
          def down(parameters)
            backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(@backend_id), $backend.one_client)
            network.disable
            $backend.check_rc(rc)
          end

        end

        ########################################################################
        # Storage class

        class Storage
          attr_reader :backend_id
          
          TEMPLATESTORAGERAWFILE = 'occi_one_template_storage.erb'

          # CREATE STORAGE
          def create
            backend_object = Image.new(Image.build_xml, $backend.one_client)
            # check creation of images
            raise "No image provided" if $image_path == ""
            @templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATESTORAGERAWFILE
            template = ERB.new(File.read(@templateRaw)).result(binding)
            $log.debug("Parsed template #{template}")
            rc = backend_object.allocate(template)
            $backend.check_rc(rc)
            @backend_id = backend_object.id
            $log.debug("OpenNebula ID of image: #{@backend_id}")
          end

          # DELETE STORAGE / IMAGE
          def finalize
            backend_object = Image.new(Image.build_xml(@backend_id), $backend.one_client)
            rc = backend_object.delete
            $backend.check_rc(rc)
          end

          # REFRESH IMAGES
          def refresh
            backend_object=Image.new(Image.build_xml(@backend_id), $backend.one_client)

            occi_object = self.parse_backend_object(backend_object)

            if occi_object.nil? then
              $log.warn("Problem refreshing network with backend id #{backend_id}")
              break
            end

            # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
            @attributes.merge!(occi_object.attributes)
            # concat mixins and remove duplicate mixins
            @mixins.concat(occi_object.mixins).uniq!
            # update state
            update_state(backend_object)
          end

          def self.parse_backend_object(backend_object)
            attributes = {}
            # parse all parameters from OpenNebula to OCCI
            attributes['occi.core.id'] = backend_object['TEMPLATE/OCCI_ID']
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

            resource = OCCI::Infrastructure::Storage.new(attributes,mixins)
          end

          # GET ALL IMAGEs
          def self.register_all_instances
            occi_objects = []
            backend_object_pool=ImagePool.new(@one_client)
            backend_object_pool.info_all
            backend_object_pool.each do |backend_object|
              @backend_id = backend_object.id
              $log.debug("Backend ID: #{@backend_id}")              
            end
          end

          # Action online
          def online(parameters)
            backend_object = Image.new(Image.build_xml(@backend_id), $backend.one_client)
            rc = backend_object.enable
            $backend.check_rc(rc)
          end

          # Action offline
          def offline(parameters)
            backend_object = Image.new(Image.build_xml(@backend_id), $backend.one_client)
            rc = backend_object.disable
            $backend.check_rc(rc)
          end

          # Action backup
          def backup(parameters)
#            @links.each do |link|
#              link_resource.kind.term = "compute"
#              compute = VirtualMachine.new(VirtualMachine.build_xml(link_resource.backend_id), @one_client)
#              backup_id = compute.savedisk(resource.backend_id,"Backup " + Time.now)
#              attributes = []
#              backup = OCCI::Infrastructure::Storage.new(attributes)
#              backup.backend_id = backup_id
#              OCCI::Rendering::HTTP::LocationRegistry.register_location(backup.get_location, backup)
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