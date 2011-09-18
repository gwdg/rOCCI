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
# Author(s): Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/rendering/http/OCCIParser'
require 'json'

module OCCI
  module Rendering
    module HTTP
      class OCCIRequest
        attr_reader :categories
        attr_reader :links
        attr_reader :attributes
        attr_reader :locations
        attr_reader :action
        attr_reader :kind
        attr_reader :mixins
        def initialize(request,params)
          parsed_categories = []
          @locations = []
          @links = []
          @attributes = {}
          @kind = nil
          @action = nil
          @mixins = []
          @parsed_categories = []

          # read in all headers (equal to text/occi content type)
          @parsed_categories.concat(OCCI::Parser.new(request.env['HTTP_CATEGORY'].to_s).category_values) if request.env['HTTP_CATEGORY']
          @links.concat(OCCI::Parser.new(request.env['HTTP_LINK'].to_s).link_values) if request.env['HTTP_LINK']
          @attributes.merge!(OCCI::Parser.new(request.env['HTTP_X_OCCI_ATTRIBUTE'].to_s).attributes_attr) if request.env['HTTP_X_OCCI_ATTRIBUTE']
          @locations.concat(OCCI::Parser.new(request.env['HTTP_X_OCCI_LOCATION'].to_s).location_values) if request.env['HTTP_X_OCCI_LOCATION']

          # handle file upload
          if params['file'] != nil
            $log.debug("Location of Image #{params['file'][:tempfile].path}")
            $image_path = $config[:one_image_tmp_dir] + '/' + params['file'][:filename]
            FileUtils.cp(params['file'][:tempfile].path, $image_path)
          end

          $log.debug(params)
          params.values.each do |body|
            $log.debug(body)
            if body.kind_of?(String)
              parse_text(body)
            elsif body.kind_of?(Hash)
              if body['type'].include?('application/json')
                # try to parse body as JSON object
                parse_json(body)
              elsif body['type'].include?('application/json') # text/plain
                parse_text(body)
              end unless body['type'].nil?
            end
          end
          
          if request.env['CONTENT_TYPE'].include?('application/json')
            parse_json(request.body)
          elsif request.env['CONTENT_TYPE'].include?('text/plain')
            parse_text(request.body)
          end unless request.env['CONTENT_TYPE'].nil?

          $log.debug(@attributes)

          @categories = OCCI::CategoryRegistry.get_all(@parsed_categories).to_a
          @kind = @categories.select {|category| category.kind_of?(OCCI::Core::Kind)}.last
          @action = @categories.select {|category| category.kind_of?(OCCI::Core::Action)}.last
          @mixin = @parsed_categories.last
          @mixins = @categories.select {|category| category.kind_of?(OCCI::Core::Mixin)}
        end

        def parse_json(body)
          doc = JSON.parse(request.body.read)
          collection = doc['collection']
          Array(doc['links']).each do |link|
            @links.concat(link)
          end
          Array(doc['attribute']).each do |attribute|
            @attributes.merge!(attribute)
          end
          Array(doc['locations']).each do |location|
            @locations.concat(location)
          end
          $log.debug("JSON output" + doc)
        end

        def parse_text(body)
          body.each_line do |line|
            @parsed_categories.concat(OCCI::Parser.new(line.gsub('Category: ','').chomp).category_values) if line.start_with?('Category')
            @links.concat(OCCI::Parser.new(line.gsub('Link: ','').chomp).link_values) if line.start_with?('Link')
            @attributes.merge!(OCCI::Parser.new(line.gsub('X-OCCI-Attribute: ','').chomp).attributes_attr) if line.start_with?('X-OCCI-Attribute')
            @locations.concat(OCCI::Parser.new(line.gsub('X-OCCI-Location: ','').chomp).location_values) if line.start_with?('X-OCCI-Location')
          end

        end
      end
    end
  end
end