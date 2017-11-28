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

# Package-related configurations:
#	Remove unneeded packages
#	Check for updates
#	Install relevant software
# 
echo "Package updates and installations."
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
apt-get -y update
# Software installations
#	Utilities: vim, zip
#	Antivirus: clamav
# 	IDS: Snort (requires bison, flex, pcre)
apt-get -y install vim \
	zip \
	clamav \
	logwatch \
	bison \
	flex \
	libpcap-dev \
	libpcre3-dev \
	libdumbnet-dev \
	checkinstall \
	auditd

# Install Snort
mkdir -p $INSTALL_DIR/snort_setup
wget https://snort.org/downloads/snort/daq-2.0.6.tar.gz -P $INSTALL_DIR/snort_setup/
wget https://snort.org/downloads/snort/snort-2.9.8.3.tar.gz -P $INSTALL_DIR/snort_setup/
tar xf daq-2.0.6.tar.gz -C $INSTALL_DIR/snort_setup/
tar xf snort-2.9.8.3.tar.gz -C $INSTALL_DIR/snort_setup/
cd $INSTALL_DIR/snort_setup/daq-2.0.6/
./configure
make
checkinstall -D --install=no --fstrans=no
dpkg -i daw_2.0.6-1_armfh.deb
cd $INSTALL_DIR/snort_setup/snort-2.9.8.3/
./configure --enable-sourcefire
make
checkinstall -D --install=no --fstrans=no
dpkg -i snort_2.9.8.3-1_armhf.deb
ln -s /usr/local/bin/snort /usr/sbin/snort
groupadd snort
useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort
mkdir -p /etc/snort/rules/iplists /etc/snort/preproc_rules /usr/local/lib/snort_dynamicrules /etc/snort/so_rules /var/log/snort
cp $INSTALL_DIR/snort_setup/snort-2.9.8.3/etc/*.{conf,config,map} /etc/snort/
chown -R snort:snort /etc/snort/ /var/log/snort/ /usr/local/lib/snort_dynamicrules

# run snort:
## snort‬‬ ‫‪-dev‬‬ ‫‪-i‬‬ ‫‪wlan0‬‬ ‫‪-c‬‬ ‫‪/etc/snort/snort.conf‬‬ ‫‪-l‬‬ ‫‪/var/log/snort/‬‬ ‫‪-A‬‬ ‫‪full‬‬

# turn off services
service bluetooth stop
service pure-ftpd stop
service rsyslog stop

# Turn off SSH by non-pem
echo "Update SSH rules."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i -e 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# Audit import OS files
auditctl -w /etc/passwd -p wa -k passwd_watch
# Log all commands by root and pi
auditctl -a always,exit -F arch=b32 -F uid=root -S execve -k programs -k rootaction
auditctl -a always,exit -F arch=b32 -F uid=pi -S execve -k programs -k piaction
# Panic on critical errors
auditctl -f 2
# Lock auditing
auditctl -e 2
service restart auditd.service

# Install FloreantPOS
echo "Unpack FloreantPOS."
unzip $BASE_DIR/floreant-raspbian-demo.zip -d $INSTALL_DIR
sudo chown -R $DEFAULT_USER:$DEFAULT_USER $INSTALL_DIR/floreantpos

# Launch FloreantPOS
echo "Switching users: $DEFAULT_USER ."
su $DEFAULT_USER <<EOF
cd $INSTALL_DIR/floreantpos

JAVA_OPTS="-Xms64m -Xmx512m"

# Run Floreant POS
echo "Running FloreantPOS."
/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/jre/bin/java $JAVA_OPTS -jar ./floreantpos.jar
EOF
