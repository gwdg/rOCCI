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
# Description: OCCI logger
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

require 'logger'

module OCCI
  class Log

    def self.debug(message)
      ActiveSupport::Notifications.instrument("log",:level=>Logger::DEBUG,:message=>message)
    end

    def self.info(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::INFO, :message => message)
    end

    def self.warn(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::WARN, :message => message)
    end

    def self.error(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::ERROR, :message => message)
    end

    def self.fatal(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::FATAL, :message => message)
    end
  end
end