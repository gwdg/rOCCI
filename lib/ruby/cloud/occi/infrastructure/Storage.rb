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
#require 'OCCI/Core/Resource'

module OCCI
  module Infrastructure
    class Storage < OCCI::Core::Resource

      # Define appropriate kind
      begin
          # Define actions
          actions = []
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "backup",    title = "Storage Action Backup",    attributes = [])
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "offline",   title = "Storage Action Offline",   attributes = [])
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "online",    title = "Storage Action Online",    attributes = [])
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "resize",    title = "Storage Action Resize",    attributes = ["size"])
          actions << OCCI::Core::Action.new(scheme = "http://schemas.ogf.org/occi/infrastructure/storage/action#", term = "snapshot",  title = "Storage Action Snapshot",  attributes = [])

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

      def initialize(attributes)
        super(attributes)
        @kind_type = "http://schemas.ogf.org/occi/infrastructure#storage"
      end
      
      def deploy()
        $backend.create_storage_Instance(self)
      end
      
      def delete()
        $backend.delete_storage_instance(self)
        delete_entity()
      end

    end
  end
end