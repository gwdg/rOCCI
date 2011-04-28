module OCCI
  module Core
    class StateMachine

      # ---------------------------------------------------------------------------------------------------------------------
      class State
        attr_reader :name
        attr_reader :transitions

        # ---------------------------------------------------------------------------------------------------------------------                
        def initialize(name)
          @name         = name
          @transitions  = {}
        end
        
#        def get_action_id(action)
#          return action.category.scheme + action.category.term
#        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def add_transition(action, target_state)
          @transitions[action] = target_state
        end
        
        # ---------------------------------------------------------------------------------------------------------------------
        def to_s()
          string = "state: [" + @name + "]; transitions => "
          @transitions.each do |key, value|
            string += " [#{key} -> #{value}]"
          end
          return string
        end
      end
      
      attr_reader :current_state
      
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
      def to_s() 
        $log.debug("Current state: " + @current_state)
      end
    end
  end
end