#!/bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR=$HOME/apps
DEFAULT_USER=pi

mkdir -p $INSTALL_DIR

sudo apt-get update
sudo apt-get install openjdk-8-jre zip clamav logwatch

# Turn off SSH by non-pem
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo sed -i -e 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

unzip $BASE_DIR/floreant-raspbian-demo.zip -d $INSTALL_DIR
chown $DEFAULT_USER:$DEFAULT_USER $INSTALL_DIR/floreantpos

sudo su - $DEFAULT_USER

cd $INSTALL_DIR/floreantpos

JAVA_OPTS="-Xms64m -Xmx512m"

# Run Floreant POS
java $JAVA_OPTS -jar ./floreantpos.jar 