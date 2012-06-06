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
#require 'nokogiri'
require 'hashie/mash'
require 'occi/core/collection'
require 'occi/log'
require 'occi/antlr/OCCIParser'

module OCCI
  class Parse

=begin
          if content_type.includes?('multipart')
            # TODO: implement multipart handling
            # handle file upload
            if params['file'] != nil
              OCCI::Log.debug("Location of Image #{params['file'][:tempfile].path}")
              $image_path = OCCI::Server.config[:one_image_tmp_dir] + '/' + params['file'][:filename]
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

    def self.header_locations(header)
      x_occi_location_strings = header['HTTP_X_OCCI_LOCATION'].to_s.split(',')
      x_occi_location_strings.collect { |loc| OCCI::Parser.new('X-OCCI-Location: ' + loc).x_occi_location }
    end

    def self.header_categories(header)
      collection = OCCI::Core::Collection.new
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      category_strings.each do |cat|
        category = OCCI::Parser.new('Category: ' + cat).category
        collection.kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind) }
        collection.mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) }
        collection.actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action) }
      end
      collection
    end

    def self.header_entity(header)
      collection = OCCI::Core::Collection.new
      entity = Hashie::Mash.new
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      return collection if category_strings.empty?
      attribute_strings = header['HTTP_X_OCCI_ATTRIBUTE'].to_s.split(',')
      categories = Hashie::Mash.new({:kinds => [], :mixins => [], :actions => []})
      category_strings.each { |cat| categories.merge!(OCCI::Parser.new('Category: ' + cat).category) }
      return collection if categories.kinds.empty?
      entity.kind = categories.kinds.first.scheme + categories.kinds.first.term
      entity.mixins = categories.mixins.collect { |mixin| mixin.scheme + mixin.term } if categories.mixins.any?
      attribute_strings.each { |attr| entity.attributes!.merge!(OCCI::Parser.new('X-OCCI-Attribute: ' + attr).x_occi_attribute) }
      kind = OCCI::Registry.get_by_id(entity.kind)
      # TODO: error handling
      return collection if kind.nil?
      if kind.entity_type == OCCI::Core::Link.name
        entity.target = link.attributes.occi!.core!.target
        entity.source = link.attributes.occi!.core!.source
        collection.links << OCCI::Core::Link.new(entity)
      elsif kind.entity_type == OCCI::Core::Resource.name
        link_strings = header['HTTP_LINK'].to_s.split(',')
        link_strings.each { |link| entity.links << OCCI::Parser.new('Link: ' + link).link }
        collection.resources << OCCI::Core::Resource.new(entity)
      end
      collection
    end

    def self.text_locations(text)
      text.lines.collect { |line| OCCI::Parser.new(line).x_occi_location if line.include? 'X-OCCI-Location' }.compact
    end

    def self.text_categories(text)
      collection = OCCI::Core::Collection.new
      text.each_line do |line|
        category = OCCI::Parser.new(line).category
        collection.kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind) }
        collection.mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) }
        collection.actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action) }
      end
      collection
    end

    def self.text_entity(text)
      collection = OCCI::Core::Collection.new
      entity = Hashie::Mash.new
      links = []
      categories = Hashie::Mash.new({:kinds => [], :mixins => [], :actions => []})
      text.each_line do |line|
        categories.merge!(OCCI::Parser.new(line).category) if line.include? 'Category'
        entity.attributes!.merge!(OCCI::Parser.new(line).x_occi_attribute) if line.include? 'X-OCCI-Attribute'
        links << OCCI::Parser.new(line).link if line.include? 'Link'
      end
      entity.kind = categories.kinds.first.scheme + categories.kinds.first.term if categories.kinds.first
      entity.mixins = categories.mixins.collect { |mixin| mixin.scheme + mixin.term } if entity.mixins
      kind = OCCI::Registry.get_by_id(entity.kind)
      # TODO: error handling
      return collection if kind.nil?
      if OCCI::Registry.get_by_id(entity.kind).entity_type == OCCI::Core::Link.name
        entity.target = links.first.attributes.occi!.core!.target
        entity.source = links.first.attributes.occi!.core!.source
        collection.links << OCCI::Core::Link.new(entity)
      elsif OCCI::Registry.get_by_id(entity.kind).entity_type == OCCI::Core::Resource.name
        entity.links = links
        collection.resources << OCCI::Core::Resource.new(entity)
      end unless entity.kind.nil?
      collection
    end

    def self.json(json)
      collection = OCCI::Core::Collection.new
      hash = Hashie::Mash.new(JSON.parse(json))
      collection.kinds.concat hash.kinds.collect { |kind| OCCI::Core::Kind.new(kind) } if hash.kinds
      collection.mixins.concat hash.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) } if hash.mixins
      collection.resources.concat hash.resources.collect { |resource| OCCI::Core::Resource.new(resource) } if hash.resources
      collection.links.concat hash.links.collect { |link| OCCI::Core::Link.new(link) } if hash.links
      collection
    end

    #def self.xml(xml)
    #  collection = OCCI::Core::Collection.new
    #  hash = Hashie::Mash.new(Hash.from_xml(Nokogiri::XML(xml)))
    #  collection.kinds.concat hash.kinds.collect { |kind| OCCI::Core::Kind.new(kind) } if hash.kinds
    #  collection.mixins.concat hash.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) } if hash.mixins
    #  collection.resources.concat hash.resources.collect { |resource| OCCI::Core::Resource.new(resource) } if hash.resources
    #  collection.links.concat hash.links.collect { |link| OCCI::Core::Link.new(link) } if hash.links
    # collection
    #end

  end

end