$:.unshift(File.dirname(__FILE__) + '/../../lib')

require 'rubygems'
require 'occi'

require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'features/cassettes'
end

VCR.cucumber_tags do |t|
  t.tags '@vcr_ignore', :record => :none
  t.tag  '@vcr_record', {:use_scenario_name => true, :record => :new_episodes}
end
