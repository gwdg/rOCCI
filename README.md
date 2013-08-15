rOCCI - A Ruby OCCI Framework
=================================

[![Build Status](https://secure.travis-ci.org/gwdg/rOCCI.png)](http://travis-ci.org/gwdg/rOCCI)
[![Dependency Status](https://gemnasium.com/gwdg/rOCCI.png)](https://gemnasium.com/gwdg/rOCCI)
[![Gem Version](https://fury-badge.herokuapp.com/rb/occi.png)](https://badge.fury.io/rb/occi)
[![Code Climate](https://codeclimate.com/github/gwdg/rOCCI.png)](https://codeclimate.com/github/gwdg/rOCCI)

_rOCCI framework now consists of the following separately maintained parts:_
* rOCCI-core -- https://github.com/gwdg/rOCCI-core
* rOCCI-api  -- https://github.com/gwdg/rOCCI-api
* rOCCI-cli  -- https://github.com/gwdg/rOCCI-cli

_You can still install it by running:_
~~~
gem install rake
gem install occi
~~~

Requirements
------------

### Ruby
* Ruby 1.9.3 is required
* RubyGems have to be installed
* Rake has to be installed (e.g., `gem install rake`)

### Libraries/packages
* libxslt1-dev/libxslt-devel
* libxml2-dev/libxml2-devel

### Examples
For distros based on Debian:
~~~
apt-get install ruby rubygems ruby-dev libxslt1-dev libxml2-dev
~~~

For distros based on RHEL:
~~~
yum install libxml2-devel libxslt-devel ruby-devel openssl-devel gcc gcc-c++ ruby rubygems
~~~
