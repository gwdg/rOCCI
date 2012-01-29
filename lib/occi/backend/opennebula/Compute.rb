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

require 'occi/backend/opennebula/ComputeERB'

module OCCI
  module Backend
    module OpenNebula

      # ---------------------------------------------------------------------------------------------------------------------
      module Compute
      
        TEMPLATECOMPUTERAWFILE = 'occi_one_template_compute.erb'
      
        # ---------------------------------------------------------------------------------------------------------------------       
        private
        # ---------------------------------------------------------------------------------------------------------------------

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
  #        backend_object.info
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
#              pool = VirtualNetworkPool(@one_client)
#              pool.info(INFO_ACL, network_id, network_id)
            
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
        public
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------     
        def compute_deploy(compute)
          # initialize backend object as VM or VM template
          # TODO: figure out templates
          # backend_object=Template.new(Template.build_xml, $backend.one_client)
          template_mixin = compute.mixins.select { |m| m.related == OCCI::Infrastructure::ResourceTemplate::MIXIN }
    
          if template_mixin.empty?
    
            backend_object = VirtualMachine.new(VirtualMachine.build_xml, @one_client)
  
            compute_erb = ComputeERB.new
    
            compute_erb.compute           = compute
            compute_erb.storage           = []
            compute_erb.networks          = []
            compute_erb.external_storage  = []
            compute_erb.nfs_mounts        = []
     
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
                      compute_erb.nfs_mounts << [target.attributes['occi.storage.export'], link.attributes['occi.storagelink.mountpoint']]
                      next
                    end
                  end
                  
                  if not target.nil?
                    compute_erb.storage << [target, link]
                  elsif not target_URI.nil?
                    compute_erb.external_storage << target_URI
                  end
    
                when 'networkinterface'
                  if not target.nil?
                    compute_erb.networks << [target, link]
                  end
    
                when 'link'
                  case target.kind.term
                  when 'storage'
                    compute_erb.storage << [target, link]
                  when 'network'
                    compute_erb.networks << [target, link]
                  end unless target.nil?
                end
              end
            end
  
            template_raw = $config["TEMPLATE_LOCATION"] + TEMPLATECOMPUTERAWFILE
            compute_template = ERB.new(File.read(template_raw)).result(compute_erb.get_binding)
  
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
  
  #        backend_object.info
  
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
  #        backend_object.info
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
          backend_object_pool = VirtualMachinePool.new(@one_client)
  #        backend_object_pool.info
          backend_object_pool.info(INFO_ACL, -1, -1, OpenNebula::VirtualMachinePool::INFO_ALL_VM)
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
      
      end
      
    end    
  end    
end
