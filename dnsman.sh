#!/bin/bash

#Color code for printing
#Syntax: printf "${YELLOW}${NC}\n"
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
    2) printf "${RED}Error code ${ERR_ID}:  No (or weak) server connection.${NC}\n"
      exit $ERR_ID
      ;;
    3) printf "${RED}Error code ${ERR_ID}: Please select correct answer${NC}\n"
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


#show banner to STDOUT
banner ()
{
cat <<- 'EOF'
 ___  _  _ ___ __  __   _   _  _
|   \| \| / __|  \/  | /_\ | \| |
| |) | .` \__ \ |\/| |/ _ \| .` |
|___/|_|\_|___/_|  |_/_/ \_\_|\_|

-------------------------------------------
EOF
printf "${GREEN}Welcome to dnsman script, this script helps you set your nameservers${NC}\n"
printf "${YELLOW}Note: This program change DNS setting temporarily${NC}\n"
}

pinger()
{
  HOST=$1
  dig @${HOST} yahoo.com > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo OK
  else
    echo NO
  fi
}

latency_checker ()
{
  TEMPFILE=/tmp/temp_result
  RESPONSE=()
  if [ -f $TEMPFILE ]
  then
  	rm $TEMPFILE
  fi
   while read IP;
    do
      TEMP_TIME="$( TIMEFORMAT='%lR';time ( dig @${IP} yahoo.com ) 2>&1 1>/dev/null )"
      TEMP2=`echo ${TEMP_TIME} | cut -d "m" -f 2`
      RESPONTIME=${TEMP2::-1}
      RESPONSE+=(${RESPONTIME})
      echo "${IP}:$RESPONTIME" >> $TEMPFILE
    done < /etc/dnsman/dnsman.conf


  min=${RESPONSE[0]}

  for i in "${RESPONSE[@]}"
  do
      if (( $(echo "$i < $min" |bc -l) )); then
          min="$i"
      fi
  done
  FASTEST_SERVER=`cat $TEMPFILE | grep ${min} | cut -d ":" -f1`
  echo $FASTEST_SERVER | cut -d " " -f1
}

verify_sever ()
{
  IP=$1
  APPEND=$2
  printf "Checking server(${IP}) connection ... "
  RES=$(pinger $IP)
  echo $RES

  if [ $RES == "OK" ];
  then
    if [ $APPEND == "true" ]
    then
      echo "nameserver $IP" >> /etc/resolv.conf
    else
      echo "nameserver $IP" > /etc/resolv.conf
    fi
    printf "${GREEN}DNS server has been changed successfully\n${NC}\n"
  else
    while true
    do
      printf "${RED}Error:${NC} The server is not reachable use it anyway? (y/n) "
      read CHAR_ANSWER
      if [ $CHAR_ANSWER == 'y' ] || [ $CHAR_ANSWER == 'Y' ];
      then
        if [ $APPEND == "true" ]
        then
          echo "nameserver $IP" >> /etc/resolv.conf
        else
          echo "nameserver $IP" > /etc/resolv.conf
        fi
        printf "${GREEN}DNS server has been changed successfully\n${NC}\n"
        break
      elif [ $CHAR_ANSWER == 'n' ] || [ $CHAR_ANSWER == 'N' ] ;
      then
        exit 0
      else
        continue
      fi
    done
  fi
}

custom_server ()
{
  printf "Please enter IP address for nameserver 1: "
  read IP1
  printf "Please enter IP address for nameserver 2 (Press enter to skip): "
  read IP2

  if [[ $IP2 = "" ]]; then
    verify_sever $IP1 false
  else
    verify_sever $IP1 false
    verify_sever $IP2 true
  fi
  exit 0
}

shecan_update ()
{
  echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" > /etc/resolv.conf
  TEMPTXT=/tmp/shecan.txt

  if [ -f $TEMPTXT ]
  then
    rm ${TEMPTXT}
  fi
  printf "Getting updated server from shecan.ir... "
  host dns.shecan.ir > $TEMPTXT
  if [ $? != 0 ]
  then
    printf "${RED}Error:${NC} Cloud not fetch update from shecan's DNS server using their known DNS servers:\n"
    echo -e "nameserver 178.22.122.100\nnameserver 185.51.200.2"
    echo -e "nameserver 178.22.122.100\nnameserver 185.51.200.2" > /etc/resolv.conf
    echo $BAR
  fi
  TEMPSERVER=`cat ${TEMPTXT} | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'`
  SERVER1=`echo $TEMPSERVER | cut -d " " -f1`
  SERVER2=`echo $TEMPSERVER | cut -d " " -f2`
  echo "Done"
  echo -e "nameserver ${SERVER1}\nnameserver ${SERVER2}"
  echo -e "nameserver ${SERVER1}\nnameserver ${SERVER2}" > /etc/resolv.conf
  echo $BAR
  printf "${GREEN}DNS server has been changed successfully\n${NC}\n"
  exit 0
}

root_checker
clear
banner

echo $BAR
echo "Please select your DNS server from below: "
echo "1) Cloudflare 1.1.1.1 - Fast DNS server."
echo "2) Google 8.8.8.8 - Popular DNS server."
echo "3) DNS 4.2.2.4 - Another popular DNS server."
echo "4) Shecan - DNS server for bypassing sanctions."
echo "5) Automate - Find the Fastest server automatically (BETA)"
echo "6) Custom server"
echo "To exit, just type quit."
while true;
do
  printf "dnsman> "
  read ANSWER

  case "$ANSWER" in
    1) echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" > /etc/resolv.conf
      echo $BAR
      printf "${GREEN}DNS server has been changed successfully\n${NC}\n"
      exit 0
      ;;
    2) echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf
      echo $BAR
      printf "${GREEN}DNS server has been changed successfully\n${NC}\n"
      exit 0
      ;;
    3) echo -e "nameserver 4.2.2.4" > /etc/resolv.conf
      echo $BAR
      printf "${GREEN}DNS server has been changed successfully\n${NC}\n"
      exit 0
      ;;
    4) shecan_update
      ;;
    5) printf "Please Wait, Searching for fastest server near you... "
      FASTANSWER=$(latency_checker)
      echo $FASTANSWER
      echo -e "nameserver ${FASTANSWER}" > /etc/resolv.conf
      echo $BAR
      printf "${GREEN}DNS server has been changed successfully\n${NC}\n"
      printf "${YELLOW}Warning: the latency may change due to your Internet speed${NC}\n"
      exit 0
      ;;
    6) custom_server
      ;;
    quit) echo "Bye"
      exit 0
      ;;
    QUIT) echo "Bye"
      exit 0
      ;;
    exit) echo "Bye"
      exit 0
      ;;
    EXIT) echo "Bye"
      exit 0
      ;;
    *) continue
  esac
done
