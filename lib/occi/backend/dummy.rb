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
# Description: Dummy Backend
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/backend/manager'
require 'hashie/hash'
require 'occi/log'
require 'uuidtools'
require 'pstore'

module OCCI
  module Backend

    # ---------------------------------------------------------------------------------------------------------------------         
    class Dummy

      def initialize
        @store = PStore.new('collection')
        @store.transaction do
          @store['resources'] ||= []
          @store['links'] ||= []
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      # Operation mappings

      OPERATIONS = {}

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#compute"] = {

          # Generic resource operations
          :deploy => :compute_deploy,
          :update_state => :resource_update_state,
          :delete => :resource_delete,

          # network specific resource operations
          :start => :compute_action_start,
          :stop => :compute_action_stop,
          :restart => :compute_action_restart,
          :suspend => :compute_action_suspend
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#network"] = {

          # Generic resource operations
          :deploy => :network_deploy,
          :update_state => :resource_update_state,
          :delete => :resource_delete,

          # Network specific resource operations
          :up => :network_action_up,
          :down => :network_action_down
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#storage"] = {

          # Generic resource operations
          :deploy => :storage_deploy,
          :update_state => :resource_update_state,
          :delete => :resource_delete,

          # Network specific resource operations
          :online => :storage_action_online,
          :offline => :storage_action_offline,
          :backup => :storage_action_backup,
          :snapshot => :storage_action_snapshot,
          :resize => :storage_action_resize
      }

      # ---------------------------------------------------------------------------------------------------------------------
      def register_existing_resources
        @store.transaction(read_only=true) do
          entities = @store['resources'] + @store['links']
          entities.each do |entity|
            kind = OCCI::Registry.get_by_id(entity.kind)
            kind.entities << entity
            OCCI::Log.debug("#### Number of entities in kind #{kind.type_identifier}: #{kind.entities.size}")
          end
        end
      end

      # TODO: register user defined mixins

      def compute_deploy(compute)
        compute.id = UUIDTools::UUID.timestamp_create.to_s
        compute_action_start(compute)
        store(compute)
      end

      def storage_deploy(storage)
        storage.id = UUIDTools::UUID.timestamp_create.to_s
        storage_action_online(storage)
        store(storage)
      end

      def network_deploy(network)
        network.id = UUIDTools::UUID.timestamp_create.to_s
        network_action_up(network)
        store(network)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def store(resource)
        OCCI::Log.debug("### DUMMY: Deploying resource with id #{resource.id}")
        @store.transaction do
          @store['resources'].delete_if { |res| res.id == resource.id }
          @store['resources'] << resource
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_update_state(resource)
        OCCI::Log.debug("Updating state of resource '#{resource.attributes['occi.core.title']}'...")
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_delete(resource)
        OCCI::Log.debug("Deleting resource '#{resource.attributes['occi.core.title']}'...")
        @store.transaction do
          @store['resources'].delete_if { |res| res.id == resource.id }
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------
      # ACTIONS
      # ---------------------------------------------------------------------------------------------------------------------

      def compute_action_start(compute, parameters=nil)
        action_dummy(compute)
        compute.attributes!.occi!.compute!.state = 'active'
        compute.links << OCCI::Core::Link.new(:target => compute.location + '?action=stop', :rel => 'http://schemas.ogf.org/occi/infrastructure/compute/action#start')
        compute.links << OCCI::Core::Link.new(:target => compute.location + '?action=restart', :rel => 'http://schemas.ogf.org/occi/infrastructure/compute/action#restart')
        compute.links << OCCI::Core::Link.new(:target => compute.location + '?action=suspend', :rel => 'http://schemas.ogf.org/occi/infrastructure/compute/action#suspend')
        store(compute)
      end

      def compute_action_stop(compute, parameters=nil)
        action_dummy(compute)
        compute.attributes!.occi!.compute!.state = 'inactive'
        compute.links << OCCI::Core::Link.new(:target => compute.location + '?action=start', :rel => 'http://schemas.ogf.org/occi/infrastructure/compute/action#start')
        store(compute)
      end

      def compute_action_restart(compute, parameters=nil)
        compute_action_start(compute)
      end

      def compute_action_suspend(compute, parameters=nil)
        action_dummy(compute)
        compute.attributes!.occi!.compute!.state = 'suspended'
        compute.links << OCCI::Core::Link.new(:target => compute.location + '?action=start', :rel => 'http://schemas.ogf.org/occi/infrastructure/compute/action#start')
        store(compute)
      end

      def storage_action_online(storage, parameters=nil)
        action_dummy(storage)
        storage.attributes!.occi!.storage!.state = 'online'
        storage.links << OCCI::Core::Link.new(:target => storage.location + '?action=offline', :rel => 'http://schemas.ogf.org/occi/infrastructure/storage/action#offline')
        storage.links << OCCI::Core::Link.new(:target => storage.location + '?action=backup', :rel => 'http://schemas.ogf.org/occi/infrastructure/storage/action#restart')
        storage.links << OCCI::Core::Link.new(:target => storage.location + '?action=snapshot', :rel => 'http://schemas.ogf.org/occi/infrastructure/storage/action#suspend')
        storage.links << OCCI::Core::Link.new(:target => storage.location + '?action=resize', :rel => 'http://schemas.ogf.org/occi/infrastructure/storage/action#resize')
        store(storage)
      end

      def storage_action_offline(storage, parameters=nil)
        action_dummy(storage)
        storage.attributes!.occi!.storage!.state = 'offline'
        storage.links << OCCI::Core::Link.new(:target => storage.location + '?action=online', :rel => 'http://schemas.ogf.org/occi/infrastructure/storage/action#online')
        storage.links << OCCI::Core::Link.new(:target => storage.location + '?action=backup', :rel => 'http://schemas.ogf.org/occi/infrastructure/storage/action#restart')
        storage.links << OCCI::Core::Link.new(:target => storage.location + '?action=snapshot', :rel => 'http://schemas.ogf.org/occi/infrastructure/storage/action#suspend')
        storage.links << OCCI::Core::Link.new(:target => storage.location + '?action=resize', :rel => 'http://schemas.ogf.org/occi/infrastructure/storage/action#resize')
        store(storage)
      end

      def storage_action_backup(storage, parameters=nil)
        # nothing to do, state and actions stay the same after the backup which is instant for the dummy
      end

      def storage_action_snapshot(storage, parameters=nil)
        # nothing to do, state and actions stay the same after the snapshot which is instant for the dummy
      end

      def storage_action_resize(storage, parameters=nil)
        puts "Parameters: #{parameters}"
        storage.attributes!.occi!.storage!.size = parameters[:size].to_i
        # state and actions stay the same after the resize which is instant for the dummy
        store(storage)
      end

      def network_action_up(network, parameters=nil)
        action_dummy(network)
        network.attributes!.occi!.network!.state = 'up'
        network.links << OCCI::Core::Link.new(:target => network.location + '?action=down', :rel => 'http://schemas.ogf.org/occi/infrastructure/network/action#down')
        store(network)
      end

      def network_action_down(network, parameters=nil)
        action_dummy(network)
        network.attributes!.occi!.network!.state = 'down'
        network.links << OCCI::Core::Link.new(:target => network.location + '?action=up', :rel => 'http://schemas.ogf.org/occi/infrastructure/network/action#up')
        store(network)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def action_dummy(resource, parameters=nil)
        OCCI::Log.debug("Calling method for resource '#{resource.attributes['occi.core.title']}' with parameters: #{parameters.inspect}")
        resource.links ||= []
        resource.links.delete_if { |link| link.rel.include? 'action' }
      end

    end

  end
end