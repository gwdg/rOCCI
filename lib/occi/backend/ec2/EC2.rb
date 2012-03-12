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
# Description: EC2 Backend
# Author(s): Max Guenther
##############################################################################

# Amazon Webservices SDK
require 'aws-sdk'

# EC2 backend
require 'occi/backend/ec2/Compute'

# for XML parsing (gem = "xml-simple")
require 'xmlsimple'


module OCCI
  module Backend
    module EC2
    # --------------------------------------------------------------------------------------------------------------------- 
    
      begin
        ### Create networks
        # Create private network
        attributes = OCCI::Core::Attributes.new()
        attributes['occi.core.title'] = "ec2_private_network"
        attributes['occi.core.summary'] = "This network contains private links to all EC2 compute instances."
        mixins = []
        private_network = OCCI::Infrastructure::Network.new(attributes, mixins)
        OCCI::Rendering::HTTP::LocationRegistry.register("/network/ec2_private_network", private_network)
        private_network.state_machine.set_state(OCCI::Infrastructure::Network::STATE_ACTIVE)
        private_network.attributes['occi.network.state'] = "active"
        
        # Create public network
        attributes = OCCI::Core::Attributes.new()
        attributes['occi.core.title'] = "ec2_public_network"
        attributes['occi.core.summary'] = "This network contains public links to all EC2 compute instances."
        mixins = []
        public_network = OCCI::Infrastructure::Network.new(attributes, mixins)
        OCCI::Rendering::HTTP::LocationRegistry.register("/network/ec2_public_network", public_network)
        public_network.state_machine.set_state(OCCI::Infrastructure::Network::STATE_ACTIVE)
        public_network.attributes['occi.network.state'] = "active"
        
        # Create elastic network
        attributes = OCCI::Core::Attributes.new()
        attributes['occi.core.title'] = "ec2_elastic_network"
        attributes['occi.core.summary'] = "This network contains elastic ip links to all EC2 compute instances."
        mixins = []
        elastic_network = OCCI::Infrastructure::Network.new(attributes, mixins)
        OCCI::Rendering::HTTP::LocationRegistry.register("/network/ec2_elastic_network", elastic_network)
        elastic_network.state_machine.set_state(OCCI::Infrastructure::Network::STATE_ACTIVE)
        elastic_network.attributes['occi.network.state'] = "active"
      end
            
      class EC2

        include Compute

        # ---------------------------------------------------------------------------------------------------------------------     
        # Operation mappings


        OPERATIONS = {}
      
        OPERATIONS["http://schemas.ogf.org/occi/infrastructure#compute"] = {
        
            # Generic resource operations
          :deploy         => :compute_deploy,
          :update_state   => :compute_update_state,
          :refresh        => :compute_refresh,
          :delete         => :compute_delete,
        
          # Compute specific resource operations
          :start          => :compute_start,
          :stop           => :compute_stop,
          :restart        => :compute_restart,
          :suspend        => :compute_suspend        
        }

        OPERATIONS["http://schemas.ogf.org/occi/infrastructure#network"] = {
        
          # Generic resource operations
          :deploy         => nil,
          :update_state   => nil,
          :refresh        => nil,
          :delete         => nil,
        
          # Network specific resource operations
          :up             => nil,
          :down           => nil
        }

        OPERATIONS["http://schemas.ogf.org/occi/infrastructure#storage"] = {

          # Generic resource operations
          :deploy         => nil,
          :update_state   => nil,
          :refresh        => nil,
          :delete         => nil,
   
          # Network specific resource operations
          :online         => nil,
          :offline        => nil,
          :backup         => nil,
          :snapshot       => nil,
          :resize         => nil
        }

        OPERATIONS["http://schemas.ogf.org/gwdg#nfsstorage"] = {

          # Generic resource operations
          :deploy         => nil,
          :update_state   => nil,
          :refresh        => nil,
          :delete         => nil
        }
        
        # ---------------------------------------------------------------------------------------------------------------------
        
        def initialize(access_key_id, secret_access_key)
          # EC2 access key
          AWS.config(
                     :access_key_id => access_key_id,
                     :secret_access_key => secret_access_key)
        end
        
        def register_templates
          $log.debug("Loading EC2 templates.")
        
          # import Compute Resource Templates from etc/ec2_templates/resource_templates.xml
          xml = XmlSimple.xml_in("etc/ec2_templates/resource_templates.xml")
          xml["instance"].each do |instance|
            term = instance["term"][0]
            scheme = "http://mycloud.org/templates/compute#"
            title = instance["title"][0]
            attributes = OCCI::Core::Attributes.new()
            actions = []
            entities = []
            related = [ OCCI::Infrastructure::ResourceTemplate::MIXIN ]
            mixin = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
            OCCI::CategoryRegistry.register(mixin)
          end
          
          ## import image templates
          # get the ec2 interface
          ec2 = AWS::EC2.new
          ec2 = ec2.regions["eu-west-1"]
          # register each image
          ec2.images.each do |image|
            term = image.id
            scheme = "http://mycloud.org/templates/os#"
            title = image.name
            attributes = OCCI::Core::Attributes.new()
            actions = []
            entities = []
            related = [ OCCI::Infrastructure::OSTemplate::MIXIN ]
            mixin = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
            OCCI::CategoryRegistry.register(mixin)
          end
          $log.debug("Finished loading EC2 templates.")
        end
        
      
        # ---------------------------------------------------------------------------------------------------------------------     
        def register_existing_resources
          
        end

         # ---------------------------------------------------------------------------------------------------------------------     
        def resource_deploy(resource)
          $log.debug("Deploying resource '#{resource.attributes['occi.core.title']}'...")
        end
      
        # ---------------------------------------------------------------------------------------------------------------------     
        def resource_refresh(resource)
          $log.debug("Refreshing resource '#{resource.attributes['occi.core.title']}'...")
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def resource_update_state(resource)
          $log.debug("Updating state of resource '#{resource.attributes['occi.core.title']}'...")
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def resource_delete(resource)
          $log.debug("Deleting resource '#{resource.attributes['occi.core.title']}'...")
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # ACTIONS
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------     
        def action_dummy(compute, parameters)
          $log.debug("Calling method for resource '#{resource.attributes['occi.core.title']}' with parameters: #{parameters.inspect}")
        end

      end

    end
  end
end
