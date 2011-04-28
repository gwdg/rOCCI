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

module OCCI
  module Rendering
    module HTTP

      class Renderer

        HEADER_CATEGORY   = "Category"
        HEADER_LINK       = "Link"
        HEADER_ATTRIBUTE  = "X-OCCI-Attribute"
        HEADER_LOCATION   = "X-OCCI-Location"

        # ---------------------------------------------------------------------------------------------------------------------
        def self.render_category_type(object)
          
          # Determine class of object

          clazz = nil

          if object.kind_of? OCCI::Core::Kind
            clazz     = "kind"
            category  = object
          end

          if object.kind_of? OCCI::Core::Mixin
            clazz     = "mixin"
            category  = object
          end

          if object.kind_of? OCCI::Core::Action
            clazz     = "action"  
            category  = object.category
          end
          
          raise "Unsupported object class: #{object.class}" if clazz == nil 
          
          # Render category-value
          category_value = %Q{#{category.term}; scheme="#{category.scheme}"; class="#{clazz}";} 
          
          # Render category-params

          category_params = ""

          # "title"
          if object.instance_variable_defined?(:@title)
            category_params += %Q{title="#{category.title}";}
          end
          
          # "related"
          if object.instance_variable_defined?(:@related) && !object.related.empty?
            related_value =  ""
            object.related.each do |related|
              related_value += related.scheme + related.term + " "
            end
            category_params += %Q{rel="#{related_value.strip}";}            
          end

          # "location"
          location = $locationRegistry.get_location_of_object(category)
          if location != nil
            category_params += %Q{location=#{location};}
          end
          
          # "attributes"
          if clazz != "action"
            attributes = ""
            category.attributes.keys.each do |attribute|
              attributes += "#{attribute} "
            end
            category_params += %Q{attributes="#{attributes.strip}";}
          end

          # "actions"
          if object.instance_variable_defined?(:@actions)
            actions = ""
            category.actions.each do |action|
              actions += action.category.scheme + action.category.term + " "
            end
            category_params += %Q{actions="#{actions.strip}";}
          end
          
          header = {}
          header[HEADER_CATEGORY] = category_value + category_params

          $log.debug("Rendered category object: #{category}:")
          $log.debug(header)

          return header
        end

        # ---------------------------------------------------------------------------------------------------------------------        
        def self.render_link_reference(link)

          # Link value 
          location        = $locationRegistry.get_location_of_object(link)
          target_location = link.attributes["occi.core.target"]
          target_resource = $locationRegistry.get_object_by_location(target_location)
          target_resource_type = target_resource.class.getKind.scheme + target_resource.class.getKind.term 
 
          link_value = %Q{<#{target_location}>;rel="#{target_resource_type}";self="#{location}"}
          
          # Link params
          category = link.class.getKind
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
        def self.render_entity_attributes(entity)
          
          return {} if entity.attributes.empty?

          attributes_values = []
          entity.attributes.each do |name, value|
            attributes_values << %Q{#{name}="#{value}"}
          end
          
          header = {}
          header[HEADER_ATTRIBUTE] = attributes_values
        
          $log.debug("Rendered attributes: #{entity.attributes}:")
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
          merge_headers(headers, render_entity_attributes(entity))
          
          # Render link references
          entity.attributes["links"].each do |link|
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
        # the main render (class)method for some render operations
        # responeAttributes: Hash object
        # respone: response object of Sinatra
        # return: text/plain and text/uri: response.body
        # return: text/occi: response[key] head
        def self.render_response(responseAttributes, response, request)
          # determine content type from request content type or reques accept, fallback to text/plain
          content_type = request.env['CONTENT_TYPE']
          content_type = request.env['HTTP_ACCEPT'] if request.env['HTTP_ACCEPT'] != nil
          content_type = "text/plain" if content_type == "text/*" || content_type == "*/*" || content_type == "" || content_type == nil

          $log.debug("Accept type: #{request.env['HTTP_ACCEPT']}")
          $log.debug("Content type: #{content_type}")

          # content type independend parameters
          response['Server'] = "OCCI/1.1"

          # TODO: replace content-type matching with regular expressions

          case content_type
            when 'text/plain'
              response['Content-Type'] = "text/plain"
              responseAttributes.each_key do |key|
                values = responseAttributes[key]
                if values.size > 0 then
                  values.each do |value|
                    response.body << key + ": " + value + "\n"
                  end
                end
              end
              response.status = HTTP_STATUS_CODE["OK"]

            when 'text/occi'
              response['Content-Type'] = "text/occi"
              responseAttributes.each_key do |key|
                values = responseAttributes[key]
                response[key] = ""
                if values.size > 0 then
                  values.each do |value|
                    response[key] << "," if not response[key] == ""
                    response[key] << value
                  end
                end
              end
              response.status = HTTP_STATUS_CODE["OK"]
              # for text/occi the body needs to contain OK
              response.body = "OK"

            when 'text/uri-list'
              response['Content-Type'] = "text/uri-list"
              responseAttributes.each_key do |key|
                values = responseAttributes[key]
                if key == "location"
                  if values.size > 0 then
                    values.each do |value|
                      response.body << value + "\n"
                    end
                  end
                end
              end
              response.status = HTTP_STATUS_CODE["OK"]
            else
              response.status = HTTP_STATUS_CODE["Unsupported Media Type" ]
          end
          
          $log.debug("Response headers: #{response.headers}")
          $log.debug("Response body: #{response.body}")
        end
                
      end

    end
  end
end