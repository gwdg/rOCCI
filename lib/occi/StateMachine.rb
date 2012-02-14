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

require 'occi/core/Action'

module OCCI

  class StateMachine

    attr_reader :current_state

    # ---------------------------------------------------------------------------------------------------------------------
    class State

      attr_reader :name
      attr_reader :transitions      

      # ---------------------------------------------------------------------------------------------------------------------
      private
      # ---------------------------------------------------------------------------------------------------------------------
      
      def get_action_name(action)
        # TODO: Fix parsing of actions
        return action.category.term if not action.category.nil?
      end
      
      # ---------------------------------------------------------------------------------------------------------------------
      public
      # ---------------------------------------------------------------------------------------------------------------------

      # ---------------------------------------------------------------------------------------------------------------------                
      def initialize(name)
        @name         = name
        @transitions  = {}
      end
                
      # ---------------------------------------------------------------------------------------------------------------------
      def add_transition(action, target_state)
        @transitions[get_action_name(action)] = target_state 
      end
      
      # ---------------------------------------------------------------------------------------------------------------------
      def has_transition(action)
        return @transitions.has_key?(get_action_name(action))
      end
      
      # ---------------------------------------------------------------------------------------------------------------------
      def get_target_state(action)
        raise "Unsupport transition [#{action}] for this state: #{self}" unless has_transition(action)
        return @transitions[get_action_name(action)]
      end
      
      # ---------------------------------------------------------------------------------------------------------------------
      def to_s()
        string = "[" + @name + "]: transitions: "
        @transitions.each do |key, value|
          string += " [#{key} -> #{value.name}]"
        end
        return string
      end
    end
      
    # ---------------------------------------------------------------------------------------------------------------------
    def initialize(start_state, states, options = {})
      raise "Start state [#{start_state}] not part of provided states" if !states.include?(start_state)
      @start_state    = start_state
      @current_state  = start_state
      @states         = states
      @options        = options
    end
    
    def set_state(state)
      @current_state  = state
    end

    # ---------------------------------------------------------------------------------------------------------------------
    # Return backend method symbol to handle transition or nil if not defined
    def transition(action)
      raise "Transition for action [#{action}] not supported in current state: #{@current_state}" if !check_transition(action)
      # TODO: state changes should only be triggered by the backend!
      #@current_state = @current_state.get_target_state(action)
      # Invoke event callback if defined
      return @options[:on_transition] if @options.has_key?(:on_transition)
      return nil
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def check_transition(action)
      return @current_state.has_transition(action)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def get_valid_transitions()
      return @current_state.transitions
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def to_s() 
      $log.debug("Current state: " + @current_state)
    end
  end
end
