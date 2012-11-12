require 'bundler'
Bundler::GemHelper.install_tasks

task :default => 'rcov:all'

namespace :rcov do

  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"
    ENV['COVERAGE'] = "true"
  end

  RSpec::Core::RakeTask.new(:rspec) do |t|
    ENV['COVERAGE'] = "true"
  end

  desc "Run cucumber & rspec to generate aggregated coverage"
  task :all do |t|
    rm "coverage/coverage.data" if File.exist?("coverage/coverage.data")
    Rake::Task['rcov:rspec'].invoke
    Rake::Task["rcov:cucumber"].invoke
  end

end

require 'yard'
YARD::Rake::YardocTask.new(:yard) do |t|
  t.files   = ['features/**/*.feature', 'features/**/*.rb']
  t.options = ['--any', '--extra', '--opts'] # optional
end
