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
# Description: OCCI HTTP Rendering
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'json'
require 'occi/core/Action'
require 'occi/core/Kind'
require 'occi/core/Mixin'

require 'occi/rendering/http/LocationRegistry'
require 'occi/rendering/AbstractRenderer'

module OCCI
  module Rendering
    module HTTP

      class JSONRenderer < OCCI::Rendering::AbstractRenderer

        # ---------------------------------------------------------------------------------------------------------------------
        private
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------
        def is_numeric?(object)
          true if Float(object) rescue false
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def attribute_to_hash(attribute)
          
          hash = {}
          hash['mutable']   = attribute.mutable
          hash['required']  = attribute.mandatory
          hash['unique']    = attribute.unique
          hash['type']      = attribute.type
          hash['default']   = attribute.default
          hash['min']       = attribute.min
          hash['max']       = attribute.max

          return hash
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def attributes_to_hash(attributes)
          
          hash = {}
          attributes.each do |key, value|
            hash[key] = value.to_hash
          end
          return hash
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def category_to_hash(category)                  

          hash = {}
          hash['term']       = category.term
          hash['scheme']     = category.scheme
          hash['title']      = category.title
          hash['attributes'] = category.attributes.to_hash unless category.attributes.to_hash.empty?
          hash['location']   = category.location
          
          return {'Category' => hash}
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def mixin_to_hash(mixin)

          hash = {}
          actions = mixin.actions.collect {|action|   action.category.type_identifier }
          related = mixin.related.collect {|related|  related.type_identifier}

          hash['actions'] = actions.join(',') unless actions.empty?
          hash['related'] = related.join(',') unless related.empty?

          return category_to_hash(mixin)['Category'].merge!(hash)
        end

        # ---------------------------------------------------------------------------------------------------------------------        
        public
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------
        def prepare_renderer()
          # Re-initialize header array
          @data = {}
        end
     
        # ---------------------------------------------------------------------------------------------------------------------
        def render_category_type(categories)

          categories = Array(categories)
          collection = []

          categories.each do |category|

            if category.kind_of?(OCCI::Core::Category) 
              collection << category_to_hash(category)
              next
            end

            if category.kind_of?(OCCI::Core::Mixin) or category.kind_of?(OCCI::Core::Kind)
              collection << mixin_to_hash(category) 
              next
            end
            
            $log.error("Unregonized category type for category: " + category.inspect)
          end

#          collection.reject! { |x| x == nil }

          @data.merge!({ "Category" => {'Collection' => collection} })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_category_short(categories)
          render_category_type(categories)          
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # render single location if a new resource has been created (e.g. use Location instead of X-OCCI-Location)
        def render_location(location)
          @data.merge!({ "Location" => location })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_link_reference(link)
          # TODO
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_action_reference(action, resource)
          # TODO
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_attributes(attributes)

          return if attributes == nil || attributes.empty?

          # TODO
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_locations(locations)

          locations = Array(locations)
          collection = locations.collect do |location|
            {'X-OCCI-Location: ' => $config["server"].chomp('/') + ':' + $config["port"] + location}
          end
 
          @data.merge!({ "Locations" => { "Collection" => collection} })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_entity(entity)

          # render kind of entity
          render_category_short(entity.kind)

          # render mixins of entity
          entity.mixins.each do |mixin|
            render_category_type(mixin)
          end

          # Render attributes
          render_attributes(entity.attributes)

          # Render link references
          entity.links.each do |link|
            render_link_reference(link)
          end if entity.kind_of?(OCCI::Core::Resource)

          # Render action references
          # TODO: only render currently applicable actions
          entity.kind.actions.each do |action|
            render_action_reference(action, entity)
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def data()
          return @data
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_response(response)

          # Don't put any data in the response if there was an error
          return if response.status != OCCI::Rendering::HTTP::HTTP_OK

          response.write(JSON.pretty_generate(@data))
        end        
  
      end
      
    end
  end
end