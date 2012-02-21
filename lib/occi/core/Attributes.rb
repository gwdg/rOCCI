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
# Description: storing all Attributes for Kinds
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

module OCCI
  module Core
    class Attributes < Hash

      def <<(attribute)
        store(attribute.name, attribute)
      end

      def check(attributes)
        values.each do |attribute|
          raise "Mandatory attribute #{attribute.name} not provided" if attribute.required && !attributes.has_key?(attribute.name)
        end
      end

      def to_s()
        string = ""
        values.each do
          |attribute|
          string += attribute.to_s + ' '
        end
        return string.strip()
      end

    end
  end
end