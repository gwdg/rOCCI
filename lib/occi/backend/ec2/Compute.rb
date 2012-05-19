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

require 'aws-sdk'
require 'occi/Log'

module OCCI
  module Backend
    module EC2

      # ---------------------------------------------------------------------------------------------------------------------
      module Compute

        # ---------------------------------------------------------------------------------------------------------------------       
        private
        # ---------------------------------------------------------------------------------------------------------------------

        def get_backend_instance(compute)
          # get the ec2 interface
          ec2 = OCCI::Backend::EC2.get_ec2_interface()

          # get the ec2 backend instance
          backend_instance = ec2.instances[compute.backend[:id]]

          raise "Problems refreshing compute instance: An instance with the EC2 ID #{compute.backend[:id]} could not be found." if backend_instance.nil?
          # return the instance
          return backend_instance
        end

        def has_console_link(compute)
          compute.links.each do |link|
            OCCI::Log.debug("Link: #{link}")
            if link.kind.term == "console"
              return true
            end
          end
          return false
        end

        def key_pair_exists(key_name)
          ec2 = OCCI::Backend::EC2.get_ec2_interface()

          ec2.key_pairs.each do |key|
            if key.name == "default_occi_key"
              return true
            end
          end
          return false
        end

        public
        # ---------------------------------------------------------------------------------------------------------------------

        # ---------------------------------------------------------------------------------------------------------------------     
        def compute_deploy(compute)
          OCCI::Log.debug("Deploying EC2 instance.")

          # look what template and instance type to use
          image_id = "ami-973b06e3" # fallback os template
          instance_type = "t1.micro" # fallback resource template
          compute.mixins.each do |mixin|
            mixin.related.each do |related|
              if related.term == "os_tpl"
                image_id = mixin.term
                break # use the first template found
              elsif related.term == "resource_tpl"
                instance_type = mixin.term
                break # use the first template found
              end
            end
          end

          # get the ec2 interface
          ec2 = OCCI::Backend::EC2.get_ec2_interface()

          # create an instance
          if key_pair_exists("default_occi_key")
            backend_instance = ec2.instances.create(:image_id => image_id,
                                                    :instance_type => instance_type,
                                                    :key_name => "default_occi_key")
          else
            backend_instance = ec2.instances.create(:image_id => image_id,
                                                    :instance_type => instance_type)
          end

          # save the id of the instance
          compute.backend[:id] = backend_instance.id

          # link it to the private ec2 network
          OCCI::Log.debug("Linking instance to \"/network/ec2_private_network\".")
          private_network = OCCI::Rendering::HTTP::LocationRegistry.get_object("/network/ec2_private_network")
          attributes = OCCI::Core::Attributes.new()
          attributes["occi.networkinterface.interface"] = ""
          attributes["occi.core.source"] = compute.get_location
          attributes["occi.core.target"] = "/network/ec2_private_network"
          ipnetwork = OCCI::CategoryRegistry.get_by_id("http://schemas.ogf.org/occi/infrastructure/networkinterface#ipnetworkinterface")
          ipnetwork.backend[:network] = "private"
          mixins = [ipnetwork]
          private_networkinterface = OCCI::Infrastructure::Networkinterface.new(attributes, mixins)
          # save the id of the compute backend instance in the network link for future identification
          private_networkinterface.backend[:backend_id] = backend_instance.id
          private_networkinterface.backend[:network] = "ec2_private_network"
          compute.links << private_networkinterface
          private_network.links << private_networkinterface
          OCCI::Rendering::HTTP::LocationRegistry.register(private_networkinterface.get_location, private_networkinterface)

          # link it to the public ec2 network
          OCCI::Log.debug("Linking instance to \"/network/ec2_public_network\".")
          public_network = OCCI::Rendering::HTTP::LocationRegistry.get_object("/network/ec2_public_network")
          attributes = OCCI::Core::Attributes.new()
          attributes["occi.networkinterface.interface"] = ""
          attributes["occi.core.source"] = compute.get_location
          attributes["occi.core.target"] = "/network/ec2_public_network"
          ipnetwork = OCCI::CategoryRegistry.get_by_id("http://schemas.ogf.org/occi/infrastructure/networkinterface#ipnetworkinterface")
          ipnetwork.backend[:network] = "ec2_public_network"
          mixins = [ipnetwork]
          public_networkinterface = OCCI::Infrastructure::Networkinterface.new(attributes, mixins)
          # save the id of the compute backend instance in the network link for future identification
          public_networkinterface.backend[:backend_id] = backend_instance.id
          public_networkinterface.backend[:network] = "public"
          compute.links << public_networkinterface
          public_network.links << public_networkinterface
          OCCI::Rendering::HTTP::LocationRegistry.register(public_networkinterface.get_location, public_networkinterface)

          OCCI::Log.debug("Deployed EC2 instance with EC2 ID: #{compute.backend[:id]}")
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def compute_refresh(compute)
          OCCI::Log.debug("Refreshing EC2 compute object with backend ID: #{compute.backend[:id]}")

          # get the ec2 backend instance
          backend_instance = get_backend_instance(compute)

          # check if there are any problems with the backend instance
          if backend_instance.nil?
            OCCI::Log.debug("Problems refreshing compute instance: An instance with the EC2 ID #{compute.backend[:id]} could not be found.")
            return
          end

          # update the state
          compute_update_state(compute)
          OCCI::Log.debug("Refreshed EC2 compute object with backend ID: #{compute.backend[:id]}")

          # setting the architecture
          compute.attributes["occi.compute.architecture"] = backend_instance.architecture.to_s
          compute.attributes["ec2.compute.platform"] = backend_instance.platform
          compute.attributes["ec2.compute.kernel_id"] = backend_instance.kernel_id

          # update public and private ip
          compute.links.each do |link|
            if link.kind.term == "networkinterface" and link.backend[:backend_id] == backend_instance.id
              if link.backend[:network] == "public" and backend_instance.ip_address != nil
                link.mixins.each do |mixin|
                  if mixin.backend[:network] == "ec2_public_network"
                    link.attributes["occi.networkinterface.address"] = backend_instance.ip_address
                    state = OCCI::Infrastructure::Networkinterface::STATE_ACTIVE
                    link.state_machine.set_state(state)
                    link.attributes['occi.networkinterface.state'] = "active"
                  end
                end
              elsif link.backend[:network] == "private" and backend_instance.private_ip_address != nil
                link.mixins.each do |mixin|
                  if mixin.backend[:network] == "ec2_private_network"
                    link.attributes["occi.networkinterface.address"] = backend_instance.private_ip_address
                    state = OCCI::Infrastructure::Networkinterface::STATE_ACTIVE
                    link.state_machine.set_state(state)
                    link.attributes['occi.networkinterface.state'] = "active"
                  end
                end
              end
            end
          end

          # create the console link if not already existent and if in state active
          if compute.state_machine.current_state == OCCI::Infrastructure::Compute::STATE_ACTIVE and not has_console_link(compute) and backend_instance.key_name == "default_occi_key"
            # create a ConsoleLink
            OCCI::Log.debug("Creating a ConsoleLink to the EC2 Compute instance.")
            attributes = OCCI::Core::Attributes.new()
            attributes['occi.core.target'] = "ssh://" + backend_instance.public_dns_name
            attributes['occi.core.source'] = compute.get_location
            mixins = []
            console_link = OCCI::Infrastructure::ConsoleLink.new(attributes, mixins)
            # save the id of the compute backend instance in the network link for future identification
            console_link.backend[:backend_id] = backend_instance.id
            # link and register
            location = console_link.get_location
            compute.links << console_link
            OCCI::Rendering::HTTP::LocationRegistry.register(location, console_link)
          end
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def compute_update_state(compute)
          # get the ec2 backend instance
          backend_instance = get_backend_instance(compute)

          # map the ec2 state to an OCCI state
          OCCI::Log.debug("Current EC2 VM state is: #{backend_instance.status}")
          state = case backend_instance.status
                    when :running then
                      OCCI::Infrastructure::Compute::STATE_ACTIVE
                    when :pending, :shutting_down, :stopping, :terminated then
                      OCCI::Infrastructure::Compute::STATE_INACTIVE
                    when :stopped then
                      OCCI::Infrastructure::Compute::STATE_SUSPENDED
                    else
                      OCCI::Infrastructure::Compute::STATE_INACTIVE
                  end
          # set the state
          compute.state_machine.set_state(state)
          compute.attributes['occi.compute.state'] = compute.state_machine.current_state.name
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        def compute_delete(compute)
          OCCI::Log.debug("Deleting EC2 Compute instance with EC2 ID #{compute.backend[:id]}")

          # get the ec2 backend instance
          backend_instance = get_backend_instance(compute)

          if backend_instance.nil?
            OCCI::Log.debug("Problems refreshing compute instance: An instance with the EC2 ID #{compute.backend[:id]} could not be found.")
            return
          end
          # terminate the instance
          backend_instance.terminate()

          # delete networklinks to the private and public network and the ConsoleLink
          compute.links.each do |link|
            if link.backend[:backend_id] == backend_instance.id
              location = OCCI::Rendering::HTTP::LocationRegistry.get_location_of_object(link)
              OCCI::Log.debug("Deleting link to #{location}")
              OCCI::Rendering::HTTP::LocationRegistry.unregister(location)
            end
          end
          OCCI::Log.debug("Deleted EC2 Compute instance with EC2 ID #{compute.backend[:id]}")
        end

        # ---------------------------------------------------------------------------------------------------------------------
        # COMPUTE ACTIONS
        # ---------------------------------------------------------------------------------------------------------------------     
        # COMPUTE Action start
        def compute_start(compute, parameters=nil)
          OCCI::Log.debug("Starting EC2 VM with EC2 instance ID #{compute.backend[:id]}")

          # get the ec2 backend instance
          backend_instance = get_backend_instance(compute)

          # suspend the instance (in EC2 lingo stop it)
          backend_instance.start()
          OCCI::Log.debug("Started EC2 VM with EC2 instance ID #{compute.backend[:id]}")
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        # Action stop
        def compute_stop(compute, parameters=nil)
          OCCI::Log.debug("Stopping EC2 VM with EC2 instance ID #{compute.backend[:id]}")

          # get the ec2 backend instance
          backend_instance = get_backend_instance(compute)

          # stop the instance
          backend_instance.stop()
          OCCI::Log.debug("Stopped EC2 VM with EC2 instance ID #{compute.backend[:id]}")
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        # Action restart
        def compute_restart(compute, parameters=nil)
          OCCI::Log.debug("Restarting EC2 VM with EC2 instance ID #{compute.backend[:id]}")

          # get the ec2 backend instance
          backend_instance = get_backend_instance(compute)

          # restart the instance
          backend_instance.reboot()
          OCCI::Log.debug("Restarted EC2 VM with EC2 instance ID #{compute.backend[:id]}")
        end

        # ---------------------------------------------------------------------------------------------------------------------     
        # Action suspend
        def compute_suspend(compute, parameters=nil)
          OCCI::Log.warning("Stop suspend is not supported on EC2 Compute instances.")
        end

      end

    end
  end
end

