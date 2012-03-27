rOCCI - A Ruby OCCI Framework
=============================

Requirements
------------

The following setup is recommended

* usage of the Ruby Version Manger
* Ruby 1.9.3
* Bundler gem installed (use ```gem install bundler```)

Installation
------------

### Stable version

* Download the latest version from http://dev.opennebula.org/projects/ogf-occi/files
* Extract file
* Install dependencies

    bundle install --deployment

* Run Passenger

    passenger start

### Latest version

Checkout latest version from GIT:

    git clone git://github.com/gwdg/rOCCI.git

Change to rOCCI folder
    cd rOCCI

Install dependencies for deployment

    bundle install --deployment

Install dependencies for testing
    bundle install

Usage
-----

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