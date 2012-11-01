module Occi
  module Core
    class Entities < Set

      def join(separator)
        self.to_a.join(separator)
      end

      def model=(model)
        each { |entity| entity.model=model }
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

    end
  end
end
