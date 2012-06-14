require 'rubygems'
require 'httparty'

module OCCI
  class Client
    include HTTParty
    format :json
    headers 'Accept' => 'application/occi+json'

    attr_reader :endpoint

    attr_reader :compute
    attr_reader :storage
    attr_reader :network

    def initialize(endpoint)
      @endpoint  = endpoint
      collection = OCCI::Collection.new(get_model)
      OCCI::Model.register_collection(collection)
      @compute = OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#compute')
      @storage = OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#storage')
      @network = OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#network')
    end

    def get_model
      self.class.get(endpoint + '/-/')
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
      OCCI::Collection.new(self.class.get(endpoint)).resources
    end

    def get_resources_list
      self.class.get(@endpoint, :headers => { 'Accept' => 'text/uri-list' }).split("\n").compact
    end

    def post_resource(attributes, kind, mixins, resources_to_link)
      resource      = OCCI::Core::Resource.new
      resource.kind = kind.type_identifier
      mixins = mixins.collect { |mixin| mixin.type_identifiers } unless mixins.first.kind_of? String
      resource.mixins = mixins
      attributes = OCCI::Core::Attributes.split(attributes) unless attributes.kind_of? OCCI::Core::Attributes
      resource.attributes = attributes
      resource.links      = []
      resources_to_link.each do |res|
        link = OCCI::Link.new
        link.kind = 'http://schemas.ogf.org/occi/infrastructure#storagelink' if OCCI::Model.get_by_id(res.kind).related_to? 'http://schemas.ogf.org/occi/infrastructure#storage'
        link.kind = 'http://schemas.ogf.org/occi/infrastructure#networkinterface' if OCCI::Model.get_by_id(res.kind).related_to? 'http://schemas.ogf.org/occi/infrastructure#network'
        link.titlte "Link to #{res.title}"
        link.target = res.location
        resource.links << link
      end
      resource.check
      collection = OCCI::Collection.new(:resources => [resource])
      self.class.post(@endpoint + kind.location, { :body => collection.to_json, :headers => { 'Content-Type' => 'application/occi+json', 'Accept' => 'text/uri-list' }, :format => 'text/plain' }).to_s
    end

    def delete_resources
      self.class.delete(@endpoint)
    end

    def trigger_action(url)
      self.class.post(url)
    end

    def trigger_action_on_resources(resources, action)
    end


    def get_compute_list
      self.class.get(@endpoint + @compute.location, {:headers => { 'Accept' => 'text/uri-list' }, :format => 'text/plain'}).split("\n").compact
    end

    def get_compute_resources
      self.class.get(endpoint + @compute.location)
    end

    def post_compute_resource(attributes=OCCI::Core::Attributes.new, mixins=[], resources_to_link=[])
      post_resource(attributes, @compute, mixins, resources_to_link)
    end

    def delete_compute_resource(id)
      self.class.delete(@endpoint + @compute.location + id)
    end

    def delete_compute_resources
      self.class.delete(@endpoint + @compute.location)
    end

    def get_storage_resources
      self.class.get(@endpoint + @storage.location)
    end

    def post_storage_resource(attributes=OCCI::Core::Attributes.new, mixins=[], resources_to_link=[])
      post_resource(attributes, @storage, mixins, resources_to_link)
    end

    def delete_storage_resource(id)
      self.class.delete(@endpoint + @storage.location + id)
    end

    def delete_storage_resources
      self.class.delete @endpoint + (@storage.location)
    end

    def get_network_resources
      self.class.get(@endpoint + @network)
    end

    def post_network_resource(attributes=OCCI::Core::Attributes.new, mixins=[], resources_to_link=[])
      post_resource(attributes, @network, mixins, resources_to_link)
    end

    def delete_network_resource(id)
      self.class.delete(@endpoint + @network.location + id)
    end

    def delete_network_resources
      self.class.delete(@endpoint + @network.location)
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
        category = OCCI::Model.get_by_id(category) if category.kind_of? String
        attributes.merge! category.attributes.combine_with_defaults
      end
      attributes
    end

    def get_attribute_definitions(categories)
      definitions = OCCI::Core::AttributeProperties.new
      [categories].flatten.each do |category|
        category = OCCI::Model.get_by_id(category) if category.kind_of? String
        definitions.merge! category.attributes
      end
      definitions
    end

  end
end