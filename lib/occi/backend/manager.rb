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

require 'occi/backend/opennebula/opennebula'
require 'occi/backend/ec2/ec2'
require 'occi/backend/dummy'

#require 'uuidtools'
#require 'OpenNebula/OpenNebula'
#require 'occi/CategoryRegistry'
#require 'occi/rendering/http/LocationRegistry'

# OpenNebula backend
#require 'occi/backend/opennebula/Compute'
#require 'occi/backend/opennebula/Network'
#require 'occi/backend/opennebula/Storage'

# OpenNebula backend based mixins
#require 'occi/extensions/one/Image'
#require 'occi/extensions/one/Network'
#require 'occi/extensions/one/VirtualMachine'
#require 'occi/extensions/one/VNC'

#require 'occi/extensions/Reservation'

#include OpenNebula

module OCCI
  module Backend

    # ---------------------------------------------------------------------------------------------------------------------
    RESOURCE_DEPLOY = :deploy
    RESOURCE_UPDATE_STATE = :update_state
    RESOURCE_REFRESH = :refresh
    RESOURCE_DELETE = :delete

    # ---------------------------------------------------------------------------------------------------------------------
    class Manager

      # ---------------------------------------------------------------------------------------------------------------------              
      private
      # ---------------------------------------------------------------------------------------------------------------------

      @@backends_classes = {}
      @@backends_operations = {}

      # ---------------------------------------------------------------------------------------------------------------------
      public
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------
      def self.register_backend(backend_class, operations)

        # Get ident of backend = class name downcased
        #        backend_ident = Object.const_get(backend_class).name.downcase

        backend_ident = backend_class.name.downcase

        @@backends_classes[backend_ident] = backend_class
        @@backends_operations[backend_ident] = operations
      end

      # ---------------------------------------------------------------------------------------------------------------------
      def self.signal_resource(backend, operation, resource, operation_parameters = nil)

        resource_type = resource.kind
        backend_ident = backend.class.name.downcase

        raise OCCI::BackendError, "Unknown backend: '#{backend_ident}'" unless @@backends_classes.has_key?(backend_ident)

        operations = @@backends_operations[backend_ident]

        raise OCCI::BackendError, "Resource type '#{resource_type}' not supported!" unless operations.has_key?(resource_type)
        raise OCCI::BackendError, "Operation '#{operation}' not supported on resource category '#{resource_type}'!" unless operations[resource_type].has_key?(operation.to_sym)

        # Delegate

        if operations[resource_type][operation.to_sym].nil?
          OCCI::Log.debug("No backend method configured => doing nothing...")
          return
        end

        if operation_parameters.nil?
          # Generic resource operation
          backend.send(operations[resource_type][operation.to_sym], resource)
        else
          # Action related operation, we need to pass on the action parameters
          backend.send(operations[resource_type][operation.to_sym], resource, operation_parameters)
        end

      end

      # ---------------------------------------------------------------------------------------------------------------------
      def self.delegate_action(backend, action, parameters, resource)

        OCCI::Log.debug("Delegating invocation of action [#{action}] on resource [#{resource}] with parameters [#{parameters}] to backend...")

        # Verify
        state_machine = resource.state_machine
        raise "Action [#{action}] not valid for current state [#{state_machine.current_state}] of resource [#{resource}]!" if !state_machine.check_transition(action)

        # Use action term as ident
        operation = action.category.term.to_s

        begin
          # TODO: define some convention for result handling!
          signal_resource(backend, operation, resource, parameters)

          state_machine.transition(action)
          signal_resource(backend, OCCI::Backend::RESOURCE_UPDATE_STATE, resource)

        rescue OCCI::BackendError
          OCCI::Log.error("Action invocation failed!")
          raise
        end
      end
    end
  end
end
