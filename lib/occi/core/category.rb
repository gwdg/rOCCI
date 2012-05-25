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

require 'json'
require 'hashie/mash'

module OCCI
  module Core
    class Category < Hashie::Mash

      def initialize(category=nil, default = nil)
        category.attributes = OCCI::Core::AttributeProperties.new(category.attributes) if category
        super(category, default)
      end

      def convert_value(val, duping=false) #:nodoc:
        case val
          when self.class
            val.dup
          when ::Hash
            val = val.dup if duping
            self.class.subkey_class.new.merge(val) unless val.kind_of?(Hashie::Mash)
            val
          when Array
            val.collect { |e| convert_value(e) }
          else
            val
        end
      end

      def type_identifier
        regular_reader("scheme") + regular_reader("term")
      end

      def related_to?(category_id)
        self.related.each do |category|
          return true if category.type_identifier == category_id || category.related_to?(category_id)
        end if self.related
        false
      end

    end
  end
end