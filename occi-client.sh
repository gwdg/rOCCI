#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)
RUBY_INCLUDE=$DIRECTORY/lib
OCCI_CLIENT=$DIRECTORY/lib/occi/occi-client.rb

ruby -I $RUBY_INCLUDE $OCCI_CLIENT $@

