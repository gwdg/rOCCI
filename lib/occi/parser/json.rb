module Occi
  module Parser
    module Json
      # @param [String] string
      # @return [Occi::Collection]
      def self.collection(string)
        collection = Occi::Collection.new
        hash = Hashie::Mash.new(JSON.parse(string))
        collection.kinds.merge hash.kinds.collect { |kind| Occi::Core::Kind.new(kind.scheme, kind.term, kind.title, kind.attributes, kind.related, kind.actions) } if hash.kinds
        collection.mixins.merge hash.mixins.collect { |mixin| Occi::Core::Mixin.new(mixin.scheme, mixin.term, mixin.title, mixin.attributes, mixin.related, mixin.actions) } if hash.mixins
        collection.actions.merge hash.actions.collect { |action| Occi::Core::Action.new(action.scheme, action.term, action.title, action.attributes) } if hash.actions
        collection.resources.merge hash.resources.collect { |resource| Occi::Core::Resource.new(resource.kind, resource.mixins, resource.attributes, resource.actions, resource.links) } if hash.resources
        collection.links.merge hash.links.collect { |link| Occi::Core::Link.new(link.kind, link.mixins, link.attributes, [], nil, link.target) } if hash.links

        if collection.resources.size == 1 && collection.links.size > 0
          if collection.resources.first.links.empty?
            collection.links.each { |link| link.source = collection.resources.first }
            collection.resources.first.links = collection.links
          end
        end

        # TODO: replace the following mechanism with one in the Links class
        # replace link locations with link objects in all resources
        collection.resources.each do |resource|
          resource.links.collect! do |resource_link|
            lnk = collection.links.select { |link| resource_link == link.to_s }.first
            lnk ||= resource_link
          end
        end
        collection
      end
    end
  end
end