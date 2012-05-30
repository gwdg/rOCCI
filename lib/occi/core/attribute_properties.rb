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
# Description: storing a single Attribute
# Author(s): Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'hashie/mash'

module OCCI
  module Core
    class AttributeProperties < Hashie::Mash

      def initialize(attributes = nil, default = nil)
        if attributes[:type] || attributes.required || attributes.mutable || attributes.pattern || attributes.minimum || attributes.maximum || attributes.description
          attributes[:type] ||= "string"
          attributes.required ||= false
          attributes.mutable ||= false
          attributes.pattern ||= ".*"
        end unless attributes.nil?
        super(attributes, default)
      end

      def combine
        array = []
        self.each_key do |key|
          puts key
          puts self[key]
          if self[key].include? 'type'
            array << key + "{}"
          else
            self[key].combine.each { |attr| array << key + '.' + attr }
          end
        end
        return array
      end

    end
  end
end
