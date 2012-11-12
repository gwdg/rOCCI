# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'occi/version'

Gem::Specification.new do |gem|
  gem.name          = "occi"
  gem.version       = Occi::VERSION
  gem.authors       = ["Florian Feldhaus","Piotr Kasprzak"]
  gem.email         = ["florian.feldhaus@gwdg.de", "piotr.kasprzak@gwdg.de"]
  gem.description   = %q{OCCI is a collection of classes to simplify the implementation of the Open Cloud Computing API in Ruby}
  gem.summary       = %q{OCCI toolkit}
  gem.homepage      = 'https://github.com/gwdg/rOCCI'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_dependency 'json'
  gem.add_dependency 'antlr3'
  gem.add_dependency 'hashie'
  gem.add_dependency 'uuidtools'
  gem.add_dependency 'nokogiri'
  gem.add_dependency 'activesupport'
  gem.add_dependency 'httparty'
  gem.add_dependency 'highline'
  gem.add_dependency 'i18n'
  gem.add_dependency 'amqp'

  gem.required_ruby_version     = ">= 1.8.7"
end
