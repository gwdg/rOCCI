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

if RUBY_PLATFORM == "java"
  warn 'Installing dependencies specific for jRuby'

  jrver = (JRUBY_VERSION || "").split('.').map{ |elm| elm.to_i }
  if jrver[0] == 1 && jrver[1] < 7
    warn 'Installing \'jruby-openssl\' for jRuby 1.6.x'
    inst.install "jruby-openssl"
  end
else
  warn 'Installing dependencies specific for Ruby'

  rver = RUBY_VERSION.split('.').map{ |elm| elm.to_i }
  if rver[0] == 1 && rver[1] < 9
    warn 'Installing \'oniguruma\' for Ruby 1.8.x'
    warn 'Make sure you have \'libonig-dev\' installed!'
    inst.install "oniguruma"
  end
end

# create dummy rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write "task :default\n"
f.close
