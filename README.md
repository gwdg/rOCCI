rOCCI - A Ruby OCCI Framework
=============================

[![Build Status](https://secure.travis-ci.org/gwdg/rOCCI.png)](http://travis-ci.org/gwdg/rOCCI)

Requirements
------------

The following setup is recommended

* usage of the Ruby Version Manger
* Ruby 1.9.3
* Bundler gem installed (use ```gem install bundler```)

Installation
------------

### Stable version

Download the latest version from http://dev.opennebula.org/projects/ogf-occi/files

Extract file

    tar xzf rOCCI-*.tar.bz
    unzip rOCCI-*.zip

Install dependencies

    bundle install --deployment

### Latest version

Checkout latest version from GIT:

    git clone git://github.com/gwdg/rOCCI.git

Change to rOCCI folder

    cd rOCCI

Install dependencies for deployment

    bundle install --deployment

Install dependencies for testing
    bundle install

Configure
---------

Edit etc/occi-server.conf and adapt to your setting.

The default templates for the OpenNebula template are located at etc/one_templates .

The default templates for EC2 are located at etc/ec2_templates .

Usage
-----

Run Passenger

    passenger start

Testing
-------

Use curl to request all categories

    curl -X GET http://localhost:3000/-/

Contributing
------------

1. Fork it.
2. Create a branch (git checkout -b my_markup)
3. Commit your changes (git commit -am "My changes")
4. Push to the branch (git push origin my_markup)
5. Create an Issue with a link to your branch