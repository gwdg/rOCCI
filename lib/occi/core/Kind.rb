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
# Description: OCCI Core Kind
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'json'
require 'occi/core/Category'

module OCCI
  module Core
    class Kind < Category

      attr_accessor :entity_type
      attr_accessor :related
      attr_accessor :entities
      attr_accessor :actions
      
      def initialize(actions, related, entity_type, entities, term, scheme, title, attributes)
        super(term, scheme, title, attributes)
        @actions      = (actions != nil ? actions : []) 
        @related      = (related != nil ? related : [])
        @entities     = (entities != nil ? entities : [])
        @entity_type  = entity_type
      end
      
      def to_json(options={})
        hash = {}
        actions = @actions.collect {|action| action.category.type_identifier }
        hash['actions'] = actions.join(',') unless actions.empty?
        rel = @related.collect {|related| related.type_identifier}
        hash['related'] = rel.join(',') unless rel.empty?
        super['Category'].merge!(hash)
      end
      
      def class_string
        return 'kind'
      end
      
    end
  end
end
