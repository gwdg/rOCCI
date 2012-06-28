require 'hashie/mash'
require 'occi/core/entity'
require 'occi/core/kind'

module OCCI
  module Core
    class Link < Entity

      # @return [OCCI::Core::Kind] kind definition of Link type
      def self.kind_definition
        kind = OCCI::Core::Kind.new('http://schemas.ogf.org/occi/core#','link')

        kind.related = %w{http://schemas.ogf.org/occi/core#entity}
        kind.title = "Link"

        kind.attributes.occi!.core!.target!.type = "string"
        kind.attributes.occi!.core!.target!.pattern = ".*"
        kind.attributes.occi!.core!.target!.required = false
        kind.attributes.occi!.core!.target!.mutable = true

        kind.attributes.occi!.core!.source!.type = "string"
        kind.attributes.occi!.core!.source!.pattern = ".*"
        kind.attributes.occi!.core!.source!.required = false
        kind.attributes.occi!.core!.source!.mutable = true

        kind
      end

    end
  end
end