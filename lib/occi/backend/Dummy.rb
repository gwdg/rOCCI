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
# Description: Dummy Backend
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'occi/backend/Backend'

module OCCI
  module Backend
    class Dummy
      
      def register_existing_resources
      end

      module Compute 
        include OCCI::Backend::Compute
        
        def deploy
          @backend_object = self
        end
        
        def refresh
        end
  
        def update_state
        end

        def finalize
          @backend_object = nil
        end
        
        # ACTIONS
        def start(parameters)
        end
  
        def stop(parameters)
        end
  
        def restart(parameters)
        end
  
        def suspend(parameters)
        end
      end
      
      module Network 
        include OCCI::Backend::Network
        def self.get_all
          #TODO: implement persistence mechanism for dummy
        end
        
        def deploy
          @backend_object = self
        end
        
        def refresh
        end
  
        def update_state
        end
        
        def finalize
          @backend_object = nil
        end
        
        # ACTIONS
        def up(parameters)
        end
  
        def down(parameters)
        end
      end
      
      module Storage 
        include OCCI::Backend::Storage
        def self.get_all
          #TODO: implement persistence mechanism for dummy
        end
        
        def deploy
          @backend_object = self
        end
        
        def refresh
        end
  
        def update_state
        end
        
        def finalize
          @backend_object = nil
        end
        
        # ACTIONS
        def online(parameters)
        end
  
        def offline(parameters)
        end
  
        def backup(parameters)
        end
  
        def snapshot(parameters)
        end
  
        def resize(parameters)
        end
      end
    end
  end
end