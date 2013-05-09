module Occi
  module Parser
    module Xml
      # @param [String] string
      # @return [Occi::Collection]
      def self.collection(string)
        collection = Occi::Collection.new
        hash = Hashie::Mash.new(Hash.from_xml(Nokogiri::XML(string)))
        collection.kinds.merge hash.kinds.collect { |kind| Occi::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) } if hash.kinds
        collection.mixins.merge hash.mixins.collect { |mixin| Occi::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) } if hash.mixins
        collection.actions.merge hash.actions.collect { |action| Occi::Core::Action.new(action.scheme, action.term, action.title, action.attributes) } if hash.actions
        collection.resources.merge hash.resources.collect { |resource| Occi::Core::Resource.new(resource.kind, resource.mixins, resource.attributes, resource.actions, resource.links) } if hash.resources
        collection.links.merge hash.links.collect { |link| Occi::Core::Link.new(link.kind, link.mixins, link.attributes) } if hash.links
        collection
      end
    end
  end
end