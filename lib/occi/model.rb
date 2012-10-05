module Occi
  class Model < Occi::Collection

    # @param [Occi::Core::Collection] collection
    def initialize(collection=nil)
      super
      register_core
      register_collection collection if collection.kind_of? Occi::Collection
    end

    # register Occi Core categories enitity, resource and link
    def register_core
      Occi::Log.info "### Registering OCCI Core categories enitity, resource and link ###"
      register Occi::Core::Entity.kind
      register Occi::Core::Resource.kind
      register Occi::Core::Link.kind
    end

    # register Occi Infrastructure categories
    def register_infrastructure
      Occi::Log.info "### Registering OCCI Infrastructure categories ###"
      Occi::Infrastructure.categories.each { |category| register category }
    end

    # register OCCI categories from files
    #
    # @param [String] path to a folder containing files which include OCCI collections in JSON format. The path is
    #  recursively searched for files with the extension .json .
    # @param [Sting] scheme_base_url base location for provider specific extensions of the OCCI model
    def register_files(path, scheme_base_url='http://localhost')
      Occi::Log.info "### Initializing OCCI Model from #{path} ###"
      Dir.glob(path + '/**/*.json').each do |file|
        collection = Occi::Collection.new(JSON.parse(File.read(file)))
        # add location of service provider to scheme if it has a relative location
        collection.kinds.collect { |kind| kind.scheme = scheme_base_url + kind.scheme if kind.scheme.start_with? '/' } if collection.kinds
        collection.mixins.collect { |mixin| mixin.scheme = scheme_base_url + mixin.scheme if mixin.scheme.start_with? '/' } if collection.mixins
        collection.actions.collect { |action| action.scheme = scheme_base_url + action.scheme if action.scheme.start_with? '/' } if collection.actions
        register_collection collection
      end
    end

    # register OCCI categories from OCCI collection
    def register_collection(collection)
      collection.kinds.each { |kind| kind.model = self }
      collection.mixins.each { |mixin| mixin.model = self }
      collection.actions.each { |action| action.model = self }
      merge! collection
    end

    # clear all entities from all categories
    def reset()
      categories.each { |category| category.entities = [] if category.respond_to? :entities }
    end

    # @param [Occi::Core::Category] category
    def register(category)
      Occi::Log.debug "### Registering category #{category.type_identifier}"
      # add model to category as back reference
      category.model = self
      case category.class.name
        when Occi::Core::Kind.to_s
          @kinds << category unless get_by_id(category.type_identifier)
        when Occi::Core::Mixin.to_s
          @mixins << category unless get_by_id(category.type_identifier)
        when Occi::Core::Action.to_s
          @actions << category unless get_by_id(category.type_identifier)
      end
    end

    # @param [Occi::Core::Category] category
    def unregister(category)
      Occi::Log.debug "### Unregistering category #{category.type_identifier}"
      @kinds.delete category
      @mixins.delete category
      @actions.delete category
    end

    # Return all categories from model. If filter is present, return only the categories specified by filter
    #
    # @param [Occi::Collection] filter
    # @return [Occi::Collection] collection
    def get(filter = nil)
      if filter
        self.intersect filter
      else
        self
      end
    end

  end
end