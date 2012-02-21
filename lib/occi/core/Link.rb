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
# Description: OCCI Core Link
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/rendering/http/LocationRegistry'
require 'occi/core/Kind'

module OCCI
  module Core
    class Link < Entity
      
      # Define appropriate kind
      begin
        actions     = []
        related     = [OCCI::Core::Entity::KIND]
        entity_type = self
        entities    = []

        term    = "link"
        scheme  = "http://schemas.ogf.org/occi/core#"
        title   = "Link"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.core.source', mutable = true, required = true,  type = "string", range = "", default = "")
        attributes << OCCI::Core::Attribute.new(name = 'occi.core.target', mutable = true, required = true,  type = "string", range = "", default = "")
          
        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
        
        # register in category and location registry
        OCCI::CategoryRegistry.register(KIND)
        OCCI::Rendering::HTTP::LocationRegistry.register('/link/', KIND)
      end
      
      def initialize(attributes, mixins = [], kind = OCCI::Core::Link::KIND)
        super(attributes, mixins, kind)
      end
      
    end
  end
end