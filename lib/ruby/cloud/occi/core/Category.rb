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
# Description: OCCI Core Category
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/core/Attributes'

module OCCI
  module Core
    class Category

      module Related
        def self.get_all_related(categories)
          related     = []
          to_process  = categories.clone
          while !to_process.empty? do
            element = to_process.shift
            related << element unless related.include?(element)
            to_process.concat(element.related)
          end
          return related
        end
      end

      attr_reader   :scheme
      attr_reader   :term
      attr_reader   :title
      attr_reader   :attributes
      
      def initialize(term, scheme, title, attributes)
        @term   = term
        @scheme = scheme
        @title  = title
        @attributes = (attributes != nil ? attributes : OCCI::Core::Attributes.new())
      end
      
      def get_location()
        location = '/' + @term + '/'
      end
      
      def id
        return @scheme + @term
      end
      
    end
  end
end