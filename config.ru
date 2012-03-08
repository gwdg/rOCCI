$: << 'lib'

require 'rubygems'
require 'sinatra'
require 'occi/occi-server.rb'

VERSION_NUMBER=0.5

run OCCIServer.new
