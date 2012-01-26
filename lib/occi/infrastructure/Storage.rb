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
#require 'occi/ActionDelegator'

module OCCI
  module Infrastructure

    class Storage < OCCI::Core::Resource
      begin
        # Define client initiated actions
        backup_attributes   = OCCI::Core::Attributes.new()
        offline_attributes  = OCCI::Core::Attributes.new()
        online_attributes   = OCCI::Core::Attributes.new()
        resize_attributes   = OCCI::Core::Attributes.new()
        resize_attributes << OCCI::Core::Attribute.new(name = 'size', mutable = false, mandatory = false, unique = true)
        snapshot_attributes = OCCI::Core::Attributes.new()

        ACTION_BACKUP   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "backup",    title = "Storage Action Backup",    attributes = backup_attributes)
        ACTION_OFFLINE  = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "offline",   title = "Storage Action Offline",   attributes = offline_attributes)
        ACTION_ONLINE   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "online",    title = "Storage Action Online",    attributes = online_attributes)
        ACTION_RESIZE   = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "resize",    title = "Storage Action Resize",    attributes = resize_attributes)
        ACTION_SNAPSHOT = OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "snapshot",  title = "Storage Action Snapshot",  attributes = snapshot_attributes)

        actions = [ACTION_BACKUP, ACTION_OFFLINE, ACTION_ONLINE, ACTION_RESIZE, ACTION_SNAPSHOT]

        OCCI::CategoryRegistry.register(ACTION_BACKUP.category)
        OCCI::CategoryRegistry.register(ACTION_OFFLINE.category)
        OCCI::CategoryRegistry.register(ACTION_ONLINE.category)
        OCCI::CategoryRegistry.register(ACTION_RESIZE.category)
        OCCI::CategoryRegistry.register(ACTION_SNAPSHOT.category)

        # Define backend initiated actions

        ACTION_BACKEND_COMPLETE = "complete"
        ACTION_BACKEND_DEGRADED = "degraded"

        # Define state-machine
        STATE_OFFLINE   = OCCI::StateMachine::State.new("offline")
        STATE_ONLINE    = OCCI::StateMachine::State.new("online")
        STATE_BACKUP    = OCCI::StateMachine::State.new("backup")
        STATE_SNAPSHOT  = OCCI::StateMachine::State.new("snapshot")
        STATE_RESIZE    = OCCI::StateMachine::State.new("resize")

        STATE_OFFLINE.add_transition(ACTION_ONLINE,   STATE_ONLINE)

        STATE_ONLINE.add_transition(ACTION_OFFLINE,   STATE_OFFLINE)
        STATE_ONLINE.add_transition(ACTION_BACKUP,    STATE_BACKUP)
        STATE_ONLINE.add_transition(ACTION_SNAPSHOT,  STATE_SNAPSHOT)
        STATE_ONLINE.add_transition(ACTION_RESIZE,    STATE_RESIZE)

        related     = [OCCI::Core::Resource::KIND]
        entity_type = self
        entities    = []

        term    = "storage"
        scheme  = "http://schemas.ogf.org/occi/infrastructure#"
        title   = "Storage Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.size',   mutable = true,   mandatory = false, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.storage.state',  mutable = false,  mandatory = true, unique = true)

        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
        
        OCCI::CategoryRegistry.register(KIND)
        OCCI::Rendering::HTTP::LocationRegistry.register('/storage/', KIND)
      end

      def initialize(attributes, mixins=[])

        @state_machine  = OCCI::StateMachine.new(STATE_OFFLINE, [STATE_OFFLINE, STATE_ONLINE, STATE_BACKUP, STATE_SNAPSHOT, STATE_RESIZE])

        # Initialize resource state
        attributes['occi.storage.state'] = state_machine.current_state.name

        # create action delegator
#        delegator = OCCI::ActionDelegator.instance

        # register methods for storage actions
#        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_ONLINE,    self, :online)
#        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_OFFLINE,   self, :offline)
#        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_BACKUP,    self, :backup)
#        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_SNAPSHOT,  self, :snapshot)
#        delegator.register_method_for_action(OCCI::Infrastructure::Storage::ACTION_RESIZE,    self, :resize)

        super(attributes, mixins, OCCI::Infrastructure::Storage::KIND)
      end
    end

  end
end
