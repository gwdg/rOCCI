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
# Description: OCCI Infrastructure IPNet6 Mixin
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/core/Mixin'
require 'singleton'

module OCCI
  module Infrastructure
    class Ipnet6 < OCCI::Core::Mixin

      # Define appropriate mixin
      begin
          # Define actions
          actions = []

          related = []
          entities = []

          term    = "ipnet6"
          scheme  = "http://schemas.ogf.org/occi/infrastructure/network#"
          title   = "Ipnet6 Mixin"

          attributes = OCCI::Core::Attributes.new()
          attributes << OCCI::Core::Attribute.new(name = 'occi.network.subnet', mutable = true, mandatory = true, unique = true)
          
          MIXIN = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
      end

      def initialize(term, scheme, title, attributes, actions, related, entities)
        super(term, scheme, title, attributes, actions, related, entities)
      end
    end
  end
end