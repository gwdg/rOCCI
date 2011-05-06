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

require 'occi/core/Kind'
require 'occi/core/Resource'
require 'occi/StateMachine'

module OCCI
  module Infrastructure
    class Storage < OCCI::Core::Resource

      # Define associated kind
      begin
        # Define client initiated actions
        ACTION_BACKUP   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "backup",    title = "Storage Action Backup",    attributes = [])
        ACTION_OFFLINE  = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "offline",   title = "Storage Action Offline",   attributes = [])
        ACTION_ONLINE   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "online",    title = "Storage Action Online",    attributes = [])
        ACTION_RESIZE   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "resize",    title = "Storage Action Resize",    attributes = ["size"])
        ACTION_SNAPSHOT = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "snapshot",  title = "Storage Action Snapshot",  attributes = [])

        actions = [ACTION_BACKUP, ACTION_OFFLINE, ACTION_ONLINE, ACTION_RESIZE, ACTION_SNAPSHOT]

        # Define backend initiated actions

        ACTION_BACKEND_COMPLETE = "complete"
        ACTION_BACKEND_DEGRADED = "degraded"

        # Define state-machine
        STATE_OFFLINE   = OCCI::StateMachine::State.new("offline")
        STATE_ONLINE    = OCCI::StateMachine::State.new("online")
        STATE_BACKUP    = OCCI::StateMachine::State.new("backup")
        STATE_SNAPSHOT  = OCCI::StateMachine::State.new("snapshot")
        STATE_RESIZE    = OCCI::StateMachine::State.new("resize")
        
        # Degraded state can only be reached by backend initiated state transitions
        STATE_DEGRADED  = OCCI::StateMachine::State.new("degraded")
        
        STATE_OFFLINE.add_transition(ACTION_ONLINE,             STATE_ONLINE)
        STATE_OFFLINE.add_transition(ACTION_BACKEND_DEGRADED,   STATE_DEGRADED)
        
        STATE_ONLINE.add_transition(ACTION_OFFLINE,             STATE_OFFLINE)
        STATE_ONLINE.add_transition(ACTION_BACKUP,              STATE_BACKUP)
        STATE_ONLINE.add_transition(ACTION_SNAPSHOT,            STATE_SNAPSHOT)
        STATE_ONLINE.add_transition(ACTION_RESIZE,              STATE_RESIZE)
        STATE_ONLINE.add_transition(ACTION_BACKEND_DEGRADED,    STATE_DEGRADED)

        STATE_BACKUP.add_transition(ACTION_BACKEND_COMPLETE,    STATE_ONLINE)
        STATE_BACKUP.add_transition(ACTION_BACKEND_DEGRADED,    STATE_DEGRADED)

        STATE_SNAPSHOT.add_transition(ACTION_BACKEND_COMPLETE,  STATE_ONLINE)
        STATE_SNAPSHOT.add_transition(ACTION_BACKEND_DEGRADED,  STATE_DEGRADED)
        
        STATE_RESIZE.add_transition(ACTION_BACKEND_COMPLETE,    STATE_ONLINE)
        STATE_RESIZE.add_transition(ACTION_BACKEND_DEGRADED,    STATE_DEGRADED)

        related     = [OCCI::Core::Resource::KIND]
        entity_type = self
        entities    = []

        term    = "storage"
        scheme  = "http://schemas.ogf.org/occi/infrastructure#"
        title   = "Storage Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.size',   mutable = true,   mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.state',  mutable = false,  mandatory = true, unique = true)
          
        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end

      def initialize(attributes, mixins=[])
        @state_machine  = OCCI::StateMachine.new(STATE_OFFLINE, [STATE_OFFLINE, STATE_ONLINE, STATE_BACKUP, STATE_SNAPSHOT, STATE_RESIZE], :on_transition => self.method(:update_state))
        # Initialize resource state
        attributes['occi.storage.state'] = state_machine.current_state.name
        super(attributes, OCCI::Infrastructure::Storage::KIND, mixins)
      end
      
      def deploy()
        $backend.create_storage_instance(self)
      end
      
      def delete()
        $backend.delete_storage_instance(self)
        delete_entity()
      end

      def update_state 
        @attributes['occi.storage.state'] = state_machine.current_state.name if [STATE_ONLINE.name, STATE_OFFLINE.name, STATE_DEGRADED.name].include?(state_machine.current_state.name)
      end

    end
  end
end
