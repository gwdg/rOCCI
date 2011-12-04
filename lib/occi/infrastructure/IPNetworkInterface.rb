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
# Description: OCCI Infrastructure IPNetworking Mixin
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/CategoryRegistry'
require 'occi/core/Mixin'

module OCCI
  module Infrastructure
    class IPNetworkInterface < OCCI::Core::Mixin
      include Singleton
      # Define appropriate mixin
      begin
        # Define actions
        actions = []

        related = []
        entities = []

        term    = "ipnetworkinterface"
        scheme  = "http://schemas.ogf.org/occi/infrastructure/networkinterface#"
        title   = "IP Networkinterface Mixin"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.address',    mutable = true, mandatory = false,   unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.gateway',    mutable = true, mandatory = false,  unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.networkinterface.allocation', mutable = true, mandatory = false,   unique = true)
          
        MIXIN = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
        
        OCCI::CategoryRegistry.register(MIXIN)
      end
    end
  end
end