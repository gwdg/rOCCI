rOCCI - A Ruby OCCI Framework
=================================

[![Build Status](https://secure.travis-ci.org/gwdg/rOCCI.png)](http://travis-ci.org/gwdg/rOCCI)
[![Dependency Status](https://gemnasium.com/gwdg/rOCCI.png)](https://gemnasium.com/gwdg/rOCCI)
[![Gem Version](https://fury-badge.herokuapp.com/rb/occi.png)](https://badge.fury.io/rb/occi)

Requirements
------------

The following setup is recommended

* usage of the Ruby Version Manager
* Ruby 1.9.3
* RubyGems installed

Installation
------------
To install the most recent stable version
    gem install occi

To install the most recent beta version
    gem install occi --pre

To build and install the bleeding edge version from master
    git clone git://github.com/gwdg/rOCCI.git
    cd rOCCI
    rake install

Usage
-----
### Client
The OCCI gem includes a client you can use directly from shell with the following auth methods: x509 (with --password, --user-cred and --ca-path), basic (with --username and --password), digest (with --username and --password), none. If you won't set a password using --password, the client will ask for it later on. There is also an interactive mode, which will allow you to interact with the client through menus and answers to simple questions (this feature is still experimental).

To find out more about available options and defaults use

    occi --help

To run the client in an interactive mode use

    occi --interactive
    occi --interactive --endpoint https://<ENDPOINT>:<PORT>/
    occi --interactive --endpoint https://<ENDPOINT>:<PORT>/ --auth x509

To list available resources use

    occi --endpoint https://<ENDPOINT>:<PORT>/ --action list --resource compute --auth x509
    occi --endpoint https://<ENDPOINT>:<PORT>/ --action list --resource storage --auth x509
    occi --endpoint https://<ENDPOINT>:<PORT>/ --action list --resource network --auth x509

To describe available resources use

    occi --endpoint https://<ENDPOINT>:<PORT>/ --action describe --resource compute --auth x509
    occi --endpoint https://<ENDPOINT>:<PORT>/ --action describe --resource storage --auth x509
    occi --endpoint https://<ENDPOINT>:<PORT>/ --action describe --resource network --auth x509

To describe specific resources use

    occi --endpoint https://<ENDPOINT>:<PORT>/ --action describe --resource https://<ENDPOINT>:<PORT>/compute/<OCCI_ID> --auth x509
    occi --endpoint https://<ENDPOINT>:<PORT>/ --action describe --resource https://<ENDPOINT>:<PORT>/storage/<OCCI_ID> --auth x509
    occi --endpoint https://<ENDPOINT>:<PORT>/ --action describe --resource https://<ENDPOINT>:<PORT>/network/<OCCI_ID> --auth x509

To list available OS templates or Resource templates use

    occi --endpoint https://<ENDPOINT>:<PORT>/ --action list --resource os_tpl --auth x509
    occi --endpoint https://<ENDPOINT>:<PORT>/ --action list --resource resource_tpl --auth x509

To describe a specific OS template or Resource template use

    occi --endpoint https://<ENDPOINT>:<PORT>/ --action describe --resource os_tpl#debian6 --auth x509
    occi --endpoint https://<ENDPOINT>:<PORT>/ --action describe --resource resource_tpl#small --auth x509

To create a compute resource with mixins use

    occi --endpoint https://<ENDPOINT>:<PORT>/ --action create --resource compute --mixin os_tpl#debian6 --mixin resource_tpl#small --resource-title "My rOCCI VM" --auth x509

To delete a compute resource use

    occi --endpoint https://<ENDPOINT>:<PORT>/ --action delete --resource https://<ENDPOINT>:<PORT>/compute/<OCCI_ID> --auth x509

### Client scripting

#### Auth

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

For keystone auth use

    auth = Hashie::Mash.new
    auth.type = 'keystone'
    auth.token = '887665443383838'

#### DSL
In your scripts, you can use the OCCI client DSL.

To include the DSL definitions in your script use

    extend Occi::Api::Dsl

To connect to an OCCI endpoint/server (e.g. running on http://localhost:3300/ )

    connect(:http, 'http://localhost:3300',auth||=nil)

To get the list of available resource, mixin, entity or link types use

    resource_types
    mixin_types
    entity_types
    link_types

To get compute, storage or network descriptions use

    describe "compute"
    describe "storage"
    describe "network"

To get the location of compute, storage or network resources use

    list "compute"
    list "storage"
    list "network"

To get the identifiers of specific mixins in specific mixin types use

    mixin "my_template", "os_tpl"
    mixin "small", "resource_tpl"

To get the identifiers of specific mixins with unknown types use

    mixin "medium"

To get mixin descriptions use

    mixin "medium", nil, true
    mixin "my_template", "os_tpl", true

To get a list of names of all / OS templates / Resource templates mixins use

    mixins
    mixins "os_tpl"
    mixins "resource_tpl"

To create a new compute resource use

    os = mixin 'my_os', 'os_tpl'
    size = mixin 'large', 'resource_tpl'
    cmpt = resource "compute"
    cmpt.mixins << os << size
    cmpt.title = "My VM"
    create cmpt

To get a description of a specific resource use

    describe "https://<ENDPOINT>:<PORT>/compute/<OCCI_ID>"
    describe "https://<ENDPOINT>:<PORT>/storage/<OCCI_ID>"
    describe "https://<ENDPOINT>:<PORT>/network/<OCCI_ID>"

To delete a specific resource use

    delete "https://<ENDPOINT>:<PORT>/compute/<OCCI_ID>"
    delete "https://<ENDPOINT>:<PORT>/storage/<OCCI_ID>"
    delete "https://<ENDPOINT>:<PORT>/network/<OCCI_ID>"

#### API
If you need low level access to parts of the OCCI client or need to use more than one instance
at a time, you should use the OCCI client API directly.

To connect to an OCCI endpoint/server (e.g. running on http://localhost:3300/ )

    client = Occi::Api::Client::ClientHttp.new('http://localhost:3300',auth||=nil)

All available categories are automatically registered to the OCCI model during client initialization. You can get them via

    client.model

To get the list of available resource, mixin, entity or link types use

    client.get_resource_types
    client.get_mixin_types
    client.get_entity_types
    client.get_link_types

To get compute, storage or network descriptions use

    client.describe "compute"
    client.describe "storage"
    client.describe "network"

To get the location of compute, storage or network resources use

    client.list "compute"
    client.list "storage"
    client.list "network"

To get the identifiers of specific mixins in specific mixin types use

    client.find_mixin "my_template", "os_tpl"
    client.find_mixin "small", "resource_tpl"

To get the identifiers of specific mixins with unknown types use

    client.find_mixin "medium"

To get mixin descriptions use

    client.find_mixin "medium", nil, true
    client.find_mixin "my_template", "os_tpl", true

To get a list of names of all / OS templates / Resource templates mixins use

    client.get_mixins
    client.get_mixins "os_tpl"
    client.get_mixins "resource_tpl"

To create a new compute resource use

    os = client.find_mixin 'my_os', 'os_tpl'
    size = client.find_mixin 'large', 'resource_tpl'
    cmpt = client.get_resource "compute"
    cmpt.mixins << os << size
    cmpt.title = "My VM"
    client.create cmpt

To get a description of a specific resource use

    client.describe "https://<ENDPOINT>:<PORT>/compute/<OCCI_ID>"
    client.describe "https://<ENDPOINT>:<PORT>/storage/<OCCI_ID>"
    client.describe "https://<ENDPOINT>:<PORT>/network/<OCCI_ID>"

To delete a specific resource use

    client.delete "https://<ENDPOINT>:<PORT>/compute/<OCCI_ID>"
    client.delete "https://<ENDPOINT>:<PORT>/storage/<OCCI_ID>"
    client.delete "https://<ENDPOINT>:<PORT>/network/<OCCI_ID>"

#### Logging

The OCCI gem includes its own logging mechanism using a message queue. By default, no one is listening to that queue.
A new OCCI Logger can be initialized by specifying the log destination (either a filename or an IO object like
STDOUT) and the log level.

    Occi::Log.new(STDOUT,Occi::Log::INFO)

You can create multiple Loggers to receive the log output.

You can always, even if there is no logger defined, log output using the class methods of OCCI::Log e.g.

    Occi::Log.info("Test message")

#### Registering categories in the OCCI Model

Before the parser may be used, the available categories have to be registered in the OCCI Model.

For categories already specified by the OCCI WG a method exists in the OCCI Model class to register them:

    model = Occi::Model.new
    model.register_infrastructure

Further categories can either be registered from files which include OCCI collections in JSON formator or from parsed
 JSON objects (e.g. from the query interface of an OCCI service endpoint).

#### Parsing OCCI messages

The OCCI gem includes a Parser to easily parse OCCI messages. With a given media type (e.g. json,
xml or plain text) the parser analyses the content of the message body and, if supplied,
the message header. As the text/plain and text/occi media type do not clearly distinguish between a message with a
category and a message with an entity which has a kind, it has to be specified if the message contains a category (e
.g. for user defined mixins)

OCCI messages can be parsed to an OCCI collection for example like

    media_type = 'text/plain'
    body = %Q|Category: compute; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind"|
    collection=Occi::Parser.parse(media_type, body)

#### Parsing OVF / OVA files

Parsing of OVF/OVA files is partly supported and will be improved in future versions.

The example in [DMTF DSP 2021](http://www.dmtf.org/sites/default/files/standards/documents/DSP2021_1.0.0.tar) is
bundled with rOCCI and can be parsed to an OCCI collection with

    require 'open-uri'
    ova=open 'https://raw.github.com/gwdg/rOCCI/master/spec/occi/test.ova'
    collection=Occi::Parser.ova(ova.read)

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

### Version 3.0

* many bugfixes
* rewrote Core classes to use metaprogramming techniques
* added VCR cassettes for reliable testing against prerecorded server responses
* several updates to the OCCI Client
* started work on an OCCI Client using AMQP as transport protocol
* added support for keystone authentication to be used with the OpenStack OCCI server
* updated dependencies
* updated rspec tests
* started work on cucumber features

### Version 2.5

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
