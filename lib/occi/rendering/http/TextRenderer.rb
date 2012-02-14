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

      class TextRenderer < OCCI::Rendering::AbstractRenderer

        # ---------------------------------------------------------------------------------------------------------------------
        private
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------        
        def is_numeric?(object)
          true if Float(object) rescue false
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def merge_data(data, data_to_add)

          data.merge!(data_to_add) { |data, value_old, value_to_add|
            if !value_old.kind_of? Array
              value_old = [value_old]
            end
            if !value_to_add.kind_of? Array
              value_to_add = [value_to_add]
            end
            value_old + value_to_add
          }
        end

        # ---------------------------------------------------------------------------------------------------------------------        
        public
        # ---------------------------------------------------------------------------------------------------------------------

        CATEGORY        = "Category"
        LINK            = "Link"
        LOCATION        = "Location"
        OCCI_ATTRIBUTE  = "X-OCCI-Attribute"
        OCCI_LOCATION   = "X-OCCI-Location"

        # ---------------------------------------------------------------------------------------------------------------------
        def prepare_renderer()
          # Re-initialize header array
          @data = {}
        end
     
        # ---------------------------------------------------------------------------------------------------------------------
        def render_category_type(categories)

          category_values = []

          # create category string for all categories
          Array(categories).each do |category|

            # category identifier
            category_string = %Q{#{category.term}; scheme="#{category.scheme}"; class="#{category.class_string}";}

            # category title
            category_string += %Q{title="#{category.title}";} if category.title

            # related kinds
            related_value = ""
            category.related.each do |related|
              related_value += related.type_identifier
            end if defined? category.related
            category_string += %Q{rel="#{related_value.strip}";} if related_value != ""

            # category location
            location = OCCI::Rendering::HTTP::LocationRegistry.get_absolute_location_of_object(category)
            category_string += %Q{location=#{location.strip};} if defined? location.strip

            # attributes
            attributes = ""
            category.attributes.keys.each do |attribute|
              attributes += "#{attribute} "
            end if defined? category.attributes
            category_string += %Q{attributes="#{attributes.strip}";} if attributes != ""

            # actions
            actions = ""
            category.actions.each do |action|
              actions += action.category.scheme + action.category.term + " "
            end if defined? category.actions

            category_string += %Q{actions="#{actions.strip}";} if actions != ""
            category_values << category_string
          end
 
          merge_data(@data, { CATEGORY => category_values }) 
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_category_short(categories)
          
          category_values = []

          # create category string for all categories
          Array(categories).each do |category|
            # category identifier
            category_string = %Q{#{category.term}; scheme="#{category.scheme}"; class="#{category.class_string}";}
            category_values << category_string
          end
 
          merge_data(@data, { CATEGORY => category_values })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # render single location if a new resource has been created (e.g. use Location instead of X-OCCI-Location)
        def render_location(location)
          merge_data(@data, { LOCATION => location })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_link_reference(link)

          # Link value
          location        = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(link)
          target_location = link.attributes["occi.core.target"]
          target_resource = OCCI::Rendering::HTTP::LocationRegistry.get_object_by_location(target_location)
          if target_resource.nil?
            target_resource_type = OCCI::Core::Link::KIND.type_identifier
          else
            target_resource_type = target_resource.kind.type_identifier
          end
          category = link.kind.type_identifier
          attributes = link.attributes.map { |key,value| %Q{#{key}="#{value}"} unless value.empty? }.join(';').to_s
          attributes << ";" unless attributes.empty?

          link_string = %Q{<#{target_location}>;rel="#{target_resource_type}";self="#{location}";category="#{category}";#{attributes}}
 
          merge_data(@data, { LINK => link_string })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_action_reference(action, resource)

          resource_location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(resource)
          action_location   = resource_location + "?action=" + action.category.term
          action_type       = action.category.type_identifier

          link_value = %Q{<#{action_location}>;rel="#{action_type}"}

          merge_data(@data, { LINK => link_value })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_attributes(attributes)

          return if attributes == nil || attributes.empty?

          attributes_values = []
          attributes.each do |name, value|
            # Render strings with quotes, numerics without
            if is_numeric?(value)
              attributes_values << %Q{#{name}=#{value}}
            else
              attributes_values << %Q{#{name}="#{value}"}
            end
          end

          merge_data(@data, { OCCI_ATTRIBUTE => attributes_values })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_locations(locations)

          locations_values = []
          locations.each do |location|
            locations_values << $config["server"].chomp('/') + ':' + $config["port"] + location unless location.nil?
          end
 
          merge_data(@data, { OCCI_LOCATION => locations_values })
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
           
          if response['Content-Type'].include?('text/plain')
            render_text_plain_response(response)

          elsif response['Content-Type'].include?('text/uri-list')
            render_text_uri_list_response(response)

          elsif response['Content-Type'].include?('text/occi')
            render_text_occi_response(response)
          end
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def render_text_plain_response(response)

#          response[LOCATION]        = @data[LOCATION] if @data.has_key?(LOCATION)
#          response[LINK]            = @data[LINK]     if @data.has_key?(LINK)

          # FIXME: check if "Location: " has to be prepended          
          response.write('Location : ' + @data[LOCATION]) if @data.has_key?(LOCATION)

          if @data.has_key?(CATEGORY)
            @data[CATEGORY].each do |category|
              response.write(CATEGORY + ': ' + category.to_s + "\n")
            end
          end

          if @data.has_key?(LINK)
            response.write('Link: ' + @data[LINK].join(',') + "\n")
          end

          if @data.has_key?(OCCI_ATTRIBUTE)
            @data[OCCI_ATTRIBUTE].each do |attribute|
              response.write('X-OCCI-Attribute: ' + attribute.to_s + "\n")
            end
          end

          if @data.has_key?(OCCI_LOCATION)
            response.write(@data[OCCI_LOCATION].collect {|location| 'X-OCCI-Location: ' + location}.join("\n"))
          end
       
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def render_text_occi_response(response)

          response[LOCATION]          = @data[LOCATION]                   if @data.has_key?(LOCATION)
          response[CATEGORY]          = @data[CATEGORY].join(',')         if @data.has_key?(CATEGORY)
          response[LINK]              = @data[LINK]                       if @data.has_key?(LINK)
          response['X-OCCI-Attribute']= @data[OCCI_ATTRIBUTE].join(',')   if @data.has_key?(OCCI_ATTRIBUTE)
          response['X-OCCI-Location'] = @data[OCCI_LOCATION].join(', ')   if @data.has_key?(OCCI_LOCATION)
 
          response.write('OK') 
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def render_text_uri_list_response(response)

          if @data.has_key?(OCCI_LOCATION)
            response.write(@data[OCCI_LOCATION].collect {|location| location}.join("\n"))
          end
        end

      end
      
    end
  end
end
