require 'hashie/mash'

module OCCI
  class Collection
    attr_accessor :kinds
    attr_accessor :mixins
    attr_accessor :actions
    attr_accessor :resources
    attr_accessor :links

    # Initialize a new OCCI Collection by initializing all supplied OCCI objects
    #
    # @param [Hash] collection including one or more of the keys kinds, mixins, actions, resources, links
    def initialize(collection={ })
      collection = Hashie::Mash.new(collection)
      @kinds     = []
      @mixins    = []
      @actions   = []
      @resources = []
      @links     = []
      @kinds = collection.kinds.collect { |kind| OCCI::Core::Kind.new(kind) } if collection.kinds.instance_of? Array
      @mixins = collection.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin) } if collection.mixins.instance_of? Array
      @actions = collection.actions.collect { |action| OCCI::Core::Action.new(action) } if collection.actions.instance_of? Array
      @resources = collection.resources.collect { |resource| OCCI::Core::Resource.new(resource) } if collection.resources.instance_of? Array
      @links = collection.links { |link| OCCI::Core::Link.new(link) } if collection.links.instance_of? Array
    end

    # @return [Array] categories combined list of all kinds, mixins and actions
    def categories
      @kinds + @mixins + @actions
    end

    # @return [Array] entities combined list of all resources and links
    def entities
      @resources + @links
    end

    def empty?
      @kinds.empty? && @mixins.empty? && @actions.empty? && @resources.empty? && @links.empty?
    end

    def to_json(options = { })
      { :kinds => @kinds, :mixins => @mixins, :actions => @actions, :resources => @resources, :links => @links }.to_json
    end

  end
end