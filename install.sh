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

if [ -f $ONE_LOCATION/bin/occi-server ]; then
    mv $ONE_LOCATION/bin/occi-server $ONE_LOCATION/bin/occi-server.old
fi

cp bin/occi-server $ONE_LOCATION/bin

echo -n "."

if [ -f $ONE_LOCATION/etc/occi-server.conf ]; then
  cp $ONE_LOCATION/etc/occi-server.conf $ONE_LOCATION/etc/occi-server.conf.bak
fi
cp etc/occi-one.conf $ONE_LOCATION/etc

echo -n "."

if [ -f $ONE_LOCATION/etc/occi-one.conf ]; then
    cp $ONE_LOCATION/etc/occi-one.conf $ONE_LOCATION/etc/occi-one.conf.bak
fi
cp etc/occi-server.conf $ONE_LOCATION/etc

if [ -d $ONE_LOCATION/etc/occi_one_templates ]; then
    mv $ONE_LOCATION/etc/occi_one_templates $ONE_LOCATION/etc/occi_one_templates.bak
fi
cp -r etc/occi_one_templates $ONE_LOCATION/etc

echo -n "."

mv -f $ONE_LOCATION/lib/ruby/cloud/occi $ONE_LOCATION/lib/ruby/cloud/occi.old

echo -n "."

cp -R lib/ruby/cloud/occi/* $ONE_LOCATION/lib/ruby/cloud/occi

chmod +x $ONE_LOCATION/lib/ruby/cloud/occi/occi-server.rb

echo "."

echo "done"

echo "Your current occi-one.conf has been moved to $ONE_LOCATION/etc/occi-one.conf.bak"
echo "Your current occi-server.conf has been moved to $ONE_LOCATION/etc/occi-server.conf.bak"
echo "Your current occi templates have been moved to $ONE_LOCATION/etc/occi_one_templates.bak"
