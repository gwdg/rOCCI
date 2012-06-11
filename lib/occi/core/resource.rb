require 'hashie/mash'
require 'occi/model'
require 'occi/core/entity'
require 'occi/core/kind'

module OCCI
  module Core
    class Resource < Entity

      def self.register
        data = Hashie::Mash.new
        data[:related] = %w{http://schemas.ogf.org/occi/core#entity}
        data[:term] = "resource"
        data[:scheme] = "http://schemas.ogf.org/occi/core#"
        data[:title] = "Resource"

        data.attributes!.occi!.core!.summary!.type = "string"
        data.attributes!.occi!.core!.summary!.pattern = ".*"
        data.attributes!.occi!.core!.summary!.required = false
        data.attributes!.occi!.core!.summary!.mutable = true

        kind = OCCI::Core::Kind.new(data)
        OCCI::Model.register(kind)
      end

      def summary
        self[:summary] ||= self.attributes!.occi!.core!.summary if self.attributes!.occi!.core
        return self[:summary]
      end

      def summary=(summary)
        self[:summary] = summary
        self.attributes ||= OCCI::Core::Attributes.new
        self.attributes!.occi!.core!.summary = summary
      end

      def convert_value(val, duping=false) #:nodoc:
        case val
          when self.class
            val.dup
          when ::Hash
            val = val.dup if duping
            self.class.subkey_class.new.merge(val) unless val.kind_of?(Hashie::Mash)
            val
          when Array
            val.collect { |e| convert_value(e) }
          else
            val
        end
      end

    end
  end
end
