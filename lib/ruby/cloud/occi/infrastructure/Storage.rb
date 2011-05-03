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
        # Define actions
        ACTION_BACKUP   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "backup",    title = "Storage Action Backup",    attributes = [])
        ACTION_OFFLINE  = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "offline",   title = "Storage Action Offline",   attributes = [])
        ACTION_ONLINE   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "online",    title = "Storage Action Online",    attributes = [])
        ACTION_RESIZE   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "resize",    title = "Storage Action Resize",    attributes = ["size"])
        ACTION_SNAPSHOT = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "snapshot",  title = "Storage Action Snapshot",  attributes = [])

        # TODO: determine how to model "complete" action (can not be called by occi-client but may be called by backend?)
        ACTION_COMPLETE = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "complete",  title = "Storage Action Complete",  attributes = [])

        actions = [ACTION_BACKUP, ACTION_OFFLINE, ACTION_ONLINE, ACTION_RESIZE, ACTION_SNAPSHOT]

        # Define state-machine
        STATE_OFFLINE   = OCCI::StateMachine::State.new("offline")
        STATE_ONLINE    = OCCI::StateMachine::State.new("online")
        STATE_BACKUP    = OCCI::StateMachine::State.new("backup")
        STATE_SNAPSHOT  = OCCI::StateMachine::State.new("snapshot")
        STATE_RESIZE    = OCCI::StateMachine::State.new("resize")
        
        STATE_OFFLINE.add_transition(ACTION_ONLINE, STATE_ONLINE)
        
        STATE_ONLINE.add_transition(ACTION_OFFLINE,   STATE_OFFLINE)
        STATE_ONLINE.add_transition(ACTION_BACKUP,    STATE_BACKUP)
        STATE_ONLINE.add_transition(ACTION_SNAPSHOT,  STATE_SNAPSHOT)
        STATE_ONLINE.add_transition(ACTION_RESIZE,    STATE_RESIZE)

        STATE_BACKUP.add_transition(ACTION_COMPLETE,  STATE_ONLINE)

        STATE_SNAPSHOT.add_transition(ACTION_COMPLETE,STATE_ONLINE)
        
        STATE_RESIZE.add_transition(ACTION_COMPLETE,  STATE_ONLINE)

        STATE_MACHINE = OCCI::StateMachine.new(STATE_OFFLINE, [STATE_OFFLINE, STATE_ONLINE, STATE_BACKUP, STATE_SNAPSHOT, STATE_RESIZE])

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
        super(attributes, mixins)
        @kind_type      = "http://schemas.ogf.org/occi/infrastructure#storage"
        @state_machine  = STATE_MACHINE.clone
      end
      
      def deploy()
        $backend.create_storage_instance(self)
      end
      
      def delete()
        $backend.delete_storage_instance(self)
        delete_entity()
      end

    end
  end
end