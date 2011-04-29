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

echo -n "Stopping OCCI server"


echo -n "Installing OCCI server."

backup_information=""

if [ -f $ONE_LOCATION/bin/occi-server ]; then
    mv $ONE_LOCATION/bin/occi-server $ONE_LOCATION/bin/occi-server.old
fi
cp bin/occi-server $ONE_LOCATION/bin

echo -n "."

if [ -f $ONE_LOCATION/etc/occi-server.conf ]; then
  rm -f $ONE_LOCATION/etc/occi-server.conf.old
  mv $ONE_LOCATION/etc/occi-server.conf $ONE_LOCATION/etc/occi-server.conf.old
  backup_information=$backup_information"Your current occi-server.conf has been moved to occi-server.conf.old\n" 
fi
cp etc/occi-server.conf $ONE_LOCATION/etc

echo -n "."

if [ -f $ONE_LOCATION/etc/occi-one.conf ]; then
    rm -f $ONE_LOCATION/etc/occi-one.conf.old
    mv $ONE_LOCATION/etc/occi-one.conf $ONE_LOCATION/etc/occi-one.conf.old
    backup_information=$backup_information"Your current occi-one.conf has been moved to occi-one.conf.old\n"   
fi
cp etc/occi-one.conf $ONE_LOCATION/etc

if [ -d $ONE_LOCATION/etc/occi_one_templates ]; then
    rm -rf $ONE_LOCATION/etc/occi_one_templates.old
    mv -f $ONE_LOCATION/etc/occi_one_templates $ONE_LOCATION/etc/occi_one_templates.old
    backup_information=$backup_information"Your current occi templates directory has been moved to occi_one_templates.old"
fi
cp -r etc/occi_one_templates $ONE_LOCATION/etc

echo -n "."

if [ -d $ONE_LOCATION/lib/ruby/cloud/occi ]; then
  rm -rf $ONE_LOCATION/lib/ruby/cloud/occi.old
  mv -f $ONE_LOCATION/lib/ruby/cloud/occi $ONE_LOCATION/lib/ruby/cloud/occi.old
fi
cp -r lib/ruby/cloud/occi/ $ONE_LOCATION/lib/ruby/cloud/occi

echo -n "."

chmod +x $ONE_LOCATION/bin/occi-server
chmod +x $ONE_LOCATION/lib/ruby/cloud/occi/occi-server.rb

echo -n "."

echo "done"

echo -e $backup_information