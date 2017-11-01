#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEFAULT_USER=pi
INSTALL_DIR=/home/$DEFAULT_USER/apps

echo "Making install directory: $INSTALL_DIR ."
mkdir -p $INSTALL_DIR
chown -R $DEFAULT_USER:$DEFAULT_USER $INSTALL_DIR

echo "Package updates and installations."
# Packagages to remove
pkgs="$pkgs
idle python3-pygame python-pygame python-tk
idle3 python3-tk
python3-rpi.gpio
python-serial python3-serial
python-picamera python3-picamera
python3-pygame python-pygame python-tk
python3-tk
debian-reference-en dillo x2x
scratch nuscratch
timidity
smartsim penguinspuzzle
pistore
sonic-pi
python3-numpy
python3-pifacecommon python3-pifacedigitalio python3-pifacedigital-scratch-handler python-pifacecommon python-pifacedigitalio
minecraft-pi python-minecraftpi
wolfram-engine
"
for pkg in $pkgs; do
	apt-get --assume-yes remove --purge $pkg
done
apt-get -y autoremove
apt-get --assume-yes update
apt-get --assume-yes install zip clamav logwatch


# Turn off SSH by non-pem
echo "Update SSH rules."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i -e 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

echo "Unpack FloreantPOS."
unzip $BASE_DIR/floreant-raspbian-demo.zip -d $INSTALL_DIR
sudo chown -R $DEFAULT_USER:$DEFAULT_USER $INSTALL_DIR/floreantpos

echo "Switching users: $DEFAULT_USER ."
su $DEFAULT_USER <<EOF
cd $INSTALL_DIR/floreantpos

JAVA_OPTS="-Xms64m -Xmx512m"

# Run Floreant POS
echo "Running FloreantPOS."
/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/jre/bin/java $JAVA_OPTS -jar ./floreantpos.jar
EOF
