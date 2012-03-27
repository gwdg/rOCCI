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
# @note OCCI RESTful Web Service
# @author Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'json'
require 'occi/antlr/OCCIParser'

module OCCI
  module Rendering
    module HTTP
      class Request

        attr_reader :categories
        attr_reader :resources
        attr_reader :links
        attr_reader :locations

        # Parses a Rack/Sinatra Request and extract OCCI relevant information
        #
        # @param [Rack::Request] request from Sinatra/Rack
        def initialize(request)
          @categories = Hashie::Mash.new({:kinds=>[],:mixins=>[],:actions=>[]})
          @links = Array.new
          @locations = Array.new

          $log.debug("HTTP Request Headers: ")
          request.env.each do |k, v|
            $log.debug(k.to_s + ":" + v.to_s) if k.include?('HTTP')
          end

          content_type = request.env['CONTENT_TYPE'].to_s

=begin
          if content_type.includes?('multipart')
            # TODO: implement multipart handling
            # handle file upload
            if params['file'] != nil
              $log.debug("Location of Image #{params['file'][:tempfile].path}")
              $image_path = $config[:one_image_tmp_dir] + '/' + params['file'][:filename]
              FileUtils.cp(params['file'][:tempfile].path, $image_path)
            end

            # handle file upload in multipart requests
            request.POST.values.each do |body|
              if body.kind_of?(String)
                parse_text(body)
              elsif body.kind_of?(Hash)
                if body['type'].include?('application/json')
                  # try to parse body as JSON object
                  parse_json(body.read)
                elsif body['type'].include?('text/plain') # text/plain
                  parse_text(body.read)
                end unless body['type'].nil?
              end
            end
          end
=end

          case content_type
            when 'text/uri-list'
              request.body.each_line do |line|
                @locations << URI.parse(line)
              end
            when 'text/occi'
              @locations.concat(parse_header_locations(request.env))
              if @locations.empty?
                if request.path_info.include?('/-/')
                  @categories = parse_header_categories(request.env)
                else
                  if request.path_info.start_with?('/link/')
                    @links = parse_header_links(request.env)
                  elsif request.path_info.include?('?action=')
                    @categories = parse_header_category(request.env)
                  else
                    @resources = parse_header_resources(request.env)
                  end
                end
              end
            when 'text/plain'
              @locations.concat(parse_text_locations(request.body))
              if @locations.empty?
                if request.path_info.include?('/-/')
                  @categories = parse_text_mixins(request.body)
                else
                  if request.path_info.start_with?('/link/')
                    @links = parse_text_links(request.body)
                  elsif request.path_info.include?('?action=')
                    @categories = parse_text_categories(request.body)
                  else
                    @resources = parse_text_resources(request.body)
                  end
                end
              end
            when 'application/occi-category+json'
              @categories = parse_json(request.body)
            when 'application/occi-resource+json'
              @resources = parse_json(request.body)
            when 'application/occi-link+json'
              @links = parse_json(request.body)
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------
        private
        # ---------------------------------------------------------------------------------------------------------------------

        def self.parse_header_locations(header)
          locations = Array.new
          x_occi_location_strings = header['HTTP_X_OCCI_LOCATION'].to_s.split(',')
          locations.concat(x_occi_location_strings.collect { |loc| OCCI::Parser.new('X-OCCI-Location: ' + loc).x_occi_location }).compact!
          return locations
        end

        def self.parse_header_categories(header)
          categories = Hashie::Mash.new({:kinds=>[],:mixins=>[],:actions=>[]})
          category_strings = header['HTTP_CATEGORY'].to_s.split(',')
          category_strings.each { |cat| categories.merge!(OCCI::Parser.new('Category: ' + cat).category) }
          return categories
        end

        def self.parse_header_links(header)
          link = Hashie::Mash.new
          category_strings = header['HTTP_CATEGORY'].to_s.split(',')
          attribute_strings = header['HTTP_X_OCCI_ATTRIBUTE'].to_s.split(',')
          link.kind = category_strings.collect { |cat| OCCI::Parser.new('Category: ' + cat).kind }.first
          link.mixins = mixin_strings.collect { |cat| OCCI::Parser.new('Category: ' + cat).mixin }.compact!
          link.attributes = attribute_strings.collect { |attr| OCCI::Parser.new('X-OCCI-Attribute: ' + attr).x_occi_attribute }.compact!
          link.target = link.attributes.occi!.core!.target
          link.source = link.attributes.occi!.core!.source
          links = [link]
          return links
        end

        def self.parse_header_resources(header)
          resource = Hashie::Mash.new
          category_strings = header['HTTP_CATEGORY'].to_s.split(',')
          attribute_strings = header['HTTP_X_OCCI_ATTRIBUTE'].to_s.split(',')
          link_strings = header['HTTP_LINK'].to_s.split(',')
          resource.kind = category_strings.collect { |cat| OCCI::Parser.new('Category: ' + cat).kind }.first
          resource.mixins = mixin_strings.collect { |cat| OCCI::Parser.new('Category: ' + cat).mixin }.compact!
          resource.attributes = attribute_strings.collect { |attr| OCCI::Parser.new('X-OCCI-Attribute: ' + attr).x_occi_attribute }.compact!
          resource.links =link_strings.collect { |link| OCCI::Parser.new('Link: ' + link).link }.compact!
          resources = [resource]
          return resources
        end

        def self.parse_text_locations(body)
          locations = Array.new
          body.each_line do |line|
            location = OCCI::Parser.new(line).x_occi_location
            locations.concat([location]) if location.any?
          end
          return locations
        end

        def self.parse_text_categories(body)
          categories = Hashie::Mash.new({:kinds=>[],:mixins=>[],:actions=>[]})
          body.each_line do |line|
            category = OCCI::Parser.new(line).category
            categories.merge!(category)
          end
          return categories
        end

        def self.parse_text_links(body)
          link = Hashie::Mash.new
          link.mixins = Array.new
          link.attributes = Array.new
          body.each_line do |line|
            kind = OCCI::Parser.new(line).kind
            link.kind = kind if kind.any?
            mixin = OCCI::Parser.new(line).mixin
            link.mixins.concat(mixin) if mixin.any?
            attribute = OCCI::Parser.new(line).x_occi_attribute
            link.attributes.concat(attribute) if attribute.any?
          end
          link.target = link.attribute!.occi!.core!.target
          link.source = link.attribute!.occi!.core!.source
          links = [link]
          return links
        end

        def self.parse_text_resource(body)
          resource = Hashie::Mash.new
          resource.mixins = Array.new
          resource.attributes = Array.new
          resource.links = Array.new
          body.each_line do |line|
            kind = OCCI::Parser.new(line).kind
            resource.kind = kind if kind.any?
            mixin = OCCI::Parser.new(line).mixin
            resource.mixins.concat(mixin) if mixin.any?
            link = OCCI::Parser.new(line).link
            resource.links.concat(attribute) if link.any?
            attribute = OCCI::Parser.new(line).x_occi_attribute
            resource.attributes.concat(attribute) if attribute.any?
          end
          resources = [resource]
          return resources
        end

        def self.parse_json(body)
          Hashie::Mash.new(JSON.parse(body))
        end
      end
    end
  end
end
