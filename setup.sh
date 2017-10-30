#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR=$HOME/apps
DEFAULT_USER=pi

echo "Making install directory: $INSTALL_DIR ."
mkdir -p $INSTALL_DIR
chown -R $DEFAULT_USER:$DEFAULT_USER $INSTALL_DIR

echo "Package updates and installations."
#apt-get --assume-yes update
#apt-get --assume-yes install zip clamav logwatch

# Turn off SSH by non-pem
echo "Update SSH rules."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i -e 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

echo "Unpack FloreantPOS."
unzip $BASE_DIR/floreant-raspbian-demo.zip -d $INSTALL_DIR
sudo chown $DEFAULT_USER:$DEFAULT_USER $INSTALL_DIR/floreantpos

echo "Switching users: $DEFAULT_USER ."
su - $DEFAULT_USER

cd $INSTALL_DIR/floreantpos

JAVA_OPTS="-Xms64m -Xmx512m"

# Run Floreant POS
echo "Running FloreantPOS."
/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/jre/bin/java $JAVA_OPTS -jar ./floreantpos.jar 