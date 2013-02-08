# make sure the local files will be loaded first;
# this should prevent installed versions of this
# gem to be included in the testing process
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.dirname(__FILE__))

# enable coverage reports
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

# enable VCR integration;
# this allows us to record and re-play network
# communication between client and server
# using so called cassettes (YAML)
require 'vcr'

# enable VCR for HTTP/HTTPS connections
# using RSPEC metadata integration;
# this will automatically generate a named
# cassette for each unit test
VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
end

# simplify the usage of VCR; this will allow us to use
#
#   it "does something", :vcr do
#     ...
#   end
#
# instead of
#
#   it "does something else", :vcr => true do
#     ...
#   end
RSpec.configure do |c|
  # in RSpec 3 this will no longer be necessary.
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
