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

##############################################################################
# HTTP Status Codes

HTTP_STATUS_CODE = {"OK" => 200,
  "Resource Created" =>201,
  "Accepted" => 202,
  "Bad Request" => 400,
  "Unauthorized" => 401,
  "Forbidden" =>403,
  "Not Found" =>404,
  "Method Not Allowed" => 405,
  "Conflict" => 409,
  "Gone" => 410,
  "Unsupported Media Type" => 415,
  "Internal Server Error" => 500,
  "Not Implemented" => 501,
  "Service Unavailable" => 503}

module OCCI
  module Rendering
    module HTTP
      module Renderer

        CATEGORY        = "Category"
        LINK            = "Link"
        LOCATION        = "Location"
        OCCI_ATTRIBUTE  = "X-OCCI-Attribute"
        OCCI_LOCATION   = "X-OCCI-Location"

        # ---------------------------------------------------------------------------------------------------------------------        
        def self.is_numeric?(object)
          true if Float(object) rescue false
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_category_type(categories, data)

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
 
          merge_data(data, { CATEGORY => category_values }) 
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_category_short(categories, data)
          
          category_values = []

          # create category string for all categories
          Array(categories).each do |category|
            # category identifier
            category_string = %Q{#{category.term}; scheme="#{category.scheme}"; class="#{category.class_string}";}
            category_values << category_string
          end
 
          merge_data(data, { CATEGORY => category_values })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # render single location if a new resource has been created (e.g. use Location instead of X-OCCI-Location)
        def self.render_location(location, data)
          merge_data(data, { LOCATION => location })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_link_reference(link, data)

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
 
          merge_data(data, { LINK => link_string })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_action_reference(action, resource, data)

          resource_location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(resource)
          action_location   = resource_location + "?action=" + action.category.term
          action_type       = action.category.type_identifier

          link_value = %Q{<#{action_location}>;rel="#{action_type}"}

          merge_data(data, { LINK => link_value })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_attributes(attributes, data)

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

          merge_data(data, { OCCI_ATTRIBUTE => attributes_values })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_locations(locations, data)

          locations_values = []
          locations.each do |location|
            locations_values << $config["server"].chomp('/') + ':' + $config["port"] + location unless location.nil?
          end
 
          merge_data(data, { OCCI_LOCATION => locations_values })
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.merge_data(data, data_to_add)

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
        def self.render_entity(entity, data)

          # render kind of entity
          render_category_short(entity.kind, data)

          # render mixins of entity
          entity.mixins.each do |mixin|
            render_category_type(mixin, data)
          end

          # Render attributes
          render_attributes(entity.attributes, data)

          # Render link references
          entity.links.each do |link|
            render_link_reference(link, data)
          end if entity.kind_of?(OCCI::Core::Resource)

          # Render action references
          # TODO: only render currently applicable actions
          entity.kind.actions.each do |action|
            render_action_reference(action, entity, data)
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # rendering general parameters
        # responeAttributes: Hash object
        # respone: response object of Sinatra
        # return: text/plain and text/uri: response.body
        # return: text/occi: response[key] head

        def self.prepare_response(response, request)

          $log.info("#################### Information on the client ####################")
          $log.info("Client IP Adress: #{request.env['REMOTE_ADDR']}")
          $log.info("Client User Agent: #{request.env['HTTP_USER_AGENT']}")
          $log.info("###################################################################")

          # determine content type from request content type or reques accept, fallback to text/plain
          content_type = ""
          content_type = request.env['CONTENT_TYPE']  if request.env['CONTENT_TYPE']
          content_type = request.env['HTTP_ACCEPT']   if request.env['HTTP_ACCEPT']
 
          if content_type.include?('application/json')
            response['Content-Type'] = 'application/json'
            
          elsif content_type.include?('text/plain') || content_type.include?('text/*') || content_type.include?('*/*') || content_type == ""
            response['Content-Type'] = 'text/plain'

          elsif content_type.include?('text/uri-list')
            response['Content-Type'] = 'text/uri-list'

          elsif content_type.include?('text/occi')
            response['Content-Type'] = 'text/occi'

          else
            response.status = HTTP_STATUS_CODE["Unsupported Media Type"]
            raise "Unsupported Media Type"
          end

          response['Accept'] = "application/json,text/plain,text/occi"
          response['Server'] = "Ruby OCCI Framework/0.4 OCCI/1.1"

          $log.debug("Content type: #{response['Content-Type']}")
          $log.debug("Accept type: #{response['Accept']}")

          # content type independend parameters
          $log.debug("Server: #{response['Server']}")

          # Set default status
          response.status = HTTP_STATUS_CODE["OK"]

#          return response
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_response(response, data)

          # Don't put any data in the response if there was an error
          return if response.status != HTTP_STATUS_CODE["OK"]

          if response['Content-Type'].include?('application/json')
            render_application_json_response(response, data)
            
          elsif response['Content-Type'].include?('text/plain')
            render_text_plain_response(response, data)

          elsif response['Content-Type'].include?('text/uri-list')
            render_text_uri_list_response(response, data)

          elsif response['Content-Type'].include?('text/occi')
            render_text_occi_response(response, data)
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_application_json_response(response, data)

#          response[LOCATION]        = data[LOCATION] if data.has_key?(LOCATION)
#          response[LINK]            = data[LINK]     if data.has_key?(LINK)

          if data.has_key?(LOCATION)
            response.write(JSON.pretty_generate({'Location' => data[LOCATION]}))  
          end

          if data.has_key?(CATEGORY)
            collection = {'Collection' => data[CATEGORY].collect! {|category| category.to_hash}}
            response.write(JSON.pretty_generate(collection))
          end
          
          if data.has_key?(LINK)
            # TODO: implement JSON rendering
            # response.write(JSON.pretty_generate({'Link' => location}))
          end

          if data.has_key?(OCCI_ATTRIBUTE)
            # TODO: implement JSON rendering
          end

          if data.has_key?(OCCI_LOCATION)
            response.write(JSON.pretty_generate(data[OCCI_LOCATION].collect {|location| {'X-OCCI-Location: ' => location} } ) )
          end

        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_text_plain_response(response, data)

#          response[LOCATION]        = data[LOCATION] if data.has_key?(LOCATION)
#          response[LINK]            = data[LINK]     if data.has_key?(LINK)
          
          response.write('Location : ' + data[LOCATION]) if data.has_key?(LOCATION)

          if data.has_key?(CATEGORY)
            data[CATEGORY].each do |category|
              response.write(CATEGORY + ': ' + category + "\n")
            end
          end

          if data.has_key?(LINK)
            response.write('Link: ' + link_string + "\n")
          end

          if data.has_key?(OCCI_ATTRIBUTE)
            attributes_values.each do |attribute|
              response.write('X-OCCI-Attribute: ' + attribute + "\n")
            end
          end

          if data.has_key?(OCCI_LOCATION)
            response.write(data[OCCI_LOCATION].collect {|location| 'X-OCCI-Location: ' + location}.join("\n"))
          end
       
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_text_occi_response(response, data)

          response[LOCATION]          = data[LOCATION]                  if data.has_key?(LOCATION)
          response[CATEGORY]   = data[CATEGORY].join(',')               if data.has_key?(CATEGORY)
          response[LINK]              = data[LINK]                      if data.has_key?(LINK)
          response['X-OCCI-Attribute']= data[OCCI_ATTRIBUTE].join(',')  if data.has_key?(OCCI_ATTRIBUTE)
          response['X-OCCI-Location'] = data[OCCI_LOCATION].join(', ')  if data.has_key?(OCCI_LOCATION)
 
          response.write('OK') 
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_text_uri_list_response(response, data)

          if data.has_key?(OCCI_LOCATION)
            response.write(data[OCCI_LOCATION].collect {|location| location}.join("\n"))
          end

        end

      end
    end
  end
end