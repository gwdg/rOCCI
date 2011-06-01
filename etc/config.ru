require 'rubygems'
require 'sinatra'

root_dir = File.join(File.dirname(__FILE__/), '../lib/occi/')
occi_server = File.join(root_dir, 'occi-server.rb')

require occi_server

set :environment, :production
disable :run
set :app_file, occi_server

run Sinatra::Application