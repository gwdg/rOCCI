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

$BIN_LOCATION/occi-server stop

echo -n "Installing OCCI server."

backup_information=""

if [[ -f $BIN_LOCATION/occi-server ] -a [ ! -f $BIN_LOCATION/occi-server.orig ]]; then
    mv $BIN_LOCATION/occi-server $BIN_LOCATION/occi-server.orig
fi
cp bin/occi-server $BIN_LOCATION

echo -n "."

if [ -f $ETC_LOCATION/occi-server.conf ]; then
  if [ ! -f $ETC_LOCATION/occi-server.conf.orig ]; then
    mv $ETC_LOCATION/occi-server.conf $ETC_LOCATION/occi-server.conf.orig
    backup_information=$backup_information"Your current occi-server.conf has been moved to occi-server.conf.orig\n" 
  else
    mv $ETC_LOCATION/occi-server.conf $ETC_LOCATION/occi-server.conf.old
    backup_information=$backup_information"Your current occi-server.conf has been moved to occi-server.conf.old\n"
  fi
fi
cp etc/occi-server.conf $ETC_LOCATION

echo -n "."

if [ -f $ETC_LOCATION/occi-one.conf ]; then
    mv $ETC_LOCATION/occi-one.con$ETC_LOCATION/occi-one.conf.old
    backup_information=$backup_information"Your current occi-one.conf has been moved to occi-one.conf.old\n"   
fi
cp etc/occi-one.conf $ETC_LOCATION

if [ -d $ETC_LOCATION/occi_one_templates ]; then
    rm -rf $ETC_LOCATION/occi_one_templates.old
    mv -f $ETC_LOCATION/occi_one_templates $ETC_LOCATION/occi_one_templates.old
    backup_information=$backup_information"Your current occi templates directory has been moved to occi_one_templates.old"
fi
cp -r etc/occi_one_templates $ETC_LOCATION

echo -n "."

if [ -d $RUBY_LOCATION/cloud/occi ]; then
  if [ ! -d $RUBY_LOCATION/cloud/occi.orig ]; then
     mv -f $RUBY_LOCATION/ruby/cloud/occi $RUBY_LOCATION/ruby/cloud/occi.orig
     backup_information=$backup_information"Your current occi lib folder has been moved to occi.old"
  else
    rm -rf $RUBY_LOCATION/cloud/occi
  fi
fi
cp -r lib/ruby/cloud/occi/ $RUBY_LOCATION/cloud/occi

echo -n "."

chmod +x $BIN_LOCATION/occi-server
chmod +x $RUBY_LOCATION/cloud/occi/occi-server.rb

echo -n "."

echo "done"

echo -e $backup_information