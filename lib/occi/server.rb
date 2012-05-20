##############################################################################
#  Copyright 2011 Service Computing group, TU Dortmund
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##############################################################################

##############################################################################
# Description: OCCI RESTful Web Service
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

##############################################################################
# Require Ruby Gems

# gems
require 'rubygems'

# sinatra
require 'sinatra'
require 'sinatra/multi_route'
require 'sinatra/cross_origin'
require 'sinatra/respond_with'

# Ruby standard library
require 'uri'
require 'fileutils'

# Server configuration
require 'occi/configuration'

# Active support notifications
require 'active_support/notifications'

# Active support for xml rendering
require 'active_support/core_ext'

##############################################################################
# Require OCCI classes

# Exceptions
require 'occi/exceptions'

# Category registry
require 'occi/registry'

# OCCI Core classes
require 'occi/core/action'
require 'occi/core/category'
require 'occi/core/entity'
require 'occi/core/kind'
require 'occi/core/link'
require 'occi/core/mixin'
require 'occi/core/resource'

# OCCI Request handling
require 'occi/request'

# Backend support
require 'occi/backend/manager'

##############################################################################
# Sinatra methods for handling HTTP requests

module OCCI
  class Server < Sinatra::Application

    register Sinatra::MultiRoute
    register Sinatra::CrossOrigin
    register Sinatra::RespondWith

    enable cross_origin

    # Read configuration file
    def self.config
      @@config ||= OCCI::Configuration.new('etc/occi-server.conf')
    end

    def self.location
      OCCI::Server.config[:server].chomp('/')
    end

    def self.port
      OCCI::Server.config[:port]
    end

    def self.uri
      self.port.nil? ? self.location : self.location + ':' + self.port
    end

    def initialize(config = {})
      # create logger
      config[:log_dest] ||= STDOUT
      config[:log_level] ||= Logger::INFO
      config[:log_level] = case OCCI::Server.config[:log_level]
                             when "debug"
                               Logger::DEBUG
                             when "info"
                               Logger::INFO
                             when "warn"
                               Logger::WARN
                             when "error"
                               Logger::ERROR
                             when "fatal"
                               Logger::FATAL
                             else
                               Logger::INFO
                           end

      @logger = Logger.new(config[:log_dest])
      @logger.level = config[:log_level]

      # subscribe to log messages and send to logger
      @log_subscriber = ActiveSupport::Notifications.subscribe("log") do |name, start, finish, id, payload|
        @logger.log(payload[:level], payload[:message])
      end

      # Configuration of HTTP Authentication
      if OCCI::Server.config['username'] != nil and OCCI::Server.config['password'] != nil
        use Rack::Auth::Basic, "Restricted Area" do |username, password|
          [username, password] == [OCCI::Server.config['username'], OCCI::Server.config['password']]
        end
      end

      OCCI::Server.initialize_core_model
      OCCI::Server.initialize_model(OCCI::Server.config['occi_model_path'])

      # set views explicitly
      set :views, File.dirname(__FILE__) + "/../../views"

      super
    end

# ---------------------------------------------------------------------------------------------------------------------

    def self.initialize_core_model
      OCCI::Log.info("### Initializing OCCI Core Model ###")
      OCCI::Core::Entity.register
      OCCI::Core::Resource.register
      OCCI::Core::Link.register
    end

    def self.initialize_model(path)
      OCCI::Log.info("### Initializing OCCI Model from #{path} ###")
      Dir.glob(path + '**/*.json').each do |file|
        collection = Hashie::Mash.new(JSON.parse(File.read(file)))
        # add location of service provider to scheme if it has a relative location
        collection.kinds.collect { |kind| kind.scheme = self.location + kind.scheme if kind.scheme.start_with? '/' } if collection.kinds
        collection.mixins.collect { |mixin| mixin.scheme = self.location + mixin.scheme if mixin.scheme.start_with? '/' } if collection.mixins
        collection.actions.collect { |action| action.scheme = self.location + action.scheme if action.scheme.start_with? '/' } if collection.actions
        # register categories
        collection.kinds.each { |kind| OCCI::Registry.register(OCCI::Core::Kind.new(kind)) } if collection.kinds
        collection.mixins.each { |mixin| OCCI::Registry.register(OCCI::Core::Mixin.new(mixin)) } if collection.mixins
        collection.actions.each { |action| OCCI::Registry.register(OCCI::Core::Action.new(action)) } if collection.actions
      end
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def initialize_backend(auth)

      if auth.provided? && auth.basic? && auth.credentials
        user, password = auth.credentials
      else
        user, password = [OCCI::Server.config['one_user'], OCCI::Server.config['one_password']]
        logger.debug("No basic auth data provided: using defaults from config (user = '#{user}')")
      end

      @backend = case OCCI::Server.config["backend"]
                   when "opennebula"
                     require 'occi/backend/opennebula/opennebula'
                     OCCI::Server.initialize_model('etc/backend/opennebula')
                     OCCI::Backend::Manager.register_backend(OCCI::Backend::OpenNebula::OpenNebula, OCCI::Backend::OpenNebula::OpenNebula::OPERATIONS)
                     OCCI::Backend::OpenNebula::OpenNebula.new(user, password)
                   when "ec2"
                     require 'occi/backend/ec2/ec2'
                     Bundler.require(:ec2)
                     OCCI::Server.initialize_model('etc/backend/ec2')
                     OCCI::Backend::Manager.register_backend(OCCI::Backend::EC2::EC2, OCCI::Backend::EC2::EC2::OPERATIONS)
                     OCCI::Backend::EC2::EC2.new(user, password)
                   when "dummy" then
                     require 'occi/backend/dummy'
                     OCCI::Backend::Manager.register_backend(OCCI::Backend::Dummy, OCCI::Backend::Dummy::OPERATIONS)
                     OCCI::Backend::Dummy.new()
                   else
                     raise "Backend '" + OCCI::Server.config["backend"] + "' not found"
                 end


    end

# ---------------------------------------------------------------------------------------------------------------------

# GET request

# tasks to be executed before the request is handled
    before do
      OCCI::Log.debug('--------------------------------------------------------------------')
      OCCI::Log.debug("### Client IP: #{request.ip}")
      OCCI::Log.debug("### Client Accept: #{request.accept}")
      OCCI::Log.debug("### Client User Agent: #{request.user_agent}")
      OCCI::Log.debug("### Client Request URL: #{request.url}")
      OCCI::Log.debug("### Client Request method: #{request.request_method}")
      OCCI::Log.debug("### Client Request Media Type: #{request.media_type}")
      OCCI::Log.debug('--------------------------------------------------------------------')

      OCCI::Log.debug('### Prepare response ###')
      response['Accept'] = "application/occi+json,application/json,text/plain,text/uri-list,application/xml,text/xml,application/occi+xml"
      response['Server'] = "rOCCI/#{VERSION_NUMBER} OCCI/1.1"
      OCCI::Log.debug('### Initialize response OCCI collection ###')
      @collection = Hashie::Mash.new(:kinds => [], :mixins => [], :actions => [], :resources => [], :links => [], :locations => [])
      OCCI::Log.debug('### Preparing authentication handling ###')
      authentication = Rack::Auth::Basic::Request.new(request.env)
      OCCI::Log.debug('### Initializing backend ###')
      initialize_backend(authentication)
      OCCI::Log.debug('### Reset OCCI model ###')
      OCCI::Registry.reset
      OCCI::Log.debug('### Parsing request data to OCCI data structure ###')
      @request_collection = OCCI::Request.new(request)
      OCCI::Log.debug('### Fill OCCI model with entities from backend ###')
      @backend.register_existing_resources
    end

    after do
      # OCCI::Log.debug((@collection.resources.to_a + @collection.links.to_a).collect {|entity| entity.location}.join("\n"))
      OCCI::Log.debug('### Rendering response ###')
      @collection.delete_if { |k, v| v.empty? } # remove empty entries
      respond_to do |f|
        f.txt { erb :collection, :locals => {:collection => @collection} }
        f.json { @collection.to_json }
        f.on('application/occi+json') { @collection.to_json }
        f.xml { @collection.to_xml(:root => "collection") }
        f.on('application/occi+xml') { @collection.to_xml(:root => "collection") }
        f.on('text/uri-list') { ((@collection.resources.to_a + @collection.links.to_a).collect { |entity| self.uri + entity.location } + @collection.locations.to_a).join("\n") }
        f.on('*/*') { erb :collection, :locals => {:collection => @collection} }
      end
      OCCI::Log.debug('### Successfully rendered ###')
    end

# discovery interface
# returns all kinds, mixins and actions registered for the server
    get '/-/', '/.well-known/org/ogf/occi/-/' do
      OCCI::Log.info("### Listing all kinds, mixins and actions ###")
      @collection = OCCI::Registry.get(@request_collection.categories)
      status 200
    end

# Resource retrieval
# returns entities either below a certain path or belonging to a certain kind or mixin
    get '*' do
      if request.path_info.end_with?('/')
        if request.path_info == '/'
          kinds = OCCI::Registry.get.kinds
        else
          kinds = [OCCI::Registry.get_by_location(request.path_info)]
        end

        @collection.resources = []
        @collection.links = []
        kinds.each do |kind|
          OCCI::Log.info("### Listing all entities of kind #{kind.type_identifier} ###")
          @collection.resources.concat kind.entities if kind.entity_type == OCCI::Core::Resource.name
          @collection.links.concat kind.entities if kind.entity_type == OCCI::Core::Link.name
        end
      else
        kind = OCCI::Registry.get_by_location(request.path_info.rpartition('/').first + '/')
        uuid = request.path_info.rpartition('/').last
        break if kind.nil? or uuid.nil?
        OCCI::Log.info("### Listing entity with uuid #{uuid} ###")
        @collection.resources = kind.entities.select { |entity| entity.id == uuid } if kind.entity_type == OCCI::Core::Resource.name
        @collection.links = kind.entities.select { |entity| entity.id == uuid } if kind.entity_type == OCCI::Core::Link.name
      end
      status 200
    end

# ---------------------------------------------------------------------------------------------------------------------
# POST request
    post '/-/', '/.well-known/org/ogf/occi/-/' do
      logger.info("## Creating user defined mixin ###")
      raise OCCI::MixinAlreadyExistsError, "Mixin already exists!" if OCCI::Registry.get(@request_collection.mixins)
      @request_collection.mixins.each do |mixin|
        OCCI::CategoryRegistry.register(mixin)
        # TODO: inform backend about new mixin
      end
    end

# Create an instance appropriate to category field and optionally link an instance to another one
    post '*' do
      begin
        category = OCCI::Registry.get_by_location(request.path_info)

        if category.nil?
          OCCI::Log.debug("### No category found for request location #{request.path_info} ###")
          status 404
        end

        # if action
        if params[:action]
          method = params[:method]
          if @request_collection.actions
            action = @request_collection.actions.first
            method ||= action.attributes!.method
          else
            action = OCCI::Registry.get_by_id(category.actions.select { |action| action.split('#').last == params[:action] }.first)
          end

          category.entities.each do |entity|
            OCCI::Backend::Manager.delegate_action(@backend, action, method, entity)
            status 200
          end
        elsif category.kind_of?(OCCI::Core::Kind)
          @request_collection.resources.each do |resource|
            OCCI::Log.debug("Deploying resource with title #{resource.title} in backend #{@backend.class.name}")
            OCCI::Backend::Manager.signal_resource(@backend, OCCI::Backend::RESOURCE_DEPLOY, resource)
            @collection.locations << self.uri + resource.location
            status 201
          end
        elsif category.kind_of?(OCCI::Core::Mixin)
          @request_collection.locations.each do |location|
            OCCI::Log.debug("Attaching resource #{resource.title} to mixin #{mixin.type_identifier} in backend #{@backend.class.name}")
            # TODO: let backend carry out tasks related to the added mixin
            category.entities << OCCI::Rendering::HTTP::LocationRegistry.get_object(location)
            status 200
          end
        else
          status 400
        end

      rescue Exception => e
        logger.error(e)
        status 400
      end
    end

# ---------------------------------------------------------------------------------------------------------------------
# PUT request

    put '*' do
      begin
        # Add an resource instance to a mixin
        unless @occi_request.mixins.empty?
          mixin = OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info)

          @occi_request.locations.each do |location|
            entity = OCCI::Rendering::HTTP::LocationRegistry.get_object(URI.parse(location).path)

            raise "No entity found at location: #{entity_location}" if entity == nil
            raise "Object referenced by uri [#{entity_location}] is not a OCCI::Core::Resource instance!" if !entity.kind_of?(OCCI::Core::Resource)

            logger.debug("Associating entity [#{entity}] at location #{entity_location} with mixin #{mixin}")

            entity.mixins << mixin
          end
          break
        end

        # Update resource instance(s) at the given location
        unless OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info).nil?
          entities = []
          # Determine set of resources to be updated
          if OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info).kind_of?(OCCI::Core::Resource)
            entities = [OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info)]
          elsif not OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info).kind_of?(OCCI::Core::Category)
            entities = OCCI::Rendering::HTTP::LocationRegistry.get_resources_below_location(request.path_info, OCCI::CategoryRegistry.get_all)
          elsif OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info).kind_of?(OCCI::Core::Category)
            object = OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info)
            @occi_request.locations.each do |loc|
              entities << OCCI::Rendering::HTTP::LocationRegistry.get_object(URI.parse(loc.chomp('"').reverse.chomp('"').reverse).path)
            end
          end
          logger.info("Full update for [#{entities.size}] entities...")

          # full update of mixins
          object.entities.each do |entity|
            entity.mixins.delete(object)
            object.entities.delete(entity)
          end if object.kind_of?(OCCI::Core::Mixin)

          entities.each do |entity|
            logger.debug("Adding entity: #{entity.get_location} to mixin #{object.type_identifier}")
            entity.mixins.push(object).uniq!
            object.entities.push(entity).uniq!
          end if object.kind_of?(OCCI::Core::Mixin)

          # full update of attributes
          entities.each do |entity|
            # Refresh information from backend for entities of type resource
            # TODO: full update
            entity.attributes.merge!(@occi_request.attributes)
            # TODO: update entity in backend
          end unless @occi_request.attributes.empty?

          # full update of links
          # TODO: full update e.g. delete old links first
          @occi_request.links.each do |link_data|
            logger.debug("Extracted link data: #{link_data}")
            raise "Mandatory information missing (related | target | category)!" unless link_data.related != nil && link_data.target != nil && link_data.category != nil

            link_mixins = []
            link_kind = nil
            link_data.category.split(' ').each do |link_category|
              begin
                cat = OCCI::CategoryRegistry.get_by_id(link_category)
              rescue OCCI::CategoryNotFoundException => e
                logger.info("Category #{link_category} not found")
                next
              end
              link_kind = cat if cat.kind_of?(OCCI::Core::Kind)
              link_mixins << cat if cat.kind_of?(OCCI::Core::Mixin)
            end

            raise "No kind for link category #{link_data.category} found" if link_kind.nil?

            target_location = link_data.target_attr
            target = OCCI::Rendering::HTTP::LocationRegistry.get_object(target_location)

            entities.each do |entity|

              source_location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(entity)

              link_attributes = link_data.attributes.clone
              link_attributes["occi.core.target"] = target_location.chomp('"').reverse.chomp('"').reverse
              link_attributes["occi.core.source"] = source_location

              link = link_kind.entity_type.new(link_attributes, link_mixins)
              OCCI::Rendering::HTTP::LocationRegistry.register_location(link.get_location(), link)

              target.links << link
              entity.links << link
            end
          end
          break
        end

        response.status = OCCI::Rendering::HTTP::Response::HTTP_NOT_FOUND
        # Create resource instance at the given location
        raise "Creating resources with method 'put' is currently not possible!"

        # This must be the last statement in this block, so that sinatra does not try to respond with random body content
        # (or fail utterly while trying to do that!)
        nil

      rescue OCCI::LocationAlreadyRegisteredException => e
        logger.error(e.message)
        response.status = OCCI::Rendering::HTTP::Response::HTTP_CONFLICT

      rescue OCCI::MixinAlreadyExistsError => e
        logger.error(e.message)
        response.status = OCCI::Rendering::HTTP::Response::HTTP_CONFLICT

      rescue Exception => e
        logger.error(e)
        response.status = OCCI::Rendering::HTTP::Response::HTTP_BAD_REQUEST
      end
    end

# ---------------------------------------------------------------------------------------------------------------------
# DELETE request

    delete '/-/', '/.well-known/org/ogf/occi/-/' do
      # Location references query interface => delete provided mixin
      raise OCCI::CategoryMissingException if @request_collection.mixins.nil?
      mixins = OCCI::Registry.get(@request_collection.mixins)
      raise OCCI::MixinNotFoundException if mixins.nil?
      mixins.each do |mixin|
        OCCI::Log.debug("### Deleting mixin #{mixin.type_identifier} ###")
        mixin.entities.each do |entity|
          entity.mixins.delete(mixin)
        end
        # TODO: Notify backend to delete mixin and unassociate entities
        OCCI::Registry.unregister(mixin)
      end
      status 200
    end

    delete '*' do

      begin
        # unassociate resources specified by URI in payload from mixin specified by request location
        if request.path_info == '/'
          categories = OCCI::Registry.get.kinds
        else
          categories = [OCCI::Registry.get_by_location(request.path_info.rpartition('/').first + '/')]
        end

        categories.each do |category|
          case category
            when OCCI::Core::Mixin
              mixin = category
              OCCI::Log.debug("### Deleting entities from mixin #{mixin.type_identifier} ###")
              @request_collection.locations.each do |location|
                uuid = location.to_s.rpartition('/').last
                mixin.entities.delete_if { |entity| entity.id == uuid }
              end
            when OCCI::Core::Kind
              kind = category
              if request.path_info.end_with?('/')
                if @request_collection.mixins.any?
                  @request_collection.mixins.each do |mixin|
                    OCCI::Log.debug("### Deleting entities from kind #{kind.type_identifier} with mixin #{mixin.type_identifier} ###")
                    kind.entities.delete_if? { |entity| mixin.include?(entity) }
                    # TODO: links
                    OCCI::Backend::Manager.signal_resource(@backend, OCCI::Backend::RESOURCE_DELETE, entity)
                  end
                else
                  # TODO: links
                  OCCI::Log.debug("### Deleting entities from kind #{kind.type_identifier} ###")
                  kind.entities.each { |resource| OCCI::Backend::Manager.signal_resource(@backend, OCCI::Backend::RESOURCE_DELETE, resource) }
                  kind.entities.clear
                end
              else
                uuid = request.path_info.rpartition('/').last
                OCCI::Log.debug("### Deleting entity with id #{uuid} from kind #{kind.type_identifier} ###")
                OCCI::Backend::Manager.signal_resource(@backend, OCCI::Backend::RESOURCE_DELETE, entity)
                kind.entities.delete_if? { |entity| entity.id == uuid }
              end
          end
        end

          # delete entities


          #  # Location references a mixin => unassociate all provided resources (by X_OCCI_LOCATION) from it
          #  object = OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info)
          #  if object != nil && object.kind_of?(OCCI::Core::Mixin)
          #    mixin = OCCI::Rendering::HTTP::LocationRegistry.get_object(request.path_info)
          #    logger.info("Unassociating entities from mixin: #{mixin}")
          #
          #    @occi_request.locations.each do |loc|
          #      entity = OCCI::Rendering::HTTP::LocationRegistry.get_object(URI.parse(loc.chomp('"').reverse.chomp('"').reverse).path)
          #      mixin.entities.delete(entity)
          #      entity.mixins.delete(mixin)
          #    end
          #    break
          #  end
          #
          #  entities = OCCI::Rendering::HTTP::LocationRegistry.get_resources_below_location(request.path_info, @occi_request.categories)
          #
          #  unless entities.nil?
          #    entities.each do |entity|
          #      location = entity.get_location
          #      OCCI::Backend::Manager.signal_resource(@backend, OCCI::Backend::RESOURCE_DELETE, entity) if entity.kind_of? OCCI::Core::Resource
          #      # TODO: delete links in backend!
          #      entity.delete
          #      OCCI::Rendering::HTTP::LocationRegistry.unregister(location)
          #    end
          #    break
          #  end
          #
          #  response.status = OCCI::Rendering::HTTP::Response::HTTP_NOT_FOUND
          #  # This must be the last statement in this block, so that sinatra does not try to respond with random body content
          #  # (or fail utterly while trying to do that!)
          #  nil

      rescue OCCI::LocationNotRegisteredException => e
        logger.error(e.message)
        response.status = OCCI::Rendering::HTTP::Response::HTTP_NOT_FOUND

      rescue OCCI::CategoryMissingException => e
        response.status = OCCI::Rendering::HTTP::Response::HTTP_BAD_REQUEST

      rescue OCCI::MixinNotFoundException => e
        response.status = OCCI::Rendering::HTTP::Response::HTTP_NOT_FOUND

      rescue Exception => e
        logger.error(e)
        response.status = OCCI::Rendering::HTTP::Response::HTTP_BAD_REQUEST
      end
    end
  end
end