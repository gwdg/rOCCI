$: << 'lib'

require 'rubygems'
require 'sinatra'
require 'occi/occi-server.rb'

run OCCIServer.new
