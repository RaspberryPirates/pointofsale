#!/bin/bash

mkdir -p ~/Downloads

# Download the Floreant POS binary release
wget -O ~/Downloads/floreantpos-1.4.zip https://www.dropbox.com/s/562jbgqi0vt76hi/floreantpos-1.4-build1707.zip?dl=1

# Unpack archive
unzip ~/Downloads/floreantpos-1.4.zip -d ~/Downloads

# Run Floreant POS
java -jar ~/Downloads/floreantpos-1.4-build1707\(1\)/floreantpos.jar