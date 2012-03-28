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
# Description: OCCI Rendering
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/rendering/AbstractRenderer'
require 'occi/rendering/http/TextRenderer'
require 'occi/rendering/http/JSONRenderer'

require 'occi/Log'

module OCCI
  module Rendering

    # ---------------------------------------------------------------------------------------------------------------------
    class Renderer

      # ---------------------------------------------------------------------------------------------------------------------
      # Prepare current rendering pass
      def self.prepare(content_type)
        @@request_content_type = content_type
        OCCI::Log.error("No renderer registered for content type '%{content_type}'") unless @@renderers.has_key?(content_type)
        @@renderers[@@request_content_type].send(:prepare_renderer)
      end
  
      # ---------------------------------------------------------------------------------------------------------------------
      def self.register(content_type, renderer_instanz)
        @@renderers[content_type] = renderer_instanz
      end
  
      # ---------------------------------------------------------------------------------------------------------------------
      # TODO: implement mission methods stuff redirection -> content
      def method_missing(method, *args, &block)
        if AbstractRenderer.method_defined?(method)
          @@renderers[@@request_content_type].send(method, *args, &block)
        else
          super
        end
      end
  
      # ---------------------------------------------------------------------------------------------------------------------
      private
      # ---------------------------------------------------------------------------------------------------------------------
  
      # The content type for the curret request
      @@request_content_type = ""
  
      # Content-type -> renderer instance 
      @@renderers = {}

      # ---------------------------------------------------------------------------------------------------------------------
      # Register available renderer
      text_renderer = OCCI::Rendering::HTTP::TextRenderer.new
      self.register("text/occi",         text_renderer)
      self.register("text/plain",        text_renderer)
      self.register("text/uri-list",     text_renderer)

      json_renderer = OCCI::Rendering::HTTP::JSONRenderer.new
      self.register("application/json",      json_renderer)
      self.register("application/occi+json", json_renderer)

    end

  end
end
