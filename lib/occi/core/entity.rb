module Occi
  module Core
    class Entity

      attr_accessor :mixins, :attributes, :actions, :id
      attr_reader :kind

      # @return [String]
      def self.type_identifier
        self.kind.type_identifier
      end

      # @return [Occi::Core::Kind] kind definition of Entity type
      def self.kind
        kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/core#', 'entity')

        kind.title = "entity"

        kind.attributes.occi!.core!.id = Occi::Core::AttributeProperties.new(
            { :pattern => "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}" })

        kind.attributes.occi!.core!.title = Occi::Core::AttributeProperties.new(
            { :mutable => true })

        kind
      end

      # @param [Array] args list of arguments
      # @return [Object] new instance of this class
      def self.new(*args)
        args[0]      ||= self.kind.type_identifier
        scheme, term = args[0].split '#'

        klass = Occi::Core::Kind.get_class scheme, term

        object = klass.allocate
        object.send :initialize, *args
        object
      end

      # @param [String] kind
      # @param [String] mixins
      # @param [Occi::Core::Attributes] attributes
      def initialize(kind, mixins=[], attributes={ }, actions=[])
        @checked = false
        raise "Kind #{kind} not of type String" unless kind.kind_of? String
        @kind       = kind
        @mixins     = mixins.to_a.flatten
        @attributes = Occi::Core::Attributes.new(attributes)
        #@attributes.occi!.core![:id] ||= UUIDTools::UUID.random_create.to_s
        @actions    = actions.to_a.flatten
      end

      # @param [Array] mixins
      def mixins=(mixins)
        @checked = false
        @mixins  = mixins
      end

      # @param [Occi::Core::Attributes] attributes
      def attributes=(attributes)
        @checked    = false
        @attributes = attributes
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

      # @return [String] location of the entity
      def location
        self.id = UUIDTools::UUID.random_create.to_uri unless self.id
        '/' + @kind.split('#').last + '/' + self.id.gsub('urn:uuid:','')
      end

      # check attributes against their definitions and set defaults
      # @param [Occi::Model] model representation of the Occi model to check the attributes against
      def check(model)
        raise "No kind defined" unless @kind
        definitions = model.get_by_id(@kind).attributes
        @mixins.each do |mixin_id|
          mixin = model.get_by_id(mixin_id)
          next if mixin.nil?
          definitions.merge!(mixin.attributes) if mixin.attributes
        end if @mixins

        @attributes = Entity.check(@attributes, definitions) if definitions
      end

      # @param [Occi::Core::Attributes] attributes
      # @param [Occi::Core::Attributes] definitions
      # @return [Occi::Core::Attributes] attributes with their defaults set
      def self.check(attributes, definitions)
        attributes = Occi::Core::Attributes.new(attributes)
        definitions.each_key do |key|
          properties = definitions[key]
          value      = attributes[key] ||= properties.default
          if properties.key? :type
            raise "required attribute #{key} not found" if value.nil? && properties.required
            next if value.nil? && !properties.required
            case properties.type
              when 'number'
                Occi::Log.warn "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless value.kind_of?(Numeric)
              when 'boolean'
                Occi::Log.warn "attribute #{key} value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless !!value == value
              else
                Occi::Log.warn "attribute #{key} with value #{value} from class #{value.class.name} does not match attribute property type #{properties.type}" unless value.kind_of?(String)
            end
            Occi::Log.warn "attribute #{key} with value #{value} does not match pattern #{properties.pattern}" if value.to_s.scan(Regexp.new(properties.pattern)).empty? if properties.pattern
            attributes[key] = value
          else
            attributes[key] = check(value, definitions[key])
          end
        end
        attributes.delete_if { |_, v| v.nil? } # remove empty attributes
        @checked = true
        attributes
      end

      # @return [true,false]
      def checked?
        @checked && @attributes.checked?
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        entity = Hashie::Mash.new
        entity.kind = @kind if @kind
        entity.mixins = @mixins if @mixins.any?
        entity.actions = @actions if @actions.any?
        entity.attributes = @attributes if @attributes.any?
        entity.id = self.id if self.id
        entity
      end

      # @return [String] text representation
      def to_text
        scheme, term = self.kind.split('#')
        scheme << '#'
        text = 'Category: ' + term + ';scheme=' + scheme.inspect + ';class="kind"' + "\n"
        @mixins.each do |mixin|
          scheme, term = mixin.split('#')
          scheme << '#'
          text << 'Category: ' + term + ';scheme=' + scheme.inspect + ';class="mixin"' + "\n"
        end
        @attributes.combine.each_pair do |name, value|
          value = value.inspect
          text << 'X-OCCI-Attribute: ' + name + '=' + value + "\n"
        end
        text << 'X-OCCI-Attribute: occi.core.id=' + self.id.inspect
        @actions.each do |action|
          _, term = action.split('#')
          text << 'Link: <' + self.location + '?action=' + term + '>;rel=' + action.inspect + "\n"
        end
        text
      end

      # @return [Hash] hash containing the HTTP headers of the text/occi rendering
      def to_header
        scheme, term = self.kind.split('#')
        scheme << '#'
        header             = Hashie::Mash.new
        header['Category'] = term + ';scheme=' + scheme.inspect + ';class="kind"'
        @mixins.each do |mixin|
          scheme, term = mixin.split('#')
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

      # @return [String] json representation
      def inspect
        JSON.pretty_generate(JSON.parse(to_json))
      end

      # @return [String] string representation of entity is its location
      def to_s
        self.location
      end

    end
  end
end
