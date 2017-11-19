#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# installs
apt-get -qy update
apt-get -qy install vim
apt-get -qy install logwatch

# turn off services
service bluetooth stop
service pure-ftpd stop
service rsyslog stop
