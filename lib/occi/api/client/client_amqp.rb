require 'rubygems'
require "amqp"
require "json"

module Occi
  module Api
    module Client

    class ClientAmqp
      attr_reader :endpoint, :auth_options, :connected, :last_response_status
      attr_accessor :media_type, :model

      CONNECTION_SETTING = {
          :host => '141.5.99.83', #IP of the MessageBroker (RabbitMQ)
          :port => 5672,
          :password => "demo",
          :vhost => "/occi_server",
          :user => "occi_server"
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

      #TODO Should a client have some kind of timeout

      # Initializes client data structures and retrieves OCCI model
      # from the server.
      #
      # @example
      #    Occi::Api::Client::ClientAmqp.new # => #<Occi::Api::Client::ClientAmqp>
      #
      # @param [String] endpoint URI
      # @param [Hash] auth options in a hash
      # @param [Hash] logging options in a hash
      # @param [Boolean] enable autoconnect
      # @param [String] media type identifier
      # @return [Occi::Api::Client::ClientAmqp] client instance
      def initialize(endpoint = "http://localhost:3000/", auth_options = { :type => "none" },
          log_options = { :out => STDERR, :level => Occi::Log::WARN, :logger => nil },
          media_type = "text/plain")

        # check the validity and canonize the endpoint URI
        prepare_endpoint endpoint

        # set Occi::Log
        set_logger log_options

        # pass auth options to HTTParty
        change_auth auth_options

        @media_type = media_type

        Occi::Log.debug("Media Type: #{@media_type}")

        @connected = false

        Thread.new { run }

        print "Waiting for connection amqp ..."

        #TODO find a better solution for the thread issue
        while(!@thread_error && !@connected)
          #dont use sleep - it blocks the eventmachine
        end

        # get model information from the endpoint
        # and create Occi::Model instance
        set_model unless @thread_error
      end

      # @describe Retrieves available resources represented by resource locations (URIs).
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
      def list(resource_type_identifier = nil, is_wait = true, is_parse_response = true)

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

        message_id = get(path, true)

        return response_value(message_id, is_wait, is_parse_response)
      end

      # @describe Retrieves descriptions for available resources specified by a type
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
      def describe(resource_type_identifier=nil, is_wait = true, is_parse_response = true)

        raise "Endpoint is not connected!" unless @connected

        # convert type to type identifier
        resource_type_identifier = @model.kinds.select {
            |kind| kind.term == resource_type_identifier
        }.first.type_identifier if @model.kinds.select {
            |kind| kind.term == resource_type_identifier
        }.any?

        descriptions = []

        if resource_type_identifier.nil?
          descriptions << response_value(get('/'), is_wait, is_parse_response)
        elsif @model.get_by_id resource_type_identifier
          # we got type identifier
          # get all available resources of this type
          locations     = list resource_type_identifier

          # make the requests
          locations.each do |location|
            descriptions << response_value(get(sanitize_resource_link(location)), is_wait, is_parse_response)
          end
        elsif resource_type_identifier.start_with? @endpoint
          # we got resource link
          # make the request
          descriptions << response_value(get(sanitize_resource_link(resource_type_identifier)), is_wait, is_parse_response)
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
      def create(entity, is_wait = true, is_parse_response = true)

        # check some basic pre-conditions
        raise "Endpoint is not connected!" unless @connected
        raise "#{entity} not an entity" unless entity.kind_of? Occi::Core::Entity

        # is this entity valid?
        entity.model = @model
        entity.check
        kind = entity.kind
        raise "No kind found for #{entity}" unless kind

        # get location for this kind of entity
        location   = entity.kind.location
        collection = Occi::Collection.new

        # is this entity a Resource or a Link?
        collection.resources << entity if entity.kind_of? Occi::Core::Resource
        collection.links << entity if entity.kind_of? Occi::Core::Link

        # make the request
        response_value(post(location, collection), is_wait, is_parse_response)
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
      def delete(resource_type_identifier, is_wait = true, is_parse_response = true)
        # convert type to type identifier
        resource_type_identifier = @model.kinds.select {
            |kind| kind.term == resource_type_identifier
        }.first.type_identifier if @model.kinds.select {
            |kind| kind.term == resource_type_identifier
        }.any?

        # check some basic pre-conditions
        raise "Endpoint is not connected!" unless @connected

        if resource_type_identifier.nil? || resource_type_identifier == "/"
          path = "/"
        else
          raise "Unknown resource identifier! #{resource_type_identifier}" unless resource_type_identifier.start_with? @endpoint
          path = sanitize_resource_link(resource_type_identifier)
        end

        # make the request
        response_value(del(path), is_wait, is_parse_response)
      end

      # Triggers given action on a specific resource.
      #
      # @example
      #    TODO: add examples
      #
      # @param [String] resource location
      # @param [String] type of action
      # @return [String] resource location
      def trigger(resource_type_identifier, action, is_wait = true, is_parse_response = true)

        # TODO: not tested
        resource_type_identifier = @model.kinds.select {
            |kind| kind.term == resource_type_identifier
        }.first.type_identifier if @model.kinds.select {
            |kind| kind.term == resource_type_identifier
        }.any?

        # check some basic pre-conditions
        raise "Endpoint is not connected!" unless @connected

        if resource_type_identifier.nil? || resource_type_identifier == "/"
          path = "/"
        else
          raise "Unknown resource identifier! #{resource_type_identifier}" unless resource_type_identifier.start_with? @endpoint
          path = sanitize_resource_link(resource_type_identifier)
        end

        # encapsulate the acion in a collection
        collection   = Occi::Collection.new
        scheme, term = action.split('#')
        collection.actions << Occi::Core::Action.new(scheme + '#', term)

        #@media_type = "text/plain"

        # make the request
        path =  path + '?action=' + term
        response_value(post(path, collection))
      end

      def parse_message(message_id, delete_response = true)
        raise "message is empty for message_id(#{ message_id })" if @response_messages.nil? || @response_messages[message_id].nil?

        payload  = @response_messages[message_id][:payload]
        type     = @response_messages[message_id][:type]
        metadata = @response_messages[message_id][:metadata]

        @last_response_status = metadata.headers["status_code"]

        @response_messages.delete(message_id) if delete_response

        raise "OCCI-Server raise error: #{ payload } server status: #{ @last_response_status }" if metadata.headers["is_error"]

        begin
          return method("parse_#{ type }").call(payload, metadata)
        rescue Exception => e
          error_msg = e.message + "\n" + e.backtrace.to_s
          Occi::Log.error error_msg
          raise "Can not parse #{ type } payload: #{ payload } metadata: #{ metadata.inspect }"
        end
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

      # private stuff --------------------------------------------------------------------------------------------------
      private

      def parse_get(payload, metadata)
        if metadata.content_type == "text/uri-list"
          return payload.split("\n")
        else
          path = metadata.headers["path_info"]
          kind = @model.get_by_location(('/' + path).match(/\/.*\//).to_s) if @model
          kind ? entity_type = kind.entity_type : entity_type = nil
          collection = Occi::Parser.parse(metadata.content_type, payload, path.include?("/-/"), entity_type)
          return collection
        end
      end

      def parse_post(payload, metadata)
        return URI.parse(payload).to_s
      end

      def parse_delete(payload, metadata)
        return true
      end

      def run
        begin
          AMQP.start(CONNECTION_SETTING) do |connection, open_ok|
            @channel  = AMQP::Channel.new(connection)
            @exchange = @channel.default_exchange

            @channel.on_error(&method(:handle_channel_exception))

            @replies_queue = @channel.queue(Time.now.to_f.to_s + Kernel.rand().to_s, :exclusive => true)
            @replies_queue.subscribe(&method(:handle_message))

            @connected = true;
          end
        rescue Exception => e
          @thread_error = true
          Occi::Log.error "Amqp Thread get an Error: #{e.message} \n #{e.backtrace.join("\n")}"
        end
      end

      def handle_message(metadata, payload)

        correlation_id = metadata.correlation_id

        unless correlation_id.size > 0
          raise "Message has no correlation_id (message_id)"
        end

        @response_messages = Hash.new                             if @response_messages.nil?
        raise "Double Response Message ID: (#{ correlation_id })" if @response_messages.has_key?(correlation_id)

        #save responses message
        @response_messages[correlation_id] = {:payload => payload, :metadata => metadata, :type => @response_waiting[correlation_id][:options][:type]}

        #delete message_id from waiting stack
        @response_waiting.delete(correlation_id) unless @response_waiting.nil?
      end

      def set_model
        collection = response_value(get('/-/'))
        @model     = Occi::Model.new(collection)

        @mixins = {
            :os_tpl => [],
            :resource_tpl => [],
            :simulation => []
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

      #TODO filter
      def get(path='', is_uri_list = false, filter=nil)
        raise "OCCI AMQP is not connected!" if !@connected

        options = {
            :routing_key  => @endpoint_queue,
            :type         => "get",
            :content_type => "text/plain",
            :reply_to     => reply_queue_name,
            :message_id   => next_message_id,
            :headers => {
                :accept    => is_uri_list ? "text/uri-list" : @media_type,
                :path_info => "/" + path.gsub(/\A\//, '')
            }
        }

        publish('', options)

        return options[:message_id]
      end

      #@description
      #@param [String] path path to the resource
      #@param [OCCI::Collection] collection
      def post(path, collection=nil)
        path       = path.reverse.chomp('/').reverse

        if @media_type == 'application/occi+json'
          message = collection.to_json
          content_type = 'application/occi+json'
        else
          message = collection.to_text
          content_type = 'text/plain'
        end

        options = {
            :routing_key  => @endpoint_queue,
            :content_type => content_type,
            :type         => "post",
            :reply_to     => reply_queue_name,  #queue for response from the rOCCI
            :message_id   => next_message_id,  #Identifier for message so that the client can match the answer from the rOCCI
            :headers => {
                :accept    => "text/uri-list",
                :path_info => "/#{ path }",
                :auth => {
                    :type     => "basic",
                    :username => "user",
                    :password => "mypass",
                },
            }
        }

        publish(message, options)

        return options[:message_id]
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

        options = {
            :routing_key  => @endpoint_queue,
            :content_type => "text/plain",
            :type         => "delete",
            :reply_to     => reply_queue_name,  #queue for response from the rOCCI
            :message_id   => next_message_id,  #Identifier for message so that the client can match the answer from the rOCCI
            :headers => {
                :accept    => @media_type,
                :path_info => "/#{ path }",
                :auth => {
                    :type     => "basic",
                    :username => "user",
                    :password => "mypass",
                },
            }
        }

        publish('', options)

        return options[:message_id]
      end

      def response_value(message_id, is_wait = true, is_parse_response = true)
        waiting_for_response(message_id) if is_wait || is_parse_response

        if is_parse_response
          value = parse_message(message_id)
        else
          value = message_id
        end

        return value
      end

      # @param [String] message_id '' == all
      def waiting_for_response(message_id = '')
        return if @response_waiting.nil?

        if message_id.size > 0
          while !@response_waiting[message_id].nil?
            sleep(0.1)
          end
        else
          while size(@response_waiting) > 0
            sleep(0.1)
          end
        end
      end

      def publish(message, options = {})
        raise "No Message Id found" if options[:message_id] == nil?

        @exchange.publish(message, options)

        @response_waiting                       = Hash.new if @response_waiting.nil?
        @response_waiting[options[:message_id]] = {:options => options, :message => message}
      end

      def reply_queue_name
        @replies_queue.name
      end

      def next_message_id
        @message_id  = 0 if @message_id.nil?
        @message_id += 1
        @message_id.to_s;
      end

      # Sets auth method and appropriate httparty attributes. Supported auth methods
      # are: ["none"] and nil
      #
      # @example
      #    change_auth { :type => "none" }
      #
      # @param [Hash] authentication options
      def change_auth(auth_options)
        @auth_options = auth_options

        case @auth_options[:type]
          when "none", nil
            # do nothing
          else
            raise ArgumentError, "Unknown AUTH method [#{@auth_options[:type]}]!"
        end
      end

      def handle_channel_exception(channel, channel_close)
        Occi::Log.error "OCCI/AMQP: Channel-level exception [ code = #{channel_close.reply_code}, message = #{channel_close.reply_text} ]"
      end

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

        @endpoint       = endpoint.chomp('/') + '/'
        @endpoint_queue = "amqp.occi.#{@endpoint}" #amqp.occi.http://localhost/
      end

    end

    end
  end
end
