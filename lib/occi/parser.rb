require 'json'
require 'nokogiri'
require 'hashie/mash'
require 'occi/collection'
require 'occi/log'
require 'occiantlr/OCCIANTLRParser'

module OCCI
  class Parser

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

    # Parses an OCCI message and extracts OCCI relevant information
    # @param [String] media_type the media type of the OCCI message
    # @param [String] body the body of the OCCI message
    # @param [true, false] category for text/plain and text/occi media types information e.g. from the HTTP request location is needed to determine if the OCCI message includes a category or an entity
    # @param [Hash] header optional header of the OCCI message
    # @return [Array<Array, OCCI::Collection>] list consisting of an array of locations and the OCCI object collection
    def self.parse(media_type, body, category=false, header={ })
      OCCI::Log.debug('### Parsing request data to OCCI data structure ###')
      collection = OCCI::Collection.new

      locations = self.header_locations(header)
      category ? collection = self.header_categories(header) : collection = self.header_entity(header) if locations.empty?

      case media_type
        when 'text/occi'
        when 'text/uri-list'
          body.each_line { |line| locations << URI.parse(line) }
        when 'text/plain', nil
          locations.concat self.text_locations(body)
            category ? collection = self.text_categories(body) : collection = self.text_entity(body) if locations.empty? && collection.empty?
        when 'application/occi+json', 'application/json'
          collection = self.json(body)
        when 'application/occi+xml', 'application/xml'
          collection = self.xml(body)
        #when 'application/ovf+xml'
        #  collection = self.ovf(body)
        else
          raise "Content Type not supported"
      end
      return locations, collection
    end

    private

    def self.header_locations(header)
      x_occi_location_strings = header['HTTP_X_OCCI_LOCATION'].to_s.split(',')
      x_occi_location_strings.collect { |loc| OCCIANTLR::Parser.new('X-OCCI-Location: ' + loc).x_occi_location }
    end

    def self.header_categories(header)
      collection       = OCCI::Collection.new
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      category_strings.each do |cat|
        category = OCCIANTLR::Parser.new('Category: ' + cat).category
        collection.kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind) }
        collection.mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) }
        collection.actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action) }
      end
      collection
    end

    def self.header_entity(header)
      collection       = OCCI::Collection.new
      entity           = Hashie::Mash.new
      category_strings = header['HTTP_CATEGORY'].to_s.split(',')
      return collection if category_strings.empty?
      attribute_strings = header['HTTP_X_OCCI_ATTRIBUTE'].to_s.split(',')
      categories        = Hashie::Mash.new({ :kinds => [], :mixins => [], :actions => [] })
      category_strings.each { |cat| categories.merge!(OCCIANTLR::Parser.new('Category: ' + cat).category) }
      return collection if categories.kinds.empty?
      entity.kind = categories.kinds.first.scheme + categories.kinds.first.term
      entity.mixins = categories.mixins.collect { |mixin| mixin.scheme + mixin.term } if categories.mixins.any?
      attribute_strings.each { |attr| entity.attributes!.merge!(OCCIANTLR::Parser.new('X-OCCI-Attribute: ' + attr).x_occi_attribute) }
      kind = OCCI::Model.get_by_id(entity.kind)
      # TODO: error handling
      return collection if kind.nil?
      if kind.entity_type == OCCI::Core::Link.name
        entity.target = link.attributes.occi!.core!.target
        entity.source = link.attributes.occi!.core!.source
        collection.links << OCCI::Core::Link.new(entity)
      elsif kind.entity_type == OCCI::Core::Resource.name
        link_strings = header['HTTP_LINK'].to_s.split(',')
        link_strings.each { |link| entity.links << OCCIANTLR::Parser.new('Link: ' + link).link }
        collection.resources << OCCI::Core::Resource.new(entity)
      end
      collection
    end

    def self.text_locations(text)
      text.lines.collect { |line| OCCIANTLR::Parser.new(line).x_occi_location if line.include? 'X-OCCI-Location' }.compact
    end

    def self.text_categories(text)
      collection = OCCI::Collection.new
      text.each_line do |line|
        category = OCCIANTLR::Parser.new(line).category
        next if category.nil?
        collection.kinds.concat category.kinds.collect { |kind| OCCI::Core::Kind.new(kind) }
        collection.mixins.concat category.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) }
        collection.actions.concat category.actions.collect { |action| OCCI::Core::Action.new(action) }
      end
      collection
    end

    def self.text_entity(text)
      collection = OCCI::Collection.new
      entity     = Hashie::Mash.new
      links      = []
      categories = Hashie::Mash.new({ :kinds => [], :mixins => [], :actions => [] })
      text.each_line do |line|
        categories.merge!(OCCIANTLR::Parser.new(line).category) if line.include? 'Category'
        entity.attributes!.merge!(OCCIANTLR::Parser.new(line).x_occi_attribute) if line.include? 'X-OCCI-Attribute'
        links << OCCIANTLR::Parser.new(line).link if line.include? 'Link'
      end
      entity.kind = categories.kinds.first.scheme + categories.kinds.first.term if categories.kinds.first
      entity.mixins = categories.mixins.collect { |mixin| mixin.scheme + mixin.term } if entity.mixins
      kind = OCCI::Model.get_by_id(entity.kind)
      # TODO: error handling
      return collection if kind.nil?
      if OCCI::Model.get_by_id(entity.kind).entity_type == OCCI::Core::Link.name
        entity.target = links.first.attributes.occi!.core!.target
        entity.source = links.first.attributes.occi!.core!.source
        collection.links << OCCI::Core::Link.new(entity)
      elsif OCCI::Model.get_by_id(entity.kind).entity_type == OCCI::Core::Resource.name
        entity.links = links
        collection.resources << OCCI::Core::Resource.new(entity)
      end unless entity.kind.nil?
      collection
    end

    def self.json(json)
      collection = OCCI::Collection.new
      hash       = Hashie::Mash.new(JSON.parse(json))
      collection.kinds.concat hash.kinds.collect { |kind| OCCI::Core::Kind.new(kind) } if hash.kinds
      collection.mixins.concat hash.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) } if hash.mixins
      collection.resources.concat hash.resources.collect { |resource| OCCI::Core::Resource.new(resource) } if hash.resources
      collection.links.concat hash.links.collect { |link| OCCI::Core::Link.new(link) } if hash.links
      collection
    end

    def self.xml(xml)
      collection = OCCI::Collection.new
      hash       = Hashie::Mash.new(Hash.from_xml(Nokogiri::XML(xml)))
      collection.kinds.concat hash.kinds.collect { |kind| OCCI::Core::Kind.new(kind) } if hash.kinds
      collection.mixins.concat hash.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) } if hash.mixins
      collection.resources.concat hash.resources.collect { |resource| OCCI::Core::Resource.new(resource) } if hash.resources
      collection.links.concat hash.links.collect { |link| OCCI::Core::Link.new(link) } if hash.links
      collection
    end

    #def self.ovf(ovf)
    # TODO: implement ovf / ova messages
    #end

  end

end