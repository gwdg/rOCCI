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

require 'singleton'

module OCCI

  # ---------------------------------------------------------------------------------------------------------------------
  class ActionDelegator

    include Singleton

    # ---------------------------------------------------------------------------------------------------------------------
    private
    # ---------------------------------------------------------------------------------------------------------------------

    # ---------------------------------------------------------------------------------------------------------------------
    def get_target_object(object, method)
      {  :object => object,
         :method => method}        
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def get_target_id(target)
      return target[:object].object_id.to_s + target[:method].to_s
    end
      
    # ---------------------------------------------------------------------------------------------------------------------
    def initialize()
      @actions = {}
      @targets = {}        
    end
      
    # ---------------------------------------------------------------------------------------------------------------------
    public
    # ---------------------------------------------------------------------------------------------------------------------

    # ---------------------------------------------------------------------------------------------------------------------
    def register_method_for_action(action, object, method, index = -1)

      $log.debug("Registering method [#{method}] of object [#{object}] for action [#{action}] (at index: #{index})...")

      raise "Method not defined for this object!" unless object.respond_to?(method)
      target    = get_target_object(object, method)
      target_id = get_target_id(target)

      @targets[target_id] = target
      @actions.store(action, []) unless @actions.has_key?(action)
      @actions[action].insert(index, target_id)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def unregister_method_for_action(action, object, method)

      $log.debug("Unregistering method [#{method}] of object [#{object}] from action [#{action}]")

      target    = get_target_object(object, method)
      target_id = get_target_id(target)

      raise "No methods registered for action!" unless @actions.has_key?(action)
      raise "Method not registered for action!" unless @actions[action].include?(target_id)

      @actions[action].delete(target_id)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def delegate_action(action, parameters, resource)

      $log.debug("Delegating invocation of action [#{action}] on resource [#{resource}] with parameters [#{parameters}] to backend methods...")

      # Verify
      state_machine = resource.state_machine
      raise "Action [#{action}] not valid for current state [#{state_machine.current_state}] of resource [#{resource}]!" if !state_machine.check_transition(action)
      if !@actions.has_key?(action)
        $log.warn("No backend methods registered for action [#{action}] on resource [#{resource}]")
        # Adapt resource state
        state_machine.transition(action)
        return
      end

      # Invoke registered backend methods
      @actions[action].each do |target_id|
        target = @targets[target_id]
        $log.debug("Invoking method [#{target[:method]}] of object [#{target[:object]}]...")
        # TODO: define some convention for result handling!
        result = target[:object].send(target[:method], action, parameters, resource)
      end

      # Adapt resource state
      state_machine.transition(action)
    end
  end
end