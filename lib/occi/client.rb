require 'rubygems'
require 'httparty'

def compute
  'http://schemas.ogf.org/occi/infrastructure#compute'
end

def storage
  'http://schemas.ogf.org/occi/infrastructure#storage'
end

def network
  'http://schemas.ogf.org/occi/infrastructure#network'
end

def resources
  '/'
end

module OCCI
  class Client
    include HTTParty
    headers 'Accept' => 'application/occi+json,text/plain;q=0.5'

    attr_reader :endpoint
    attr_reader :model
    attr_reader :auth_options

    # @param [String] endpoint URI of the OCCI endpoint to connect to
    # @param [Hash] authorization hash containing authorization information
    # @param [IO,String] log_dev The log device.  This is a filename (String) or IO object (typically +STDOUT+#, +STDERR+, or an open file).
    def initialize(endpoint, auth_options = { }, log_dev=STDOUT)
      OCCI::Log.new(log_dev)

      @auth_options = auth_options || { :type => "none" }
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

      raise 'endpoint not a valid URI' if (endpoint =~ URI::ABS_URI).nil?
      @endpoint = endpoint.chomp('/') + '/'
      refresh_model
      select_media_type
    end

    # @return [OCCI::Model]
    def refresh_model
      model  = get '/-/'
      @model = OCCI::Model.new(model)
    end

    # trigger action on resource location
    # @param [OCCI::Core::Action] action
    # @param [String,URI::Generic] location
    def trigger(action, location)
      collection = OCCI::Collection.new
      collection.actions << action
      post(location, collection)
    end

    # @return [OCCI::Collection] collection including all registered OS templates
    def get_os_templates
      filter        = OCCI::Collection.new
      # use the os_tpl mixin as filter for the request
      filter.mixins = @model.get.mixins.select { |mixin| mixin.term == 'os_tpl' }
      collection    = get '/-/', filter
      # remove os_tpl mixin from the mixins as it does not represent a template itself
      collection.mixins.select { |mixin| mixin.term != 'os_tpl' }
    end

    # @return [OCCI::Collection] collection including all registered resource templates
    def get_resource_templates
      filter        = OCCI::Collection.new
      # use the resource_tpl mixin as filter for the request
      filter.mixins = @model.get.mixins.select { |mixin| mixin.term == 'resource_tpl' }
      collection    = get '/-/', filter
      # remove os_tpl mixin from the mixins as it does not represent a template itself
      collection.mixins.select { |mixin| mixin.term != 'resource_tpl' }
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

    # @param [String] path
    # @return [Array] list of URIs
    def list(path='')
      self.class.get(path, :headers => { "Accept" => 'text/uri-list' }).split("\n").compact
    end

    # @param [OCCI::Core::Entity] entity
    # @return [URI] location of the entity
    def create(entity)
      raise "#{entity} not an entity" unless entity.kind_of? OCCI::Core::Entity
      entity.check(model)
      kind = @model.get_by_id(entity.kind)
      raise "no kind found for #{entity}" unless kind
      location   = @model.get_by_id(entity.kind).location
      collection = OCCI::Collection.new
      collection.resources << entity if entity.kind_of? OCCI::Core::Resource
      collection.links << entity if entity.kind_of? OCCI::Core::Link
      post location, collection
    end

    # @param [String] path
    # @param [OCCI::Collection] filter
    # @return [OCCI::Collection]
    def get(path='', filter=nil)
      path = path.split('#').last + '/' if path.start_with? 'http://'
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

      response_message response

      kind = @model.get_by_location path if @model
      kind ? entity_type = kind.entity_type : entity_type = nil
      _, collection = OCCI::Parser.parse(response.content_type, response.body, path.include?('/-/'), entity_type)
      collection
    end

    # @param [String] path
    # @param [OCCI::Collection] collection
    # @return [URI] if an entity has been created its location is returned
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

      response_message response

      URI.parse(response.body)
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

      response_message response

      _, collection = OCCI::Parser.parse(response.content_type, response.body)
      collection
    end

    # @param [String] path
    # @param [OCCI::Collection] collection
    # @return [true,false]
    def delete(path, collection=nil)
      path     = path.reverse.chomp('/').reverse
      response = self.class.delete(@endpoint + path)
      response_message response
      false unless response.code.between? 200, 300
    end

    private

    # @return [String]
    def select_media_type
      media_types = self.class.head(@endpoint).headers['accept']
      OCCI::Log.debug("Available media types: #{media_types}")
      @media_type = case media_types
                      when /application\/occi\+json/
                        'application/occi+json'
                      else
                        'text/plain'
                    end
    end

    # @param [Integer] code
    # @return [String] HTTP status reason
    def reason_phrase(code)
      hash = {
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
      hash[code.to_s]
    end

    # @param [HTTParty::Response] response
    def response_message(response)
      if defined?(IRB)
        puts 'HTTP Response status: ' + response.code.to_s + ' ' + reason_phrase(response.code)
        raise response.request.http_method.to_s + ' failed ' unless response.code.between? 200, 300
      end
    end

  end
end