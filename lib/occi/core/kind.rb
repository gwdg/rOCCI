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
require 'occi/core/category'
require 'occi/core/action'
require 'occi/core/attribute_properties'

module OCCI
  module Core
    class Kind < OCCI::Core::Category

      attr_accessor :entities

      def initialize(kind, default = nil)
        @entities = []
        super(kind, default)
      end

      def entity_type
        case type_identifier
          when "http://schemas.ogf.org/occi/core#resource"
            return OCCI::Core::Resource.name
          when "http://schemas.ogf.org/occi/core#link"
            return OCCI::Core::Link.name
          else
            OCCI::Registry.get_by_id(self[:related].first).entity_type unless self[:term] == 'entity'
        end
      end

      def location
        '/' + self[:term] + '/'
      end

    end
  end
end
