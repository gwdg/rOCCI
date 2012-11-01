module Occi
  module Core
    class Categories < Set

      attr_accessor :model

      def initialize(categories=[])
        categories.to_a.collect! do |category|
          convert category
        end
        super categories
      end

      def <<(category)
        super convert category
      end

      def join(separator)
        self.to_a.join(separator)
      end

      # @param [Occi::Model] model
      # @return [Occi::Model]
      def model=(model)
        @model = model
        collect! { |category| model.get_by_id category.to_s or category}
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        self.to_a.as_json
      end

      # @return [String] json representation
      def inspect
        JSON.pretty_generate(JSON.parse(to_json))
      end

      private

      def convert(category)
        (@model.get_by_id category if @model if category.kind_of? String) or category
      end

    end
  end
end