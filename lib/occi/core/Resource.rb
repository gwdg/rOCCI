##############################################################################
#  Copyright 2011 Service Computing group, TU Dortmund
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##############################################################################

##############################################################################
# Description: OCCI Core Resource
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/core/Entity'
require 'occi/core/Kind'

module OCCI
  module Core
    class Resource < Entity

      attr_reader   :links
      
      attr_reader   :template

      begin
        actions     = []
        related     = [OCCI::Core::Entity::KIND]
        entity_type = self
        entities    = []

        term    = "resource"
        scheme  = "http://schemas.ogf.org/occi/core#"
        title   = "Resource"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.core.summary', mutable = true, mandatory = false, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'links',             mutable = true, mandatory = false, unique = false)

        KIND = OCCI::Core::Kind.new(actions, related, entity_type, entities, term, scheme, title, attributes)
      end

      def initialize(attributes, kind, mixins = [])
        attributes['occi.core.summary'] = "" if attributes['occi.core.summary'] == nil
        @links = []
        @template = false
        super(attributes, kind, mixins)
        
        # if mixins include a template mixin, we link this entity and the template entity
        mixins.each do |mixin|
          mixin.related.each do |related|
            if related.term == 'tpl'
              source = self
              target = mixin.template_location
              attributes = {}
              attributes['occi.core.source'] = source.get_location
              attributes['occi.core.target'] = target.get_location
              OCCI::Infrastructure::TemplateLink.new(attributes)
              target.links << links
              source.links << links
            end
          end
        end
      end

      def get_location()
        @template ?  location = 'template' : location = ''
        location << super
      end

      def make_template()
        @template = true
        related_mixin = OCCI::Infrastructure::ResourceTemplate::MIXIN if @links == []
        related_mixin = OCCI::Infrastructure::OSTemplate::MIXIN if @links != []
        term = attributes['occi.core.title'].gsub(/[^0-9A-Za-z]/, '_' + '_tpl')
        scheme = 'http://' + $config['domain'] + '/templates/' + KIND.term
        title = attributes['occi.core.title']
        template_mixin = OCCI::Core::Mixin.new(term, scheme, title, nil, [], related_mixin, [])
        template_mixin.template_location = get_location
        $categoryRegistry.register_mixin(mixin)
      end

    end
  end
end
