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
require 'occi/log'
require 'occi/antlr/OCCIParser'

module OCCI
  class Request

    attr_reader :kinds
    attr_reader :mixins
    attr_reader :actions
    attr_reader :resources
    attr_reader :links
    attr_reader :locations

    # Parses a Rack/Sinatra Request and extract OCCI relevant information
    #
    # @param [Rack::Request] request from Sinatra/Rack
    def initialize(request)
      @kinds = []
      @mixins = []
      @actions = []
      @resources = []
      @links = []
      @locations = []

=begin
          if content_type.includes?('multipart')
            # TODO: implement multipart handling
            # handle file upload
            if params['file'] != nil
              OCCI::Log.debug("Location of Image #{params['file'][:tempfile].path}")
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

      body = request.body.read.to_s

      # always check headers
      parse_header_locations(request.env)
      if @locations.empty?
        if request.path_info.include?('/-/')
          parse_header_categories(request.env)
        else
          parse_header_entity(request.env)
        end
      end

      case request.media_type
        when 'text/uri-list'
          body.each_line do |line|
            @locations << URI.parse(line)
          end
        when 'text/plain', nil
          parse_text_locations(body)
          if @locations.empty?
            if request.path_info.include?('/-/')
              parse_text_categories(body)
            else
              parse_text_entity(body)
            end
          end
        when 'application/occi+json' || 'application/json'
          parse_json(body)
        else
          raise OCCI::ContentTypeNotSupported
      end

    end

    def categories
      @kinds + @mixins + @actions
    end

    # ---------------------------------------------------------------------------------------------------------------------
    private
    # ---------------------------------------------------------------------------------------------------------------------

    def parse_header_locations(header)
      x_occi_location_strings = header['HTTP_X_OCCI_LOCATION'].to_s.split(',')
      x_occi_location_strings.each { |loc| @locations << OCCI::Parser.new('X-OCCI-Location: ' + loc).x_occi_location }
    end

    def parse_header_categories(header)
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      category_strings.each do |cat|
        category = OCCI::Parser.new('Category: ' + cat).category
        @kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind) }
        @mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) }
        @actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action) }
      end
    end

    def parse_header_entity(header)
      entity = Hashie::Mash.new
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      return if category_strings.empty?
      attribute_strings = header['HTTP_X_OCCI_ATTRIBUTE'].to_s.split(',')
      categories = Hashie::Mash.new({:kinds => [], :mixins => [], :actions => []})
      category_strings.each { |cat| categories.merge!(OCCI::Parser.new('Category: ' + cat).category) }
      return if categories.kinds.empty?
      entity.kind = categories.kinds.first.scheme + categories.kinds.first.term
      entity.mixins = categories.mixins.collect { |mixin| mixin.scheme + mixin.term } if categories.mixins.any?
      attribute_strings.each { |attr| entity.attributes!.merge!(OCCI::Parser.new('X-OCCI-Attribute: ' + attr).x_occi_attribute) }
      kind = OCCI::Registry.get_by_id(entity.kind)
      # TODO: error handling
      return if kind.nil?
      if kind.entity_type == OCCI::Core::Link.name
        entity.target = link.attributes.occi!.core!.target
        entity.source = link.attributes.occi!.core!.source
        @links << OCCI::Core::Link.new(entity)
      elsif kind.entity_type == OCCI::Core::Resource.name
        link_strings = header['HTTP_LINK'].to_s.split(',')
        link_strings.each { |link| entity.links << OCCI::Parser.new('Link: ' + link).link }
        @resources << OCCI::Core::Resource.new(entity)
      end
    end

    def parse_text_locations(body)
      body.each_line do |line|
        @locations << OCCI::Parser.new(line).x_occi_location if line.include? 'X-OCCI-Location'
      end
    end

    def parse_text_categories(body)
      body.each_line do |line|
        category = OCCI::Parser.new(line).category
        @kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind) }
        @mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) }
        @actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action) }
      end
    end

    def parse_text_entity(body)
      entity = Hashie::Mash.new
      links = []
      categories = Hashie::Mash.new({:kinds => [], :mixins => [], :actions => []})
      body.each_line do |line|
        categories.merge!(OCCI::Parser.new(line).category) if line.include? 'Category'
        entity.attributes!.merge!(OCCI::Parser.new(line).x_occi_attribute) if line.include? 'X-OCCI-Attribute'
        links << OCCI::Parser.new(line).link if line.include? 'Link'
      end
      entity.kind = categories.kinds.first.scheme + categories.kinds.first.term if categories.kinds.first
      entity.mixins = categories.mixins.collect { |mixin| mixin.scheme + mixin.term } if entity.mixins
      kind = OCCI::Registry.get_by_id(entity.kind)
      # TODO: error handling
      return if kind.nil?
      if OCCI::Registry.get_by_id(entity.kind).entity_type == OCCI::Core::Link.name
        entity.target = links.first.attributes.occi!.core!.target
        entity.source = links.first.attributes.occi!.core!.source
        @links << OCCI::Core::Link.new(entity)
      elsif OCCI::Registry.get_by_id(entity.kind).entity_type == OCCI::Core::Resource.name
        entity.links = links
        @resources << OCCI::Core::Resource.new(entity)
      end unless entity.kind.nil?
    end

    def parse_json(body)
      collection = Hashie::Mash.new(JSON.parse(body))
      @kinds.concat collection.kinds.collect { |kind| OCCI::Core::Kind.new(kind) } if collection.kinds
      @mixins.concat collection.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) } if collection.mixins
      @resources.concat collection.resources.collect { |resource| OCCI::Core::Resource.new(resource) } if collection.resources
      @links.concat collection.links.collect { |link| OCCI::Core::Link.new(link) } if collection.links
      @locations.concat collection.locations.collect { |location| URI.parse(location) } if collection.locations
    end

  end
end
