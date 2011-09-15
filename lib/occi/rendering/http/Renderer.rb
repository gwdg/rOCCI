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
  "Method Not Allowed" => 405,
  "Conflict" => 409,
  "Gone" => 410,
  "Unsupported Media Type" => 415,
  "Internal Server Error" => 500,
  "Not Implemented" => 501,
  "Service Unavailable" => 503}
  
HEADER_CATEGORY   = "Category"
HEADER_LINK       = "Link"
HEADER_ATTRIBUTE  = "X-OCCI-Attribute"
HEADER_LOCATION   = "X-OCCI-Location"

module OCCI
  module Rendering
    module HTTP
      module Renderer

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_category_type(response,occi_request)
          
          # create category string for all categories
          categories = []
          occi_request.categories.each do |category|
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
            categories << category_string
          end
          # response[HEADER_CATEGORY] = categories.join(',')

          case response['Content-Type']
          when 'application/json'
            # dump categories as JSON string into response body
            collection = {'Collection' => occi_request.categories.collect! {|category| category.to_hash}}
            response.write(JSON.pretty_generate(collection))     
          when 'text/plain'
            categories.each do |category|
              response.write(HEADER_CATEGORY + ': ' + category + "\n")
            end
          when 'text/occi'
            # for text/occi the body needs to contain OK
            response.write = "OK"
          # when 'text/uri-list'
          end

          response.status = HTTP_STATUS_CODE["OK"]

          return response
        end
        
        def self.render_location(response, location)
          
          response['Location'] = location
          case response['Content-Type']
          when 'application/json'
            # dump categories as JSON string into response body
            location = {'Location' => location}
            response.write(JSON.pretty_generate(location))     
          when 'text/plain'
            response.write('Location: ' + location)
          when 'text/occi'
            # for text/occi the body needs to contain OK
            response.write = "OK"
          # when 'text/uri-list'
          end

          response.status = HTTP_STATUS_CODE["OK"]

          return response
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_link_reference(link)

          # Link value
          location        = $locationRegistry.get_location_of_object(link)
          target_location = link.attributes["occi.core.target"]
          target_resource = $locationRegistry.get_object_by_location(target_location)
          target_resource_type = target_resource.kind.scheme + target_resource.kind.term

          link_value = %Q{<#{target_location}>;rel="#{target_resource_type}";self="#{location}"}

          # Link params
          category = link.kind
          link_params = %Q{;category="#{category.scheme + category.term}"}

          if !link.attributes.empty?
            link.attributes.each do |name, value|
              link_params += %Q{;#{name}="#{value}"}
            end
          end

          header = {}
          header[HEADER_LINK] = link_value + link_params

          $log.debug("Rendered link reference: #{link}:")
          $log.debug(header)

          return header
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_action_reference(resource, action)

          resource_location = $locationRegistry.get_location_of_object(resource)
          action_location   = resource_location + "?action=" + action.category.term
          action_type       = action.category.scheme + action.category.term

          link_value = %Q{<#{action_location}>;rel="#{action_type}"}

          header = {}
          header[HEADER_LINK] = link_value

          $log.debug("Rendered action reference (for resource): #{action}: #{resource}:")
          $log.debug(header)

          return header
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_attributes(attributes)

          return {} if attributes == nil || attributes.empty?

          attributes_values = []
          attributes.each do |name, value|
            attributes_values << %Q{#{name}="#{value}"}
          end

          header = {}
          header[HEADER_ATTRIBUTE] = attributes_values

          $log.debug("Rendered attributes: #{attributes}:")
          $log.debug(header)

          return header
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_locations(locations)

          return {} if locations.empty?

          locations_values = []
          locations.each do |location|
            locations_values << $config["server"] + ':' + $config["port"] + location
          end

          header = {}
          header[HEADER_LOCATION] = locations_values

          $log.debug("Rendered locations: #{locations}:")
          $log.debug(header)

          return header
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.merge_headers(headers, headers_to_add)

          headers.merge!(headers_to_add) { |header, value_old, value_to_add|
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
        def self.render_resource(entity)

          $log.debug("Rendering entity: #{entity}")

          headers = {}
          entity_kind = entity.kind

          # Render related kind / mixins
          merge_headers(headers, render_category_type(entity_kind))
          entity.mixins.each do |mixin|
            merge_headers(headers, render_category_type(mixin))
          end

          # Render attributes
          merge_headers(headers, render_attributes(entity.attributes))

          # Render link references
          entity.links.each do |link|
            merge_headers(headers, render_link_reference(link))
          end

          # Render action references
          # TODO: only render currently applicable actions
          entity_kind.actions.each do |action|
            merge_headers(headers, render_action_reference(entity, action))
          end

          return headers
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # rendering general parameters
        # responeAttributes: Hash object
        # respone: response object of Sinatra
        # return: text/plain and text/uri: response.body
        # return: text/occi: response[key] head
        def self.render_response(response, request)
          $log.info("#################### Information on the client ####################")
          $log.info("Client IP Adress: #{request.env['REMOTE_ADDR']}")
          $log.info("Client User Agent: #{request.env['HTTP_USER_AGENT']}")
          $log.info("###################################################################")

          # determine content type from request content type or reques accept, fallback to text/plain
          content_type = ""
          content_type = request.env['CONTENT_TYPE'] if request.env['CONTENT_TYPE']
          content_type = request.env['HTTP_ACCEPT'] if request.env['HTTP_ACCEPT']
          if content_type.include?('application/json')
            response['Content-Type'] = 'application/json'
          elsif content_type.include?('text/html')
            response['Content-Type'] = 'text/html'
          elsif content_type.include?('text/plain') || content_type.include?('text/*') || content_type.include?('*/*') || content_type == ""
            response['Content-Type'] = 'text/plain'
          elsif content_type.include?('text/uri-list')
            response['Content-Type'] = 'text/uri-list'
          elsif content_type.include?('text/occi')
            response['Content-Type'] = 'text/occi'
          else
            response.status = HTTP_STATUS_CODE["Unsupported Media Type"]
            exit
          end
          $log.debug("Content type: #{response['Content-Type']}")
          
          response['Accept'] = "application/json,text/plain,text/occi"
          $log.debug("Accept type: #{response['Accept']}")

          # content type independend parameters
          response['Server'] = "Ruby OCCI Framework/0.4 OCCI/1.1"
          $log.debug("Server: #{response['Server']}")
          
          return response
        end
      end
    end
  end
end