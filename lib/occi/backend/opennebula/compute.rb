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

require 'occi/log'
require 'erubis'

module OCCI
  module Backend
    module OpenNebula

      # ---------------------------------------------------------------------------------------------------------------------
      module Compute

        TEMPLATECOMPUTERAWFILE = 'compute.erb'

        # ---------------------------------------------------------------------------------------------------------------------       
        #        private
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------     
        # PARSE OPENNEBULA COMPUTE OBJECT
        def compute_parse_backend_object(backend_object)

          # get information on compute object from OpenNebula backend
          backend_object.info

          compute_kind = OCCI::Registry.get_by_id("http://schemas.ogf.org/occi/infrastructure#compute")

          compute = Hashie::Mash.new

          compute.kind = compute_kind.type_identifier
          compute.mixins = %w|http://opennebula.org/occi/infrastructure#compute|
          compute.id = self.generate_occi_id(compute_kind, backend_object.id.to_s)
          compute.title = backend_object['NAME']
          compute.summary = backend_object['TEMPLATE/DESCRIPTION'] if backend_object['TEMPLATE/DESCRIPTION']

          compute.attributes!.occi!.compute!.cores = backend_object['TEMPLATE/VCPU'].to_i if backend_object['TEMPLATE/VCPU']
          compute.attributes!.occi!.compute!.architecture = "x64" if backend_object['TEMPLATE/ARCHITECTURE'] == "x86_64"
          compute.attributes!.occi!.compute!.architecture = "x86" if backend_object['TEMPLATE/ARCHITECTURE'] == "i686"
          compute.attributes!.occi!.compute!.memory = backend_object['TEMPLATE/MEMORY'].to_f/1000 if backend_object['TEMPLATE/MEMORY']

          compute.attributes!.org!.opennebula!.compute!.cpu = backend_object['TEMPLATE/CPU'].to_f if backend_object['TEMPLATE/CPU']
          compute.attributes!.org!.opennebula!.compute!.kernel = backend_object['TEMPLATE/KERNEL'] if backend_object['TEMPLATE/KERNEL']
          compute.attributes!.org!.opennebula!.compute!.initrd = backend_object['TEMPLATE/INITRD'] if backend_object['TEMPLATE/INITRD']
          compute.attributes!.org!.opennebula!.compute!.root = backend_object['TEMPLATE/ROOT'] if backend_object['TEMPLATE/ROOT']
          compute.attributes!.org!.opennebula!.compute!.kernel_cmd = backend_object['TEMPLATE/KERNEL_CMD'] if backend_object['TEMPLATE/KERNEL_CMD']
          compute.attributes!.org!.opennebula!.compute!.bootloader = backend_object['TEMPLATE/BOOTLOADER'] if backend_object['TEMPLATE/BOOTLOADER']
          compute.attributes!.org!.opennebula!.compute!.boot = backend_object['TEMPLATE/BOOT'] if backend_object['TEMPLATE/BOOT']

          compute = OCCI::Core::Resource.new(compute)

          compute_set_state(backend_object, compute)

          # TODO: refactor VNC handling
          #if backend_object['TEMPLATE/GRAPHICS/TYPE'] == 'vnc' \
          #and backend_object['HISTORY_RECORDS/HISTORY/HOSTNAME'] \
          #and not OCCI::Server.config[:novnc_path].nil? \
          #and not OCCI::Server.config[:vnc_proxy_base_port].nil?
          #
          #  vnc_host = backend_object['HISTORY_RECORDS/HISTORY/HOSTNAME']
          #  vnc_port = backend_object['TEMPLATE/GRAPHICS/PORT']
          #
          #  vnc_proxy_host = URI.parse(OCCI::Server.location).host
          #
          #  # The noVNC proxy_port
          #  proxy_port = OCCI::Server.config[:vnc_proxy_base_port].to_i + vnc_port.to_i
          #
          #  OCCI::Log.debug("NOVNC path: #{OCCI::Server.config[:novnc_path]}")
          #  OCCI::Log.debug("Graphics type: #{backend_object['TEMPLATE/GRAPHICS/TYPE']}")
          #  OCCI::Log.debug("VNC base port: #{OCCI::Server.config[:vnc_proxy_base_port]}")
          #  OCCI::Log.debug("VNC port: #{vnc_port}")
          #  OCCI::Log.debug("VNC host: #{vnc_host}")
          #
          #  compute.mixins << OCCI::Registry.get_by_id("http://schemas.ogf.org/occi/infrastructure/compute#console")
          #
          #  if occi_object.attributes['opennebula.vm.vnc'].nil? or occi_object.backend[:novnc_pipe].nil?
          #
          #    # CREATE PROXY FOR VNC SERVER
          #    begin
          #      novnc_cmd = "#{OCCI::Server.config[:novnc_path]}/utils/websockify"
          #      pipe = IO.popen("#{novnc_cmd} --web #{OCCI::Server.config[:novnc_path]} #{proxy_port} #{vnc_host}:#{vnc_port}")
          #
          #      if pipe
          #        vnc_url = OCCI::Server.config[:server].chomp('/') + ':' + vnc_port + '/vnc_auto.html?host=' + vnc_proxy_host + '&port=' + vnc_port
          #        OCCI::Log.debug("VNC URL: #{vnc_url}")
          #        occi_object.backend[:novnc_pipe] = pipe
          #        occi_object.attributes['opennebula.vm.vnc'] = vnc_host + ':' + vnc_port
          #        occi_object.attributes['opennebula.vm.web_vnc'] = vnc_url
          #      end
          #    rescue Exception => e
          #      OCCI::Log.error("Error in creating VNC proxy: #{e.message}")
          #    end
          #  end
          #  OCCI::Registry.get_by_id(kind).entities << compute
          #end

          compute_parse_links(compute, backend_object)

          # register compute resource in entities of compute kind
          compute_kind.entities << compute
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # PARSE OPENNEBULA DEPENDENCIES TO E.G. STORAGE AND NETWORK LINKS
        def compute_parse_links(compute, backend_object)
          # create links for all storage instances
          backend_object.each('TEMPLATE/DISK') do |disk|
            OCCI::Log.debug("Storage Backend ID: #{disk['IMAGE_ID']}")

            link = OCCI::Core::Link.new
            storagelink_kind = OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#storagelink')
            link.kind = storagelink_kind.type_identifier
            link.id = self.generate_occi_id(storagelink_kind, disk['IMAGE_ID'].to_s)
            storage_kind = OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#storage')
            storage_id = self.generate_occi_id(storage_kind, disk['IMAGE_ID'].to_s)
            target = storage_kind.entities.select { |entity| entity.id == storage_id }.first
            if target.nil?
              one_storage = Image.new(Image.build_xml(disk['IMAGE_ID']), @one_client)
              self.storage_parse_backend_object(one_storage)
              target = storage_kind.entities.select { |entity| entity.id == storage_id }.first
            end
            link.target = target.location
            link.title = target.title
            link.summary = target.summary
            link.rel = storage_kind.type_identifier
            link.source = compute.location
            link.mixins << OCCI::Registry.get_by_id('http://opennebula.org/occi/infrastructure#storagelink')
            link.attributes!.occi!.storagelink!.deviceid = disk['TARGET'] if disk['TARGET']
            link.attributes!.org!.opennebula!.storagelink!.bus = disk['BUS'] if disk['BUS']
            link.attributes!.org!.opennebula!.storagelink!.driver = disk['DRIVER'] if disk['TARGET']

            # check link attributes against definition in kind and mixins
            link.check

            storagelink_kind.entities << link
          end

          #create links for all network instances
          backend_object.each('TEMPLATE/NIC') do |nic|
            OCCI::Log.debug("Network Backend ID: #{nic['NETWORK_ID']}")

            link = OCCI::Core::Link.new
            networkinterface_kind = OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#networkinterface')
            link.kind = networkinterface_kind.type_identifier
            link.id = self.generate_occi_id(networkinterface_kind, nic['NETWORK_ID'].to_s)
            network_kind = OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#network')
            network_id = self.generate_occi_id(network_kind, nic['NETWORK_ID'].to_s)
            target = network_kind.entitis.select { |entity| entity.id == network_id }.first
            if target.nil?
              one_network = VirtualNetwork.new(VirtualNetwork.build_xml(nic['NETWORK_ID']), @one_client)
              self.network_parse_backend_object(one_network)
              target = network_kind.entities.select { |entity| entity.id == network_id }.first
            end
            link.target = target.location
            link.title = target.title
            link.summary = target.summary
            link.rel = network_kind.type_identifier
            link.source = compute.location
            link.mixins << OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure/networkinterface#ipnetworkinterface')
            link.mixins << OCCI::Registry.get_by_id('http://opennebula.org/occi/infrastructure#networkinterface')
            link.attributes!.occi!.networkinterface!.address = nic['IP'] if nic['IP']
            link.attributes!.occi!.networkinterface!.mac = nic['MAC'] if nic['MAC']
            link.attributes!.occi!.networkinterface!.interface = nic['TARGET'] if nic['TARGET']
            link.attributes!.org!.opennebula!.networkinterface!.bridge = nic['BRIDGE'] if nic['BRIDGE']
            link.attributes!.org!.opennebula!.networkinterface!.script = nic['SCRIPT'] if nic['SCRIPT']
            link.attributes!.org!.opennebula!.networkinterface!.white_ports_tcp = nic['WHITE_PORTS_TCP'] if nic['WHITE_PORTS_TCP']
            link.attributes!.org!.opennebula!.networkinterface!.black_ports_tcp = nic['BLACK_PORTS_TCP'] if nic['BLACK_PORTS_TCP']
            link.attributes!.org!.opennebula!.networkinterface!.white_ports_udp = nic['WHITE_PORTS_UDP'] if nic['WHITE_PORTS_UDP']
            link.attributes!.org!.opennebula!.networkinterface!.black_ports_udp = nic['BLACK_PORTS_UDP'] if nic['BLACK_PORTS_UDP ']
            link.attributes!.org!.opennebula!.networkinterface!.icmp = nic['ICMP'] if nic['ICMP ']

            # check link attributes against definition in kind and mixins
            link.check

            networkinterface_kind.entities << link
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------
        public
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------
        def compute_deploy(compute)
          os_tpl = compute.mixins!.select { |mixin| mixin.related_to?("http://schemas.ogf.org/occi/infrastructure#os_tpl") }.first

          backend_object = nil

          templates = TemplatePool.new(@one_client, OpenNebula::INFO_ACL)
          templates.info
          template = templates.select { |template| template['NAME'] == os_tpl.title }.first
          if template
            template.info
            template['TEMPLATE/VCPU'] = compute.attributes.occi.compute.cores if compute.attributes!.occi!.compute!.cores
            template['TEMPLATE/MEMORY'] = (compute.attributes.occi.compute.memory.to_f * 1000).to_s if compute.attributes!.occi!.compute!.memory
            template['TEMPLATE/ARCHITECTURE'] = compute.attributes.occi.compute.architecture if compute.attributes!.occi!.compute!.architecture
            template['TEMPLATE/CPU'] = compute.attributes.occi.compute.speed if compute.attributes!.occi!.compute!.speed
            backend_object = template.instantiate
            check_rc(backend_object)
          else
            backend_object = VirtualMachine.new(VirtualMachine.build_xml, @one_client)

            template_location = OCCI::Server.config["TEMPLATE_LOCATION"] + TEMPLATECOMPUTERAWFILE
            template = Erubis::Eruby.new(File.read(template_location)).evaluate(:compute => compute)

            OCCI::Log.debug("Parsed template #{template}")
            rc = backend_object.allocate(template)
            check_rc(rc)
            OCCI::Log.debug("Return code from OpenNebula #{rc}") if rc != nil
          end

          backend_object.info
          compute.id = self.generate_occi_id(OCCI::Registry.get_by_id(compute.kind), backend_object['ID'].to_s)

          compute_set_state(backend_object, compute)

          OCCI::Log.debug("OpenNebula automatically triggers action start for Virtual Machines")
          OCCI::Log.debug("Changing state to started")
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def compute_set_state(backend_object, compute)
          OCCI::Log.debug("current VM state is: #{backend_object.lcm_state_str}")
          compute.actions = []
          case backend_object.lcm_state_str
            when "RUNNING" then
              compute.attributes!.occi!.compute!.state = "active"
              compute.actions << OCCI::Server.uri + compute.location + '?action=stop'
              compute.actions << OCCI::Server.uri + compute.location + '?action=restart'
              compute.actions << OCCI::Server.uri + compute.location + '?action=suspend'
            when "PROLOG", "BOOT", "SAVE_STOP", "SAVE_SUSPEND", "SAVE_MIGRATE", "MIGRATE", "PROLOG_MIGRATE", "PROLOG_RESUME" then
              compute.attributes!.occi!.compute!.state = "inactive"
              compute.actions << OCCI::Server.uri + compute.location + '?action=stop'
              compute.actions << OCCI::Server.uri + compute.location + '?action=restart'
            when "SUSPENDED" then
              compute.attributes!.occi!.compute!.state = "suspended"
              compute.actions << OCCI::Server.uri + compute.location + '?action=start'
            when "FAIL" then
              compute.attributes!.occi!.compute!.state = "error"
              compute.actions << OCCI::Server.uri + compute.location + '?action=start'
            else
              compute.attributes!.occi!.compute!.state = "inactive"
              compute.actions << OCCI::Server.uri + compute.location + '?action=start'
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def compute_delete(compute)
          backend_object=VirtualMachine.new(VirtualMachine.build_xml(compute.backend[:id]), @one_client)

          rc = backend_object.finalize
          check_rc(rc)
          # TODO: VNC
          #OCCI::Log.debug("killing NoVNC pipe with pid #{compute.backend[:novnc_pipe].pid}") unless compute.backend[:novnc_pipe].nil?
          #Process.kill 'INT', compute.backend[:novnc_pipe].pid unless compute.backend[:novnc_pipe].nil?
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # GET ALL COMPUTE INSTANCES
        def compute_register_all_instances
          backend_object_pool = VirtualMachinePool.new(@one_client)
          backend_object_pool.info(OCCI::Backend::OpenNebula::OpenNebula::INFO_ACL, -1, -1, OpenNebula::VirtualMachinePool::INFO_NOT_DONE)
          compute_register_all_objects(backend_object_pool)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # GET ALL COMPUTE TEMPLATES
        def compute_register_all_templates
          backend_object_pool = TemplatePool.new(@one_client, INFO_ACL)
          backend_object_pool.info
          compute_register_all_objects(backend_object_pool, template = true)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # GET ALL COMPUTE OBJECTS
        def compute_register_all_objects(backend_object_pool, template = false)
          backend_object_pool.each { |backend_object| compute_parse_backend_object(backend_object) }
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # COMPUTE ACTIONS
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------
        def compute_action_dummy(compute, parameters)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # COMPUTE Action start
        def compute_start(compute, parameters)
          backend_object = VirtualMachine.new(VirtualMachine.build_xml(compute.backend[:id]), @one_client)
          rc = backend_object.resume
          check_rc(rc)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # Action stop
        def compute_stop(compute, parameters)
          backend_object = VirtualMachine.new(VirtualMachine.build_xml(compute.backend[:id]), @one_client)
          # TODO: implement parameters when available in OpenNebula
          case parameters
            when 'method="graceful"'
              OCCI::Log.debug("Trying to stop VM graceful")
              rc = backend_object.shutdown
            when 'method="acpioff"'
              OCCI::Log.debug("Trying to stop VM via ACPI off")
              rc = backend_object.shutdown
            else # method="poweroff" or no method specified
              OCCI::Log.debug("Powering off VM")
              rc = backend_object.shutdown
          end
          check_rc(rc)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # Action restart
        def compute_restart(compute, parameters)
          backend_object = VirtualMachine.new(VirtualMachine.build_xml(compute.backend[:id]), @one_client)
          # TODO: implement parameters when available in OpenNebula
          case parameters
            when "graceful"
              rc = vm.reboot
            when "warm"
              rc = vm.reboot
            else # "cold" or no parameter specified
              rc = vm.resubmit
          end
          check_rc(rc)
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # Action suspend
        def compute_suspend(compute, parameters)
          backend_object = VirtualMachine.new(VirtualMachine.build_xml(compute.backend[:id]), @one_client)
          rc = vm.suspend
          check_rc(rc)
        end

      end
    end
  end
end