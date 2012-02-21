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
# Description: OCCI Mixin to support OpenNebula specific image parameters
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/core/Mixin'
require 'occi/core/Attribute'
require 'occi/core/Attributes'
require 'singleton'

module OCCI
  module Backend
    module ONE
      class Image < OCCI::Core::Mixin

        # Define appropriate mixin
        begin
          # Define actions
          actions = []

          related = []
          entities = []

          term    = "image"
          scheme  = "http://schemas.opennebula.org/occi/infrastructure#"
          title   = "OpenNebula Image Mixin"

          attributes = OCCI::Core::Attributes.new()
          attributes << OCCI::Core::Attribute.new(name = 'opennebula.image.type',       mutable = true, required = false,  type = "string", range = "", default = "")
          attributes << OCCI::Core::Attribute.new(name = 'opennebula.image.public',     mutable = true, required = false,  type = "string", range = "", default = "")
          attributes << OCCI::Core::Attribute.new(name = 'opennebula.image.persistent', mutable = true, required = false,  type = "string", range = "", default = "")
          attributes << OCCI::Core::Attribute.new(name = 'opennebula.image.dev_prefix', mutable = true, required = false,  type = "string", range = "", default = "")
          attributes << OCCI::Core::Attribute.new(name = 'opennebula.image.bus',        mutable = true, required = false,  type = "string", range = "", default = "")
          attributes << OCCI::Core::Attribute.new(name = 'opennebula.image.path',       mutable = true, required = false,  type = "string", range = "", default = "")
          attributes << OCCI::Core::Attribute.new(name = 'opennebula.image.source',     mutable = true, required = false,  type = "string", range = "", default = "")
          attributes << OCCI::Core::Attribute.new(name = 'opennebula.image.fstype',     mutable = true, required = false,  type = "string", range = "", default = "")

          MIXIN = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
        end

        def initialize(term, scheme, title, attributes, actions, related, entities)
          super(term, scheme, title, attributes, actions, related, entities)
        end
        
      end
    end
  end
end