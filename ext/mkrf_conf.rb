require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb' 

begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
  # do nothing but warn the user
  warn "Gem::Command doesn't have a method named 'build_args'!"
end 

warn 'Installing platform-specific dependencies.'

warn 'Installing the most recent version of \'rake\''
inst = Gem::DependencyInstaller.new
inst.install "rake"

# create dummy rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write "task :default\n"
f.close
