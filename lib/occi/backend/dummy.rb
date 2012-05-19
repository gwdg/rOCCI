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
        @store = PStore.new('collection', thread_safe=true)
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
          :deploy => :resource_deploy,
          :update_state => :resource_update_state,
          :refresh => :resource_refresh,
          :delete => :resource_delete,

          # Compute specific resource operations
          :start => :action_dummy,
          :stop => :action_dummy,
          :restart => :action_dummy,
          :suspend => :action_dummy
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#network"] = {

          # Generic resource operations
          :deploy => :resource_deploy,
          :update_state => :resource_update_state,
          :refresh => :resource_refresh,
          :delete => :resource_delete,

          # Network specific resource operations
          :up => :action_dummy,
          :down => :action_dummy
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#storage"] = {

          # Generic resource operations
          :deploy => :resource_deploy,
          :update_state => :resource_update_state,
          :refresh => :resource_refresh,
          :delete => :resource_delete,

          # Network specific resource operations
          :online => :action_dummy,
          :offline => :action_dummy,
          :backup => :action_dummy,
          :snapshot => :action_dummy,
          :resize => :action_dummy
      }

      OPERATIONS["http://schemas.ogf.org/gwdg#nfsstorage"] = {

          # Generic resource operations
          :deploy => :resource_deploy,
          :update_state => :resource_update_state,
          :refresh => :resource_refresh,
          :delete => :resource_delete,
      }

      # ---------------------------------------------------------------------------------------------------------------------
      def register_existing_resources
        @store.transaction(read_only=true) do
          entities = @store['resources'] + @store['links']
          entities.each do |entity|
            kind = OCCI::Registry.get_by_id(entity.kind)
            OCCI::Log.debug('Entity from dummy backend #{entity}')
            kind.entities << entity
            OCCI::Log.debug("Entities in kind #{kind.type_identifier}: #{kind.entities.size}")
          end
        end
      end

      # TODO: register user defined mixins

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_deploy(resource)
        OCCI::Log.debug("### DUMMY: Deploying resource with title #{resource.title}")
        resource.id = UUIDTools::UUID.timestamp_create.to_s
        @store.transaction do
          @store['resources'] << resource
        end
        OCCI::Log.debug(@collection)
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_refresh(resource)
        OCCI::Log.debug("Refreshing resource '#{resource.attributes['occi.core.title']}'...")
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

      # ---------------------------------------------------------------------------------------------------------------------     
      def action_dummy(compute, parameters)
        OCCI::Log.debug("Calling method for resource '#{resource.attributes['occi.core.title']}' with parameters: #{parameters.inspect}")
      end

    end

  end
end