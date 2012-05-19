$: << 'lib'

require 'rubygems'
require 'sinatra'
require 'occi/server'

VERSION_NUMBER=0.5

run OCCI::Server.new
