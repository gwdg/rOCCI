require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb' 

begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
  # do nothing but warn the user
  warn "Gem::Command doesn't have a method named 'build_args'!"
end 

if defined? RUBY_PLATFORM && RUBY_PLATFORM == "java"
  inst = Gem::DependencyInstaller.new

  begin
    inst.install "jruby-openssl" if ((defined? JRUBY_VERSION) && (JRUBY_VERSION.split('.')[1].to_i < 7))
  rescue
    warn "Gem::DependencyInstaller failed to install 'jruby-openssl'!"
    exit
  end
end

# create dummy rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write "task :default\n"
f.close
