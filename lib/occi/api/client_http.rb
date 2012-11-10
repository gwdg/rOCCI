require 'rubygems'
require 'httparty'

module Occi
  module API
    class ClientHttp

      #
      include Occi::API::ClientCommon

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

      # Initializes client data structures and retrieves OCCI model
      # from the server.
      #
      # @example
      #    Occi::API::Client.new # => #<Occi::API::Client>
      #
      # @param [String] endpoint URI
      # @param [Hash] auth options in a hash
      # @param [Hash] logging options in a hash
      # @param [Boolean] enable autoconnect
      # @param [String] media type identifier
      # @return [Occi::API::Client] client instance
      def initialize(endpoint = "http://localhost:3000/", auth_options = { :type => "none" },
                     log_options = { :out => STDERR, :level => Occi::Log::WARN, :logger => nil },
                     auto_connect = true, media_type = nil)
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

      private

      # Sets the logger and log levels. This allows users to pass existing logger
      # instances to the rOCCI client.
      #
      # @example
      #    set_logger { :out => STDERR, :level => Occi::Log::WARN, :logger => nil }
      #
      # @param [Hash] logger options
      def set_logger(log_options)
        if log_options[:logger].nil? or (not log_options[:logger].kind_of? Occi::Log)
          logger       = Occi::Log.new(log_options[:out])
          logger.level = log_options[:level]
        end

        self.class.debug_output $stderr if log_options[:level] == Occi::Log::DEBUG
      end

      # Sets auth method and appropriate httparty attributes. Supported auth methods
      # are: ["basic", "digest", "x509", "none"] 
      #
      # @example
      #    change_auth { :type => "none" }
      #    change_auth { :type => "basic", :username => "123", :password => "321" }
      #    change_auth { :type => "digest", :username => "123", :password => "321" }
      #    change_auth { :type => "x509", :user_cert => "~/cert.pem",
      #                  :user_cert_password => "321", :ca_path => nil }
      #
      # @param [Hash] authentication options
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

      # Performs GET request and parses the responses to collections.
      #
      # @example
      #    get "/-/" # => #<Occi::Collection>
      #    get "/compute/" # => #<Occi::Collection>
      #    get "/compute/fs65g4fs6g-sf54g54gsf-aa12faddf52" # => #<Occi::Collection>
      #
      # @param [String] path for the GET request
      # @param [Occi::Collection] collection of filters
      # @return [Occi::Collection] parsed result of the request
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

        Occi::Log.debug "Response location: #{('/' + path).match(/\/.*\//).to_s}"
        kind = @model.get_by_location(('/' + path).match(/\/.*\//).to_s) if @model

        Occi::Log.debug "Response kind: #{kind}"

        if kind
          kind.related_to? Occi::Core::Resource ? entity_type = Occi::Core::Resource : entity_type = nil
          entity_type = Occi::Core::Link if kind.related_to? Occi::Core::Link
        end

        Occi::Log.debug "Parser call: #{response.content_type} #{entity_type} #{path.include?('-/')}"
        _, collection = Occi::Parser.parse(response.content_type, response.body, path.include?('-/'), entity_type)

        # parse Links for Resource
        #if entity_type == Occi::Core::Resource
        #  _, link_collection = Occi::Parser.parse(response.content_type, response.body, false, Occi::Core::Link)
        #  collection.links.merge link_collection.links
        #end

        Occi::Log.debug "Parsed collection: empty? #{collection.empty?}"
        collection
      end

      # Performs POST requests and returns URI locations. Resource data must be provided
      # in an Occi::Collection instance.
      #
      # @example
      #    collection = Occi::Collection.new
      #    collection.resources << entity if entity.kind_of? Occi::Core::Resource
      #    collection.links << entity if entity.kind_of? Occi::Core::Link
      #
      #    post "/compute/", collection # => "http://localhost:3300/compute/23sf4g65as-asdgsg2-sdfgsf2g"
      #    post "/network/", collection # => "http://localhost:3300/network/23sf4g65as-asdgsg2-sdfgsf2g"
      #    post "/storage/", collection # => "http://localhost:3300/storage/23sf4g65as-asdgsg2-sdfgsf2g"
      #
      # @param [String] path for the POST request
      # @param [Occi::Collection] resource data to be POSTed
      # @return [String] URI location
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

      # Performs PUT requests and parses responses to collections.
      #
      # @example
      #    TODO: add examples
      #
      # @param [String] path for the PUT request
      # @param [Occi::Collection] resource data to send
      # @return [Occi::Collection] parsed result of the request
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

      # Performs DELETE requests and returns True on success.
      #
      # @example
      #    del "/compute/65sf4g65sf4g-sf6g54sf5g-sfgsf32g3" # => true
      #
      # @param [String] path for the DELETE request
      # @param [Occi::Collection] collection of filters (currently NOT used)
      # @return [Boolean] status
      def del(path, filter=nil)
        # remove the leading slash
        path.gsub!(/\A\//, '')

        response = self.class.delete(@endpoint + path)

        response_msg = response_message response
        raise "HTTP DELETE failed! #{response_msg}" unless response.code.between? 200, 300

        true
      end

      # Creates a link of a specified kind and binds it to the given resource.
      #
      # @example
      #    link_kind = 'http://schemas.ogf.org/occi/infrastructure#storagelink'
      #    compute = client.get_resource "compute"
      #    storage_location = "http://localhost:3300/storage/321df21adfad-f3adfa5f4adf-a3d54ffadffe"
      #    linked_resource_kind = 'http://schemas.ogf.org/occi/infrastructure#storage'
      #
      #    link link_kind, compute, storage_location, linked_resource_kind
      #
      # @param [String] link type identifier (link kind)
      # @param [Occi::Core::Resource] resource to link to
      # @param [URI, String] resource to be linked
      # @param [String] type identifier of the linked resource
      # @param [Occi::Core::Attributes] link attributes
      # @param [Array<String>] link mixins
      # @return [Occi::Core::Link] link instance 
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

      # Checks whether the given endpoint URI is valid and adds a trailing
      # slash if necessary.
      #
      # @example 
      #    prepare_endpoint "http://localhost:3300" # => "http://localhost:3300/"
      #
      # @param [String] endpoint URI in a non-canonical string 
      # @return [String] canonical endpoint URI in a string, with a trailing slash
      def prepare_endpoint(endpoint)
        raise 'Endpoint not a valid URI' if (endpoint =~ URI::ABS_URI).nil?
        @endpoint = endpoint.chomp('/') + '/'
      end

      # Extracts the resource path from a resource link. It will remove the leading @endpoint
      # and replace it with a slash.
      #
      # @example
      #    sanitize_resource_link "http://localhost:3300/compute/35ad4f45gsf-gsfg524s6gsfg-sfgsf4gsfg"
      #     # => "/compute/35ad4f45gsf-gsfg524s6gsfg-sfgsf4gsfg"
      #
      # @param [String] string containing the full resource link
      # @return [String] extracted path, with a leading slash
      def sanitize_resource_link(resource_link)
        raise "Resource link #{resource_link} is not valid!" unless resource_link.start_with? @endpoint

        resource_link.gsub @endpoint, '/'
      end

      # Creates an Occi::Model from data retrieved from the server.
      #
      # @example
      #    set_model
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

      # Retrieves available os_tpls from the model.
      #
      # @example
      #    get_os_templates # => #<Occi::Collection>
      #
      # @return [Occi::Collection] collection containing all registered OS templates
      def get_os_templates
        @model.get.mixins.select { |mixin| mixin.related.select { |rel| rel.end_with? 'os_tpl' }.any? }
      end

      # Retrieves available resource_tpls from the model.
      #
      # @example
      #    get_resource_templates # => #<Occi::Collection>
      #
      # @return [Occi::Collection] collection containing all registered resource templates
      def get_resource_templates
        @model.get.mixins.select { |mixin| mixin.related.select { |rel| rel.end_with? 'resource_tpl' }.any? }
      end

      # Sets media type. Will choose either application/occi+json or text/plain
      # based on the formats supported by the server.
      #
      # @example
      #    set_media_type # => 'application/occi+json'
      #
      # @return [String] chosen media type
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

      # Generates a human-readable response message based on the HTTP response code. 
      #
      # @example
      #    response_message self.class.delete(@endpoint + path)
      #     # =>  'HTTP Response status: [200] OK'
      #
      # @param [HTTParty::Response] HTTParty response object
      # @return [String] message
      def response_message(response)
        'HTTP Response status: [' + response.code.to_s + '] ' + reason_phrase(response.code)
      end

      # Converts HTTP response codes to human-readable phrases.
      #
      # @example
      #    reason_phrase(500) # => "Internal Server Error"
      #
      # @param [Integer] HTTP response code
      # @return [String] human-readable phrase
      def reason_phrase(code)
        HTTP_CODES[code.to_s]
      end

    end
  end
end
