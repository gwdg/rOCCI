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
require 'ipaddr'

module OCCI
  module Backend
    module OpenNebula

      # ---------------------------------------------------------------------------------------------------------------------
      module Network

        TEMPLATENETWORKRAWFILE = 'network.erb'

        # ---------------------------------------------------------------------------------------------------------------------       
        #        private
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------     
        def network_parse_backend_object(backend_object)

          # get information on storage object from OpenNebula backend
          backend_object.info

          network_kind = OCCI::Registry.get_by_id("http://schemas.ogf.org/occi/infrastructure#network")

          network = Hashie::Mash.new

          network.kind = storage_kind.type_identifier
          network.mixins = %w|http://opennebula.org/occi/infrastructure#network http://schemas.ogf.org/occi/infrastructure#ipnetwork|
          network.id = self.generate_occi_id(network_kind, backend_object.id.to_s)
          network.title = backend_object['NAME']
          network.summary = backend_object['TEMPLATE/DESCRIPTION'] if backend_object['TEMPLATE/DESCRIPTION']

          network.attributes!.occi!.network!.address = backend_object['TEMPLATE/NETWORK_ADDRESS'] if backend_object['TEMPLATE/NETWORK_ADDRESS']
          network.attributes!.occi!.network!.gateway = backend_object['TEMPLATE/GATEWAY'] if backend_object['TEMPLATE/GATEWAY']
          network.attributes!.occi!.network!.vlan = backend_object['TEMPLATE/VLAN_ID'] if backend_object['TEMPLATE/VLAN_ID']
          network.attributes!.occi!.network!.allocation = "static" if backend_object['TEMPLATE/TYPE'].downcase == "fixed"
          network.attributes!.occi!.network!.allocation = "dynamic" if backend_object['TEMPLATE/TYPE'].downcase == "ranged"

          network.attributes!.org!.opennebula!.network!.vlan = backend_object['TEMPLATE/VLAN'] if backend_object['TEMPLATE/VLAN']
          network.attributes!.org!.opennebula!.network!.phydev = backend_object['TEMPLATE/PHYDEV'] if backend_object['TEMPLATE/PHYDEV']
          network.attributes!.org!.opennebula!.network!.bridge = backend_object['TEMPLATE/BRIDGE'] if backend_object['TEMPLATE/BRIDGE']

          network.attributes!.org!.opennebula!.network!.ip_start = backend_object['TEMPLATE/IP_START'] if backend_object['TEMPLATE/IP_START']
          network.attributes!.org!.opennebula!.network!.ip_end = backend_object['TEMPLATE/IP_END'] if backend_object['TEMPLATE/IP_END']

          network = OCCI::Core::Resource.new(network)

          network_set_state(backend_object, network)

          network_kind.entities << network
        end

        # ---------------------------------------------------------------------------------------------------------------------
        public
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------     
        def network_deploy(network)

          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(), @one_client)

          template_location = OCCI::Server.config["TEMPLATE_LOCATION"] + TEMPLATENETWORKRAWFILE
          template = Erubis::Eruby.new(File.read(template_raw)).evaluate(network)

          OCCI::Log.debug("Parsed template #{template}")
          rc = backend_object.allocate(template)
          check_rc(rc)

          backend_object.info
          network.id = self.generate_occi_id(OCCI::Registry.get_by_id(network.kind), backend_object['ID'].to_s)

          network_set_state(backend_object, network)

          OCCI::Log.debug("OpenNebula ID of virtual network: #{network.backend[:id]}")
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def network_set_state(backend_object, network)
          network.attributes!.occi!.network!.state = "active"
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
          backend_object_pool.each { |backend_object| network_parse_backend_object(backend_object) }
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
          # not implemented in OpenNebula
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def network_down(network, parameters)
          backend_object = VirtualNetwork.new(VirtualNetwork.build_xml(network.backend[:id]), @one_client)
          # not implemented in OpenNebula
        end

      end

    end
  end
end