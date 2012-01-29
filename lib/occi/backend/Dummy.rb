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

module OCCI
  module Backend

    # ---------------------------------------------------------------------------------------------------------------------         
    class Dummy  
  
      # ---------------------------------------------------------------------------------------------------------------------     
      # Operation mappings

      OPERATIONS = {}
      
      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#compute"] = {
        
        # Generic resource operations
        :deploy         => :resource_deploy,
        :update_state   => :resource_update_state,
        :refresh        => :resource_refresh,
        :delete         => :resource_delete,
        
        # Compute specific resource operations
        :start          => :action_dummy,
        :stop           => :action_dummy,
        :restart        => :action_dummy,
        :suspend        => :action_dummy        
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#network"] = {
        
        # Generic resource operations
        :deploy         => :resource_deploy,
        :update_state   => :resource_update_state,
        :refresh        => :resource_refresh,
        :delete         => :resource_delete,
        
        # Network specific resource operations
        :up             => :action_dummy,
        :down           => :action_dummy
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#storage"] = {

        # Generic resource operations
        :deploy         => :resource_deploy,
        :update_state   => :resource_update_state,
        :refresh        => :resource_refresh,
        :delete         => :resource_delete,
   
        # Network specific resource operations
        :online         => :action_dummy,
        :offline        => :action_dummy,
        :backup         => :action_dummy,
        :snapshot       => :action_dummy,
        :resize         => :action_dummy
      }

      OPERATIONS["http://schemas.ogf.org/gwdg#nfsstorage"] = {

        # Generic resource operations
        :deploy         => nil,
        :update_state   => nil,
        :refresh        => nil,
        :delete         => nil,   
      }  
      
      # ---------------------------------------------------------------------------------------------------------------------     
      def register_existing_resources
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_deploy(resource)
        $log.debug("Deploying resource '#{resource.attributes['occi.core.title']}'...")
      end
      
      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_refresh(resource)
        $log.debug("Refreshing resource '#{resource.attributes['occi.core.title']}'...")
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_update_state(resource)
        $log.debug("Updating state of resource '#{resource.attributes['occi.core.title']}'...")
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_delete(resource)
        $log.debug("Deleting resource '#{resource.attributes['occi.core.title']}'...")
      end

      # ---------------------------------------------------------------------------------------------------------------------
      # ACTIONS
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------     
      def action_dummy(compute, parameters)
        $log.debug("Calling method for resource '#{resource.attributes['occi.core.title']}' with parameters: #{parameters.inspect}")
      end

    end

  end
end