module Occi
  module Parser
    module Text
      # Backwards compatibility for Ruby 1.8.7 and named groups in regular expressions
      if RUBY_VERSION =~ /1.8/
        require 'oniguruma'
        REGEXP = Oniguruma::ORegexp
      else
        REGEXP = Regexp
      end

      # Regular expressions
      REGEXP_QUOTED_STRING = /([^"\\\\]|\\\\.)*/
      REGEXP_LOALPHA = /[a-z]/
      REGEXP_DIGIT = /[0-9]/
      REGEXP_INT = /#{REGEXP_DIGIT}*/
      REGEXP_FLOAT = /#{REGEXP_DIGIT}*\.#{REGEXP_DIGIT}*/
      REGEXP_NUMBER = /#{REGEXP_INT}|#{REGEXP_FLOAT}/
      REGEXP_BOOL = /true|false/

      # Regular expressions for OCCI
      REGEXP_TERM = /#{REGEXP_LOALPHA}(#{REGEXP_LOALPHA}|-|_)*/
      REGEXP_SCHEME = /#{URI::ABS_URI_REF}#/
      REGEXP_TYPE_IDENTIFIER = /#{REGEXP_SCHEME}#{REGEXP_TERM}/
      REGEXP_CLASS = /action|mixin|kind/

      REGEXP_ATTR_COMPONENT = /#{REGEXP_LOALPHA}(#{REGEXP_LOALPHA}|#{REGEXP_DIGIT}|-|_)*/
      REGEXP_ATTRIBUTE_NAME = /#{REGEXP_ATTR_COMPONENT}(\.#{REGEXP_ATTR_COMPONENT})*/
      REGEXP_ATTRIBUTE_PROPERTY = /immutable|required/
      REGEXP_ATTRIBUTE_DEF = /(#{REGEXP_ATTRIBUTE_NAME})(\{#{REGEXP_ATTRIBUTE_PROPERTY}(\s+#{REGEXP_ATTRIBUTE_PROPERTY})*\})?/
      REGEXP_ATTRIBUTE_LIST = /#{REGEXP_ATTRIBUTE_DEF}(\s+#{REGEXP_ATTRIBUTE_DEF})*/
      REGEXP_ATTRIBUTE_REPR = /#{REGEXP_ATTRIBUTE_NAME}=("#{REGEXP_QUOTED_STRING}"|#{REGEXP_NUMBER}|#{REGEXP_BOOL})/

      REGEXP_ACTION = /#{REGEXP_TYPE_IDENTIFIER}/
      REGEXP_ACTION_LIST = /#{REGEXP_ACTION}(\s+#{REGEXP_ACTION})*/

      REGEXP_RESOURCE_TYPE = /#{REGEXP_TYPE_IDENTIFIER}(\s+#{REGEXP_TYPE_IDENTIFIER})*/
      REGEXP_LINK_INSTANCE = /#{URI::URI_REF}/
      REGEXP_LINK_TYPE = /#{REGEXP_TYPE_IDENTIFIER}(\s+#{REGEXP_TYPE_IDENTIFIER})*/

      # Regular expression for OCCI Categories
      REGEXP_CATEGORY = "Category:\\s*(?<term>#{REGEXP_TERM})" << # term (mandatory)
          ";\\s*scheme=\"(?<scheme>#{REGEXP_SCHEME})\"" << # scheme (mandatory)
          ";\\s*class=\"(?<class>#{REGEXP_CLASS})\"" << # class (mandatory)
          "(;\\s*title=\"(?<title>#{REGEXP_QUOTED_STRING})\")?" << # title (optional)
          "(;\\s*rel=\"(?<rel>#{REGEXP_TYPE_IDENTIFIER})\")?"<< # rel (optional)
          "(;\\s*location=\"(?<location>#{URI::URI_REF})\")?" << # location (optional)
          "(;\\s*attributes=\"(?<attributes>#{REGEXP_ATTRIBUTE_LIST})\")?" << # attributes (optional)
          "(;\\s*actions=\"(?<actions>#{REGEXP_ACTION_LIST})\")?" << # actions (optional)
          ';?' # additional semicolon at the end (not specified, for interoperability)

      # Regular expression for OCCI Link Instance References
      REGEXP_LINK = "Link:\\s*\\<(?<uri>#{URI::URI_REF})\\>" << # uri (mandatory)
          ";\\s*rel=\"(?<rel>#{REGEXP_RESOURCE_TYPE})\"" << # rel (mandatory)
          "(;\\s*self=\"(?<self>#{REGEXP_LINK_INSTANCE})\")?" << # self (optional)
          "(;\\s*category=\"(?<category>#{REGEXP_LINK_TYPE})\")?" << # category (optional)
          "(?<attributes>(;\\s*(#{REGEXP_ATTRIBUTE_REPR}))*)" << # attributes (optional)
          ';?' # additional semicolon at the end (not specified, for interoperability)

      # Regular expression for OCCI Entity Attributes
      REGEXP_ATTRIBUTE = "X-OCCI-Attribute:\\s*(?<name>#{REGEXP_ATTRIBUTE_NAME})=(\"(?<string>#{REGEXP_QUOTED_STRING})\"|(?<number>#{REGEXP_NUMBER})|(?<bool>#{REGEXP_BOOL}))" <<
          ';?' # additional semicolon at the end (not specified, for interoperability)

      # Regular expression for OCCI Location
      REGEXP_LOCATION = "X-OCCI-Location:\\s*(?<location>#{URI::URI_REF})" <<
          ';?' # additional semicolon at the end (not specified, for interoperability)


      def self.categories(lines)
        collection = Occi::Collection.new
        lines.each do |line|
          line.strip!
          category = self.category(line) if line.start_with? 'Category:'
          collection << category if category.kind_of? Occi::Core::Category
        end
        collection
      end

      def self.resource(lines)
        collection = Occi::Collection.new
        resource = Occi::Core::Resource.new
        lines.each do |line|
          line.strip!
          case line
            when /^Category:/
              category = self.category(line)
              resource.kind = category if category.kind_of? Occi::Core::Kind
              resource.mixins << category if category.kind_of? Occi::Core::Mixin
            when /^X-OCCI-Attribute:/
              resource.attributes.merge! self.attribute(line)
            when /^Link:/
              resource.links << self.link_string(line, resource)
          end
        end
        collection << resource if resource.kind_of? Occi::Core::Resource
        collection
      end

      def self.link(lines)
        collection = Occi::Collection.new
        link = Occi::Core::Link.new
        lines.each do |line|
          line.strip!
          case line
            when /^Category:/
              category = self.category(line)
              link.kind = category if category.kind_of? Occi::Core::Kind
              link.mixins << category if category.kind_of? Occi::Core::Mixin
            when /^X-OCCI-Attribute:/
              link.attributes.merge! self.attribute(line)
          end
        end
        collection << link if link.kind_of? Occi::Core::Link
        collection
      end

      def self.locations(lines)
        locations = []
        lines.each do |line|
          line.strip!
          locations << self.location(line) if line.start_with? 'X-OCCI-Location:'
        end
        locations
      end

      private

      def self.category(string)
        # create regular expression from regexp string
        regexp = REGEXP.new(REGEXP_CATEGORY)
        # match string to regular expression
        match = regexp.match string

        raise "could not match #{string}" unless match

        term = match[:term]
        scheme = match[:scheme]
        title = match[:title]
        related = match[:rel].to_s.split
        if match[:attributes]
          attributes = Hashie::Mash.new
          match[:attributes].split.each do |attribute|
            property_string = attribute[/#{REGEXP_ATTRIBUTE_DEF}/, -2]
            properties = Occi::Core::AttributeProperties.new
            if property_string
              properties.required = true if property_string.include? 'required'
              properties.mutable = false if property_string.include? 'immutable'
            end
            name = attribute[/#{REGEXP_ATTRIBUTE_DEF}/, 1]
            attributes.merge! name.split('.').reverse.inject(properties) { |a, n| {n => a} }
          end
        end
        actions = match[:actions].to_s.split
        location = match[:location]
        case match[:class]
          when 'kind'
            Occi::Core::Kind.new scheme, term, title, attributes, related, actions, location
          when 'mixin'
            Occi::Core::Mixin.new scheme, term, title, attributes, related, actions, location
          when 'action'
            Occi::Core::Action.new scheme, term, title, attributes
          else
            raise "Category with class #{match[:class]} not recognized in string: #{string}"
        end
      end

      def self.attribute(string)
        # create regular expression from regexp string
        regexp = REGEXP.new(REGEXP_ATTRIBUTE)
        # match string to regular expression
        match = regexp.match string

        raise "could not match #{string}" unless match

        value = match[:string] if match[:string]
        value = match[:number].to_i if match[:number]
        value = match[:bool] == "true" if match[:bool]
        Occi::Core::Attributes.split match[:name] => value
      end

      def self.link_string(string, source)
        # create regular expression from regexp string
        regexp = REGEXP.new(REGEXP_LINK)
        # match string to regular expression
        match = regexp.match string

        raise "could not match #{string}" unless match

        categories = match[:category].split
        kind = categories.shift
        mixins = categories
        actions = nil
        rel = match[:rel]
        target = match[:uri]
        location = match[:self]

        # create an array of the list of attributes
        attributes = match[:attributes].sub(/^\s*;\s*/, '').split ';'
        # parse each attribute and create an OCCI Attribute object from it
        attributes = attributes.inject(Occi::Core::Attributes.new) { |hsh, attribute| hsh.merge!(Occi::Parser::Text.attribute('X-OCCI-Attribute: ' + attribute)) }
        Occi::Core::Link.new kind, mixins, attributes, actions, rel, target, source, location
      end

      def self.location(string)
        # create regular expression from regexp string
        regexp = REGEXP.new(REGEXP_LOCATION)
        # match string to regular expression
        match = regexp.match string

        raise "could not match #{string}" unless match

        match[:location]
      end

    end
  end
end