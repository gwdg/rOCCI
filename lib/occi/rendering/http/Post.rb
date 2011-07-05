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
# Description: OCCI RESTful Web Service
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

# OCCI HTTP rendering
require 'occi/rendering/http/Renderer'
require 'occi/rendering/http/LocationRegistry'
require 'occi/rendering/http/OCCIParser'

module OCCI
  module Rendering
    module HTTP
      module Post

        module_function

        # ---------------------------------------------------------------------------------------------------------------------
        def self.resources_trigger_action(request, location)
          
          $log.info("Triggering action on resource(s)...")
          
          # Unnecessry, if we derive action term from category header
#          regexp        = Regexp.new(/action=([^&]*)/)
#          action_params = regexp.match(request.query_string())
#          raise "Could not extract action from query-string: #{request.query_string}" if action_params == nil
#          $log.debug("Action from query string: #{action_params}")
          
          action  = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="actions")[0]
          
          entities  = $locationRegistry.get_resources_below_location(location)
          method    = request.env["HTTP_X_OCCI_ATTRIBUTE"]
            
          raise "No entities corresponding to location [#{location}] could be found!" if entities == nil
            
          $log.debug("Action [#{action}] to be triggered on [#{entities.length}] entities:")
          delegator = OCCI::ActionDelegator.instance
          entities.each do |entity|
            delegator.delegate_action(action, method, entity)
          end
        end
  
        # ---------------------------------------------------------------------------------------------------------------------
        def self.resource_create_link(request)
          
          $log.info("Creating link...")
          
          kind        = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="kinds")[0]
          attributes  = request.env["HTTP_X_OCCI_ATTRIBUTE"] != nil ? OCCI::Parser.new(request.env["HTTP_X_OCCI_ATTRIBUTE"]).attributes_attr : {}
  
          $log.debug("Attributes string: " + request.env["HTTP_X_OCCI_ATTRIBUTE"])
          $log.debug("Extracted attributes of link: #{attributes}")
  
          target_uri = URI.parse(attributes["occi.core.target"])
          target = $locationRegistry.get_object_by_location(target_uri.path)
          $log.debug("target entity of Link: #{target}")
  
          source_uri = URI.parse(attributes["occi.core.source"])
          source = $locationRegistry.get_object_by_location(source_uri.path)
          $log.debug("source entity of Link: #{source}")
  
          link = kind.entity_type.new(attributes)
          source.links << link
          target.links << link
  
          link_location = link.get_location()
          $locationRegistry.register_location(link_location, link)
          headers['Location'] = $locationRegistry.get_absolute_location_of_object(link,request.host_with_port)
  
          $log.debug("Link succesfully created at location [#{link_location}]")
        end

        # ---------------------------------------------------------------------------------------------------------------------
        def self.resource_create(request, location)
          
          $log.info("Creating resource...")  

          kind = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="kinds")[0]

          $log.warn("Provided location does not match location of category: #{kind.get_location} vs. #{location}") if kind.get_location != location
    
          # Get mixins
          mixins = $categoryRegistry.get_categories_by_category_string(request.env['HTTP_CATEGORY'], filter="mixins") if request.env['HTTP_CATEGORY'] != nil
    
          # Get attributes
          attributes = request.env["HTTP_X_OCCI_ATTRIBUTE"] != nil ? OCCI::Parser.new(request.env["HTTP_X_OCCI_ATTRIBUTE"]).attributes_attr : {}
    
          # Create resource
          resource = kind.entity_type.new(attributes, mixins)
    
          # Add links
          if request.env['HTTP_LINK'] != nil        
            $log.debug("HTTP Links: #{request.env['HTTP_LINK']}")
            links = OCCI::Parser.new(request.env['HTTP_LINK']).link_values
              
            links.each do |link_data|
              $log.debug("Creating link, extracted link data: #{link_data}")
              raise "Mandatory link information missing (related | target | category | location)!" unless link_data.related != nil && link_data.target != nil && link_data.category != nil # && link_data.location != nil
                    
              kind = $categoryRegistry.getKind(link_data.category)
              raise "Kind not found in category!" if kind == nil
              $log.debug("Link kind found: #{kind.scheme}#{kind.term}")
    
              source = resource
              target = $locationRegistry.get_object_by_location(link_data.target)
              raise "Link target not found!" if target == nil
    
              link_data.attributes["occi.core.target"] = link_data.target
              link_data.attributes["occi.core.source"] = source.get_location()
                
              link = kind.entity_type.new(link_data.attributes)
               
              source.links << link
              target.links << link
    
              $locationRegistry.register_location(link.get_location(), link)
              $log.debug("Link successfully created!")
            end
          end
          
          # Check if resource should be a template
          template = location.start_with?('template')
          $log.debug("Resource should be a template") if template
          resource.make_template if template
    
          resource.deploy()
    
          $locationRegistry.register_location(resource.get_location, resource)

          response_header = {}
          response_header['Location'] = $locationRegistry.get_absolute_location_of_object(resource,request.host_with_port)

          return response_header
        end
        
      end
    end
  end
end