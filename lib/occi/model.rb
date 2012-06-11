require 'hashie/mash'
require 'occi/log'

module OCCI
  class Model
    @@categories = { }
    @@locations  = { }

    # register OCCI Core categories enitity, resource and link
    def self.register_core
      OCCI::Log.info("### Registering OCCI Core categories enitity, resource and link ###")
      OCCI::Core::Entity.register
      OCCI::Core::Resource.register
      OCCI::Core::Link.register
    end

    # register OCCI Infrastructure categories
    def self.register_infrastructure
      OCCI::Log.info("### Registering OCCI Infrastructure categories ###")
      self.register_files('etc/model/infrastructure', nil)
    end

    # register OCCI categories from files
    #
    # @param [String] path to a folder containing files which include OCCI collections in JSON format. The path is
    #  recursively searched for files with the extension .json .
    # @param [Sting] scheme_base_url base location for provider specific extensions of the OCCI model
    def self.register_files(path, scheme_base_url)
      OCCI::Log.info("### Initializing OCCI Model from #{path} ###")
      Dir.glob(path + '/**/*.json').each do |file|
        collection = OCCI::Collection.new(JSON.parse(File.read(file)))
        # add location of service provider to scheme if it has a relative location
        collection.kinds.collect { |kind| kind.scheme = scheme_base_url + kind.scheme if kind.scheme.start_with? '/' } if collection.kinds
        collection.mixins.collect { |mixin| mixin.scheme = scheme_base_url + mixin.scheme if mixin.scheme.start_with? '/' } if collection.mixins
        collection.actions.collect { |action| action.scheme = scheme_base_url + action.scheme if action.scheme.start_with? '/' } if collection.actions
        self.register_collection(collection)
      end
    end

    # register OCCI categories from OCCI collection
    def self.register_collection(collection)
      collection.kinds.each { |kind| self.register(OCCI::Core::Kind.new(kind)) } if collection.kinds
      collection.mixins.each { |mixin| self.register(OCCI::Core::Mixin.new(mixin)) } if collection.mixins
      collection.actions.each { |action| self.register(OCCI::Core::Action.new(action)) } if collection.actions
    end

    def self.reset()
      @@categories.each_value.each { |category| category.entities = [] if category.entities }
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def self.register(category)
      OCCI::Log.debug("### Registering category #{category.type_identifier}")
      @@categories[category.type_identifier] = category
      @@locations[category.location] = category.type_identifier unless category.kind_of?(OCCI::Core::Action)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def self.unregister(category)
      OCCI::Log.debug("### Unregistering category #{category.type_identifier}")
      @@categories.delete(category.type_identifier)
      @@locations.delete(category.location) unless category.kind_of?(OCCI :Core::Action)
    end

    # Returns the category corresponding to a given type identifier
    #
    # @param [URI] type identifier of a category
    def self.get_by_id(id)
      @@categories.fetch(id) { OCCI::Log.debug("Category with id #{id} not found"); nil }
    end

    # Returns the category corresponding to a given location
    #
    # @param [URI] Location of a category
    def self.get_by_location(location)
      id = @@locations.fetch(location) { OCCI::Log.debug("Category with location #{location} not found"); nil }
      self.get_by_id(id)
    end

    # Return all categories from model. If filter is present, return only the categories specified by filter
    #
    # @param [Hashie:Hash] filter
    # @return [Hashie::Mash] collection
    def self.get(filter = [])
      collection = Hashie::Mash.new({ :kinds => [], :mixins => [], :actions => [] })
      if filter.empty?
        @@categories.each_value do |category|
          collection.kinds << category if category.kind_of? OCCI::Core::Kind
          collection.mixins << category if category.kind_of? OCCI::Core::Mixin
          collection.actions << category if category.kind_of? OCCI::Core::Action
        end
      end
      OCCI::Log.debug("### Filtering categories #{filter.collect{|c| c.type_identifier}.inspect}")
      while filter.any? do
        cat = filter.pop
        filter.concat @@categories.each_value.select { |category| category.related_to?(cat.type_identifier) }
        category = get_by_id(cat.type_identifier)
        collection.kinds << category if category.kind_of?(OCCI::Core::Kind)
        collection.mixins << category if category.kind_of?(OCCI::Core::Mixin)
        collection.actions << category if category.kind_of?(OCCI::Core::Action)
      end
      return collection
    end

  end
end