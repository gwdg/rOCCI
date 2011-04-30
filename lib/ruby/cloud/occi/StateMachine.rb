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

module OCCI

  class StateMachine

    attr_reader :current_state

    # ---------------------------------------------------------------------------------------------------------------------
    class State

      attr_reader :name
      attr_reader :transitions      

      # ---------------------------------------------------------------------------------------------------------------------                
      def initialize(name)
        @name         = name
        @transitions  = {}
      end
                
      # ---------------------------------------------------------------------------------------------------------------------
      def add_transition(action, target_state)
        @transitions[action] = target_state
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
    def initialize(start_state, states)
      @start_state = start_state
      @current_state = start_state
      @states = states
      raise "Start state [#{start_state}] not part of provided states" if !states.include?(start_state)
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def transition(action)
      raise "Transition for action [#{action}] not supported in current state: #{@current_state}" if !check_transition(action)
      @current_state = @current_state.transitions[action]
    end

    # ---------------------------------------------------------------------------------------------------------------------
    def check_transition(action)
      return @current_state.transitions.has_key?(action)
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