##############################################################################
#  Copyright 2012 GWDG
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
# Description: OCCI monitoring VM memory usage
# Author(s): Ali Imran Jehangiri, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'singleton'
require 'occi/core/Mixin'

module OCCI
  module Monitor
    class Memory < OCCI::Core::Mixin

      # Define appropriate mixin
      begin
        # Define actions
        actions = []

        related = [OCCI::Monitor::Metric::MIXIN]
        entities = []

        term    = "memory"
        scheme  = "http://example.com/occi/infrastructure/metric/compute#"
        title   = "compute.memory"

        attributes = OCCI::Core::Attributes.new()
        MIXIN = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
        OCCI::CategoryRegistry.register(MIXIN)
        OCCI::Rendering::HTTP::LocationRegistry.register('/metric/compute/memory', MIXIN)

      end
    end
  end
end