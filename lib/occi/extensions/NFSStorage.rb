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
# Description: OCCI Infrastructure Storage
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/CategoryRegistry'
require 'occi/core/Kind'
require 'occi/core/Resource'
require 'occi/StateMachine'
require 'occi/ActionDelegator'

module OCCI
  module Infrastructure
    class NFSStorage < OCCI::Core::Resource

      # Define associated kind
      begin

        ACTION_OFFLINE  = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/gwdg/nfsstorage/action#", term = "offline",   title = "Storage Action Offline",   attributes = OCCI::Core::Attributes.new())
        ACTION_ONLINE   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/gwdg/nfsstorage/action#", term = "online",    title = "Storage Action Online",    attributes = OCCI::Core::Attributes.new())

        actions = [ACTION_OFFLINE, ACTION_ONLINE]

        OCCI::CategoryRegistry.register(ACTION_OFFLINE.category)
        OCCI::CategoryRegistry.register(ACTION_ONLINE.category)

        # Define backend initiated actions

        ACTION_BACKEND_COMPLETE = "complete"
        ACTION_BACKEND_DEGRADED = "degraded"

        # Define state-machine
        STATE_OFFLINE   = OCCI::StateMachine::State.new("offline")
        STATE_ONLINE    = OCCI::StateMachine::State.new("online")

        STATE_OFFLINE.add_transition(ACTION_ONLINE, STATE_ONLINE)

        STATE_ONLINE.add_transition(ACTION_OFFLINE, STATE_OFFLINE)

        related     = [OCCI::Core::Resource::KIND]
        entity_type = self
        entities    = []

        term    = "nfsstorage"
        scheme  = "http://schemas.ogf.org/gwdg#"
        title   = "NFS Storage Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.size',   mutable = true,   mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.state',  mutable = false,  mandatory = true,   unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.export', mutable = false,  mandatory = true,   unique = true)

        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
        
        OCCI::CategoryRegistry.register(KIND)
        OCCI::Rendering::HTTP::LocationRegistry.register('/nfsstorage/', KIND)
      end

      def initialize(attributes, mixins=[])

        @state_machine  = OCCI::StateMachine.new(STATE_OFFLINE, [STATE_OFFLINE, STATE_ONLINE])

        # Initialize resource state
        attributes['occi.storage.state'] = state_machine.current_state.name

        # create action delegator
#        delegator = OCCI::ActionDelegator.instance

        # register methods for storage actions
#        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_ONLINE,    self, :online)
#        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_OFFLINE,   self, :offline)

        super(attributes, mixins, OCCI::Infrastructure::NFSStorage::KIND)
      end
      
#      def update_state
#        # Nothing to do
#      end
      
#      def deploy
#        # Nothing to do
#      end

#      def refresh
#        # Nothing to do
#      end

    end
  end
end
