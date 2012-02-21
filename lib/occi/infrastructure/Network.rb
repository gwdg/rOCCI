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
# Description: OCCI Infrastructure Network
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/CategoryRegistry'
require 'occi/core/Kind'
require 'occi/StateMachine'

module OCCI
  module Infrastructure

    class Network < OCCI::Core::Resource
      begin
        # Define actions
        down_attributes = OCCI::Core::Attributes.new()
        up_attributes = OCCI::Core::Attributes.new()

        ACTION_DOWN = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/network/action#", term = "down",      title = "Network Action Down", attributes = down_attributes)
        ACTION_UP   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/network/action#", term = "up",        title = "Network Action Up", attributes = up_attributes)

        actions = [ACTION_DOWN, ACTION_UP]

        OCCI::CategoryRegistry.register(ACTION_DOWN.category)
        OCCI::CategoryRegistry.register(ACTION_UP.category)

        # Define state-machine
        STATE_INACTIVE  = OCCI::StateMachine::State.new("inactive")
        STATE_ACTIVE    = OCCI::StateMachine::State.new("active")

        STATE_INACTIVE.add_transition(ACTION_UP, STATE_ACTIVE)

        STATE_ACTIVE.add_transition(ACTION_DOWN, STATE_INACTIVE)

        related     = [OCCI::Core::Resource::KIND]
        entity_type = self
        entities    = []

        term    = "network"
        scheme  = "http://schemas.ogf.org/occi/infrastructure#"
        title   = "Network Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.vlan',   mutable = true,   required = false,  type = "string", range = "", default = "")
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.label',  mutable = true,   required = false,  type = "string", range = "", default = "")
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.state',  mutable = false,  required = true,  type = "string", range = "", default = "")

        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
        
        OCCI::CategoryRegistry.register(KIND)
        OCCI::Rendering::HTTP::LocationRegistry.register('/network/', KIND)
      end

      def initialize(attributes, mixins=[])

        @state_machine  = OCCI::StateMachine.new(STATE_INACTIVE, [STATE_INACTIVE, STATE_ACTIVE])

        # Initialize resource state
        attributes['occi.network.state'] = state_machine.current_state.name

        super(attributes, mixins, OCCI::Infrastructure::Network::KIND)
      end
    end

  end
end
