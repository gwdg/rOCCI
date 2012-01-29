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
# Description: OpenNebula Backend
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'rubygems'
require 'uuidtools'
require 'OpenNebula/OpenNebula'
require 'occi/CategoryRegistry'
require 'occi/rendering/http/LocationRegistry'
require 'occi/ActionDelegator'

# OpenNebula backend
require 'occi/backend/opennebula/Compute'
require 'occi/backend/opennebula/Network'
require 'occi/backend/opennebula/Storage'

# OpenNebula backend based mixins
require 'occi/extensions/one/Image'
require 'occi/extensions/one/Network'
require 'occi/extensions/one/VirtualMachine'
require 'occi/extensions/one/VNC'

require 'occi/extensions/Reservation'

include OpenNebula

module OCCI
  module Backend

    # ---------------------------------------------------------------------------------------------------------------------
    RESOURCE_DEPLOY         = :deploy
    RESOURCE_UPDATE_STATE   = :update_state
    RESOURCE_REFRESH        = :refresh
    RESOURCE_DELETE         = :delete

#    ACTION_START            = :start
#    ACTION_STOP             = :stop
#    ACTION_RESTART          = :restart
#    ACTION_SUSPEND          = :suspend

    # ---------------------------------------------------------------------------------------------------------------------
    class OpenNebula
      
      include Compute
      include Network
      include Storage
      
      # The ACL level to be used when querying resource in OpenNebula:
      # - INFO_ALL returns all resources and works only when running under the oneadmin account
      # - INFO_GROUP returns the resources of the account + his group (= default)
      # - INFO_MINE returns only the resources of the account
      INFO_ACL = OpenNebula::Pool::INFO_GROUP
 
      # Operation mappings
       
      OPERATIONS = {}
      
      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#compute"] = {
        
        # Generic resource operations
        :deploy         => :compute_deploy,
        :update_state   => :compute_update_state,
        :refresh        => :compute_refresh,
        :delete         => :compute_delete,
        
        # Compute specific resource operations
        :start          => :compute_start,
        :stop           => :compute_stop,
        :restart        => :compute_restart,
        :suspend        => :compute_suspend        
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#network"] = {
        
        # Generic resource operations
        :deploy         => :network_deploy,
        :update_state   => :network_update_state,
        :refresh        => :network_refresh,
        :delete         => :network_delete,
        
        # Network specific resource operations
        :up             => :network_up,
        :down           => :network_down
      }

      OPERATIONS["http://schemas.ogf.org/occi/infrastructure#storage"] = {

        # Generic resource operations
        :deploy         => :storage_deploy,
        :update_state   => :storage_update_state,
        :refresh        => :storage_refresh,
        :delete         => :storage_delete,
   
        # Network specific resource operations
        :online         => :storage_online,
        :offline        => :storage_offline,
        :backup         => :storage_backup,
        :snapshot       => :storage_snapshot,
        :resize         => :storage_resize
      }

      OPERATIONS["http://schemas.ogf.org/gwdg#nfsstorage"] = {

        # Generic resource operations
        :deploy         => nil,
        :update_state   => nil,
        :refresh        => nil,
        :delete         => nil,   
      }

      # ---------------------------------------------------------------------------------------------------------------------       
      # Register backend specific mixins
      begin
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::Image::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::Network::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Backend::ONE::VirtualMachine::MIXIN)
        OCCI::CategoryRegistry.register(OCCI::Mixins::Reservation::MIXIN)
      end

      # ---------------------------------------------------------------------------------------------------------------------       
      private
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------      
      def check_rc(rc)
        if rc.class == Error
          raise OCCI::BackendError, "Error message from OpenNebula: #{rc.to_str}"
          # TODO: return failed!
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------
      # Generate a new occi id for resources created directly in OpenNebula using a seed id and the kind identifier
      def self.generate_occi_id(kind, seed_id)
        # Use strings as kind ids
        kind = kind.type_identifier if kind.kind_of?(OCCI::Core::Kind)
        return UUIDTools::UUID.sha1_create(UUIDTools::UUID_DNS_NAMESPACE, "#{kind}:#{seed_id}").to_s
      end

      # ---------------------------------------------------------------------------------------------------------------------
      public
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------     
      def initialize(user, password)

        # TODO: create mixins from existing templates

        # initialize OpenNebula connection
        $log.debug("Initializing connection with OpenNebula")

        # TODO: check for error!
 #       @one_client = Client.new($config['one_user'] + ':' + $config['one_password'], $config['one_xmlrpc'])
        @one_client = Client.new(user + ':' + password, $config['one_xmlrpc'])
 
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def register_existing_resources
        # get all compute objects
        resource_template_register()
        os_template_register()
        compute_register_all_instances()
        network_register_all_instances()
        storage_register_all_instances()
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def resource_template_register
        backend_object_pool=TemplatePool.new(@one_client, INFO_ACL)
        backend_object_pool.info
        backend_object_pool.each do |backend_object|
          actions = []
          related = [ OCCI::Infrastructure::ResourceTemplate::MIXIN ]
          entities = []
          term    = backend_object['NAME'].downcase.chomp.gsub(/\W/,'_')
          scheme  = "http://schemas.ogf.org/occi/infrastructure#"
          title   = backend_object['NAME']
          attributes = OCCI::Core::Attributes.new()
          mixin = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
          mixin.backend[:id] = backend_object.id
          OCCI::CategoryRegistry.register(mixin)
        end
      end

      # ---------------------------------------------------------------------------------------------------------------------     
      def os_template_register
        # TODO: implement
      end

    end

    # ---------------------------------------------------------------------------------------------------------------------
    class Manager
              
      private
      
      @@backends_classes    = {}
      @@backends_operations = {}
      
      public
   
   
      # ---------------------------------------------------------------------------------------------------------------------
      def self.register_backend(backend_class, operations)
        
        # Get ident of backend = class name downcased
#        backend_ident = Object.const_get(backend_class).name.downcase

        backend_ident = backend_class.name.downcase

        @@backends_classes[backend_ident]     = backend_class
        @@backends_operations[backend_ident]  = operations
      end

      # ---------------------------------------------------------------------------------------------------------------------
      def self.signal_resource(backend, operation, resource, operation_parameters = nil)

        resource_type = resource.kind.type_identifier
        backend_ident = backend.class.name.downcase
        
        raise OCCI::BackendError, "Unknown backend: '#{backend_ident}'"                                             unless @@backends_classes.has_key?(backend_ident)
        
        operations = @@backends_operations[backend_ident]
        
        raise OCCI::BackendError, "Resource type '#{resource_type}' not supported!"                                 unless operations.has_key?(resource_type)
        raise OCCI::BackendError, "Operation '#{operation}' not supported on resource category '#{resource_type}'!" unless operations[resource_type].has_key?(operation)
        
        # Delegate
        
        if operations[resource_type][operation].nil?
          $log.debug("No backend method configured => doing nothing...")
          return
        end
        
        if operation_parameters.nil?
          # Generic resource operation
          backend.send(operations[resource_type][operation], resource)
        else
          # Action related operation, we need to pass on the action parameters
          backend.send(operations[resource_type][operation], resource, operation_parameters)
        end

      end

      # ---------------------------------------------------------------------------------------------------------------------
      def self.delegate_action(backend, action, parameters, resource)
  
        $log.debug("Delegating invocation of action [#{action}] on resource [#{resource}] with parameters [#{parameters}] to backend...")
  
        # Verify
        state_machine = resource.state_machine
        raise "Action [#{action}] not valid for current state [#{state_machine.current_state}] of resource [#{resource}]!" if !state_machine.check_transition(action)
        
        # Use action term as ident
        operation = action.term.to_s

        begin
          # TODO: define some convention for result handling!
          signal_resource(backend, operation, resource, parameters)

          state_machine.transition(action)
          signal_resource(backend, OCCI::Backend::RESOURCE_UPDATE_STATE)

        rescue OCCI::BackendError
          $log.error("Action invocation failed!")
          raise
        end   
      end

      # Register available backends
      register_backend(OCCI::Backend::OpenNebula,   OCCI::Backend::OpenNebula::OPERATIONS)

    end
        
  end
end
