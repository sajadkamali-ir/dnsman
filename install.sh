#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
BAR="-------------------------------------------"


#Handling errors caused by user or program
error_handler ()
{
  ERR_ID=$1
  case "$ERR_ID" in
    1) printf "${RED}Error code ${ERR_ID}:  Please run the program as root${NC}\n"
      exit $ERR_ID
      ;;
    *) echo "Unknown Error!"
      ;;
  esac
}

#This script needs root access and this function takes care of it
root_checker ()
{
  USER=$(whoami)
  if [ $USER != "root" ]
  then
      error_handler 1
  fi
}
root_checker

echo "Installing dnsman...."
cp ./dnsman.sh /usr/local/bin/dnsman
chmod a+x /usr/local/bin/dnsman

mkdir /etc/dnsman
cp ./dnsman.conf /etc/dnsman/dnsman.conf

echo "dnsman has been installed successfully :) To run it, just type dnsman in your terminal"
echo $BAR
