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

require 'occi/backend/opennebula/NetworkERB'

require 'occi/Log'

module OCCI
  module Backend
    module OpenNebula

      # ---------------------------------------------------------------------------------------------------------------------
      module Network

        TEMPLATENETWORKRAWFILE = 'occi_one_template_network.erb'

        # ---------------------------------------------------------------------------------------------------------------------       
        #        private
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------     
        def network_parse_backend_object(backend_object)
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
          #          OCCI::Log.debug("*** object: " + backend_object.to_xml)
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
          occi_object = OCCI::Rendering::HTTP::LocationRegistry.get_object('/network/' + occi_id)
          if occi_object.nil?
            occi_object = OCCI::Infrastructure::Network.new(attributes, mixins)
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
        def network_deploy(network)

          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(), @one_client)

          network_erb = NetworkERB.new
          network_erb.network = network

          template_raw = $config["TEMPLATE_LOCATION"] + TEMPLATENETWORKRAWFILE
          template = ERB.new(File.read(template_raw)).result(network_erb.get_binding)

          OCCI::Log.debug("Parsed template #{template}")
          rc = backend_object.allocate(template)
          check_rc(rc)
          network.backend[:id] = backend_object.id
          OCCI::Log.debug("OpenNebula ID of virtual network: #{network.backend[:id]}")
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def network_refresh(network)
          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)

          backend_object.info

          occi_object = network_parse_backend_object(backend_object)

          if occi_object.nil? then
            OCCI::Log.warn("Problem refreshing network with backend id #{network.backend[:id]}")
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
        def network_delete(network)
          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)
          rc = backend_object.delete
          check_rc(rc)
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def network_register_all_instances
          occi_objects = []
          backend_object_pool=VirtualNetworkPool.new(@one_client, OCCI::Backend::OpenNebula::OpenNebula::INFO_ACL)
          backend_object_pool.info
          backend_object_pool.each do |backend_object|
#            OCCI::Log.debug("*** network_register_all_instances: backend_object: " + backend_object.to_xml)
            backend_object.info
            occi_object = network_parse_backend_object(backend_object)
            if occi_object.nil?
              OCCI::Log.debug("Error creating network from backend")
            else
              occi_object.backend[:id] = backend_object.id
              OCCI::Log.debug("Backend ID: #{occi_object.backend[:id]}")
              occi_objects << occi_object
            end
          end
          return occi_objects
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # STORAGE ACTIONS
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------     
        def network_action_dummy(network, parameters)
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def network_up(network, parameters)
          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)
          # FIXME
          network.enable
          check_rc(rc)
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def network_down(network, parameters)
          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)
          # FIXME
          network.disable
          check_rc(rc)
        end

      end

    end
  end
end

