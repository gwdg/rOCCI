if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  # For rails applications use
  # SimpleCov.start 'rails'
end