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
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

module OCCI
  module Core
    class Attribute
      
      attr_reader :name
      attr_reader :mutable
      attr_reader :required
      attr_reader :type
      attr_reader :range
      attr_reader :default
      
      def initialize(name, mutable, required, type = String, range = "", default = "")
        @name       = name
        @mutable    = mutable
        @required   = required
        @type       = type
        @range      = range
        @default    = default
      end

      def to_s
        @name
      end
      
    end
  end
end