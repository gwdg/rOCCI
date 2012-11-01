module Occi
  class Collection
    attr_accessor :kinds, :mixins, :actions, :resources, :links, :action, :model

    # Initialize a new OCCI Collection by initializing all supplied OCCI objects
    #
    # @param [Hash] collection including one or more of the keys kinds, mixins, actions, resources, links
    def initialize(collection={ })
      #TODO: add classes for entity lists
      collection = Hashie::Mash.new(collection) unless collection.kind_of? Occi::Collection
      @kinds     = Occi::Core::Kinds.new
      @mixins    = Occi::Core::Mixins.new
      @actions   = Occi::Core::Actions.new
      @resources = Occi::Core::Resources.new
      @links     = Occi::Core::Links.new
      @kinds = collection.kinds.collect { |kind| Occi::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) } if collection.kinds.instance_of? Array
      @mixins = collection.mixins.collect { |mixin| Occi::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) } if collection.mixins.instance_of? Array
      @actions = collection.actions.collect { |action| Occi::Core::Action.new(action.scheme, action.term, action.title, action.attributes) } if collection.actions.instance_of? Array
      @resources = collection.resources.collect { |resource| Occi::Core::Resource.new(resource.kind, resource.mixins, resource.attributes, resource.links) } if collection.resources.instance_of? Array
      @links = collection.links { |link| Occi::Core::Link.new(link.kind, link.mixins, link.attributes) } if collection.links.instance_of? Array
      @action = Occi::Core::Action.new(collection.action.scheme, collection.action.term, collection.action.title, collection.action.attributes) if collection.action
    end

    # @return [Array] categories combined list of all kinds, mixins and actions
    def categories
      @kinds + @mixins + @actions
    end

    # @return [Array] entities combined list of all resources and links
    def entities
      @resources + @links
    end

    # @param [Occi::Core::Model] model
    # @return [Occi::Core::Model]
    def model=(model)
      @kinds.model   = model
      @mixins.model  = model
      @actions.model = model
      @resource.model= model
      @links.model   = model
    end

    # @param [Occi::Collection] other_collection
    # @return [Occi::Collection]
    def merge!(other_collection)
      merge other_collection, self
    end

    # @param [Occi::Collection] other_collection
    # @param [Occi::Collection] collection
    # @return [Occi::Collection]
    def merge(other_collection, collection=self.clone)
      collection.kinds.merge other_collection.kinds.select { |kind| get_by_id(kind.type_identifier).nil? }
      collection.mixins.merge other_collection.mixins.select { |mixin| get_by_id(mixin.type_identifier).nil? }
      collection.actions.merge other_collection.actions.select { |action| get_by_id(action.type_identifier).nil? }
      collection.resources.merge other_collection.resources.select { |resource| get_by_id(resource.id).nil? }
      collection.links.merge other_collection.links.select { |link| get_by_id(link.type_identifier).nil? }
      collection.action = other_collection.action if other_collection.action
      collection
    end

    # @param [Occi::Collection] other_collection
    # @return [Occi::Collection]
    def intersect!(other_collection)
      intersect other_collection, self
    end

    # @param [Occi::Collection] other_collection
    # @param [Occi::Collection] collection
    # @return [Occi::Collection]
    def intersect(other_collection, collection=self.clone)
      collection.kinds     = other_collection.kinds.select { |kind| get_by_id(kind.type_identifier) }
      collection.mixins    = other_collection.mixins.select { |mixin| get_by_id(mixin.type_identifier) }
      collection.actions   = other_collection.actions.select { |action| get_by_id(action.type_identifier) }
      collection.resources = other_collection.resources.select { |resource| get_by_id(resource.id) }
      collection.links     = other_collection.links.select { |link| get_by_id(link.type_identifier) }
      if collection.action == other_collection.action
        collection.action = other_collection.action
      else
        collection.action = nil
      end
      collection
    end

    # Returns the category corresponding to a given id
    #
    # @param [String] id
    # @return [Occi::Core::Category]
    def get_by_id(id)
      object = self.categories.select { |category| category.type_identifier == id }
      object = self.entities.select { |entity| entity.id == id } if object.empty?
      object.first
    end

    # Returns the category corresponding to a given location
    #
    # @param [URI] location
    # @return [Occi::Core::Category]
    def get_by_location(location)
      self.categories.select { |category| category.location == location }.first
    end

    # @return [true,false] true if collection is empty, false otherwise
    def empty?
      @kinds.empty? && @mixins.empty? && @actions.empty? && @resources.empty? && @links.empty? && @action.nil?
    end

    # @return [Hashie::Mash] json representation
    def as_json(options = { })
      collection = Hashie::Mash.new
      collection.kinds = @kinds.collect { |kind| kind.as_json } if @kinds.any?
      collection.mixins = @mixins.collect { |mixin| mixin.as_json } if @mixins.any?
      collection.actions = @actions.collect { |action_category| action_category.as_json } if actions.any?
      collection.resources = @resources.collect { |resource| resource.as_json } if @resources.any?
      @links.merge(@resources.collect { |resource| resource.links.select { |link| link.kind_of? Occi::Core::Link } }.flatten)
      collection.links = @links.collect { |link| link.as_json } if @links.any?
      collection.action = @action.as_json if @action
      collection
    end

    # @return [String] text representation
    def to_text
      text = ""
      text << self.categories.collect { |category| category.to_text }.join("\n")
      text << "\n" if self.categories.any?
      raise "Only one resource allowed for rendering to text/plain" if self.resources.size > 1
      text << self.resources.collect { |resource| resource.to_text }.join("\n")
      text << self.links.collect { |link| link.to_text_link }.join("\n")
      text << self.action.to_text if self.action
      text
    end

    def to_header
      header = Hashie::Mash.new
      header['Category'] = self.categories.collect { |category| category.to_string_short }.join(',') if self.categories.any?
      raise "Only one resource allowed for rendering to text/occi" if self.resources.size > 1
      header = self.resources.first.to_header if self.resources.any?
      header['Link'] = self.links.collect { |link| link.to_string }.join(',') if self.links.any?
      header = self.action.to_header if self.action
      header
    end

    def inspect
      JSON.pretty_generate(JSON.parse(to_json))
    end

  end
end