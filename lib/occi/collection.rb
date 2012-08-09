require 'hashie/mash'
require 'active_support/json'

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
      @kinds = collection.kinds.collect { |kind| OCCI::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) } if collection.kinds.instance_of? Array
      @mixins = collection.mixins.collect { |mixin| OCCI::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) } if collection.mixins.instance_of? Array
      @actions = collection.actions.collect { |action| OCCI::Core::Action.new(action.scheme, action.term, action.title, action.attributes) } if collection.actions.instance_of? Array
      @resources = collection.resources.collect { |resource| OCCI::Core::Resource.new(resource.kind, resource.mixins, resource.attributes, resource.links) } if collection.resources.instance_of? Array
      @links = collection.links { |link| OCCI::Core::Link.new(link.kind, link.mixins, link.attributes) } if collection.links.instance_of? Array
    end

    # @return [Array] categories combined list of all kinds, mixins and actions
    def categories
      @kinds + @mixins + @actions
    end

    # @return [Array] entities combined list of all resources and links
    def entities
      @resources + @links
    end

    # @return [true,false] true if collection is empty, false otherwise
    def empty?
      @kinds.empty? && @mixins.empty? && @actions.empty? && @resources.empty? && @links.empty?
    end

    # @return [Hashie::Mash] json representation
    def as_json(options = { })
      collection = Hashie::Mash.new
      collection.kinds = @kinds.collect { |kind| kind.as_json } if @kinds.any?
      collection.mixins = @mixins.collect { |mixin| mixin.as_json } if @mixins.any?
      collection.actions = @actions.collect { |action| action.as_json } if @actions.any?
      collection.resources = @resources.collect { |resource| resource.as_json } if @resources.any?
      collection.links = @links.collect { |link| link.as_json } if @links.any?
      collection
    end

    # @return [String] text representation
    def to_text
      text = ""
      text << self.categories.collect { |category| category.to_text }.join("\n")
      text << "\n" if self.categories.any?
      raise "Only one entity allowed for rendering to plain text" if self.entities.size > 1
      text << self.entities.collect {|entity| entity.to_text}.join("\n")
      text
    end

    def inspect
      JSON.pretty_generate(JSON.parse(to_json))
    end

  end
end