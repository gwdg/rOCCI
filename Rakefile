require 'rubygems/tasks'

task :default => [:test]

Gem::Tasks.new(:build => {:tar => true, :zip => true}, :sign => {:checksum => true, :pgp => false})

task :test do
  # nothing
end
