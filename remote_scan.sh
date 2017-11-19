#!/bin/bash

nmap -A -v -sV pi3-personal

sudo snort‬‬ ‫‪-dev‬‬ ‫‪-i‬‬ ‫‪wlan0‬‬ ‫‪-c‬‬ ‫‪/etc/snort/snort.conf‬‬ ‫‪-l‬‬ ‫‪/var/log/snort/‬‬ ‫‪-A‬‬ ‫‪full‬‬