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

# OpenNebula based mixins
require 'occi/extensions/one/Image'
require 'occi/extensions/one/Network'
require 'occi/extensions/one/VirtualMachine'
require 'occi/extensions/one/VNC'

require 'occi/extensions/Reservation'

include OpenNebula

module OCCI
  module Backend

    # ---------------------------------------------------------------------------------------------------------------------
    RESOURCE_DEPLOY         = :deploy
    RESOURCE_UPDATE_STATE   = :update_state
    RESOURCE_REFRESH        = :refresh
    RESOURCE_DELETE         = :delete

#    ACTION_START            = :start
#    ACTION_STOP             = :stop
#    ACTION_RESTART          = :restart
#    ACTION_SUSPEND          = :suspend

    # ---------------------------------------------------------------------------------------------------------------------
    class OpenNebula
      
      # Supported operations
       
      OPERATIONS = {}
      
      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#compute"] = {
        
        # Generic resource operations
        :deploy         => :compute_deploy,
        :update_state   => :compute_update_state,
        :refresh        => :compute_refresh,
        :delete         => :compute_delete,
        
        # Compute specific resource operations
        :start          => :compute_start,
        :stop           => :compute_stop,
        :restart        => :compute_restart,
        :suspend        => :compute_suspend        
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#network"] = {
        
        # Generic resource operations
        :deploy         => :network_deploy,
        :update_state   => :network_update_state,
        :refresh        => :network_refresh,
        :delete         => :network_delete,
        
        # Network specific resource operations
        :up             => :network_up,
        :down           => :network_down
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#storage"] = {

        # Generic resource operations
        :deploy         => :storage_deploy,
        :update_state   => :storage_update_state,
        :refresh        => :storage_refresh,
        :delete         => :storage_delete,
   
        # Network specific resource operations
        :online         => :storage_online,
        :offline        => :storage_offline,
        :backup         => :storage_backup,
        :snapshot       => :storage_snapshot,
        :resize         => :storage_resize
      }
       
      begin
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::Image::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::Network::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::VirtualMachine::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Mixins::Reservation::MIXIN)
      end

      # ---------------------------------------------------------------------------------------------------------------------       
      private
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------      
      def check_rc(rc)
        if rc.class == Error
          raise OCCI::BackendError, "Error message from OpenNebula: #{rc.to_str}"
          # TODO: return failed!
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------
      # Generate a new occi id for resources created directly in OpenNebula using a seed id and the kind identifier
      def self.generate_occi_id(kind, seed_id)
        # Use strings as kind ids
        kind = kind.type_identifier if kind.kind_of?(OCCI::Core::Kind)
        return UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE, "#{kind}:#{seed_id}").to_s
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # PARSE OPENNEBULA COMPUTE OBJECT
      def self.compute_parse_backend_object(backend_object)
        if backend_object['TEMPLATE/OCCI_ID'].nil?
          raise "no backend ID found" if backend_object.id.nil?
          occi_id = self.generate_occi_id(OCCI::Infrastructure::Compute::KIND, backend_object.id.to_s)
        else
          occi_id = backend_object['TEMPLATE/OCCI_ID']
        end

        mixins = []
        mixins << OCCI::Backend::ONE::VirtualMachine::MIXIN

        attributes = {}
        backend_object.info
        # parse all parameters from OpenNebula to OCCI
        attributes['occi.core.id']        = occi_id
        attributes['occi.core.title']     = backend_object['NAME']
        attributes['occi.core.summary']   = backend_object['TEMPLATE/DESCRIPTION']
        attributes['occi.compute.cores']  = backend_object['TEMPLATE/VCPU']

        if backend_object['TEMPLATE/ARCHITECTURE'] == "x86_64"
          attributes['occi.compute.architecture'] = "x64"
        else
          attributes['occi.compute.architecture'] = "x86"
        end
        attributes['occi.compute.memory']           = backend_object['TEMPLATE/MEMORY']
        attributes['opennebula.vm.cpu_reservation'] = backend_object['TEMPLATE/CPU']
        attributes['opennebula.vm.boot']            = backend_object['TEMPLATE/BOOT']

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
              novnc_cmd = "#{$config[:novnc_path]}/utils/websockify"
              pipe = IO.popen("#{novnc_cmd} --web #{$config[:novnc_path]} #{proxy_port} #{vnc_host}:#{vnc_port}")

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
        occi_object = self.compute_parse_links(occi_object, backend_object)
        $log.info("OCCI compute object created/updated")
        return occi_object
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # PARSE OPENNEBULA DEPENDENCIES TO E.G. STORAGE AND NETWORK LINKS
      def self.compute_parse_links(occi_object, backend_object)
        # create links for all storage instances
        backend_object['TEMPLATE/DISK/IMAGE_ID'].each do |image_id|
          attributes = {}
          target = nil
          $log.debug("Storage Backend ID: #{image_id}")
          OCCI::Infrastructure::Storage::KIND.entities.each do |storage|
            target = storage if storage.backend[:id].to_i == image_id.to_i
          end
          if target == nil
            backend_object = Image.new(Image.build_xml(image_id), @one_client)
#            backend_object.info
            target = self.storage_parse_backend_object(backend_object)
          end
          source = occi_object
          attributes["occi.core.target"] = target.get_location
          attributes["occi.core.source"] = source.get_location
          # check if link already exists
          occi_id = self.generate_occi_id(OCCI::Infrastructure::StorageLink::KIND, image_id.to_s)
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
            backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network_id), @one_client)
            backend_object.info
            target = self.network_parse_backend_object(backend_object)
          end
          source = occi_object
          attributes["occi.core.target"] = target.get_location
          attributes["occi.core.source"] = source.get_location
          # check if link already exists
          occi_id = self.generate_occi_id(OCCI::Infrastructure::Networkinterface::KIND, network_id.to_s)
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

      # ---------------------------------------------------------------------------------------------------------------------     
      def self.network_parse_backend_object(backend_object)
        if backend_object['TEMPLATE/OCCI_ID'].nil?
          raise "no backend ID found" if backend_object.id.nil?
          occi_id = self.generate_occi_id(OCCI::Infrastructure::Network::KIND, backend_object.id.to_s)
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
          attributes['occi.network.allocation'] = 'static'
        end
        if backend_object['TEMPLATE/TYPE'].downcase == 'ranged'
          require 'occi/infrastructure/Ipnetworking'
          mixins << OCCI::Infrastructure::Ipnetworking::MIXIN
          attributes['occi.network.allocation'] = 'dynamic'
          if backend_object['TEMPLATE/NETWORK_SIZE'].to_i > 0
            network_size = backend_object['TEMPLATE/NETWORK_SIZE'].to_i
          else
            network_size = 8*(backend_object['TEMPLATE/NETWORK_SIZE'].upcase.ord - 64)
          end
          attributes['occi.network.address'] = backend_object['TEMPLATE/NETWORK_ADDRESS'] + '/' + (32-(Math.log(network_size)/Math.log(2)).ceil).to_s
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

      # ---------------------------------------------------------------------------------------------------------------------     
      def self.storage_parse_backend_object(backend_object)
        if backend_object['TEMPLATE/OCCI_ID'].nil?
          raise "no backend ID found" if backend_object.id.nil?
          occi_id = self.generate_occi_id(OCCI::Infrastructure::Storage::KIND, backend_object.id.to_s)
        else
          occi_id = backend_object['TEMPLATE/OCCI_ID']
        end

        attributes = {}
        mixins = []
#        backend_object.info
        attributes = {}
        # parse all parameters from OpenNebula to OCCI
        attributes['occi.core.id']      = occi_id
        attributes['occi.core.title']   = backend_object['NAME']
        attributes['occi.core.summary'] = backend_object['TEMPLATE/DESCRIPTION']

        attributes['opennebula.image.type']       = backend_object['TEMPLATE/TYPE']
        attributes['opennebula.image.public']     = backend_object['TEMPLATE/PUBLIC']
        attributes['opennebula.image.persistent'] = backend_object['TEMPLATE/PERSISTENT']
        attributes['opennebula.image.dev_prefix'] = backend_object['TEMPLATE/DEV_PREFIX']
        attributes['opennebula.image.bus']        = backend_object['TEMPLATE/BUS']

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

      # ---------------------------------------------------------------------------------------------------------------------
      public
      # ---------------------------------------------------------------------------------------------------------------------

      
      # The ACL level to be used when querying resource in OpenNebula:
      # - INFO_ALL returns all resources and works only when running under the oneadmin account
      # - INFO_GROUP returns the resources of the account + his group (= default)
      # - INFO_USER returns only the resources of the account
      INFO_ACL = OpenNebula::Pool::INFO_GROUP
 
      # ---------------------------------------------------------------------------------------------------------------------     
      def initialize(user, password)

        # TODO: create mixins from existing templates

        # initialize OpenNebula connection
        $log.debug("Initializing connection with OpenNebula")

        # TODO: check for error!
 #       @one_client = Client.new($config['one_user'] + ':' + $config['one_password'], $config['one_xmlrpc'])
        @one_client = Client.new(user + ':' + password, $config['one_xmlrpc'])
 
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def register_existing_resources
        # get all compute objects
        resource_template_register()
        os_template_register()
        compute_register_all_instances()
        network_register_all_instances()
        storage_register_all_instances()
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_template_register
        backend_object_pool=TemplatePool.new(@one_client)
        backend_object_pool.info_group
        backend_object_pool.each do |backend_object|
          actions = []
          related = [ OCCI::Infrastructure::ResourceTemplate::MIXIN ]
          entities = []
          term    = backend_object['NAME'].downcase.chomp.gsub(/\W/,'_')
          scheme  = "http://schemas.ogf.org/occi/infrastructure#"
          title   = backend_object['NAME']
          attributes = OCCI::Core::Attributes.new()
          mixin = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
          mixin.backend[:id] = backend_object.id
          OCCI::CategoryRegistry.register(mixin)
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def os_template_register
        # TODO: implement
      end

      ########################################################################
      # COMPUTE class

      TEMPLATECOMPUTERAWFILE = 'occi_one_template_compute.erb'

      # ---------------------------------------------------------------------------------------------------------------------     
      def compute_deploy(compute)
        # initialize backend object as VM or VM template
        # TODO: figure out templates
        # backend_object=Template.new(Template.build_xml, $backend.one_client)
        template_mixin = compute.mixins.select { |m| m.related == OCCI::Infrastructure::ResourceTemplate::MIXIN }
  
        if template_mixin.empty?
  
          backend_object = VirtualMachine.new(VirtualMachine.build_xml, @one_client)
  
          storages                = []
          networks                = []
          external_storages       = []
          compute.nfs_mounts      = [] if $nfs_support
  
  
          if compute.links != nil
            compute.links.each do |link|
              $log.debug("Processing link: #{link.kind.type_identifier}, attributes: #{link.attributes.inspect}")
              target_URI = link.attributes['occi.core.target'] if URI.parse(link.attributes['occi.core.target']).absolute?
              target = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(link.attributes['occi.core.target'])
              
              case link.kind.term
              when 'storagelink'
                # TODO: incorporate mountpoint here (e.g. occi.storagelink.mountpoint )
                # Check for nfs mount points                  
                if $nfs_support
                  if target.kind == OCCI::Infrastructure::NFSStorage::KIND
                    # Keep track of nfs-export -> mount-point tuples
                    $log.debug("Adding nfs mount: #{target.attributes["occi.storage.export"]} -> #{link.attributes['occi.storagelink.mountpoint']}")
                    @nfs_mounts << [target.attributes['occi.storage.export'], link.attributes['occi.storagelink.mountpoint']]
  #                      nfs_mounts << mount
                    next
                  end
                end
                
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
  
  #            if $nfs_support
  #              @nfs_mounts = %|"#{nfs_mounts.join(", ")}"|
  #            end
  
          compute.templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATECOMPUTERAWFILE
          compute_template = ERB.new(File.read(compute.templateRaw)).result(binding)
          $log.debug("Parsed template #{compute_template}")
          rc = backend_object.allocate(compute_template)
          check_rc(rc)
          $log.debug("Return code from OpenNebula #{rc}") if rc != nil
          compute.backend[:id] = backend_object.id
        else
          backend_template = Template.new(Template.build_xml(template_mixin.backend[:id]), @one_client)
          res = backend_template.instantiate
          check_rc(res)
          compute.backend[:id] = backend_id
          refresh_compute(compute)
        end
  
        $log.debug("OpenNebula ID of virtual machine: #{compute.backend[:id]}")
        $log.debug("OpenNebula automatically triggers action start for Virtual Machines")
        $log.debug("Changing state to started")
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def compute_refresh(compute)
        $log.debug("Refreshing compute object with backend ID: #{compute.backend[:id]}")
        backend_object = VirtualMachine.new(VirtualMachine.build_xml(compute.backend[:id]), @one_client)

        backend_object.info

        occi_object = OCCI::Backend::OpenNebula.compute_parse_backend_object(backend_object)
        if occi_object.nil?
          $log.debug("Problems refreshing backend object")
        else
          # TODO: parse links?

          # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
          compute.attributes.merge!(occi_object.attributes)
          # concat mixins and remove duplicate mixins
          compute.mixins.concat(occi_object.mixins).uniq!
          # update state
          compute_update_state(compute)
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def compute_update_state(compute)
        backend_object = VirtualMachine.new(VirtualMachine.build_xml(compute.backend[:id]), @one_client)
        backend_object.info
        $log.debug("current VM state is: #{backend_object.lcm_state_str}")
        state = case backend_object.lcm_state_str
          when "RUNNING" then OCCI::Infrastructure::Compute::STATE_ACTIVE
          when "PROLOG" , "BOOT" , "SAVE_STOP" , "SAVE_SUSPEND" , "SAVE_MIGRATE" , "MIGRATE" , "PROLOG_MIGRATE" , "PROLOG_RESUME" then OCCI::Infrastructure::Compute::STATE_INACTIVE
          when "SUSPENDED" then OCCI::Infrastructure::Compute::STATE_SUSPENDED
          else OCCI::Infrastructure::Compute::STATE_INACTIVE
        end
        compute.state_machine.set_state(state)
        compute.attributes['occi.compute.state'] = compute.state_machine.current_state.name
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def compute_delete(compute)
        backend_object=VirtualMachine.new(VirtualMachine.build_xml(compute.backend[:id]), @one_client)

        rc = backend_object.finalize
        check_rc(rc)
        $log.debug("killing NoVNC pipe with pid #{compute.backend[:novnc_pipe].pid}") unless compute.backend[:novnc_pipe].nil?
        Process.kill 'INT', compute.backend[:novnc_pipe].pid unless compute.backend[:novnc_pipe].nil?
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # GET ALL COMPUTE INSTANCES
      def compute_register_all_instances
        backend_object_pool = VirtualMachinePool.new(@one_client, INFO_ACL)
        backend_object_pool.info_group
        compute_register_all_objects(backend_object_pool)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # GET ALL COMPUTE TEMPLATES
      def compute_register_all_templates
        backend_object_pool = TemplatePool.new(@one_client, INFO_ACL)
        backend_object_pool.info_group
        compute_register_all_objects(backend_object_pool, template = true)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # GET ALL COMPUTE OBJECTS
      def compute_register_all_objects(backend_object_pool, template = false)
        occi_objects = []
        backend_object_pool.each do |backend_object|
          $log.debug("ONE compute object: #{backend_object}")
          occi_object = OCCI::Backend::OpenNebula.compute_parse_backend_object(backend_object)
          if occi_object.nil?
            $log.debug("Error creating occi resource from backend")
          else
            $log.debug("Compute Backend ID: #{occi_object.backend[:id]}")
            $log.debug("OCCI compute object location: #{occi_object.get_location}")
            occi_objects << occi_object
          end
        end
      end

      # COMPUTE ACTIONS

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
          $log.debug("Trying to stop VM graceful")
          rc = backend_object.shutdown
        when 'method="acpioff"'
          $log.debug("Trying to stop VM via ACPI off")
          rc = backend_object.shutdown
        else # method="poweroff" or no method specified
          $log.debug("Powering off VM")
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
          rc = vm.resubmit
        when "warm"
          rc = vm.resubmit
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

      ########################################################################
      # Network class

      TEMPLATENETWORKRAWFILE = 'occi_one_template_network.erb'

      # ---------------------------------------------------------------------------------------------------------------------     
      # CREATE VNET
      def network_deploy(network)
        backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(), @one_client)
        network.templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATENETWORKRAWFILE
        template = ERB.new(File.read(network.templateRaw)).result(binding)
        $log.debug("Parsed template #{template}")
        rc = backend_object.allocate(template)
        check_rc(rc)
        network.backend[:id] = backend_object.id
        $log.debug("OpenNebula ID of virtual network: #{network.backend[:id]}")
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # REFRESH VNETs
      def network_refresh(network)
        backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)

        backend_object.info

        occi_object = OCCI::Backend::OpenNebula.network_parse_backend_object(backend_object)

        if occi_object.nil? then
          $log.warn("Problem refreshing network with backend id #{network.backend[:id]}")
        else

          # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
          network.attributes.merge!(occi_object.attributes)
          # concat mixins and remove duplicate mixins
          network.mixins.concat(occi_object.mixins).uniq!
          # update state
          network_update_state(network)
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def network_update_state(network)
        state = OCCI::Infrastructure::Network::STATE_ACTIVE
        network.state_machine.set_state(state)
        network.attributes['occi.network.state'] = network.state_machine.current_state.name
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # DELETE VNET
      def network_delete(network)
        backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)
        rc = backend_object.delete
        check_rc(rc)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # GET ALL VNETs
      def network_register_all_instances
        occi_objects = []
        backend_object_pool=VirtualNetworkPool.new(@one_client, INFO_ACL)
        backend_object_pool.info_group
        backend_object_pool.each do |backend_object|
          occi_object = OCCI::Backend::OpenNebula.network_parse_backend_object(backend_object)
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

      # ---------------------------------------------------------------------------------------------------------------------     
      def network_action_dummy(network, parameters)       
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # Action up
      def network_up(network, parameters)
        backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)
        # FIXME
        network.enable
        check_rc(rc)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # Action down
      def network_down(network, parameters)
        backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)
        # FIXME
        network.disable
        check_rc(rc)
      end

      ########################################################################
      # Storage class

      TEMPLATESTORAGERAWFILE = 'occi_one_template_storage.erb'
 
      # ---------------------------------------------------------------------------------------------------------------------     
      # CREATE STORAGE
      def storage_deploy(storage)
        
        backend_object = Image.new(Image.build_xml, @one_client)

        storagelink = nil

        if storage.links != nil
          storage.links.each do |link|
            if link.kind.term == 'storagelink'
              $image_path = link.attributes['occi.core.target']
            end
          end
        end

        # check creation of images
        raise "No image or storagelink provided" if $image_path == ""
        storage.templateRaw = $config["TEMPLATE_LOCATION"] + TEMPLATESTORAGERAWFILE
        template = ERB.new(File.read(storage.templateRaw)).result(binding)
        $log.debug("Parsed template #{template}")
        rc = backend_object.allocate(template)
        check_rc(rc)
        $log.debug("OpenNebula ID of image: #{storage.backend[:id]}")
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def storage_update_state(storage)
        backend_object = Image.new(Image.build_xml(storage.backend[:id]), @one_client)
        backend_object.info
        $log.debug("current Image state is: #{backend_object.state_str}")
        state = case backend_object.state_str
                  when "READY" , "USED" , "LOCKED" then OCCI::Infrastructure::Storage::STATE_ONLINE
                  else OCCI::Infrastructure::Storage::STATE_OFFLINE
                end
        storage.state_machine.set_state(state)
        storage.attributes['occi.storage.state'] = storage.state_machine.current_state.name
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # DELETE STORAGE / IMAGE
      def storage_delete(storage)
        backend_object = Image.new(Image.build_xml(storage.backend[:id]), @one_client)
        rc = backend_object.delete
        check_rc(rc)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # REFRESH IMAGES
      def storage_refresh(storage)
        backend_object = Image.new(Image.build_xml(storage.backend[:id]), @one_client)

        backend_object.info

        occi_object = OCCI::Backend::OpenNebula.storage_parse_backend_object(backend_object)

        if occi_object.nil? then
          $log.warn("Problem refreshing storage with backend id #{storage.backend[:id]}")
        else

          # merge new attributes with existing attributes, by overwriting existing attributes with refreshed values
          storage.attributes.merge!(occi_object.attributes)
          # concat mixins and remove duplicate mixins
          storage.mixins.concat(occi_object.mixins).uniq!
          # update state
          storage_update_state(storage)
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def storage_register_all_instances
        occi_objects = []
        backend_object_pool=ImagePool.new(@one_client, INFO_ACL)
        backend_object_pool.info_group
        backend_object_pool.each do |backend_object|
          occi_object = OCCI::Backend::OpenNebula.storage_parse_backend_object(backend_object)
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


      # ---------------------------------------------------------------------------------------------------------------------     
      def storage_action_dummy(storage, parameters)       
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # Action online
      def storage_online(network, parameters)
        backend_object = Image.new(Image.build_xml(network.backend[:id]), @one_client)
        rc = backend_object.enable
        check_rc(rc)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # Action offline
      def storage_offline(network, parameters)
        backend_object = Image.new(Image.build_xml(network.backend[:id]), @one_client)
        rc = backend_object.disable
        check_rc(rc)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # Action backup
      def storage_backup(network, parameters)
        $log.debug("not yet implemented")
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # Action snapshot
      def storage_snapshot(network, parameters)
        $log.debug("not yet implemented")
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # Action resize
      def storage_resize(network, parameters)
        $log.debug("not yet implemented")
      end

    end
    
    
    # ---------------------------------------------------------------------------------------------------------------------
    class Manager
              
      private
      
      @@backends_classes    = {}
      @@backends_operations = {}
      
      public
   
   
      # ---------------------------------------------------------------------------------------------------------------------
      def self.register_backend(backend_class, operations)
        
        # Get ident of backend = class name downcased
#        backend_ident = Object.const_get(backend_class).name.downcase

        backend_ident = backend_class.name.downcase

        @@backends_classes[backend_ident]     = backend_class
        @@backends_operations[backend_ident]  = operations
      end

      # ---------------------------------------------------------------------------------------------------------------------
      def self.signal_resource(backend, operation, resource, operation_parameters = nil)

        resource_type = resource.kind.type_identifier
        backend_ident = backend.class.name.downcase
        
        raise OCCI::BackendError, "Unknown backend: '#{backend_ident}'"                                             unless @@backends_classes.has_key?(backend_ident)
        
        operations = @@backends_operations[backend_ident]
        
        raise OCCI::BackendError, "Resource type '#{resource_type}' not supported!"                                 unless operations.has_key?(resource_type)
        raise OCCI::BackendError, "Operation '#{operation}' not supported on resource category '#{resource_type}'!" unless operations[resource_type].has_key?(operation)
        
        # Delegate
        if operation_parameters.nil?
          # Generic resource operation
          backend.send(operations[resource_type][operation], resource)
        else
          # Action related operation, we need to pass on the action parameters
          backend.send(operations[resource_type][operation], resource, operation_parameters)
        end

      end

      # ---------------------------------------------------------------------------------------------------------------------
      def self.delegate_action(backend, action, parameters, resource)
  
        $log.debug("Delegating invocation of action [#{action}] on resource [#{resource}] with parameters [#{parameters}] to backend...")
  
        # Verify
        state_machine = resource.state_machine
        raise "Action [#{action}] not valid for current state [#{state_machine.current_state}] of resource [#{resource}]!" if !state_machine.check_transition(action)
        
        # Use action term as ident
        operation = action.term.to_s

        begin
          # TODO: define some convention for result handling!
          signal_resource(backend, operation, resource, parameters)

          state_machine.transition(action)
          signal_resource(backend, OCCI::Backend::RESOURCE_UPDATE_STATE)

        rescue OCCI::BackendError
          $log.error("Action invocation failed!")
          raise
        end   
      end

      # Register available backends
      register_backend(OCCI::Backend::OpenNebula,   OCCI::Backend::OpenNebula::OPERATIONS)

    end
        
  end
end
