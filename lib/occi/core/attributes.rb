require 'hashie/mash'

module OCCI
  module Core
    class Attributes < Hashie::Mash

      def combine
        hash = { }
        self.each_key do |key|
          if self[key].kind_of? Hashie::Mash
            self[key].combine.each_pair { |k, v| hash[key + '.' + k] = v }
          else
            hash[key] = self[key]
          end
        end
        return hash
      end

      def self.split(attributes)
        attribute = Attributes.new
        attributes.each do |name,value|
          puts name
          key, dot, rest = name.partition('.')
          if rest.empty?
            attribute[key] = value
          else
            attribute.merge! Attributes.new(key => self.split(rest => value))
          end
        end
        return attribute
      end

    end
  end
end