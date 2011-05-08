#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)
RUBY_INCLUDE=$DIRECTORY/lib/ruby/cloud
OCCI_CLIENT=$DIRECTORY/lib/ruby/cloud/occi/occi-client.rb

ruby -I $RUBY_INCLUDE $OCCI_CLIENT $@

