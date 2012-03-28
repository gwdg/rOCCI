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

module OCCI
  module Rendering

    # ---------------------------------------------------------------------------------------------------------------------
    class AbstractRenderer

      def prepare()
      end

      def render_category_type(categories)
        raise NotImplementedError, "Method 'render_category_type' not implemented!"
      end

      def render_category_short(categories)
        raise NotImplementedError, "Method 'render_category_short' not implemented!"
      end
      
      def render_location(location)
        raise NotImplementedError, "Method 'render_location' not implemented!"
      end
      
      def render_link_reference(link)        
        raise NotImplementedError, "Method 'render_link_reference' not implemented!"
      end
      
      def render_action_reference(action, resource)
        raise NotImplementedError, "Method 'render_action_reference' not implemented!"
      end
      
      def render_attributes(attributes)
        raise NotImplementedError, "Method 'render_attributes' not implemented!"
      end
      
      def render_locations(locations)
        raise NotImplementedError, "Method 'render_locations' not implemented!"
      end

      def render_entity(entity)
        raise NotImplementedError, "Method 'render_entity' not implemented!"
      end
      
      def data()
        raise NotImplementedError, "Method 'data' not implemented!"        
      end
      
      def render(response)
        raise NotImplementedError, "Method 'render_response' not implemented!"
      end

    end

  end
end