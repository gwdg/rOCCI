# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'occi/version'

Gem::Specification.new do |gem|
  gem.name          = "occi"
  gem.version       = Occi::Dummy::VERSION
  gem.authors       = ["Florian Feldhaus","Piotr Kasprzak", "Boris Parak"]
  gem.email         = ["florian.feldhaus@gwdg.de", "piotr.kasprzak@gwdg.de", "xparak@mail.muni.cz"]
  gem.description   = %q{OCCI is a collection of classes to simplify the implementation of the Open Cloud Computing API in Ruby}
  gem.summary       = %q{OCCI toolkit}
  gem.homepage      = 'https://github.com/gwdg/rOCCI'
  gem.license       = 'Apache License, Version 2.0'

  gem.add_dependency 'occi-cli'

  gem.add_development_dependency 'rubygems-tasks'
  gem.add_development_dependency 'rake'

  gem.required_ruby_version     = ">= 1.8.7"
end
