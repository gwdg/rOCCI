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
        attr_reader :location
        attr_reader :action
        attr_reader :kind
        attr_reader :mixins
        def initialize(request)
          parsed_categories = []
          @location = []
          @links = []
          @attributes = []
          @kind = nil
          @action = nil
          @mixins = []

          # read in all headers (equal to text/occi content type)
          parsed_categories.concat(OCCI::Parser.new(request.env['HTTP_CATEGORY'].to_s).category_values) if request.env['HTTP_CATEGORY']
          @links = (OCCI::Parser.new(request.env['HTTP_LINK'].to_s).link_values) if request.env['HTTP_LINK']
          @attributes = OCCI::Parser.new(request.env['HTTP_X_OCCI_ATTRIBUTE'].to_s).attributes_attr if request.env['HTTP_X_OCCI_ATTRIBUTE']
          @location.concat(OCCI::Parser.new(request.env['HTTP_X_OCCI_LOCATION'].to_s).location_values) if request.env['HTTP_X_OCCI_LOCATION']

          # text/plain is default content type
          request.env['CONTENT_TYPE'] = 'text/plain' unless request.env['CONTENT_TYPE']

          case request.env['CONTENT_TYPE']
          when 'text/plain'
            request.body.each do |line|
              parsed_categories.concat(OCCI::Parser.new(line).category_values) if line.start_with?('Category')
              @link.concat(OCCI::Parser.new(line).category_values) if line.start_with?('Link')
              @attribute.concat(OCCI::Parser.new(line).category_values) if line.start_with?('X-OCCI-Attribute')
              @location.concat(OCCI::Parser.new(line).category_values) if line.start_with?('X-OCCI-Location')
            end
          when 'application/json'
            doc = JSON.parse(request.body.read)
            $log.debug("JSON output" + doc)
          end

          @categories = OCCI::CategoryRegistry.get_all(parsed_categories.to_a).to_a
          @kind = @categories.select {|category| category.kind_of?(OCCI::Core::Kind)}.last
          @action = @categories.select {|category| category.kind_of?(OCCI::Core::Action)}.last
          @mixins = @categories.select {|category| category.kind_of?(OCCI::Core::Mixin)}
        end
      end
    end
  end
end