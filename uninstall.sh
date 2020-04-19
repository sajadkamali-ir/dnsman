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

echo "Uninstalling dnsman...."
rm /usr/local/bin/dnsman
rm -rf /etc/dnsman

echo "dnsman has been uninstalled successfully, We are sad to see you go :("
echo $BAR
