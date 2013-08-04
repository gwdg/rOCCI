rOCCI - A Ruby OCCI Framework
=================================

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
* at least version 1.8.7 is required
* Ruby 1.9.3+ is recommended
* RubyGems installed
* rake installed (e.g., `gem install rake`)

### Libraries/packages
* libxslt1-dev/libxslt-devel
* libxml2-dev/libxml2-devel
* **only if using Ruby 1.8.7:** libonig-dev/oniguruma-devel (Linux) or oniguruma (Mac)

### Examples
For distros based on Debian:
~~~
apt-get install ruby rubygems ruby-dev libxslt1-dev libxml2-dev libonig-dev
~~~

For distros based on RHEL:
~~~
yum install libxml2-devel libxslt-devel ruby-devel openssl-devel gcc gcc-c++ ruby rubygems oniguruma-devel
~~~