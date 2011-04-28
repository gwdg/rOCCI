#!/bin/bash

if [ -z "${ONE_LOCATION}" ]; then
    echo "ONE_LOCATION is not defined."

    if [ -d /usr/lib/one/ruby ] && [ -d /etc/one ] && [ -d /usr/bin ]; then
        echo "ONE system wide installation detected."
        ETC_LOCATION=/etc/one
        RUBY_LOCATION=/usr/lib/one/ruby
        BIN_LOCATION=/usr/bin
    else
        echo "ONE installation not found. Aborting."
        exit -1
    fi
else
    ETC_LOCATION=$ONE_LOCATION/etc
    RUBY_LOCATION=$ONE_LOCATION/lib/ruby
    BIN_LOCATION=$ONE_LOCATION/bin
fi

echo -n "Installing OCCI server."

cp bin/occi $ONE_LOCATION/bin

echo -n "."

cp $ONE_LOCATION/etc/occi-server.conf $ONE_LOCATION/etc/occi-server.conf.bck
cp etc/occi-one.conf $ONE_LOCATION/etc
cp $ONE_LOCATION/etc/occi-one.conf $ONE_LOCATION/etc/occi-one.conf.bck
cp etc/occi-server.conf $ONE_LOCATION/etc
cp -r etc/occi_one_templates $ONE_LOCATION/etc

echo -n "."

mv -f $ONE_LOCATION/lib/ruby/cloud/occi $ONE_LOCATION/lib/ruby/cloud/occi.old
rm -rf $ONE_LOCATION/lib/ruby/cloud/occi
cp -R lib/ruby/cloud/occi/* $ONE_LOCATION/lib/ruby/cloud/occi

chmod +x $ONE_LOCATION/lib/ruby/cloud/occi/occi-server.rb

echo "."

echo "done"

echo "Your current occi-one.conf has been moved to $ONE_LOCATION/etc/occi-one.conf.bck"
echo "Your current occi-server.conf has been moved to $ONE_LOCATION/etc/occi-server.conf.bck"