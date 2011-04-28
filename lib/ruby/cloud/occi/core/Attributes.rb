module OCCI
  module Core
    class Attributes < Hash

      def <<(attribute)
        store(attribute.name, attribute)
      end

      def check(attributes)
        values.each do |attribute|
          raise "Mandatory attribute #{attribute.name} not provided" if attribute.mandatory && !attributes.has_key?(attribute.name)
          raise "Unique attribute #{attribute.name} supplied multiple times" if attribute.unique && attributes.kind_of?(Array)
        end
      end

      def to_s()
        string = ""
        values.each do
          |attribute|
          string += attribute.to_s + ' '
        end
        return string.strip()
      end

    end
  end
end