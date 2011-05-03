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
# Description: OCCI Infrastructure Network Interface Link
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/core/Kind'
require 'occi/core/Link'

module OCCI
  module Infrastructure
    class Networkinterface < OCCI::Core::Link

      # Define appropriate kind
      begin
        
        # Define backend initiated actions

        ACTION_BACKEND_START  = "start"
        ACTION_BACKEND_STOP   = "stop"

        # Define state-machine

        STATE_INACTIVE  = OCCI::StateMachine::State.new("inactive")
        STATE_ACTIVE    = OCCI::StateMachine::State.new("active")

        STATE_INACTIVE.add_transition(ACTION_BACKEND_START, STATE_ACTIVE)

        STATE_ACTIVE.add_transition(ACTION_BACKEND_STOP,    STATE_INACTIVE)
        
        actions = []
        related = [OCCI::Core::Link::KIND]
        entity_type = self
        entities = []

        term    = "networkinterface"
        scheme  = "http://schemas.ogf.org/occi/infrastructure#"
        title   = "Networkinterface"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.interface', mutable = false,  mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.mac',       mutable = true,   mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.state',     mutable = false,  mandatory = true, unique = true)

        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end

      def initialize(attributes)
        super(attributes)
        @kind_type      = "http://schemas.ogf.org/occi/infrastructure#networkinterface"
        @state_machine  = OCCI::StateMachine.new(STATE_INACTIVE, [STATE_INACTIVE, STATE_ACTIVE], :on_transition => self.method(:update_state))
      end

      def update_state
        @attributes['occi.networkinterface.state'] = state_machine.current_state.name
      end

    end
  end
end