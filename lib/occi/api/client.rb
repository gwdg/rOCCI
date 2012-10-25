require 'rubygems'
require 'httparty'

module Occi
  class Client

    # HTTParty for raw HTTP requests
    include HTTParty
    # TODO: uncomment the following line as JSON is properly implemented in OpenStack
    # headers 'Accept' => 'application/occi+json,text/plain;q=0.8,text/occi;q=0.2'
    headers 'Accept' => 'text/plain,text/occi;q=0.2'

    # a few attributes which should be visible outside the client
    attr_reader :endpoint
    attr_reader :auth_options
    attr_accessor :media_type
    attr_reader :connected
    attr_accessor :model

    # hash mapping HTTP response codes to human-readable messages
    HTTP_CODES = {
        "100" => "Continue",
        "101" => "Switching Protocols",
        "200" => "OK",
        "201" => "Created",
        "202" => "Accepted",
        "203" => "Non-Authoritative Information",
        "204" => "No Content",
        "205" => "Reset Content",
        "206" => "Partial Content",
        "300" => "Multiple Choices",
        "301" => "Moved Permanently",
        "302" => "Found",
        "303" => "See Other",
        "304" => "Not Modified",
        "305" => "Use Proxy",
        "307" => "Temporary Redirect",
        "400" => "Bad Request",
        "401" => "Unauthorized",
        "402" => "Payment Required",
        "403" => "Forbidden",
        "404" => "Not Found",
        "405" => "Method Not Allowed",
        "406" => "Not Acceptable",
        "407" => "Proxy Authentication Required",
        "408" => "Request Time-out",
        "409" => "Conflict",
        "410" => "Gone",
        "411" => "Length Required",
        "412" => "Precondition Failed",
        "413" => "Request Entity Too Large",
        "414" => "Request-URI Too Large",
        "415" => "Unsupported Media Type",
        "416" => "Requested range not satisfiable",
        "417" => "Expectation Failed",
        "500" => "Internal Server Error",
        "501" => "Not Implemented",
        "502" => "Bad Gateway",
        "503" => "Service Unavailable",
        "504" => "Gateway Time-out",
        "505" => "HTTP Version not supported"
    }

    # @param [String] Endpoint URI
    # @param [Hash] Auth options
    # @param [Hash] Logging options
    # @param [Boolean] Enable autoconnect?
    # @return [Occi:Client] Client instance
    def initialize(endpoint = "http://localhost:3000/", auth_options = { :type => "none" }, log_options = { :out => STDERR, :level => Occi::Log::WARN, :logger => nil }, auto_connect = true, media_type = nil)
      # set Occi::Log
      set_logger log_options

      # pass auth options to HTTParty
      change_auth auth_options

      # check the validity and canonize the endpoint URI
      prepare_endpoint endpoint

      # get accepted media types from HTTParty
      set_media_type

      # force media_type if provided
      if media_type
        self.class.headers 'Accept' => media_type
        @media_type = media_type
      end

      Occi::Log.debug("Media Type: #{@media_type}")
      Occi::Log.debug("Headers: #{self.class.headers}")

      # get model information from the endpoint
      # and create Occi::Model instance
      set_model

      # auto-connect?
      @connected = auto_connect
    end

    # @param [String] Resource name or resource identifier
    # @return [Occi::Core::Entity] Resource instance
    def get_resource(resource_type)

      Occi::Log.debug("Instantiating #{resource_type} ...")

      if @model.get_by_id resource_type
        # we got a resource type identifier
        Occi::Core::Resource.new resource_type
      elsif @model.kinds.select { |kind| kind.term == resource_type }.any?
        # we got a resource type name
        Occi::Core::Resource.new @model.kinds.select { |kind| kind.term == resource_type }.first.type_identifier
      else
        raise "Unknown resource type! [#{resource_type}]"
      end

    end

    # @return [Array] List of available resource types in a human-readable format
    def get_resource_types
      Occi::Log.debug("Getting resource types ...")
      @model.kinds.collect { |kind| kind.term }
    end

    # @return [Array] List of available resource types in a Occi ID format
    def get_resource_type_identifiers
      Occi::Log.debug("Getting resource identifiers ...")
      @model.kinds.collect { |kind| kind.type_identifier }
    end

    # @param [String] Name of the mixin
    # @param [String] Type of the mixin
    # @param [Boolean] Should we describe the mixin or return its link?
    # @return [String, Occi:Collection] Link or mixin description
    def find_mixin(name, type = nil, describe = false)

      Occi::Log.debug("Looking for mixin #{name} + #{type} + #{describe}")

      # is type valid?
      unless type.nil?
        raise "Unknown mixin type! [#{type}]" unless @mixins.has_key? type.to_sym
      end

      # TODO: extend this code to support multiple matches and regex filters
      # should we look for links or descriptions?
      unless describe
        # we are looking for links
        # prefix mixin name with '#' to simplify the search
        name = "#" + name
        unless type
          # there is no type preference, return first global match
          @mixins.flatten(2).select { |mixin| mixin.to_s.reverse.start_with? name.reverse }.first
        else
          # return the first match with the selected type
          @mixins[type.to_sym].select { |mixin| mixin.to_s.reverse.start_with? name.reverse }.first
        end
      else
        # we are looking for descriptions
        unless type
          # try in os_tpls first
          found = get_os_templates.select { |mixin| mixin.term == name }.first

          # then try in resource_tpls
          unless found
            found = get_resource_templates.select { |template| template.term == name }.first
          end

          found
        else
          # get the first match from either os_tpls or resource_tpls
          case
            when type == "os_tpl"
              get_os_templates.select { |mixin| mixin.term == name }.first
            when type == "resource_tpl"
              get_resource_templates.select { |template| template.term == name }.first
            else
              nil
          end
        end
      end
    end

    # @param [String] Type of mixins to return
    # @return [Array] List of available mixins
    def get_mixins(type = nil)
      unless type.nil?
        # is type valid?
        raise "Unknown mixin type! #{type}" unless @mixins.has_key? type.to_sym

        # return mixin of the selected type
        @mixins[type.to_sym]
      else
        # we did not get a type, return all mixins
        mixins = []

        # flatten the hash and remove its keys
        get_mixin_types.each do |ltype|
          mixins.concat @mixins[ltype.to_sym]
        end

        mixins
      end
    end

    # @return [Array] List of available mixin types
    def get_mixin_types
      @mixins.keys.map! { |k| k.to_s }
    end

    # @return [Array] List of available mixin type identifiers
    def get_mixin_type_identifiers
      identifiers = []

      get_mixin_types.each do |mixin_type|
        identifiers << 'http://schemas.ogf.org/occi/infrastructure#' + mixin_type
      end

      identifiers
    end

    # @param [String] Occi resource type identifier or just type
    # @return [Array] List of links
    def list(resource_type_identifier=nil)
      if resource_type_identifier
        # convert type to type identifier
        resource_type_identifier = @model.kinds.select { |kind| kind.term == resource_type_identifier }.first.type_identifier if @model.kinds.select { |kind| kind.term == resource_type_identifier }.any?

        # check some basic pre-conditions
        raise "Endpoint is not connected!" unless @connected
        raise "Unkown resource type identifier! [#{resource_type_identifier}]" unless @model.get_by_id resource_type_identifier

        # split the type identifier and get the most important part
        uri_part = resource_type_identifier.split('#').last

        # request uri-list from the server
        path = uri_part + '/'
      else
        path = '/'
      end

      self.class.get(@endpoint + path, :headers => { "Accept" => 'text/uri-list' }).body.split("\n").compact
    end

    # @param [String] OCCI resource type identifier or just type
    # @return [Occi::Collection] List of descriptions
    def describe(resource_type_identifier=nil)

      # convert type to type identifier
      resource_type_identifier = @model.kinds.select { |kind| kind.term == resource_type_identifier }.first.type_identifier if @model.kinds.select { |kind| kind.term == resource_type_identifier }.any?

      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected

      descriptions = []

      if resource_type_identifier.nil?
        descriptions << get('/')
      elsif @model.get_by_id resource_type_identifier
        # we got type identifier
        # get all available resources of this type
        locations     = list resource_type_identifier

        # make the requests
        locations.each do |location|
          descriptions << get(sanitize_resource_link(location))
        end
      elsif resource_type_identifier.start_with? @endpoint
        # we got resource link
        # make the request
        descriptions << get(sanitize_resource_link(resource_type_identifier))
      else
        raise "Unkown resource type identifier! [#{resource_type_identifier}]"
      end

      descriptions
    end

    # @param [Occi::Core::Entity] Entity to be created on the server
    # @return [String] URI of the new resource
    def create(entity)

      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected
      raise "#{entity} not an entity" unless entity.kind_of? Occi::Core::Entity

      # is this entity valid?
      entity.check(@model)
      kind = @model.get_by_id(entity.kind)
      raise "No kind found for #{entity}" unless kind

      # get location for this kind of entity
      location   = @model.get_by_id(entity.kind).location
      collection = Occi::Collection.new

      # is this entity a Resource or a Link?
      collection.resources << entity if entity.kind_of? Occi::Core::Resource
      collection.links << entity if entity.kind_of? Occi::Core::Link

      # make the request
      post location, collection
    end

    # @param [String] Location of a OVF/OVA file
    # @return [String] URI of the new resource
    def deploy(location)
      media_types = self.class.head(@endpoint).headers['accept'].to_s
      raise "File #{location} does not exist" unless File.exist? location
      file        = File.read(location)
      if location.include? '.ovf'
        if media_types.include? 'application/ovf'
          headers                 = self.class.headers.clone
          headers['Content-Type'] = 'application/ovf'
          self.class.post(@endpoint + '/compute/',
                          :body    => file,
                          :headers => headers)
        end
      elsif location.include? '.ova'
        if media_types.include? ' application/ova '
          headers                 = self.class.headers.clone
          headers['Content-Type'] = 'application/ova'
          self.class.post(@endpoint + '/compute/',
                          :body    => file,
                          :headers => headers)
        end
      end
    end

    # @param [String] Resource link (URI)
    # @return [Boolean] Success?
    def delete(resource_type_identifier)
      # convert type to type identifier
      if @model.kinds.select { |kind| kind.term == resource_type_identifier }.any?
        type_identifier          = @model.kinds.select { |kind| kind.term == resource_type_identifier }.first.type_identifier
        location                 = @model.get_by_id(type_identifier).location
        resource_type_identifier = @endpoint + location
      end

      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected
      raise "Unknown resource identifier! #{resource_type_identifier}" unless resource_type_identifier.start_with? @endpoint

      # make the request
      del(sanitize_resource_link(resource_type_identifier))
    end

    # @param [String] Resource link (URI)
    # @param [String] Type of action
    # @return [String] Resource link (URI)
    def trigger(resource_type_identifier, action)
      # TODO: not tested
      if @model.kinds.select { |kind| kind.term == resource_type }.any?
        type_identifier          = @model.kinds.select { |kind| kind.term == resource_type_identifier }.first.type_identifier
        location                 = @model.get_by_id(type_identifier).location
        resource_type_identifier = @endpoint + location
      end
      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected
      raise "Unknown resource identifier! #{resource_type_identifier}" unless resource_type_identifier.start_with? @endpoint

      # encapsulate the acion in a collection
      collection   = Occi::Collection.new
      scheme, term = action.split(' #')
      collection.actions << Occi::Core::Action.new(scheme + '#', term)

      # make the request
      path = sanitize_resource_link(resource_type_identifier) + '?action=' + term
      post path, collection
    end

    def refresh
      # re-download the model from the server
      set_model
    end

    private

    # @param [Hash]
    def set_logger(log_options)

      if log_options[:logger].nil? or (not log_options[:logger].kind_of? Occi::Log)
        logger       = Occi::Log.new(log_options[:out])
        logger.level = log_options[:level]
      end

      self.class.debug_output $stderr if log_options[:level] == Occi::Log::DEBUG

    end

    # @param [Hash]
    def change_auth(auth_options)
      @auth_options = auth_options

      case @auth_options[:type]
        when "basic"
          # set up basic auth
          raise ArgumentError, "Missing required options 'username' and 'password' for basic auth!" unless @auth_options[:username] and @auth_options[:password]
          self.class.basic_auth @auth_options[:username], @auth_options[:password]
        when "digest"
          # set up digest auth
          raise ArgumentError, "Missing required options 'username' and 'password' for digest auth!" unless @auth_options[:username] and @auth_options[:password]
          self.class.digest_auth @auth_options[:username], @auth_options[:password]
        when "x509"
          # set up pem and optionally pem_password and ssl_ca_path
          raise ArgumentError, "Missing required option 'user_cert' for x509 auth!" unless @auth_options[:user_cert]
          raise ArgumentError, "The file specified in 'user_cert' does not exist!" unless File.exists? @auth_options[:user_cert]

          self.class.pem File.read(@auth_options[:user_cert]), @auth_options[:user_cert_password]
          self.class.ssl_ca_path @auth_options[:ca_path] unless @auth_options[:ca_path].nil? or @auth_options[:ca_path].empty?
        when "none", nil
          # do nothing
        else
          raise ArgumentError, "Unknown AUTH method [#{@auth_options[:type]}]!"
      end
    end

    # @param [String]
    # @param [Occi::Collection]
    # @return [Occi::Collection]
    def get(path='', filter=nil)
      # remove the leading slash
      path.gsub!(/\A\//, '')

      response = if filter
                   categories = filter.categories.collect { |category| category.to_text }.join(',')
                   attributes = filter.entities.collect { |entity| entity.attributes.combine.collect { |k, v| k + '=' + v } }.join(',')

                   headers                 = self.class.headers.clone
                   headers['Content-Type'] = 'text/occi'
                   headers['Category'] = categories unless categories.empty?
                   headers['X-OCCI-Attributes'] = attributes unless attributes.empty?

                   self.class.get(@endpoint + path, :headers => headers)
                 else
                   self.class.get(@endpoint + path)
                 end

      response_msg = response_message response
      raise "HTTP GET failed! #{response_msg}" unless response.code.between? 200, 300

      kind = @model.get_by_location(('/' + path).match(/\/.*\//).to_s) if @model
      kind ? entity_type = kind.entity_type : entity_type = nil
      _, collection = Occi::Parser.parse(response.content_type, response.body, path.include?('-/'), entity_type)

      collection
    end

    # @param [String]
    # @param [Occi::Collection]
    # @return [String]
    def post(path, collection)
      # remove the leading slash
      path.gsub!(/\A\//, '')

      response = if @media_type == 'application/occi+json'
                   self.class.post(@endpoint + path,
                                   :body    => collection.to_json,
                                   :headers => { 'Accept' => 'text/uri-list', 'Content-Type' => 'application/occi+json' })
                 elsif @media_type == 'text/occi'
                   self.class.post(@endpoint + path,
                                   :headers => collection.to_header.merge({ 'Accept' => 'text/uri-list', 'Content-Type' => 'text/occi' }))
                 else
                   self.class.post(@endpoint + path,
                                   :body    => collection.to_text,
                                   :headers => { 'Accept' => 'text/uri-list', 'Content-Type' => 'text/plain' })
                 end

      response_msg = response_message response
      raise "HTTP POST failed! #{response_msg}" unless response.code.between? 200, 300

      URI.parse(response.body).to_s
    end

    # @param [String]
    # @param [Occi::Collection]
    # @return [Occi::Collection]
    def put(path, collection)
      # remove the leading slash
      path.gsub!(/\A\//, '')

      response = if @media_type == 'application/occi+json'
                   self.class.post(@endpoint + path, :body => collection.to_json, :headers => { 'Content-Type' => 'application/occi+json' })
                 else
                   self.class.post(@endpoint + path, { :body => collection.to_text, :headers => { 'Content-Type' => 'text/plain' } })
                 end

      response_msg = response_message response
      raise "HTTP PUT failed! #{response_msg}" unless response.code.between? 200, 300

      _, collection = Occi::Parser.parse(response.content_type, response.body)

      collection
    end

    # @param [String]
    # @param [Occi::Collection]
    # @return [Boolean]
    def del(path, collection=nil)
      # remove the leading slash
      path.gsub!(/\A\//, '')

      response = self.class.delete(@endpoint + path)

      response_msg = response_message response
      raise "HTTP DELETE failed! #{response_msg}" unless response.code.between? 200, 300

      true
    end

    # @param [String]
    # @param [Occi::Core::Resource]
    # @param [URI,String]
    # @param [String]
    # @param [Occi::Core::Attributes]
    # @param [Array]
    # @return [Occi::Core::Link]
    def link(kind, source, target_location, target_kind, attributes=Occi::Core::Attributes.new, mixins=[])
      link            = Occi::Core::Link.new(kind)
      link.mixins     = mixins
      link.attributes = attributes
      link.target     = (target_location.kind_of? URI::Generic) ? target_location.path : target_location.to_s
      link.rel        = target_kind

      jj link
      link.check @model
      source.links << link
      link
    end

    # @param [String]
    # @return [String]
    def prepare_endpoint(endpoint)
      raise 'Endpoint not a valid URI' if (endpoint =~ URI::ABS_URI).nil?
      @endpoint = endpoint.chomp('/') + '/'
    end

    # @param [String]
    # @return [String]
    def sanitize_resource_link(resource_link)
      raise "Resource link #{resource_link} is not valid!" unless resource_link.start_with? @endpoint

      resource_link.gsub @endpoint, '/'
    end

    def set_model

      #
      model  = get('/-/')
      @model = Occi::Model.new(model)

      @mixins = {
          :os_tpl       => [],
          :resource_tpl => []
      }

      #
      get_os_templates.each do |os_tpl|
        @mixins[:os_tpl] << os_tpl.type_identifier unless os_tpl.nil? or os_tpl.type_identifier.nil?
      end

      #
      get_resource_templates.each do |res_tpl|
        @mixins[:resource_tpl] << res_tpl.type_identifier unless res_tpl.nil? or res_tpl.type_identifier.nil?
      end
    end

    # @return [Occi::Collection] collection including all registered OS templates
    def get_os_templates
      @model.get.mixins.select { |mixin| mixin.related.select { |rel| rel.end_with? 'os_tpl' }.any? }
    end

    # @return [Occi::Collection] collection including all registered resource templates
    def get_resource_templates
      @model.get.mixins.select { |mixin| mixin.related.select { |rel| rel.end_with? 'resource_tpl' }.any? }
    end

    # @return [String]
    def set_media_type
      media_types = self.class.head(@endpoint).headers['accept']
      Occi::Log.debug("Available media types: #{media_types}")
      @media_type = case media_types
                      when /application\/occi\+json/
                        'application/occi+json'
                      else
                        'text/plain'
                    end
    end

    # @param [HTTParty::Response]
    def response_message(response)
      'HTTP Response status: [' + response.code.to_s + '] ' + reason_phrase(response.code)
    end

    # @param [Integer]
    # @return [String]
    def reason_phrase(code)
      HTTP_CODES[code.to_s]
    end

  end
end
