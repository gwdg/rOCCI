#!/bin/bash

# Global configuration
URI="http://localhost:3000"

# network parameters
NET_CATEGORY='network;scheme="http://schemas.ogf.org/occi/infrastructure#";class="kind";,'
NET_CATEGORY+='ipnetwork;scheme="http://schemas.ogf.org/occi/infrastructure/network#";class="kind";'
NET_ATTRIBUTE='occi.core.title="My Network1",'
NET_ATTRIBUTE+='occi.core.summary="A short summary",'
NET_ATTRIBUTE+='occi.network.address="192.168.0.0/24",'
NET_ATTRIBUTE+='occi.network.allocation="dynamic",'
NET_ATTRIBUTE+='occi.network.vlan=1'
NET_LOCATION=$URI'/network/'

STOR_CATEGORY='storage;scheme="http://schemas.ogf.org/occi/infrastructure#";class="kind";'
STOR_ATTRIBUTE='occi.core.title="My Image",'
STOR_ATTRIBUTE+='occi.core.summary="A short summary"'
STOR_LOCATION=$URI'/storage/'
IMAGE_PATH='ttylinux.img'

CDMI_SERVER_URI="http://129.217.252.37:2364"
CDMI_OBJECT_URI="$CDMI_SERVER_URI/WubiClub"
CDMI_CONTAINER_ID="cb37d6689bcc43a0a29d54c480a91331"

COM_CATEGORY='compute; scheme="http://schemas.ogf.org/occi/infrastructure#";class="kind";'
COM_ATTRIBUTE='occi.core.title="My VM1",'
COM_ATTRIBUTE+='occi.core.summary="A short summary",'
COM_ATTRIBUTE+='occi.compute.architecture="x64",'
COM_ATTRIBUTE+='occi.compute.cores=1,'
COM_ATTRIBUTE+='occi.compute.memory=4'
COM_LOCATION=$URI'/compute/'

function crud_network {
  echo '################ Creating network'
  case $CONTENT_TYPE in
  'text/occi')
    NETWORK_LOCATION=`curl -vs -X POST --header "Content-Type: $CONTENT_TYPE" --header "Accept: $ACCEPT" --header "Category: $NET_CATEGORY" --header "X-OCCI-Attribute: $NET_ATTRIBUTE" $NET_LOCATION`
    ;;
  'text/plain')
    BODY="Category: $NET_CATEGORY
X-OCCI-Attribute: $NET_ATTRIBUTE"
    NETWORK_LOCATION=`curl -vs -X POST --form "occi=$BODY" --header "Accept: $ACCEPT" --header "Category: $NET_CATEGORY" $NET_LOCATION`
    ;;
  esac
  if [ "$NETWORK_LOCATION" = "" ]; then exit;fi 
  echo '################  Network created successful'
  echo $NETWORK_LOCATION
  read -p "Press any key to continue..."
  echo '################ Getting all network URIs'
  curl -v -X GET $URI/network/
  echo ""
  read -p "Press any key to continue..."
  echo '################ Getting information on previously created network'
  curl -v -X GET $NETWORK_LOCATION
  echo ""
  read -p "Press any key to continue..."
  echo '################ Delete previously created network'
  echo ${NETWORK_LOCATION:17}
  HTTP_CODE=`curl -s -w "%{http_code}" -X DELETE ${NETWORK_LOCATION:17}`
  if [ "$HTTP_CODE" = 200 ]; then
    echo "################ Successfully deleted network"
  else
    echo "################ Deleting network failed."
  fi
  echo ""
  read -p "Press any key to exit test."
}

function crud_storage {
  echo '################ Creating storage'
  case $CONTENT_TYPE in
  'text/occi')
    STORAGE_LOCATION=`curl -v -X POST  --form "file=@$IMAGE_PATH" --header "Accept: $ACCEPT" --header "Category: $STOR_CATEGORY" --header "X-OCCI-Attribute: $STOR_ATTRIBUTE" $STOR_LOCATION`
    ;;
  'text/plain')
    BODY="Category: $STOR_CATEGORY
X-OCCI-Attribute: $STOR_ATTRIBUTE"
    STORAGE_LOCATION=`curl -v -X POST --form "occi=$BODY" --form "file=@$IMAGE_PATH" --header "Accept: $ACCEPT" --header "Category: $STOR_CATEGORY" $STOR_LOCATION`
    ;;
  esac
  if [ "$STORAGE_LOCATION" = "" ]; then 
    echo '################  Storage creation failed, exiting.'
    exit
  else
    echo '################  Storage created successful'
  fi
  echo $STORAGE_LOCATION
  read -p "Press any key to continue..."
  echo '################ Getting all storage URIs'
  curl -v -X GET $URI/storage/
  echo ""
  read -p "Press any key to continue..."
  echo '################ Getting information on previously created storage'
  curl -v -X GET $STORAGE_LOCATION
  echo ""
  read -p "Press any key to continue..."
  echo '################ Delete previously created storage'
  echo ${STORAGE_LOCATION:17}
  HTTP_CODE=`curl -s -w "%{http_code}" -X DELETE ${STORAGE_LOCATION:17}`
  if [ "$HTTP_CODE" = 200 ]; then
    echo "################ Successfully deleted storage"
  else
    echo "################ Deleting storage failed."
  fi
  echo ""
  read -p "Press any key to exit test."
}

function crud_compute {
  echo '################ Creating compute'
  case $CONTENT_TYPE in
  'text/occi')
    echo '################ Creating network'
    NETWORK_LOCATION=`curl -vs -X POST --header "Content-Type: $CONTENT_TYPE" --header "Accept: $ACCEPT" --header "Category: $NET_CATEGORY" --header "X-OCCI-Attribute: $NET_ATTRIBUTE" $NET_LOCATION`
    read -p "Press any key to continue..."
    echo '################ Creating storage'
    STORAGE_LOCATION=`curl -v -X POST  --form "file=@$IMAGE_PATH" --header --header "Accept: $ACCEPT" --header "Category: $STOR_CATEGORY" --header "X-OCCI-Attribute: $STOR_ATTRIBUTE" $STOR_LOCATION`
    read -p "Press any key to continue..."
    echo '################ Creating compute'
    COM_LINK="<${NETWORK_LOCATION#*$URI}>"';rel="http://schemas.ogf.org/occi/infrastructure#network";category="http://schemas.ogf.org/occi/core#link";,'
    COM_LINK+="<${STORAGE_LOCATION#*$URI}>"';rel="http://schemas.ogf.org/occi/infrastructure#storage";category="http://schemas.ogf.org/occi/core#link";'
    COMPUTE_LOCATION=`curl -vs -X POST --header "Content-Type: $CONTENT_TYPE" --header "Accept: $ACCEPT" --header "Link: $COM_LINK" --header "Category: $COM_CATEGORY" --header "X-OCCI-Attribute: $COM_ATTRIBUTE" $COM_LOCATION`
    ;;
  'text/plain')
    BODY="Category: $COMPUTE_CATEGORY
X-OCCI-Attribute: $COMPUTE_ATTRIBUTE
Link: $COM_LINK"
    COMPUTE_LOCATION=`curl -vs -X POST --form "occi=$BODY" --header "Accept: $ACCEPT" --header "Category: $COMPUTE_CATEGORY" $COM_LOCATION`
    ;;
  esac
  if [ "$COMPUTE_LOCATION" = "" ]; then exit;fi 
  echo '################  Compute created successful'
  echo $COMPUTE_LOCATION
  read -p "Press any key to continue..."
  echo '################ Getting all compute URIs'
  curl -v -X GET $URI/compute/
  echo ""
  read -p "Press any key to continue..."
  echo '################ Getting information on previously created compute'
  curl -v -X GET $COMPUTE_LOCATION
  echo ""
  read -p "Press any key to continue..."
  echo '################ Delete previously created compute'
  echo ${COMPUTE_LOCATION:17}
  HTTP_CODE=`curl -s -w "%{http_code}" -X DELETE ${COMPUTE_LOCATION:17}`
  if [ "$HTTP_CODE" = 200 ]; then
    echo "################ Successfully deleted compute"
  else
    echo "################ Deleting compute failed."
  fi
  echo ""
  HTTP_CODE=`curl -s -w "%{http_code}" -X DELETE ${NETWORK_LOCATION:17}`
  if [ "$HTTP_CODE" = 200 ]; then
    echo "################ Successfully deleted network"
  else
    echo "################ Deleting compute network."
  fi
  echo ""
  read -p "Press any key to exit test."
}

function crud_compute_cdmi {
  echo '################ Creating compute with CDMI'
  case $CONTENT_TYPE in
  'text/occi')
    echo '################ Creating network'
    NETWORK_LOCATION=`curl -vs -X POST --header "Content-Type: $CONTENT_TYPE" --header "Accept: $ACCEPT" --header "Category: $NET_CATEGORY" --header "X-OCCI-Attribute: $NET_ATTRIBUTE" $NET_LOCATION`
    read -p "Press any key to continue..."
    echo '################ Creating compute'
    COM_LINK="<${NETWORK_LOCATION#*$URI}>"';rel="http://schemas.ogf.org/occi/infrastructure#network";category="http://schemas.ogf.org/occi/core#link";,'
    COM_LINK+="<$CDMI_OBJECT_URI>"';rel="http://schemas.ogf.org/occi/core#link";category="http://schemas.ogf.org/occi/infrastructure#storagelink";'"occi.storagelink.deviceid=\"$CDMI_CONTAINER_ID\";"
    COMPUTE_LOCATION=`curl -vs -X POST --header "Content-Type: $CONTENT_TYPE" --header "Accept: $ACCEPT" --header "Link: $COM_LINK" --header "Category: $COM_CATEGORY" --header "X-OCCI-Attribute: $COM_ATTRIBUTE" $COM_LOCATION`
    ;;
  'text/plain')
    BODY="Category: $NET_CATEGORY
X-OCCI-Attribute: $NET_ATTRIBUTE
Link: $COM_LINK"
    COMPUTE_LOCATION=`curl -vs -X POST --form "occi=$BODY" --header "Accept: $ACCEPT" --header "Category: $NET_CATEGORY" $NET_LOCATION`
    ;;
  esac
  if [ "$COMPUTE_LOCATION" = "" ]; then exit;fi
  echo '################  Compute created successful'
  echo $COMPUTE_LOCATION
  read -p "Press any key to continue..."
  echo '################ Getting all compute URIs'
  curl -v -X GET $URI/compute/
  echo ""
  read -p "Press any key to continue..."
  echo '################ Getting information on previously created compute'
  curl -v -X GET $COMPUTE_LOCATION
  echo ""
  read -p "Press any key to continue..."
  echo '################ Delete previously created compute'
  echo ${COMPUTE_LOCATION:17}
  HTTP_CODE=`curl -s -w "%{http_code}" -X DELETE ${COMPUTE_LOCATION:17}`
  if [ "$HTTP_CODE" = 200 ]; then
    echo "################ Successfully deleted compute"
  else
    echo "################ Deleting compute failed."
  fi
  echo ""
  HTTP_CODE=`curl -s -w "%{http_code}" -X DELETE ${NETWORK_LOCATION:17}`
  if [ "$HTTP_CODE" = 200 ]; then
    echo "################ Successfully deleted network"
  else
    echo "################ Deleting compute network."
  fi
  echo ""
  read -p "Press any key to exit test."
}

# Ask for Content-Type to use for requests
cmd=(dialog --menu "Select Content-Type for requests:" 22 76 16)
options=(1 "text/plain"   # any option can be set to default to "on"
         2 "text/occi"
         3 "application/json")
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            CONTENT_TYPE='text/plain'
            ;;
        2)
            CONTENT_TYPE='text/occi'
            ;;
        3)
            CONTENT_TYPE='application/json'
            ;;
    esac
done

# Ask for Accept MIME-Type to use for requests
cmd=(dialog --menu "Select Accept MIME-Type for requests:" 22 76 16)
options=(1 "text/plain"   # any option can be set to default to "on"
         2 "text/occi"
         3 "application/json")
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            ACCEPT='text/plain'
            ;;
        2)
            ACCEPT='text/occi'
            ;;
        3)
            ACCEPT='application/json'
            ;;
    esac
done

cmd=(dialog --separate-output --checklist "Select tests to run:" 22 76 16)
options=(1 "Create/Read/Update/Delete network" off    # any option can be set to default to "on"
         2 "Create/Read/Update/Delete storage" off
         3 "Create/Read/Update/Delete compute" off
         4 "Create/Read/Update/Delete compute with CDMI storage" on
         5 "Create/Read/Update/Delete template" off
         6 "Create/Read/Update/Delete compute from template" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            crud_network
            ;;
        2)
            crud_storage
            ;;
        3)
            crud_compute
            ;;
        4)
            crud_compute_cdmi
            ;;
        5)
            crud_template
            ;;
        6)
            crud_compute_from_template
            ;;
    esac
done
