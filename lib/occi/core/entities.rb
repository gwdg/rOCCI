module Occi
  module Core
    class Entities < Set

      include Occi::Helpers::Inspect

      attr_accessor :model

      def initialize(entities=[])
        entities.to_a.each { |entity| entity.model = @model } if @model
        super entities
      end

      def join(separator)
        self.to_a.join(separator)
      end

      def model=(model)
        @model = model
        each { |entity| entity.model=model }
      end

      def check
        each { |entity| entity.check }
      end

      def create(*args)
        entity = Occi::Core::Entity.new(*args)
        entity.model = @model if @model
        self << entity
        entity
      end

      def <<(entity)
        entity.model = @model if @model
        super entity
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        self.to_a.as_json
      end

    end
  end
end
