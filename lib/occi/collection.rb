module Occi
  class Collection

    include Occi::Helpers::Inspect

    attr_accessor :kinds, :mixins, :actions, :resources, :links, :action, :model

    # Initialize a new OCCI Collection by initializing all supplied OCCI objects
    #
    # @param [Hash] collection including one or more of the keys kinds, mixins, actions, resources, links
    def initialize(collection={}, model = Occi::Model.new)
      collection = Hashie::Mash.new(collection) unless collection.kind_of? Occi::Collection

      @kinds = Occi::Core::Kinds.new
      @mixins = Occi::Core::Mixins.new
      @actions = Occi::Core::Actions.new
      @resources = Occi::Core::Resources.new
      @links = Occi::Core::Links.new

      self.model = model if model

      @kinds.merge collection.kinds.to_a.collect { |kind| Occi::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) }
      @mixins.merge collection.mixins.to_a.collect { |mixin| Occi::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) }
      @actions.merge collection.actions.to_a.collect { |action| Occi::Core::Action.new(action.scheme, action.term, action.title, action.attributes) }
      @resources.merge collection.resources.to_a.collect { |resource| Occi::Core::Resource.new(resource.kind, resource.mixins, resource.attributes, resource.links) }
      @links.merge collection.links.to_a.collect { |link| Occi::Core::Link.new(link.kind, link.mixins, link.attributes) }
      @action = Occi::Core::ActionInstance.new(collection.action, collection.attributes) if collection.action
    end

    def <<(object)
      object.kind_of? Occi::Core::Kind and self.kinds << object
      object.kind_of? Occi::Core::Mixin and self.mixins << object
      object.kind_of? Occi::Core::Action and self.actions << object
      object.kind_of? Occi::Core::Resource and self.resources << object
      object.kind_of? Occi::Core::Link and self.links << object
    end

    def ==(category)
      not intersect(category).empty?
    end

    # @return [Occi::Core::Categories] categories combined list of all kinds, mixins and actions
    def categories
      Occi::Core::Categories.new(@kinds + @mixins + @actions)
    end

    # @return [Occi::Core::Entities] entities combined list of all resources and links
    def entities
      Occi::Core::Entities.new(@resources + @links)
    end

    # @param [Occi::Core::Model] model
    # @return [Occi::Core::Model]
    def model=(model)
      @model = model
      @kinds.model = model
      @mixins.model = model
      @actions.model = model
      @resources.model = model
      @links.model = model
    end

    def check
      @resources.check
      @links.check
      # TODO: check action instance format, should check be applicable?
      #@action.check
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
      collection.kinds.replace other_collection.kinds.select { |kind| get_by_id(kind.type_identifier) }
      collection.mixins.replace other_collection.mixins.select { |mixin| get_by_id(mixin.type_identifier) }
      collection.actions.replace other_collection.actions.select { |action| get_by_id(action.type_identifier) }
      collection.resources.replace other_collection.resources.select { |resource| get_by_id(resource.id) }
      collection.links.replace other_collection.links.select { |link| get_by_id(link.type_identifier) }
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

    # Returns a collection with all categories related to the specified category
    #
    # @param [Occi::Core::Category] category
    # @return [Occi::Core::Collection]
    def get_related_to(category)
      collection = self.class.new
      collection.kinds = @kinds.get_related_to(category)
      collection.mixins = @mixins.get_related_to(category)
      collection
    end

    # @return [Hashie::Mash] json representation
    def as_json(options = {})
      collection = Hashie::Mash.new
      collection.kinds = @kinds.collect { |kind| kind.as_json } if @kinds.any?
      collection.mixins = @mixins.collect { |mixin| mixin.as_json } if @mixins.any?
      collection.actions = @actions.collect { |action_category| action_category.as_json } if @actions.any?
      collection.resources = @resources.collect { |resource| resource.as_json } if @resources.any?
      # if there is only one resource and the links inside the resource have no location,
      # then these links must be rendered as separate links inside the collection
      if !collection.resources.nil? && collection.resources.size == 1
        if collection.resources.first.links.blank? && @links.empty?
          lnks = @resources.first.links
        else
          lnks = @links
        end
      else
        lnks = @links
      end
      collection.links = lnks.collect { |link| link.as_json } if lnks.to_a.any?
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

  end
end