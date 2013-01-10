source :rubygems

gemspec

gem 'vcr', :git => 'git://github.com/arax/vcr.git', :branch => 'cucumber_patch'

platforms :jruby do
  gem 'jruby-openssl' if ((defined? JRUBY_VERSION) && (JRUBY_VERSION.split('.')[1].to_i < 7))
end
