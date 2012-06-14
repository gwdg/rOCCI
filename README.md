rOCCI - A Ruby OCCI Framework
=================================

[![Build Status](https://secure.travis-ci.org/gwdg/rOCCI.png)](http://travis-ci.org/gwdg/rOCCI)

Requirements
------------

The following setup is recommended

* usage of the Ruby Version Manger
* Ruby 1.9.3
* RubyGems installed

Installation
------------

    gem install occi

### Latest version

Checkout latest version from GIT:

    git clone git://github.com/gwdg/rOCCI.git

Change to rOCCI folder

    cd rOCCI

Install dependencies for deployment

    bundle install --deployment

Usage
-----

First require the gem
    require 'occi'

### Client

The OCCI gem includes a Client to simplify the usage of an OCCI endpoint.

To connect to an OCCI endpoint/server (e.g. running at http://localhost:3000/ ) use

    client = OCCI::Client.new('http://localhost:3000')

All available categories are automatically registered to the OCCI model during client initialization. You can get them via

    OCCI::Model.get

To get all resources (as a list of OCCI::Resources) currently managed by the endpoint use

    client.get_resources

To get only compute, storage or network resources use get_compute_resources, ...

To get the location of all resources use

    client.get_resource_list

Analogue for compute, storage, network via get_compute_list, ...

To get a list of all OS / resource templates use

    client.get_os_templates
    client.get_resource_templates

To get all attributes with their default values for a given category use

    client.get_attributes(client.compute)

To create a new compute resource use

    os = client.get_os_templates.select { |template| template.term.include? 'my_os' }
    size = client.get_resource_templates.select { |template| template.term.include? 'large' }
    attributes = client.get_attributes([client.compute,os,size])
    attributes['occi.core.title'] = "My VM"
    client.post_compute(attributes,os,size)

### Logging

The OCCI gem includes its own logging mechanism using a message queue. By default, no one is listening to that queue.
A new OCCI Logger can be initialized by specifying the log destination (either a filename or an IO object like
STDOUT) and the log level.

    OCCI::Log.new(STDOUT,OCCI::Log::INFO)

You can create multiple Loggers to receive the log output.

You can always, even if there is no logger defined, log output using the class methods of OCCI::Log e.g.

    OCCI::Log.info("Test message")

### Registering categories in the OCCI Model

Before the parser may be used, the available categories have to be registered in the OCCI Model.

For categories already specified by the OCCI WG a method exists in the OCCI Model class to register them:

    OCCI::Model.register_core
    OCCI::Model.register_infrastructure

Further categories can either be registered from files which include OCCI collections in JSON formator or from parsed
 JSON objects (e.g. from the query interface of an OCCI service endpoint).

### Parsing OCCI messages

The OCCI gem includes a Parser to easily parse OCCI messages. With a given media type (e.g. json,
xml or plain text) the parser analyses the content of the message body and, if supplied,
the message header. As the text/plain and text/occi media type do not clearly distinguish between a message with a
category and a message with an entity which has a kind, it has to be specified if the message contains a category (e
.g. for user defined mixins)

OCCI messages can be parsed for example like

    media_type = text/plain
    body = %Q|Category: compute; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind"|
    OCCI::Parser.parse(media_type,body)

### Using the OCCI model

The OCCI gem includes all OCCI Core classes necessary to handly arbitrary OCCI objects.

Changelog
---------

### Version 2.2

OCCI Client added. The client simplifies the execution of OCCI commands and provides shortcuts for often used steps.

### Version 2.1

Several improvements to the gem structure and code documentation. First rSpec test were added. Readme has been extended to include instructions how the gem can be used.

### Version 2.0

Starting with version 2.0 Florian Feldhaus and Piotr Kasprzak took over the development of the OCCI gem. The codebase was taken from the rOCCI framework and improved to be bundled as a standalone gem.

### Version 1.X

Version 1.X of the OCCI gem has been developed by retr0h and served as a simple way to access the first OpenNebula OCCI implementation.

Development
-----------

### Code Documentation

[Code Documentation for rOCCI by YARD](http://rubydoc.info/github/gwdg/rOCCI/)

### Continuous integration

[Continuous integration for rOCCI by Travis-CI](http://travis-ci.org/gwdg/rOCCI/)

### Contribute

1. Fork it.
2. Create a branch (git checkout -b my_markup)
3. Commit your changes (git commit -am "My changes")
4. Push to the branch (git push origin my_markup)
5. Create an Issue with a link to your branch