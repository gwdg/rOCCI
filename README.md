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

Usage
-----

Use the Interactive Ruby Shell (IRB) to interact with an OCCI server. If you have the occi gem installed, you just have
to start irb from the command line:

    irb

If you want to test newer versions of rOCCI, you have to tell irb from where it
should load occi:

    cd rOCCI
    irb -I lib

First require the gem, for Ruby 1.8.7 you also have to require rubygems

    require 'rubygems'
    require 'occi'

### Client

The OCCI gem includes a Client to simplify the usage of an OCCI endpoint. If you want to use authentication then you
should create a hash with information either on username and password for basic authentication or with a X.509 user
certificate, the user certificate password and the path to the Root CAs which are used to verify the certificate of the
OCCI server.

For Basic auth use

    auth = Hashie::Mash.new
    auth.type = 'basic'
    auth.username = 'user'
    auth.password = 'mypass'

For Digest auth use

    auth = Hashie::Mash.new
    auth.type = 'digest'
    auth.username = 'user'
    auth.password = 'mypass'

For X.509 auth use

    auth = Hashie::Mash.new
    auth.type = 'x509'
    auth.user_cert = '/Path/To/My/usercert.pem'
    auth.user_cert_password = 'MyPassword'
    auth.ca_path = '/Path/To/root-certificates'

To connect to an OCCI endpoint/server (e.g. running on http://localhost:3000/ )

    client = OCCI::Client.new('http://occi.cloud.gwdg.de:3300',auth||=nil)

All available categories are automatically registered to the OCCI model during client initialization. You can get them via

    client.model

To get all resources (as a list of OCCI::Resources) currently managed by the endpoint use

    client.get resources

To get only compute, storage or network resources use

    client.get compute
    client.get storage
    client.get network

To get the location of all resources use

    client.list resources

Analogue for compute, storage, network.

To get a list of all OS / resource templates use

    client.get_os_templates
    client.get_resource_templates

To create a new compute resource use

    os = client.get_os_templates.select { |template| template.term.include? 'my_os' }
    size = client.get_resource_templates.select { |template| template.term.include? 'large' }
    cmpt = OCCI::Core::Resource.new compute
    cmpt.mixins << os << size
    cmpt.attributes.occi!.core!.title = "My VM"
    client.create cmpt

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

    model = OCCI::Model.new
    model.register_infrastructure

Further categories can either be registered from files which include OCCI collections in JSON formator or from parsed
 JSON objects (e.g. from the query interface of an OCCI service endpoint).

### Parsing OCCI messages

The OCCI gem includes a Parser to easily parse OCCI messages. With a given media type (e.g. json,
xml or plain text) the parser analyses the content of the message body and, if supplied,
the message header. As the text/plain and text/occi media type do not clearly distinguish between a message with a
category and a message with an entity which has a kind, it has to be specified if the message contains a category (e
.g. for user defined mixins)

OCCI messages can be parsed to an OCCI collection for example like

    media_type = text/plain
    body = %Q|Category: compute; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind"|
    collection=OCCI::Parser.parse(media_type, body)

### Parsing OVF / OVA files

Parsing of OVF/OVA files is partly supported and will be improved in future versions.

The example in [DMTF DSP 2021](http://www.dmtf.org/sites/default/files/standards/documents/DSP2021_1.0.0.tar) is
bundled with rOCCI and can be parsed to an OCCI collection with

    require 'open-uri'
    ova=open 'https://raw.github.com/gwdg/rOCCI/master/spec/occi/test.ova'
    collection=OCCI::Parser.ova(ova.read)

Currently only the following entries of OVF files are parsed

* File in References
* Disk in the DiskSection
* Network in the NetworkSection
* in the VirutalSystemSection:
** Info
** in the VirtualHardwareSection the items regarding
*** Processor
*** Memory
*** Ethernet Adapter
*** Parallel port

### Using the OCCI model

The OCCI gem includes all OCCI Core classes necessary to handly arbitrary OCCI objects.

Changelog
---------

### version 2.5

* improved OCCI Client
* improved documentation
* several bugfixes

### Version 2.4

* Changed OCCI attribute properties from lowercase to first letter uppercase (e.g. type -> Type, default -> Default, ...)

### Version 2.3

* OCCI objects are now initialized with a list of attributes instead of a hash. Thus it is easier to check which
attributes are expected by a class and helps prevent errors.
* Parsing of a subset of the OVF specification is supported. Further parts of the specification will be covered in
future versions of rOCCI.

### Version 2.2

* OCCI Client added. The client simplifies the execution of OCCI commands and provides shortcuts for often used steps.

### Version 2.1

* Several improvements to the gem structure and code documentation. First rSpec test were added. Readme has been extended to include instructions how the gem can be used.

### Version 2.0

* Starting with version 2.0 Florian Feldhaus and Piotr Kasprzak took over the development of the OCCI gem. The codebase was taken from the rOCCI framework and improved to be bundled as a standalone gem.

### Version 1.X

* Version 1.X of the OCCI gem has been developed by retr0h and served as a simple way to access the first OpenNebula OCCI implementation.

Development
-----------

Checkout latest version from GIT:

    git clone git://github.com/gwdg/rOCCI.git

Change to rOCCI folder

    cd rOCCI

Install dependencies for deployment

    bundle install --deployment

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