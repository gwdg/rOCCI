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
    class NFSStorage < OCCI::Infrastructure::Storage

      # Define associated kind
      begin

        related     = [OCCI::Infrastructure::Storage::KIND]
        entity_type = self
        entities    = []

        term    = "nfsstorage"
        scheme  = "http://schemas.ogf.org/occi/gwdg#"
        title   = "NFS Storage Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.size',   mutable = true,   mandatory = false, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.state',  mutable = false,  mandatory = true, unique = true)

        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
        
        OCCI::CategoryRegistry.register(KIND)
        OCCI::Rendering::HTTP::LocationRegistry.register('/nfsstorage/', KIND)
      end

      def initialize(attributes, mixins=[])
        @state_machine  = OCCI::StateMachine.new(STATE_OFFLINE, [STATE_OFFLINE, STATE_ONLINE, STATE_BACKUP, STATE_SNAPSHOT, STATE_RESIZE], :on_transition => self.method(:update_state))
        # Initialize resource state
        attributes['occi.storage.state'] = state_machine.current_state.name

        # create action delegator
        delegator = OCCI::ActionDelegator.instance

        # register methods for storage actions
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_ONLINE,    self, :online)
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_OFFLINE,   self, :offline)
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_BACKUP,    self, :backup)
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_SNAPSHOT,  self, :snapshot)
        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_RESIZE,    self, :resize)

        super(attributes, OCCI::Infrastructure::NFSStorage::KIND, mixins)
      end
    end
  end
end
