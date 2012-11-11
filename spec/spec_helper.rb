if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'
end

RSpec.configure do |c|
    c.extend VCR::RSpec::Macros
end
