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
# Description: OCCI Core Mixin
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

module OCCI
  module Core

    class Mixin < Category

      attr_accessor :actions
      attr_accessor :related
      attr_accessor :entities

      def initialize(term, scheme, title, attributes, actions, related, entities)
        super(term, scheme, title, attributes)
        @actions  = (actions != nil ? actions : []) 
        @related  = (related != nil ? related : [])
        @entities = (entities != nil ? entities : [])
      end

    end
  end
end
