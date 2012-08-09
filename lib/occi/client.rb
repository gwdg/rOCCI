require 'rubygems'
require 'httparty'

module OCCI
  class Client
    include HTTParty
    format :json
    headers 'Accept' => 'application/occi+json'

    attr_reader :endpoint
    attr_reader :model
    attr_reader :auth_options

    def initialize(endpoint, auth_options=nil)
      @endpoint = endpoint
      @auth_options = auth_options

      @auth_options = @auth_options || {:type => "none"}

      case @auth_options[:type]
        when "basic"
          # set up basic auth
          raise ArgumentError, "Missing required options 'username' and 'password' for basic auth!" if @auth_options[:username].nil? or @auth_options[:password].nil?

          self.class.basic_auth @auth_options[:username], @auth_options[:password]
        when "digest"
          # set up digest auth
          raise ArgumentError, "Missing required options 'username' and 'password' for digest auth!" if @auth_options[:username].nil? or @auth_options[:password].nil?

          self.class.digest_auth @auth_options[:username], @auth_options[:password]
        when "x509"
          # set up pem and optionally pem_password and ssl_ca_path
          raise ArgumentError, "Missing required option 'pem_path' for x509 auth!" if @auth_options[:pem_path].nil? or @auth_options[:pem_path].empty?
          raise ArgumentError, "The file specified in 'pem_path' does not exist!" unless File.exists? @auth_options[:pem_path]

          self.class.pem File.read(@auth_options[:pem_path]), @auth_options[:pem_password]
          self.class.ssl_ca_path @auth_options[:ssl_ca_path] unless @auth_options[:ssl_ca_path].nil? or @auth_options[:ssl_ca_path].empty?
        when "none", nil
          # do nothing
        else
          raise ArgumentError, "Unknown AUTH method [#{@auth_options[:type]}]!"  
      end

      @model    = OCCI::Model.new(get_model)
      @storage_location = '/storage/'
      @compute_location = '/compute/'
      @network_location = '/network/'
    end

    def get_model
      get(@endpoint + '/-/')[1]
    end

    def post_mixin

    end

    def post_resources_to_mixin

    end

    def delete_resources_from_mixin

    end

    def delete_mixin

    end

    def get_resources
      get(@endpoint)[1]
    end

    def get_resources_list
      self.class.get(@endpoint, { :headers => { 'Accept' => 'text/uri-list' }, :format => 'text/plain' }).body.split("\n").compact
    end

    def post_resource(attributes, kind, mixins, resources_to_link)
      resource      = OCCI::Core::Resource.new(kind.type_identifier)
      mixins = mixins.collect { |mixin| mixin.type_identifiers } unless mixins.first.kind_of? String
      resource.mixins = mixins
      attributes = OCCI::Core::Attributes.split(attributes) unless attributes.kind_of? OCCI::Core::Attributes
      resource.attributes = attributes
      resource.links      = []
      resources_to_link.each do |res|
        kind = 'http://schemas.ogf.org/occi/infrastructure#storagelink' if @model.get_by_id(res.kind).related_to? 'http://schemas.ogf.org/occi/infrastructure#storage'
        kind = 'http://schemas.ogf.org/occi/infrastructure#networkinterface' if @model.get_by_id(res.kind).related_to? 'http://schemas.ogf.org/occi/infrastructure#network'
        link = OCCI::Link.new(kind)
        link.titlte "Link to #{res.title}"
        link.target = res.location
        resource.links << link
      end
      resource.check
      collection = OCCI::Collection.new(:resources => [resource])
      self.class.post(@endpoint + kind.location, { :body => collection.to_json, :headers => { 'Content-Type' => 'application/occi+json', 'Accept' => 'text/uri-list' }, :format => 'text/plain' }).body
    end

    def delete_resources
      delete(@endpoint)
    end

    def trigger_action(url)
      self.class.post(url)
    end

    def trigger_action_on_resources(resources, action)
    end


    def get_compute_list
      self.class.get(@endpoint + @compute_location, { :headers => { 'Accept' => 'text/uri-list' }, :format => 'text/plain' }).body.split("\n").compact
    end

    def get_compute_resources
      get(@endpoint + @compute_location)[1]
    end

    def post_compute_resource(attributes=OCCI::Core::Attributes.new, os = nil, size = nil, mixins=[], resources_to_link=[])
      mixins << os if os
      mixins << size if size
      post_resource(attributes, @model.get_by_location(@compute_location), mixins, resources_to_link)
    end

    def delete_compute_resource(id)
      delete(@endpoint + @compute_location + id)
    end

    def delete_compute_resources
      delete(@endpoint + @compute_location)
    end

    def get_storage_resources
      get(@endpoint + @storage_location)[1]
    end

    def get_storage_list
      self.class.get(@endpoint + @storage_location, { :headers => { 'Accept' => 'text/uri-list' }, :format => 'text/plain' }).body.split("\n").compact
    end

    def post_storage_resource(attributes=OCCI::Core::Attributes.new, mixins=[], resources_to_link=[])
      post_resource(attributes, @model.get_by_location(@storage_location), mixins, resources_to_link)
    end

    def delete_storage_resource(id)
      delete(@endpoint + @storage_location + id)
    end

    def delete_storage_resources
      delete (@endpoint + @storage_location)
    end

    def get_network_resources
      get(@endpoint + @network_location)[1]
    end

    def get_network_list
      self.class.get(@endpoint + @network_location, { :headers => { 'Accept' => 'text/uri-list' }, :format => 'text/plain' }).body.split("\n").compact
    end

    def post_network_resource(attributes=OCCI::Core::Attributes.new, mixins=[], resources_to_link=[])
      post_resource(attributes, @model.get_by_location(@network_location), mixins, resources_to_link)
    end

    def delete_network_resource(id)
      delete(@endpoint + @network_location + id)
    end

    def delete_network_resources
      delete(@endpoint + @network_location)
    end

    def get_os_templates
      OCCI::Collection.new(self.class.get(@endpoint + '/-/', :headers => { 'Accept' => 'application/occi+json', 'Content-Type' => 'text/occi', 'Category' => 'os_tpl;scheme="http://schemas.ogf.org/occi/infrastructure#";class="mixin"' })).mixins.select { |mixin| mixin.term != 'os_tpl' }
    end

    def get_resource_templates
      OCCI::Collection.new(self.class.get(@endpoint + '/-/', :headers => { 'Accept' => 'application/occi+json', 'Content-Type' => 'text/occi', 'Category' => 'resource_tpl;scheme="http://schemas.ogf.org/occi/infrastructure#";class="mixin"' })).mixins.select { |mixin| mixin.term != 'resource_tpl' }
    end

    def get_attributes(categories)
      attributes = Hashie::Mash.new
      [categories].flatten.each do |category|
        category = @model.get_by_id(category) if category.kind_of? String
        attributes.merge! category.attributes.combine_with_defaults
      end
      attributes
    end

    def get_attribute_definitions(categories)
      definitions = OCCI::Core::AttributeProperties.new
      [categories].flatten.each do |category|
        category = @model.get_by_id(category) if category.kind_of? String
        definitions.merge! category.attributes
      end
      definitions
    end

    private

    def get(path, collection=nil)
      accept = self.class.head(path).headers['accept']
      if accept.include? 'application/occi+json'
        if collection
          response = self.class.get(path, :body => collection.to_json)
        else
          response = self.class.get(path)
        end
        OCCI::Parser.parse(response.headers.content_type(), response.body)
      else
        if collection
          response = self.class.get(path, :headers => { 'Accept' => 'text/plain', 'Content-Type' => 'text/occi', 'Category ' => collection.categories.collect { |category| category.to_text }.join(','), 'X-OCCI-Attributes' => collection.entities.collect { |entity| entity.attributes.combine.collect { |k, v| k + '=' + v } }.join(',') })
        else
          response = self.class.get(path, :headers => { 'Accept' => 'text/plain' })
        end
        OCCI::Parser.parse(response.headers.content_type(), response.body, true)
      end
    end

    def post(path, collection)
      accept = self.class.head(path).headers['accept']
      if accept.include? 'application/occi+json'
        self.class.post(path, :body => collection.to_json)
      else
        self.class.post(path, { :body => collection.to_text, :headers => { 'Accept' => 'text/plain', 'Content-Type' => 'text/plain' } })
      end
    end

    def put(path, collection)
      accept = self.class.head(path).headers['accept']
      if accept.include? 'application/occi+json'
        self.class.put(path, :body => collection.to_json)
      else
        self.class.put(path, { :body => collection.to_text, :headers => { 'Accept' => 'text/plain', 'Content-Type' => 'text/plain' } })
      end
    end

    def delete(path)
      accept = self.class.head(path).headers['accept']
      self.class.delete(path)
    end

  end
end
