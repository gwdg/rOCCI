require 'occi/parser/text'
require 'occi/parser/json'
require 'occi/parser/xml'
require 'occi/parser/ova'
require 'occi/parser/ovf'

module Occi
  module Parser

    # Parses an OCCI message and extracts OCCI relevant information
    # @param [String] media_type the media type of the OCCI message
    # @param [String] body the body of the OCCI message
    # @param [true, false] category for text/plain and text/occi media types information e.g. from the HTTP request location is needed to determine if the OCCI message includes a category or an entity
    # @param [Occi::Core::Resource,Occi::Core::Link] entity_type entity type to use for parsing of text plain entities
    # @param [Hash] header optional header of the OCCI message
    # @return [Occi::Collection] list consisting of an array of locations and the OCCI object collection
    def self.parse(media_type, body, category=false, entity_type=Occi::Core::Resource, header={})
      Occi::Log.debug '### Parsing request data to OCCI Collection ###'
      collection = Occi::Collection.new

      # remove trailing HTTP_ prefix if present
      header = Hash[header.map { |k, v| [k.gsub('HTTP_', '').upcase, v] }]

      if category
        collection = Occi::Parser::Text.categories(header.map { |k, v| v.to_s.split(',').collect { |w| "#{k}: #{w}" } }.flatten)
      else
        if entity_type == Occi::Core::Resource
          collection = Occi::Parser::Text.resource(header.map { |k, v| v.to_s.split(',').collect { |w| "#{k}: #{w}" } }.flatten)
        elsif entity_type == Occi::Core::Link
          collection = Occi::Parser::Text.link(header.map { |k, v| v.to_s.split(',').collect { |w| "#{k}: #{w}" } }.flatten)
        end
      end

      case media_type
        when 'text/uri-list'
          nil
        when 'text/occi'
          nil
        when 'text/plain', nil
          if category
            collection = Occi::Parser::Text.categories body
          else
            if entity_type == Occi::Core::Resource
              collection = Occi::Parser::Text.resource body
            elsif entity_type == Occi::Core::Link
              collection = Occi::Parser::Text.link body
            end
          end
        when 'application/occi+json', 'application/json'
          collection = Occi::Parser::Json.collection body
        when 'application/occi+xml', 'application/xml'
          collection = Occi::Parser::Xml.collection body
        when 'application/ovf', 'application/ovf+xml'
          collection = Occi::Parser::Ovf.collection body
        when 'application/ova'
          collection = Occi::Parser::Ova.collection body
        else
          raise "Content Type not supported"
      end
      collection
    end

    def self.locations(media_type, body, header)
      locations = Occi::Parser::Text.locations header.map { |k, v| v.to_s.split(',').collect { |w| "#{k}: #{w}" } }.flatten
      locations << header['Location'] if !header['Location'].nil? && header['Location'].any?
      case media_type
        when 'text/uri-list'
          locations << body.split("\n")
        when 'text/plain', nil
          locations << Occi::Parser::Text.locations(body)
        else
          nil
      end
      locations
    end

  end
end
