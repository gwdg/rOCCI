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

    # hash mapping human-readable resource names to OCCI identifiers
    RESOURCES = { 
			:compute => "http://schemas.ogf.org/occi/infrastructure#compute",
			:storage => "http://schemas.ogf.org/occi/infrastructure#storage",
			:network => "http://schemas.ogf.org/occi/infrastructure#network",
      :os_tpl => "http://schemas.ogf.org/occi/infrastructure#os_tpl",
      :resource_tpl => "http://schemas.ogf.org/occi/infrastructure#resource_tpl"
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
		# @param [Hash] Auth options, x509|basic|digest|none
		# @param [IO, File] Target for logging messages
    # @return [OCCI::Client] OCCI client instance
		def self.get_client(endpoint = "http://localhost:3000/", auth_options = {:type => "none"}, log_dev=STDOUT)
			self.new endpoint, auth_options, log_dev, true
		end

    # @param [String] Resource name or resource identifier
    # @return [OCCI::Core::Resource] Resource instance
    def get_instance(resource_type)
      
      if RESOURCES.has_value? resource_type
        OCCI::Core::Resource.new resource_type
      elsif RESOURCES.has_key? resource_type.to_sym
        OCCI::Core::Resource.new get_resource_type_identifier(resource_type) 
      else
        raise "Unknown resource type! [#{resource_type}]"
      end

    end

    # @return [Array] List of available resource types in a human-readable format
    def get_resource_types
      RESOURCES.keys.map! { |k| k.to_s }
    end

    # @return [Array] List of available resource types in a OCCI ID format
    def get_resource_type_identifiers
      RESOURCES.values
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

    # @param [String] 
    # @return [Array]
		def list(resource_type_identifier)
			raise "Endpoint is not connected!" unless @connected
      raise "Unkown resource type identifier! [#{resource_type_identifier}]" unless RESOURCES.has_value? resource_type_identifier

      uri_part = resource_type_identifier.split('#').last

      list = []

      case uri_part 
        when "os_tpl", "resource_tpl"
          @mixins[uri_part.to_sym].each do |mixin|
            list << mixin unless mixin.nil?
          end
        else
          path = uri_part + '/'
          list = self.class.get(@endpoint + path, :headers => { "Accept" => 'text/uri-list' }).body.split("\n").compact
      end

      list
		end

    # @param [String]
    # @return [OCCI::Collection]
		def describe(resource_type_identifier)
			raise "Endpoint is not connected!" unless @connected

      uri_part = resource_type_identifier.split('#').last

      descriptions = nil

      if @mixins[:os_tpl].include? resource_type_identifier
        descriptions = get_os_templates.mixins.select { |mixin| mixin.term == uri_part }
      elsif @mixins[:resource_tpl].include? resource_type_identifier
        descriptions = get_os_templates.mixins.select { |mixin| mixin.term == uri_part }
      elsif resource_type_identifier == RESOURCES[:os_tpl]
        descriptions = get_os_templates
      elsif resource_type_identifier == RESOURCES[:resource_tpl]
        descriptions = get_resource_templates
      elsif RESOURCES.has_value? resource_type_identifier
        descriptions = get(uri_part + '/')
      elsif resource_type_identifier.start_with? @endpoint
        descriptions = get(resource_type_identifier)
      else
        raise "Unkown resource type identifier! [#{resource_type_identifier}]"
      end

      descriptions
		end

    # @param [OCCI::Core::Resource]
    # @return [String]
		def create
			raise "Endpoint is not connected!" unless @connected
		end

    # @param [String]
		def delete
			raise "Endpoint is not connected!" unless @connected
		end

    # @param []
    # @param [String]
		def trigger
			raise "Endpoint is not connected!" unless @connected
		end

    def refresh
      set_model
    end

    # @param [OCCI::Core::Resource] compute
    # @param [URI,String] storage_location
    # @param [OCCI::Core::Attributes] attributes
    # @param [Array] mixins
    # @return [OCCI::Core::Link]
    def storagelink(compute, storage_location, attributes=OCCI::Core::Attributes.new, mixins=[])
      kind         = 'http://schemas.ogf.org/occi/infrastructure#storagelink'
      storage_kind = 'http://schemas.ogf.org/occi/infrastructure#storage'
      storagelink  = link(kind, compute, storage_location, storage_kind, attributes, mixins)
      
      storagelink
    end

    # @param [OCCI::Core::Resource] compute
    # @param [URI,String] network_location
    # @param [OCCI::Core::Attributes] attributes
    # @param [Array] mixins
    # @return [OCCI::Core::Link]
    def networkinterface(compute, network_location, attributes=OCCI::Core::Attributes.new, mixins=[])
      kind             = 'http://schemas.ogf.org/occi/infrastructure#networkinterface'
      network_kind     = 'http://schemas.ogf.org/occi/infrastructure#network'
      networkinterface = link(kind, compute, network_location, network_kind, attributes, mixins)
      
      networkinterface
    end

		private

		# @param [String]
		# @param [Hash]
		# @param [IO, File]
		def initialize(endpoint = "http://localhost:3000/", auth_options = {:type => "none"}, log_dev=STDOUT, auto_connect = false)
			# set OCCI:Log output to log_dev
			OCCI::Log.new(log_dev)

			@connected = auto_connect

			# pass auth options to HTTParty
			change_auth auth_options

			# check the validity and canonize the endpoint URI 
			prepare_endpoint endpoint

			# get model information from the endpoint
			# and create OCCI::Model instance
			set_model

			# get accepted media types from HTTParty
			set_media_type
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

    # @param [String] path
    # @param [OCCI::Collection] filter
    # @return [OCCI::Collection]
    def get(path='', filter=nil)
      path     = path.reverse.chomp('/').reverse
      response = if filter
                   categories = filter.categories.collect { |category| category.to_text }.join(',')
                   attributes = filter.entities.collect { |entity| entity.attributes.combine.collect { |k, v| k + '=' + v } }.join(',')
                   self.class.get(@endpoint + path,
                                  :headers => { 'Accept'            => 'application/occi+json,text/plain;q=0.5',
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

    # @param [String] path
    # @param [OCCI::Collection] collection
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

    # @param [String] path
    # @param [OCCI::Collection] collection
    # @return [OCCI::Collection]
    def put(path, collection)
      path     = path.reverse.chomp('/').reverse
      response = if @media_type == 'application/occi+json'
                   self.class.post(@endpoint + path, :body => collection.to_json, :headers => { 'Accept' => 'application/occi+json,text/plain;q=0.5', 'Content-Type' => 'application/occi+json' })
                 else
                   self.class.post(@endpoint + path, { :body => collection.to_text, :headers => { 'Accept' => 'application/occi+json,text/plain;q=0.5', 'Content-Type' => 'text/plain' } })
                 end

      response_msg = response_message response
      raise "HTTP PUT failed! #{response_msg}" unless response.code.between? 200, 300

      _, collection = OCCI::Parser.parse(response.content_type, response.body)
      
      collection
    end

    # @param [String] path
    # @param [OCCI::Collection] collection
    # @return [String]
    def delete(path, collection=nil)
      path     = path.reverse.chomp('/').reverse
      response = self.class.delete(@endpoint + path)

      response_msg = response_message response
      raise "HTTP DELETE failed! #{response_msg}" unless response.code.between? 200, 300

      response_msg
    end

    # @param [String] kind
    # @param [OCCI::Core::Resource] source
    # @param [URI,String] target_location
    # @param [String] target_kind
    # @param [OCCI::Core::Attributes] attributes
    # @param [Array] mixins
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

    # @param [HTTParty::Response] response
    def response_message(response)
      'HTTP Response status: [' + response.code.to_s + '] ' + reason_phrase(response.code)
    end

    # @param [Integer] code
    # @return [String] HTTP status reason
    def reason_phrase(code)
      HTTP_CODES[code.to_s]
    end

	end
end