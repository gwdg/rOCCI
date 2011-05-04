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
require 'occi/infrastructure/Storage'
require 'occi/infrastructure/Network'
require 'occi/infrastructure/Networkinterface'
require 'occi/infrastructure/StorageLink'
require 'occi/infrastructure/Ipnetworking'
require 'occi/infrastructure/Ipnet6'
require 'occi/infrastructure/Reservation'

# OCCI HTTP rendering
require 'occi/rendering/http/Renderer'
require 'occi/rendering/http/LocationRegistry'

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

$objects = []

REQUEST_DEFAULTS  = { :method        => :get,
                      :headers       => {:Accept => "text/occi"},
                      :timeout       => 10000,   # milliseconds
                      :cache_timeout => 0       # seconds
                    } 

# ---------------------------------------------------------------------------------------------------------------------
def check_response(response)

  return true if response.success?

  if response.timed_out?
    # Response timed out
    $log.error("Response timed out: #{response.time} seconds!")
    return
  end

  if response.code == 0
    # Could not get an http response, something's wrong.
    $log.error("No http response received: #{response.curl_error_message}")
    return
  end

  # Received a non-successful http response.
  $log.error("HTTP request failed: " + response.code.to_s)

end

# ---------------------------------------------------------------------------------------------------------------------
def dump_headers(response)
    response.headers_hash.each do |key, value|
      $log.debug("#{key} = #{value}")
    end
end

# ---------------------------------------------------------------------------------------------------------------------
def get_default_request(params = {})
  url       = $config["server"] + ":" + $config["port"] + (params[:location] || "/")
  request   = Typhoeus::Request.new(url, REQUEST_DEFAULTS.merge(params))
  return request  
end

# ---------------------------------------------------------------------------------------------------------------------
def get_version
  request = get_default_request
  request.on_complete do |response|
    check_response(response)
    $log.debug("Server version: " + response.headers_hash["Server"])
  end
  $hydra.queue(request)
end 

# ---------------------------------------------------------------------------------------------------------------------
def get_categories
  request = get_default_request(:location => "/-/")
  request.on_complete do |response|
    check_response(response)
    response.headers_hash.each do |key, value|
      $log.debug("#{key} = #{value}")
    end
  end
  $hydra.queue(request)
end

# ---------------------------------------------------------------------------------------------------------------------
def create_resource(kind)

  request = get_default_request(:method => :post)
  headers = OCCI::Rendering::HTTP::Renderer.render_category_type(kind)
  request.headers.merge!(headers)

  request.on_complete do |response|
    check_response(response)
    $log.debug("Resource of kind [#{kind}] created under location: #{response.headers_hash["Location"]}")
    resource_uri = URI.parse(response.headers_hash["Location"])
    $objects << resource_uri.path
  end

  $hydra.queue(request)
end

# ---------------------------------------------------------------------------------------------------------------------
def retrieve_resource(location)

  request = get_default_request(  :method   => :get,
                                  :location => location)

  request.on_complete do |response|
    check_response(response)
    if response.body == "OK"
      $log.debug("Retrieved resource under location [#{location}]!")
      dump_headers(response)
    else
      $log.error("Could not retrieve resource under location [#{location}]!")
    end
  end

  $hydra.queue(request)
end

# ---------------------------------------------------------------------------------------------------------------------
def delete_resource(location)

  request = get_default_request(  :method   => :delete,
                                  :location => location)

  request.on_complete do |response|
    check_response(response)
    if response.body == "OK"
      $log.debug("Resource under location [#{location}] has been deleted!")
      $objects.delete(location)
    else
      $log.error("Could not delete resource under location [#{location}]!")
    end
  end

  $hydra.queue(request)
end

# ---------------------------------------------------------------------------------------------------------------------
def trigger_action(location, action, parameters = {})

  request = get_default_request(  :method   => :post,
                                  :location => "#{location}?action=#{action.category.term}")
  headers = {}
  headers = OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_category_type(action))
  headers = OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_attributes(parameters))
  request.headers.merge!(headers)

  request.on_complete do |response|
    check_response(response)
    if response.body == "OK"
      $log.debug("Triggered action [#{action}] on resource under location [#{location}] with parameters [#{parameters}]!")
    else
      $log.error("Could not trigger action [#{action}] on resource under location [#{location}] with parameters [#{parameters}]!")
    end
  end

  $hydra.queue(request)  
end

# ---------------------------------------------------------------------------------------------------------------------
def clean_up
  $objects.each do |location|
    delete_resource(location)
  end
end

# ---------------------------------------------------------------------------------------------------------------------
begin

  # Run the request via Hydra
  $hydra = Typhoeus::Hydra.new(:max_concurrency => 1)

  # No memoization
  $hydra.disable_memoization
 
  get_version
  get_categories
  
#  20.times do
#    create_resource(OCCI::Infrastructure::Compute::KIND)
#  end
 
  create_resource(OCCI::Infrastructure::Compute::KIND)
  $hydra.run

  retrieve_resource($objects[0])
  $hydra.run
  
  trigger_action($objects[0], OCCI::Infrastructure::Compute::ACTION_START)
  $hydra.run

  retrieve_resource($objects[0])
  $hydra.run
  
#  $hydra.run

  clean_up

#  sleep 1.0
  
  $hydra.run
  
end
