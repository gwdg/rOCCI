require 'rubygems'
require 'httparty'

module OCCI
  class Client

    # HTTParty for raw HTTP requests
    include HTTParty
    headers 'Accept' => 'application/occi+json,text/plain;q=0.5'

    # a few attributes which should be visible outside the client
    attr_reader :endpoint
    attr_reader :auth_options
    attr_reader :media_type
    attr_reader :connected
    attr_reader :model

    # hash mapping human-readable resource names to OCCI identifiers
    # TODO: get resources dynamically from the model
    RESOURCES = {
      :compute => "http://schemas.ogf.org/occi/infrastructure#compute",
      :storage => "http://schemas.ogf.org/occi/infrastructure#storage",
      :network => "http://schemas.ogf.org/occi/infrastructure#network"
    }

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
    # @return [OCCI:Client] Client instance
    def initialize(endpoint = "http://localhost:3000/", auth_options = {:type => "none"}, log_options = { :out => STDERR, :level => OCCI::Log::WARN, :logger => nil}, auto_connect = true, media_type = nil)
      # set OCCI::Log
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

      OCCI::Log.debug("Media Type: #{@media_type}")
      OCCI::Log.debug("Headers: #{self.class.headers}")

      # get model information from the endpoint
      # and create OCCI::Model instance
      set_model

      # auto-connect?
      @connected = auto_connect
    end

    # @param [String] Resource name or resource identifier
    # @return [OCCI::Core::Entity] Resource instance
    def get_resource(resource_type)

      OCCI::Log.debug("Instantiating #{resource_type} ...")

      if RESOURCES.has_value? resource_type
        # we got a resource type identifier
        OCCI::Core::Resource.new resource_type
      elsif RESOURCES.has_key? resource_type.to_sym
        # we got a resource type name
        OCCI::Core::Resource.new get_resource_type_identifier(resource_type)
      else
        raise "Unknown resource type! [#{resource_type}]"
      end

    end

    # @return [Array] List of available resource types in a human-readable format
    def get_resource_types
      OCCI::Log.debug("Getting resource types ...")
      RESOURCES.keys.map! { |k| k.to_s }
    end

    # @return [Array] List of available resource types in a OCCI ID format
    def get_resource_type_identifiers
      OCCI::Log.debug("Getting resource identifiers ...")
      RESOURCES.values
    end

    # @param [String] Name of the mixin
    # @param [String] Type of the mixin
    # @param [Boolean] Should we describe the mixin or return its link?
    # @return [String, OCCI:Collection] Link or mixin description
    def find_mixin(name, type = nil, describe = false)

      OCCI::Log.debug("Looking for mixin #{name} + #{type} + #{describe}")

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
        get_mixin_types.each do |type|
          mixins.concat @mixins[type.to_sym]
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

    # @param [String] Human-readable name of the resource
    # @return [String] OCCI resource identifier
    def get_resource_type_identifier(resource_type)
      raise "Unknown resource type! [#{resource_type}]" unless RESOURCES.has_key? resource_type.to_sym

      RESOURCES[resource_type.to_sym]
    end

    # @param [String] OCCI resource identifier
    # @return [String] Human-readable name of the resource
    def get_resource_type(resource_type_identifier)
      raise "Unknown resource type identifier! [#{resource_type_identifier}]" unless RESOURCES.has_value? resource_type_identifier

      RESOURCES.key(resource_type_identifier).to_s
    end

    # @param [String] OCCI resource type identifier or just type
    # @return [Array] List of links
    def list(resource_type_identifier)

      # convert type to type identifier
      unless resource_type_identifier.start_with? "http://" or resource_type_identifier.start_with? "https://"
        resource_type_identifier = get_resource_type_identifier resource_type_identifier
      end

      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected
      raise "Unkown resource type identifier! [#{resource_type_identifier}]" unless RESOURCES.has_value? resource_type_identifier

      # split the type identifier and get the most important part
      uri_part = resource_type_identifier.split('#').last

      list = []

      # request uri-list from the server
      path = uri_part + '/'
      list = self.class.get(@endpoint + path, :headers => { "Accept" => 'text/uri-list' }).body.split("\n").compact

      list
    end

    # @param [String] OCCI resource type identifier or just type
    # @return [OCCI::Collection] List of descriptions
    def describe(resource_identifier)

      # convert type to type identifier
      unless resource_identifier.start_with? "http://" or resource_identifier.start_with? "https://"
        resource_identifier = get_resource_type_identifier resource_identifier
      end

      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected

      descriptions = nil

      if RESOURCES.has_value? resource_identifier
        # we got type identifier
        # split the type identifier
        uri_part = resource_identifier.split('#').last
        # make the request
        descriptions = get(uri_part + '/')
      elsif resource_identifier.start_with? @endpoint
        # we got resource link
        # make the request
        descriptions = get(sanitize_resource_link(resource_identifier))
      else
        raise "Unkown resource identifier! [#{resource_identifier}]"
      end

      descriptions
    end

    # @param [OCCI::Core::Entity] Entity to be created on the server
    # @return [String] Link (URI) or the new resource
    def create(entity)

      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected
      raise "#{entity} not an entity" unless entity.kind_of? OCCI::Core::Entity

      # is this entity valid?
      entity.check(@model)
      kind = @model.get_by_id(entity.kind)
      raise "No kind found for #{entity}" unless kind

      # get location for this kind of entity
      location   = @model.get_by_id(entity.kind).location
      collection = OCCI::Collection.new

      # is this entity a Resource or a Link?
      collection.resources << entity if entity.kind_of? OCCI::Core::Resource
      collection.links << entity if entity.kind_of? OCCI::Core::Link

      # make the request
      post location, collection
    end

    # @param [String] Resource link (URI)
    # @return [Boolean] Success?
    def delete(resource_identifier)
      # TODO: delete should work for entire resource types
      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected
      raise "Unknown resource identifier! #{resource_identifier}" unless resource_identifier.start_with? @endpoint

      # make the request
      del(sanitize_resource_link(resource_identifier))
    end

    # @param [String] Resource link (URI)
    # @param [String] Type of action
    # @return [String] Resource link (URI)
    def trigger(resource_identifier, action)
      # TODO: not tested
      # check some basic pre-conditions
      raise "Endpoint is not connected!" unless @connected
      raise "Unknown resource identifier! #{resource_identifier}" unless resource_identifier.start_with? @endpoint

      # encapsulate the acion in a collection
      collection = OCCI::Collection.new
      collection.actions << action

      # make the request
      post sanitize_resource_link(resource_identifier), collection
    end

    def refresh
      # re-download the model from the server
      set_model
    end

    # @param [OCCI::Core::Resource] Compute instance
    # @param [URI,String] Storage location (URI)
    # @param [OCCI::Core::Attributes] Attributes
    # @param [Array] Mixins
    # @return [OCCI::Core::Link] Link instance
    def storagelink(compute, storage_location, attributes=OCCI::Core::Attributes.new, mixins=[])
      kind         = 'http://schemas.ogf.org/occi/infrastructure#storagelink'
      storage_kind = 'http://schemas.ogf.org/occi/infrastructure#storage'
      storagelink  = link(kind, compute, storage_location, storage_kind, attributes, mixins)

      storagelink
    end

    # @param [OCCI::Core::Resource] Compute instance
    # @param [URI,String] Network location (URI)
    # @param [OCCI::Core::Attributes] Attributes
    # @param [Array] Mixins
    # @return [OCCI::Core::Link] Link instance
    def networkinterface(compute, network_location, attributes=OCCI::Core::Attributes.new, mixins=[])
      kind             = 'http://schemas.ogf.org/occi/infrastructure#networkinterface'
      network_kind     = 'http://schemas.ogf.org/occi/infrastructure#network'
      networkinterface = link(kind, compute, network_location, network_kind, attributes, mixins)

      networkinterface
    end

    private

    # @param [Hash]
    def set_logger(log_options)

      if log_options[:logger].nil? or not (log_options[:logger].kind_of? OCCI::Log)
        logger = OCCI::Log.new(log_options[:out])
        logger.level = log_options[:level]
      end

      self.class.debug_output $stderr if log_options[:level] == OCCI::Log::DEBUG

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
    # @param [OCCI::Collection]
    # @return [OCCI::Collection]
    def get(path='', filter=nil)
      path     = path.reverse.chomp('/').reverse
      response = if filter
        categories = filter.categories.collect { |category| category.to_text }.join(',')
        attributes = filter.entities.collect { |entity| entity.attributes.combine.collect { |k, v| k + '=' + v } }.join(',')
        self.class.get(@endpoint + path,
                       :headers => { 'Accept' => self.class.headers['Accept'],
                                     'Content-Type'      => 'text/occi',
                                     'Category'          => categories,
                                     'X-OCCI-Attributes' => attributes })
      else
        self.class.get(@endpoint + path)
      end

      response_msg = response_message response
      raise "HTTP GET failed! #{response_msg}" unless response.code.between? 200, 300

      kind = @model.get_by_location path if @model
      kind ? entity_type = kind.entity_type : entity_type = nil
      _, collection = OCCI::Parser.parse(response.content_type, response.body, path.include?('/-/'), entity_type)

      collection
    end

    # @param [String]
    # @param [OCCI::Collection]
    # @return [String]
    def post(path, collection)
      path     = path.reverse.chomp('/').reverse
      response = if @media_type == 'application/occi+json'
        self.class.post(@endpoint + path,
                        :body    => collection.to_json,
                        :headers => { 'Accept' => 'text/uri-list', 'Content-Type' => 'application/occi+json' })
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
    # @param [OCCI::Collection]
    # @return [OCCI::Collection]
    def put(path, collection)
      path     = path.reverse.chomp('/').reverse
      response = if @media_type == 'application/occi+json'
        self.class.post(@endpoint + path, :body => collection.to_json, :headers => { 'Content-Type' => 'application/occi+json' })
      else
        self.class.post(@endpoint + path, { :body => collection.to_text, :headers => { 'Content-Type' => 'text/plain' } })
      end

      response_msg = response_message response
      raise "HTTP PUT failed! #{response_msg}" unless response.code.between? 200, 300

      _, collection = OCCI::Parser.parse(response.content_type, response.body)

      collection
    end

    # @param [String]
    # @param [OCCI::Collection]
    # @return [Boolean]
    def del(path, collection=nil)
      path     = path.reverse.chomp('/').reverse
      response = self.class.delete(@endpoint + path)

      response_msg = response_message response
      raise "HTTP DELETE failed! #{response_msg}" unless response.code.between? 200, 300

      true
    end

    # @param [String]
    # @param [OCCI::Core::Resource]
    # @param [URI,String]
    # @param [String]
    # @param [OCCI::Core::Attributes]
    # @param [Array]
    # @return [OCCI::Core::Link]
    def link(kind, source, target_location, target_kind, attributes=OCCI::Core::Attributes.new, mixins=[])
      link            = OCCI::Core::Link.new(kind)
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
      @model = OCCI::Model.new(model)

      @mixins = {
        :os_tpl => [],
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

    # @return [OCCI::Collection] collection including all registered OS templates
    def get_os_templates
      filter        = OCCI::Collection.new
      # use the os_tpl mixin as filter for the request
      filter.mixins = @model.get.mixins.select { |mixin| mixin.term == 'os_tpl' }
      collection    = get('/-/', filter)
      # remove os_tpl mixin from the mixins as it does not represent a template itself
      collection.mixins.select { |mixin| mixin.term != 'os_tpl' }
    end

    # @return [OCCI::Collection] collection including all registered resource templates
    def get_resource_templates
      filter        = OCCI::Collection.new
      # use the resource_tpl mixin as filter for the request
      filter.mixins = @model.get.mixins.select { |mixin| mixin.term == 'resource_tpl' }
      collection    = get('/-/', filter)
      # remove os_tpl mixin from the mixins as it does not represent a template itself
      collection.mixins.select { |mixin| mixin.term != 'resource_tpl' }
    end

    # @return [String]
    def set_media_type
      media_types = self.class.head(@endpoint).headers['accept']
      OCCI::Log.debug("Available media types: #{media_types}")
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
