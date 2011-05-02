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
# Description: OCCI RESTful Web Service
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

##############################################################################
# Require Ruby Gems and OCCI classes

# gems
require 'rubygems'
require 'typhoeus'
#require 'sinatra'
require 'logger'

# Ruby standard library
require 'uri'

# Server configuration
require 'occi/Configuration'

# Registry for all OCCI Categories
#require 'occi/CategoryRegistry'

# OCCI Core classes
#require 'occi/core/Action'
#require 'occi/core/Category'
#require 'occi/core/Entity'
#require 'occi/core/Kind'
#require 'occi/core/Link'
#require 'occi/core/Mixin'
#require 'occi/core/Resource'

# OCCI Infrastructure classes
require 'occi/infrastructure/Compute'
#require 'occi/infrastructure/Storage'
#require 'occi/infrastructure/Network'
#require 'occi/infrastructure/Networkinterface'
#require 'occi/infrastructure/StorageLink'
#require 'occi/infrastructure/Ipnetworking'
#require 'occi/infrastructure/Ipnet6'
#require 'occi/infrastructure/Reservation'

# OCCI HTTP rendering
require 'occi/rendering/http/Renderer'
#require 'occi/rendering/http/LocationRegistry'

##############################################################################
# Initialize logger

$stdout.sync = true
$log = Logger.new(STDOUT)

##############################################################################
# Read configuration file and set loglevel

if ARGV[0] != nil
CONFIGURATION_FILE = ARGV[0]
else
  $log.error("A configuration file needs to be provided in the arguments for occi-client")
  break
end

$config = OCCI::Configuration.new(CONFIGURATION_FILE)

if $config['LOG_LEVEL'] != nil
  $log.level = case $config['LOG_LEVEL'].upcase
  when 'FATAL' then Logger::FATAL
  when 'ERROR' then Logger::ERROR
  when 'WARN' then Logger::WARN
  when 'INFO' then Logger::INFO
  when 'DEBUG' then Logger::DEBUG
  else
    $log.warn("Invalid loglevel specified. Loglevel set to INFO")
    Logger::INFO
  end
end

# registry for the locations of all OCCI objects
$locationRegistry = OCCI::Rendering::HTTP::LocationRegistry.new

REQUEST_DEFAULTS  = { :method        => :get,
                      :headers       => {:Accept => "text/occi"},
                      :timeout       => 1000,   # milliseconds
                      :cache_timeout => 0       # seconds
                    } 


def get_default_request(params = {})
  url       = $config["server"] + ":" + $config["port"] + (params[:location] || "/")
  request   = Typhoeus::Request.new(url, REQUEST_DEFAULTS.merge(params))
  return request  
end

def get_version
  request = get_default_request
  request.on_complete do |response|
    $log.debug("Server version: " + response.headers_hash["Server"])
  end
  $hydra.queue(request)
end 

def get_categories
  request = get_default_request(:location => "/-/")
  request.on_complete do |response|
    response.headers_hash.each do |key, value|
      $log.debug("#{key} = #{value}")
    end
  end
  $hydra.queue(request)
end

def create_resource(kind)
  request = get_default_request(:method => :post)
  header = OCCI::Rendering::HTTP::Renderer.render_category_type(kind)
#  $log.debug("* Category-string: " + category_string)
  request.headers.merge!(header)
  request.on_complete do |response|
    $log.debug("Resource of kind [#{kind}] created: ")
    response.headers_hash.each do |key, value|
      $log.debug("#{key} = #{value}")
    end
  end
  $hydra.queue(request)
end

begin

  # Run the request via Hydra ()
  $hydra = Typhoeus::Hydra.new(:max_concurrency => 1)
  # No memoization
  $hydra.disable_memoization
 
  get_version
  get_categories
  create_resource(OCCI::Infrastructure::Compute::KIND)
  
#  request = get_version()
#  $log.debug(request)
  
#  $hydra.queue(request)
  $hydra.run

  # the response object will be set after the request is run
#  response = request.response
#  response.code    # http status code
#  response.time    # time in seconds the request took
#  response.headers # the http headers
#  response.headers_hash # http headers put into a hash
#  response.body    # the response body
#  $log.debug(response)
  
#  response.headers_hash.each do |key, value|
#    $log.debug("#{key} = #{value}")
#  end
  
end
