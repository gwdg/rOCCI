module Occi
  module Core
    class Entity

      include Occi::Helpers::Inspect

      attr_accessor :mixins, :attributes, :actions, :id, :model, :kind, :location

      class_attribute :kind, :mixins, :attributes, :actions

      self.mixins = Occi::Core::Mixins.new

      self.attributes = Occi::Core::AttributeProperties.new
      self.attributes['occi.core.id'] = {:pattern => '[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}'}
      self.attributes['occi.core.title'] = {:mutable => true}

      self.kind = Occi::Core::Kind.new scheme=' http ://schemas.ogf.org/occi/core #',
                                       term='entity',
                                       title='entity',
                                       attributes=self.attributes

      # @return [String]
      def self.type_identifier
        self.kind.type_identifier
      end

      # @param [Array] args list of arguments
      # @return [Object] new instance of this class
      def self.new(*args)
        if args.size > 0
          type_identifier = args[0].to_s
          related = [self.kind]
        else
          type_identifier = self.kind.type_identifier
          related = nil
        end
        scheme, term = type_identifier.split '#'

        klass = Occi::Core::Kind.get_class scheme, term, related

        object = klass.allocate
        object.send :initialize, *args
        object
      end

      # @param [String] kind
      # @param [String] mixins
      # @param [Occi::Core::Attributes] attributes
      # @param [Occi::Core::Actions] actions
      # @return [Occi::Core::Entity]
      def initialize(kind = self.kind, mixins=[], attributes={}, actions=[], location=nil)
        @kind = self.class.kind.clone
        @mixins = Occi::Core::Mixins.new mixins
        @attributes = Occi::Core::Attributes.new self.kind.attributes
        @actions = Occi::Core::Actions.new actions
        @location = location
      end

      # @return [Occi::Core::Kind]
      def kind
        @kind
      end

      # @param [Occi::Core::Kind,String] kind
      # @return [Occi::Core::Kind]
      def kind=(kind)
        if kind.kind_of? String
          scheme, term = kind.split '#'
          kind = Occi::Core::Category.get_class scheme, term
        end
        @kind = kind
      end

      # @param [Array] mixins
      def mixins=(mixins)
        @mixins = Occi::Core::Mixins.new mixins
      end

      # @param [Occi::Core::Attributes] attributes
      def attributes=(attributes)
        @attributes = Occi::Core::Attributes.new attributes
      end

      # @param [Occi::Core::Actions] actions
      def actions=(actions)
        @actions = Occi::Core::Actions.new actions
      end

      # set id for entity
      # @param [UUIDTools::UUID] id
      def id=(id)
        @attributes.occi!.core!.id = id
        @id = id
      end

      # @return [UUIDTools::UUID] id of the entity
      def id
        @id ||= @attributes.occi.core.id if @attributes.occi.core if @attributes.occi
        @id
      end

      # set title attribute for entity
      # @param [String] title
      def title=(title)
        @attributes.occi!.core!.title = title
      end

      # @return [String] title attribute of entity
      def title
        @attributes.occi.core.title if @attributes.occi.core if @attributes.occi
      end

      # @param [Occi::Model] model
      # @return [Occi::Model]
      def model=(model)
        @model = model
        @kind = (model.get_by_id(@kind.type_identifier) || @kind)
        @kind.entities << self
        @mixins.model = model
        @mixins.each { |mixin| mixin.entities << self }
        @actions.model = model
      end

      # set location attribute of entity
      # @param [String] location
      def location=(location)
        @location = location
      end

      # @return [String] location of the entity
      def location
        return @location if @location
        kind.location + id.gsub('urn:uuid:', '') if id
      end

      # check attributes against their definitions and set defaults
      # @param [Occi::Model] model representation of the Occi model to check the attributes against
      def check
        raise "No model associated" unless @model
        definitions = model.get_by_id(@kind.to_s).attributes
        @mixins.each do |mixin_id|
          mixin = model.get_by_id(mixin_id)
          next if mixin.nil?
          definitions.merge!(mixin.attributes) if mixin.attributes
        end if @mixins

        @attributes = Entity.check(@attributes, definitions) if definitions
      end

      # @param [Occi::Core::Attributes] attributes
      # @param [Occi::Core::Attributes] definitions
      # @param [true,false] set_defaults
      # @return [Occi::Core::Attributes] attributes with their defaults set
      def self.check(attributes, definitions, set_defaults=false)
        attributes = Occi::Core::Attributes.new(attributes)
        definitions.each_key do |key|
          if definitions[key].kind_of? Occi::Core::Attributes
            attributes[key] = check(attributes[key], definitions[key])
          else
            properties = definitions[key]
            value = attributes[key]
            value ||= properties.default if set_defaults or properties.required
            raise "required attribute #{key} not found" if value.nil? && properties.required
            next if value.nil? and not properties.required
            case properties.type
              when 'number'
                raise "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless value.kind_of?(Numeric)
              when 'boolean'
                raise "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless !!value == value
              when 'string'
                raise "attribute #{key} with value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless value.kind_of?(String)
              else
                raise "property type #{properties.type} is not one of the allowed types number, boolean or string"
            end
            Occi::Log.warn "attribute #{key} with value #{value} does not match pattern #{properties.pattern}" if value.to_s.scan(Regexp.new(properties.pattern)).empty? if properties.pattern
            attributes[key] = value
          end
        end
        attributes.delete_if { |_, v| v.empty? } # remove empty attributes
        attributes
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={})
        entity = Hashie::Mash.new
        entity.kind = @kind.to_s if @kind
        entity.mixins = @mixins.join(' ').split(' ') if @mixins.any?
        entity.actions = @actions if @actions.any?
        entity.attributes = @attributes if @attributes.any?
        entity.id = id if id
        entity
      end

      # @return [String] text representation
      def to_text
        text = 'Category: ' + self.kind.term + ';scheme=' + self.kind.scheme.inspect + ';class="kind"' + "\n"
        @mixins.each do |mixin|
          scheme, term = mixin.to_s.split('#')
          scheme << '#'
          text << 'Category: ' + term + ';scheme=' + scheme.inspect + ';class="mixin"' + "\n"
        end
        @attributes.combine.each_pair do |name, value|
          value = value.inspect
          text << 'X-OCCI-Attribute: ' + name + '=' + value + "\n"
        end
        @actions.each do |action|
          _, term = action.split('#')
          text << 'Link: <' + self.location + '?action=' + term + '>;rel=' + action.inspect + "\n"
        end
        text
      end

      # @return [Hash] hash containing the HTTP headers of the text/occi rendering
      def to_header
        header = Hashie::Mash.new
        header['Category'] = self.kind.term + ';scheme=' + self.kind.scheme.inspect + ';class="kind"'
        @mixins.each do |mixin|
          scheme, term = mixin.to_s.split('#')
          scheme << '#'
          header['Category'] += ',' + term + ';scheme=' + scheme.inspect + ';class="mixin"'
        end
        attributes = []
        @attributes.combine.each_pair do |name, value|
          attributes << name + '=' + value.inspect
        end
        header['X-OCCI-Attribute'] = attributes.join(',') if attributes.any?
        links = []
        @actions.each do |action|
          _, term = action.split('#')
          links << self.location + '?action=' + term + '>;rel=' + action.inspect
        end
        header
      end

      # @return [String] string representation of entity is its location
      def to_s
        self.location
      end

    end
  end
end
