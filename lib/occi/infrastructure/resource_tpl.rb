module Occi
  module Infrastructure
    class Resource_tpl < Occi::Core::Mixin

      def initialize(scheme='http://schemas.ogf.org/occi/infrastructure#',
          term='resource_tpl',
          title='resource template',
          attributes=Occi::Core::Attributes.new,
          related=Occi::Core::Categories.new,
          actions=Occi::Core::Actions.new,
          location='/mixins/resource_tpl/')

        super(scheme, term, title, attributes, related, actions, location)
        self.related << Occi::Infrastructure::Compute.kind
      end

    end
  end
end