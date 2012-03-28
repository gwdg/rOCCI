task :default => 'rcov:all'

require 'rspec/core/rake_task'
#require 'cucumber/rake/task'

namespace :rcov do

=begin
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"

    ENV['COVERAGE'] = "true"
  end
=end

  RSpec::Core::RakeTask.new(:rspec) do |t|
    t.rspec_opts = %w{"--color"}

    ENV['COVERAGE'] = "true"
  end

  desc "Run cucumber & rspec to generate aggregated coverage"
  task :all do |t|
    rm "coverage/coverage.data" if File.exist?("coverage/coverage.data")
    Rake::Task['rcov:rspec'].invoke
#    Rake::Task["rcov:cucumber"].invoke
  end
end