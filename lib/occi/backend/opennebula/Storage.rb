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

require 'occi/backend/opennebula/StorageERB'

module OCCI
  module Backend
    module OpenNebula

      # ---------------------------------------------------------------------------------------------------------------------
      module Storage
        
        TEMPLATESTORAGERAWFILE = 'occi_one_template_storage.erb'
        
        # ---------------------------------------------------------------------------------------------------------------------       
        private
        # ---------------------------------------------------------------------------------------------------------------------
       
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
       
        # ---------------------------------------------------------------------------------------------------------------------
        def storage_deploy(storage)
          
          backend_object = Image.new(Image.build_xml, @one_client)
  
          storage_erb         = StorageERB.new
          storage_erb.storage = storage
  
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
  
          template_raw = $config["TEMPLATE_LOCATION"] + TEMPLATESTORAGERAWFILE
          template = ERB.new(File.read(template_raw)).result(storage_erb.get_binding)
  
          $log.debug("Parsed template #{template}")
          rc = backend_object.allocate(template)
          check_rc(rc)
          $log.debug("OpenNebula ID of image: #{storage.backend[:id]}")
        end
  
        # ---------------------------------------------------------------------------------------------------------------------
        def storage_update_state(storage)
          backend_object = Image.new(Image.build_xml(storage.backend[:id]), @one_client)
  #        backend_object.info
          $log.debug("current Image state is: #{backend_object.state_str}")
          state = case backend_object.state_str
                    when "READY" , "USED" , "LOCKED" then OCCI::Infrastructure::Storage::STATE_ONLINE
                    else OCCI::Infrastructure::Storage::STATE_OFFLINE
                  end
          storage.state_machine.set_state(state)
          storage.attributes['occi.storage.state'] = storage.state_machine.current_state.name
        end
  
        # ---------------------------------------------------------------------------------------------------------------------
        def storage_delete(storage)
          backend_object = Image.new(Image.build_xml(storage.backend[:id]), @one_client)
          rc = backend_object.delete
          check_rc(rc)
        end
  
        # ---------------------------------------------------------------------------------------------------------------------
        def storage_refresh(storage)
          backend_object = Image.new(Image.build_xml(storage.backend[:id]), @one_client)
  
  #        backend_object.info
  
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
          backend_object_pool.info
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
        # STORAGE ACTIONS
        # ---------------------------------------------------------------------------------------------------------------------
  
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

    end 
  end   
end
