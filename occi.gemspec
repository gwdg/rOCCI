# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'occi/version'

Gem::Specification.new do |gem|
  gem.name          = "occi"
  gem.version       = Occi::Dummy::VERSION
  gem.authors       = ["Florian Feldhaus","Piotr Kasprzak", "Boris Parak"]
  gem.email         = ["florian.feldhaus@gwdg.de", "piotr.kasprzak@gwdg.de", "xparak@mail.muni.cz"]
  gem.description   = %q{This gem is a client implementation of the Open Cloud Computing Interface in Ruby}
  gem.summary       = %q{Executable OCCI client}
  gem.homepage      = 'https://github.com/gwdg/rOCCI'
  gem.license       = 'Apache License, Version 2.0'

  gem.add_dependency 'occi-cli'

  gem.add_development_dependency 'rubygems-tasks'
  gem.add_development_dependency 'rake'

  gem.required_ruby_version     = ">= 1.8.7"
end
