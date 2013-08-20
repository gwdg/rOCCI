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

### Dependencies
* `libxslt1-dev` or `libxslt-devel`
* `libxml2-dev` or `libxml2-devel`

### Examples
#### For distros based on Debian:
~~~
apt-get install ruby rubygems ruby-dev libxslt1-dev libxml2-dev
~~~
~~~
ruby -v
~~~

**Unless you have Ruby >= 1.9.3, please, go to [rOCCI#RVM](#rvm) and install RVM with a newer Ruby version.**

#### For distros based on RHEL:
~~~
yum install libxml2-devel libxslt-devel ruby-devel openssl-devel gcc gcc-c++ ruby rubygems
~~~
~~~
ruby -v
~~~

**Unless you have Ruby >= 1.9.3, please, go to [rOCCI#RVM](#rvm) and install RVM with a newer Ruby version.**

#### RVM
**Notice:** Follow the RVM installation guide linked below, we recommend using the default 'Single-User installation'.

**Warning:** NEVER install RVM as root! If you choose the 'Multi-User installation', use a different user account with sudo access instead!

* [Installing RVM](https://rvm.io/rvm/install#explained)
* Install Ruby

~~~
rvm requirements
rvm install 1.9.3
rvm use 1.9.3 --default
~~~
~~~
ruby -v
~~~
