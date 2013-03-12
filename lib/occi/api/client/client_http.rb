require 'rubygems'
require 'httparty'

require 'occi/api/client/http/net_http_fix'
require 'occi/api/client/http/httparty_fix'
require 'occi/api/client/http/authn_utils'

module Occi
  module Api
    module Client

      class ClientHttp

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
        attr_reader :logger
        attr_reader :last_response

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
        #    options = {
        #      :endpoint => "http://localhost:3300/",
        #      :auth => {:type => "none"},
        #      :log => {:out => STDERR, :level => Occi::Log::WARN, :logger => nil},
        #      :auto_connect => "value", auto_connect => true,
        #      :media_type => nil
        #    }
        #
        #    Occi::Api::Client::ClientHttp.new options # => #<Occi::Api::Client::ClientHttp>
        #
        # @param [Hash] options, for available options and defaults see examples
        # @return [Occi::Api::Client::ClientHttp] client instance
        def initialize(options = {})

          defaults = {
            :endpoint => "http://localhost:3300/",
            :auth => {:type => "none"},
            :log => {:out => STDERR, :level => Occi::Log::WARN, :logger => nil},
            :auto_connect => true,
            :media_type => nil
          }

          options = options.marshal_dump if options.is_a? OpenStruct
          options = defaults.merge options

          # set Occi::Log
          set_logger options[:log]

          # pass auth options to HTTParty
          change_auth options[:auth]

          # check the validity and canonize the endpoint URI
          prepare_endpoint options[:endpoint]

          # get accepted media types from HTTParty
          set_media_type

          # force media_type if provided
          if options[:media_type]
            self.class.headers 'Accept' => options[:media_type]
            @media_type = options[:media_type]
          end

          Occi::Log.debug("Media Type: #{@media_type}")
          Occi::Log.debug("Headers: #{self.class.headers}")

          # get model information from the endpoint
          # and create Occi::Model instance
          set_model

          # auto-connect?
          @connected = options[:auto_connect]
        end

        # Creates a new resource instance, resource should be specified
        # by its name or identifier.
        #
        # @example
        #   client.get_resource "compute" # => Occi::Core::Resource
        #   client.get_resource "storage" # => Occi::Core::Resource
        #   client.get_resource "http://schemas.ogf.org/occi/infrastructure#network"
        #    # => Occi::Core::Resource
        #
        # @param [String] resource name or resource identifier
        # @return [Occi::Core::Resource] new resource instance
        def get_resource(resource_type)

          Occi::Log.debug("Instantiating #{resource_type} ...")

          if @model.get_by_id resource_type
            # we got a resource type identifier
            Occi::Core::Resource.new resource_type
          elsif @model.kinds.select { |kind| kind.term == resource_type }.any?
            # we got a resource type name
            Occi::Core::Resource.new @model.kinds.select {
              |kind| kind.term == resource_type
            }.first.type_identifier
          else
            raise "Unknown resource type! [#{resource_type}]"
          end

        end

        # Retrieves all entity type identifiers related to a given type identifier
        #
        # @example
        #    client.get_entity_type_identifiers_related_to 'network'
        #    # => [ "http://schemas.ogf.org/occi/infrastructure#network",
        #    #      "http://schemas.ogf.org/occi/infrastructure#ipnetwork" ]
        #
        # @param [String] type_identifier
        # @return [Array<String>] list of available entity type identifiers related to given type identifier in a human-readable format
        def get_entity_types_related_to(type_identifier)
          Occi::Log.debug("Getting entity type identifiers related to #{type_identifier}")
          collection = @model.get type_identifier
          collection.kinds.collect { |kind| kind.type_identifier }
        end

        # Retrieves all available entity types.
        #
        # @example
        #    client.get_entity_types # => [ "entity", "resource", "link" ]
        #
        # @return [Array<String>] list of available entity types in a human-readable format
        def get_entity_types
          Occi::Log.debug("Getting entity types ...")
          @model.kinds.collect { |kind| kind.term }
        end

        # Retrieves all available entity type identifiers.
        #
        # @example
        #    client.get_entity_type_identifiers
        #    # => [ "http://schemas.ogf.org/occi/core#entity",
        #    #      "http://schemas.ogf.org/occi/core#resource",
        #    #      "http://schemas.ogf.org/occi/core#link" ]
        #
        # @return [Array<String>] list of available entity types in a OCCI ID format
        def get_entity_type_identifiers
          get_entity_types_related_to Occi::Core::Entity.kind.type_identifier
        end

        # Retrieves all available resource types.
        #
        # @example
        #    client.get_resource_types # => [ "compute", "storage", "network" ]
        #
        # @return [Array<String>] list of available resource types in a human-readable format
        def get_resource_types
          Occi::Log.debug("Getting resource types ...")
          collection = @model.get Occi::Core::Resource.kind
          collection.kinds.collect { |kind| kind.term }
        end

        # Retrieves all available resource type identifiers.
        #
        # @example
        #    client.get_resource_type_identifiers
        #    # => [ "http://schemas.ogf.org/occi/infrastructure#compute",
        #    #      "http://schemas.ogf.org/occi/infrastructure#storage",
        #    #      "http://schemas.ogf.org/occi/infrastructure#network" ]
        #
        # @return [Array<String>] list of available resource types in a Occi ID format
        def get_resource_type_identifiers
          get_entity_types_related_to Occi::Core::Resource.kind.type_identifier

        end

        # Retrieves all available link types.
        #
        # @example
        #    client.get_link_types # => [ "storagelink", "networkinterface" ]
        #
        # @return [Array<String>] list of available link types in a human-readable format
        def get_link_types
          Occi::Log.debug("Getting link types ...")
          collection = @model.get Occi::Core::Link.kind
          collection.kinds.collect { |kind| kind.term }
        end

        # Retrieves all available link type identifiers.
        #
        # @example
        #    client.get_link_type_identifiers
        #    # => [ "http://schemas.ogf.org/occi/infrastructure#storagelink",
        #    #      "http://schemas.ogf.org/occi/infrastructure#networkinterface" ]
        #
        # @return [Array<String>] list of available link types in a OCCI ID format
        def get_link_type_identifiers
          get_entity_types_related_to Occi::Core::Link.kind.type_identifier
        end

        # Looks up a mixin using its name and, optionally, a type as well.
        # Will return mixin's full location (a link) or a description.
        #
        # @example
        #    client.find_mixin "debian6"
        #     # => "http://my.occi.service/occi/infrastructure/os_tpl#debian6"
        #    client.find_mixin "debian6", "os_tpl"
        #     # => "http://my.occi.service/occi/infrastructure/os_tpl#debian6"
        #    client.find_mixin "large", "resource_tpl"
        #     # => "http://my.occi.service/occi/infrastructure/resource_tpl#large"
        #    client.find_mixin "debian6", "resource_tpl" # => nil
        #
        # @param [String] name of the mixin
        # @param [String] type of the mixin
        # @param [Boolean] should we describe the mixin or return its link?
        # @return [String, Occi::Collection, nil] link, mixin description or nothing found
        def find_mixin(name, type = nil, describe = false)

          Occi::Log.debug("Looking for mixin #{name} + #{type} + #{describe}")

          # is type valid?
          if type
            raise "Unknown mixin type! [#{type}]" unless @mixins.has_key? type.to_sym
          end

          # TODO: extend this code to support multiple matches and regex filters
          # should we look for links or descriptions?
          if describe
            # we are looking for descriptions
            if type
              # get the first match from either os_tpls or resource_tpls
              case
              when type == "os_tpl"
                get_os_templates.select { |mixin| mixin.term == name }.first
              when type == "resource_tpl"
                get_resource_templates.select { |template| template.term == name }.first
              else
                nil
              end
            else
              # try in os_tpls first
              found = get_os_templates.select { |os| os.term == name }.first

              # then try in resource_tpls
              found = get_resource_templates.select {
                |template| template.term == name
              }.first unless found

              found
            end
          else
            # we are looking for links
            # prefix mixin name with '#' to simplify the search
            name = "#" + name
            if type
              # return the first match with the selected type
              @mixins[type.to_sym].select {
                |mixin| mixin.to_s.reverse.start_with? name.reverse
              }.first
            else
              # there is no type preference, return first global match
              @mixins.flatten(2).select {
                |mixin| mixin.to_s.reverse.start_with? name.reverse
              }.first
            end
          end
        end

        # Retrieves available mixins of a specified type or all available
        # mixins if the type wasn't specified. Mixins are returned in the
        # form of mixin identifiers.
        #
        # @example
        #    client.get_mixins
        #     # => ["http://my.occi.service/occi/infrastructure/os_tpl#debian6",
        #     #     "http://my.occi.service/occi/infrastructure/resource_tpl#small"]
        #    client.get_mixins "os_tpl"
        #     # => ["http://my.occi.service/occi/infrastructure/os_tpl#debian6"]
        #    client.get_mixins "resource_tpl"
        #     # => ["http://my.occi.service/occi/infrastructure/resource_tpl#small"]
        #
        # @param [String] type of mixins
        # @return [Array<String>] list of available mixins
        def get_mixins(type = nil)
          if type
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

        # Retrieves available mixin types. Mixin types are presented
        # in a shortened format (i.e. not as type identifiers).
        #
        # @example
        #    client.get_mixin_types # => [ "os_tpl", "resource_tpl" ]
        #
        # @return [Array<String>] list of available mixin types
        def get_mixin_types
          @mixins.keys.map { |k| k.to_s }
        end

        # Retrieves available mixin type identifiers.
        #
        # @example
        #    client.get_mixin_type_identifiers
        #     # => ['http://schemas.ogf.org/occi/infrastructure#os_tpl',
        #     #     'http://schemas.ogf.org/occi/infrastructure#resource_tpl']
        #
        # @return [Array<String>] list of available mixin type identifiers
        def get_mixin_type_identifiers
          identifiers = []

          get_mixin_types.each do |mixin_type|
            identifiers << 'http://schemas.ogf.org/occi/infrastructure#' + mixin_type
          end

          identifiers
        end

        # Retrieves available resources represented by resource locations (URIs).
        # If no type identifier is specified, all available resource are listed.
        # Type identifier can be specified in its shortened format (e.g. "compute",
        # "storage", "network").
        #
        # @example
        #    client.list
        #     # => [ "http://localhost:3300/compute/jh425jhj3h413-7dj29d7djd9e3-djh2jh4j4j",
        #     #      "http://localhost:3300/network/kh425jhj3h413-7dj29d7djd9e3-djh2jh4j4j",
        #     #      "http://localhost:3300/storage/lh425jhj3h413-7dj29d7djd9e3-djh2jh4j4j" ]
        #    client.list "compute"
        #     # => [ "http://localhost:3300/compute/jh425jhj3h413-7dj29d7djd9e3-djh2jh4j4j" ]
        #    client.list "http://schemas.ogf.org/occi/infrastructure#compute"
        #     # => [ "http://localhost:3300/compute/jh425jhj3h413-7dj29d7djd9e3-djh2jh4j4j" ]
        #
        # @param [String] resource type identifier or just type name
        # @return [Array<String>] list of links
        def list(resource_type_identifier=nil)
          if resource_type_identifier
            # convert type to type identifier
            resource_type_identifier = @model.kinds.select {
              |kind| kind.term == resource_type_identifier
            }.first.type_identifier if @model.kinds.select {
              |kind| kind.term == resource_type_identifier
            }.any?

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

          headers = self.class.headers.clone
          headers['Accept'] = 'text/uri-list'

          # TODO: remove the gsub OCCI-OS hack
          response = self.class.get(
            @endpoint + path,
            :headers => headers
          ).body.gsub(/\# uri:\/(compute|storage|network)\/[\n]?/, '').split("\n").compact
        end

        # Retrieves descriptions for available resources specified by a type
        # identifier or resource location. If no type identifier or location
        # is specified, all available resources in all available resource types
        # will be described.
        #
        # @example
        #    client.describe
        #     # => [#<Occi::Collection>, #<Occi::Collection>, #<Occi::Collection>]
        #    client.describe "compute"
        #     # => [#<Occi::Collection>, #<Occi::Collection>, #<Occi::Collection>]
        #    client.describe "http://schemas.ogf.org/occi/infrastructure#compute"
        #     # => [#<Occi::Collection>, #<Occi::Collection>, #<Occi::Collection>]
        #    client.describe "http://localhost:3300/compute/j5hk1234jk2524-2j3j2k34jjh234-adfaf1234"
        #     # => [#<Occi::Collection>]
        #
        # @param [String] resource type identifier, type name or resource location
        # @return [Array<Occi::Collection>] list of resource descriptions
        def describe(resource_type_identifier=nil)

          # convert type to type identifier
          resource_type_identifier = @model.kinds.select {
            |kind| kind.term == resource_type_identifier
          }.first.type_identifier if @model.kinds.select {
            |kind| kind.term == resource_type_identifier
          }.any?

          # check some basic pre-conditions
          raise "Endpoint is not connected!" unless @connected

          descriptions = []

          if resource_type_identifier.nil?
            descriptions << get('/')
          elsif @model.get_by_id resource_type_identifier
            # we got type identifier
            # get all available resources of this type
            locations = list resource_type_identifier

            # make the requests
            locations.each do |location|
              descriptions << get(sanitize_resource_link(location))
            end
          elsif resource_type_identifier.start_with?(@endpoint) || resource_type_identifier.start_with?('/')
            # we got resource link
            # make the request
            descriptions << get(sanitize_resource_link(resource_type_identifier))
          else
            raise "Unkown resource type identifier! [#{resource_type_identifier}]"
          end

          descriptions
        end

        # Creates a new resource on the server. Resource must be provided
        # as an instance of Occi::Core::Entity, e.g. instantiated using
        # the get_resource method.
        #
        # @example
        #    res = client.get_resource "compute"
        #
        #    res.title = "MyComputeResource1"
        #    res.mixins << client.find_mixin('small', "resource_tpl")
        #    res.mixins << client.find_mixin('debian6', "os_tpl")
        #
        #    client.create res # => "http://localhost:3300/compute/df7698...f987fa"
        #
        # @param [Occi::Core::Entity] resource to be created on the server
        # @return [String] URI of the new resource
        def create(entity)

          # check some basic pre-conditions
          raise "Endpoint is not connected!" unless @connected
          raise "#{entity} not an entity" unless entity.kind_of? Occi::Core::Entity

          # is this entity valid?
          entity.model = @model
          entity.check

          Occi::Log.debug "Entity kind: #{entity.kind}"
          kind = entity.kind
          raise "No kind found for #{entity}" unless kind

          # get location for this kind of entity
          Occi::Log.debug "Kind location: #{entity.kind.location}"
          location = kind.location
          collection = Occi::Collection.new

          # is this entity a Resource or a Link?
          Occi::Log.debug "Entity class: #{entity.class.name}"
          collection.resources << entity if entity.kind_of? Occi::Core::Resource
          collection.links << entity if entity.kind_of? Occi::Core::Link

          # make the request
          post location, collection
        end

        # Deploys a compute resource based on an OVF/OVA descriptor available
        # on a local file system.
        #
        # @example
        #    client.deploy "~/MyVMs/rOcciVM.ovf" # => "http://localhost:3300/compute/343423...42njhdafa"
        #
        # @param [String] location of an OVF/OVA file
        # @return [String] URI of the new resource
        def deploy(location)
          media_types = self.class.head(@endpoint).headers['accept'].to_s
          raise "File #{location} does not exist" unless File.exist? location

          file = File.read(location)

          if location.include? '.ovf'
            if media_types.include? 'application/ovf'
              headers = self.class.headers.clone
              headers['Content-Type'] = 'application/ovf'
              self.class.post(@endpoint + '/compute/',
                              :body => file,
                              :headers => headers)
            end
          elsif location.include? '.ova'
            if media_types.include? ' application/ova '
              headers = self.class.headers.clone
              headers['Content-Type'] = 'application/ova'
              self.class.post(@endpoint + '/compute/',
                              :body => file,
                              :headers => headers)
            end
          end
        end

        # Deletes a resource or all resource of a certain resource type
        # from the server.
        #
        # @example
        #    client.delete "compute" # => true
        #    client.delete "http://schemas.ogf.org/occi/infrastructure#compute" # => true
        #    client.delete "http://localhost:3300/compute/245j42594...98s9df8s9f" # => true
        #
        # @param [String] resource type identifier, type name or location
        # @return [Boolean] status
        def delete(resource_type_identifier)
          # convert type to type identifier
          raise "Endpoint is not connected!" unless @connected

          path = path_for_resource_type resource_type_identifier

          del path
        end

        # Triggers given action on a specific resource.
        #
        # @example
        #    TODO: add examples
        #
        # @param [String] resource location
        # @param [String] type of action
        # @return [String] resource location
        def trigger(resource_type_identifier, action)
          # TODO: not tested
          if @model.kinds.select { |kind| kind.term == resource_type }.any?
            type_identifier = @model.kinds.select {
              |kind| kind.term == resource_type_identifier
            }.first.type_identifier

            location = @model.get_by_id(type_identifier).location
            resource_type_identifier = @endpoint + location
          end
          # check some basic pre-conditions
          raise "Endpoint is not connected!" unless @connected
          raise "Unknown resource identifier! #{resource_type_identifier}" unless resource_type_identifier.start_with? @endpoint

          # encapsulate the acion in a collection
          collection = Occi::Collection.new
          scheme, term = action.split(' #')
          collection.actions << Occi::Core::Action.new(scheme + '#', term)

          # make the request
          path = sanitize_resource_link(resource_type_identifier) + '?action=' + term
          post path, collection
        end

        # Refreshes the Occi::Model used inside the client. Useful for
        # updating the model without creating a new instance or
        # reconnecting. Saves a lot of time in an interactive mode.
        #
        # @example
        #    client.refresh
        def refresh
          # re-download the model from the server
          set_model
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
            @logger = Occi::Log.new(log_options[:out])
            @logger.level = log_options[:level]
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
        #    change_auth { :type => "keystone", :token => "005c8a5d7f2c437a9999302c458afbda" }
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

            # handle PKCS#12 credentials before passing them
            # to httparty
            if /\A(.)+\.p12\z/ =~ @auth_options[:user_cert]
              self.class.pem AuthnUtils.extract_pem_from_pkcs12(@auth_options[:user_cert], @auth_options[:user_cert_password]), ''
            else
              # httparty will handle ordinary PEM formatted credentials
              # TODO: Issue #49, check PEM credentials in jRuby
              self.class.pem File.open(@auth_options[:user_cert], 'rb').read, @auth_options[:user_cert_password]
            end

            self.class.ssl_ca_path @auth_options[:ca_path] unless @auth_options[:ca_path].nil?
            self.class.ssl_ca_file @auth_options[:ca_file] unless @auth_options[:ca_file].nil?
            self.class.ssl_extra_chain_cert AuthnUtils.certs_to_file_ary(@auth_options[:proxy_ca]) unless @auth_options[:proxy_ca].nil?
          when "keystone"
            Occi::Log.warn "AuthN method 'keystone' is deprecated and you should use it only as a fall-back option!"
            # set up OpenStack Keystone token based auth
            raise ArgumentError, "Missing required option 'token' for OpenStack Keystone auth!" unless @auth_options[:token]
            self.class.headers['X-Auth-Token'] = @auth_options[:token]
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
          path = path.gsub(/\A\//, '')

          response = if filter
                       categories = filter.categories.collect { |category| category.to_text }.join(',')
                       attributes = filter.entities.collect { |entity| entity.attributes.combine.collect { |k, v| k + '=' + v } }.join(',')

                       headers = self.class.headers.clone
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
          collection = Occi::Parser.parse(response.content_type, response.body, path.include?('-/'), entity_type, response.headers)

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
          path = path.gsub(/\A\//, '')

          headers = self.class.headers.clone
          headers['Content-Type'] = @media_type

          response = case @media_type
                     when 'application/occi+json'
                       self.class.post(@endpoint + path,
                                       :body => collection.to_json,
                                       :headers => headers)
                     when 'text/occi'
                       self.class.post(@endpoint + path,
                                       :headers => collection.to_header.merge(headers))
                     else
                       self.class.post(@endpoint + path,
                                       :body => collection.to_text,
                                       :headers => headers)
                     end

          response_msg = response_message response

          case response.code
          when 200
            collection = Occi::Parser.parse(response.header["content-type"].split(";").first, response)
            if collection.empty?
              Occi::Parser.locations(response.header["content-type"].split(";").first, response.body, response.header).first
            else
              collection.resources.first.location if collection.resources.first
            end
          when 201
            Occi::Parser.locations(response.header["content-type"].split(";").first, response.body, response.header).first
          else
            raise "HTTP POST failed! #{response_msg}"
          end
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
          path = path.gsub(/\A\//, '')

          headers = self.class.headers.clone
          headers['Content-Type'] = @media_type

          response = case @media_type
                     when 'application/occi+json'
                       self.class.post(@endpoint + path,
                                       :body => collection.to_json,
                                       :headers => headers)
                     when 'text/occi'
                       self.class.post(@endpoint + path,
                                       :headers => collection.to_header.merge(headers))
                     else
                       self.class.post(@endpoint + path,
                                       :body => collection.to_text,
                                       :headers => headers)
                     end

          response_msg = response_message response

          case response.code
          when 200, 201
            Occi::Parser.parse(response.header["content-type"].split(";").first, response)
          else
            raise "HTTP POST failed! #{response_msg}"
          end
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
          path = path.gsub(/\A\//, '')

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
          link = Occi::Core::Link.new(kind)
          link.mixins = mixins
          link.attributes = attributes
          link.target = (target_location.kind_of? URI::Generic) ? target_location.path : target_location.to_s
          link.rel = target_kind

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
        #    sanitize_resource_link "/compute/35ad4f45gsf-gsfg524s6gsfg-sfgsf4gsfg"
        #     # => "/compute/35ad4f45gsf-gsfg524s6gsfg-sfgsf4gsfg"
        #
        # @param [String] string containing the full resource link
        # @return [String] extracted path, with a leading slash
        def sanitize_resource_link(resource_link)
          # everything starting with '/' is considered to be a resource path
          return resource_link if resource_link.start_with? '/'

          raise "Resource link #{resource_link} is not valid!" unless resource_link.start_with? @endpoint

          resource_link.gsub @endpoint, '/'
        end

        # @describe find the path for the resource type identifier
        #
        # @example
        #
        #
        # @param [String] resource_type_identifier
        #
        # @return [String]
        def path_for_resource_type(resource_type_identifier)
          if resource_type_identifier.nil? || resource_type_identifier == "/"
            #we got all
            path = "/"
          else
            kinds = @model.kinds.select { |kind| kind.term == resource_type_identifier }
            if kinds.any?
              #we got an type identifier
              path = "/" + kinds.first.type_identifier.split('#').last + "/"
            elsif resource_type_identifier.start_with?(@endpoint) || resource_type_identifier.start_with?('/')
              #we got an resource link
              path = sanitize_resource_link(resource_type_identifier)
            else
              raise "Unknown resource identifier! #{resource_type_identifier}"
            end
          end

          path
        end

        # Creates an Occi::Model from data retrieved from the server.
        #
        # @example
        #    set_model
        #
        # @return [Occi::Model]
        def set_model

          # check credentials and handle OpenStack Keystone
          # TODO: check expiration dates on Keystone tokens
          raise "You are not authorized to use this endpoint!" unless check_authn

          #
          model = get('/-/')
          @model = Occi::Model.new(model)

          @mixins = {
            :os_tpl => [],
            :resource_tpl => []
          }

          #
          get_os_templates.each do |os_tpl|
            unless os_tpl.nil? || os_tpl.type_identifier.nil?
              tid = os_tpl.type_identifier.strip
              @mixins[:os_tpl] << tid unless tid.empty?
            end
          end

          #
          get_resource_templates.each do |res_tpl|
            unless res_tpl.nil? || res_tpl.type_identifier.nil?
              tid = res_tpl.type_identifier.strip
              @mixins[:resource_tpl] << tid unless tid.empty?
            end
          end

          model
        end

        # Checks provided credentials and attempts transparent
        # authentication with OS Keystone using the "www-authenticate"
        # header.
        #
        # @example
        #    check_authn
        #
        # @return [true, false]
        def check_authn
          response = self.class.head @endpoint

          return true if response.success?

          if response.code == 401 && response.headers["www-authenticate"]
            if response.headers["www-authenticate"].start_with? "Keystone"
              keystone_uri = /^Keystone uri='(.+)'$/.match(response.headers["www-authenticate"])[1]

              if keystone_uri
                if @auth_options[:type] == "x509"
                  body = { "auth" => { "voms" => true } }
                else
                  body = {
                    "auth" => {
                      "passwordCredentials" => {
                        "username" => @auth_options[:username],
                        "password" => @auth_options[:password]
                      }
                    }
                  }
                end

                headers = self.class.headers.clone
                headers['Content-Type'] = "application/json"
                headers['Accept'] = headers['Content-Type']

                response = self.class.post(keystone_uri + "/v2.0/tokens", :body => body.to_json, :headers => headers)

                if response.success?
                  self.class.headers['X-Auth-Token'] = response['access']['token']['id']
                  return true
                end
              end
            end
          end

          false
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
          @last_response = response
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
end
