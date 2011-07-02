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
# Description: OCCI Infrastructure Compute
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/core/Action'
require 'occi/core/Kind'
require 'occi/core/Resource'
require 'occi/StateMachine'

module OCCI
  module Infrastructure
    class Compute < OCCI::Core::Resource
 
      # Define associated kind
      begin
        # Define actions
        ACTION_RESTART = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/compute/action#", term = "restart",
                          title = "Compute Action Restart",   attributes = ["graceful", "warm", "cold"])

        ACTION_START   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/compute/action#", term = "start",
                          title = "Compute Action Start",     attributes = [])

        ACTION_STOP    = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/compute/action#", term = "stop",      
                          title = "Compute Action Stop",      attributes = ["graceful", "acpioff", "poweroff"])

        ACTION_SUSPEND = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/compute/action#", term = "suspend",
                          title = "Compute Action Suspend",   attributes = ["hibernate", "suspend"])

        actions = [ACTION_RESTART, ACTION_START, ACTION_STOP, ACTION_SUSPEND]
          
        # Define state-machine
        STATE_INACTIVE  = OCCI::StateMachine::State.new("inactive")
        STATE_ACTIVE    = OCCI::StateMachine::State.new("active")
        STATE_SUSPENDED = OCCI::StateMachine::State.new("suspended")
          
        STATE_INACTIVE.add_transition(ACTION_START, STATE_ACTIVE)

        STATE_ACTIVE.add_transition(ACTION_STOP,    STATE_INACTIVE)
        STATE_ACTIVE.add_transition(ACTION_SUSPEND, STATE_SUSPENDED)
        # TODO: determine if the following modelling of the restart action is approriate
        STATE_ACTIVE.add_transition(ACTION_RESTART, STATE_ACTIVE)

        STATE_SUSPENDED.add_transition(ACTION_START, STATE_ACTIVE)

        related = [OCCI::Core::Resource::KIND]
        entity_type = self
        entities = []

        term    = "compute"
        scheme  = "http://schemas.ogf.org/occi/infrastructure#"
        title   = "Compute Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.compute.cores',        mutable = true,   mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.compute.architecture', mutable = true,   mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.compute.state',        mutable = false,  mandatory = true,   unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.compute.hostname',     mutable = true,   mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.compute.memory',       mutable = true,   mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.compute.speed',        mutable = true,   mandatory = false,  unique = true)
          
        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end
 
      def initialize(attributes, mixins = [])
        @state_machine  = OCCI::StateMachine.new(STATE_INACTIVE, [STATE_INACTIVE, STATE_ACTIVE, STATE_SUSPENDED], :on_transition => self.method(:update_state))
        # Initialize resource state
        attributes['occi.compute.state'] = state_machine.current_state.name
        super(attributes, OCCI::Infrastructure::Compute::KIND ,mixins)
      end

      def deploy
        template ? $backend.create_compute_instance(self) : $backend.create_compute_template(self)
      end
      
      def delete
        $backend.delete_compute_instance(self)
        delete_entity()
      end

      def update_state
        @attributes['occi.compute.state'] = state_machine.current_state.name
      end

    end
  end
end
