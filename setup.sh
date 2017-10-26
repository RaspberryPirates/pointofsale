#!/bin/bash
sudo apt-get update
sudo apt-get install maven

cd floreantpos-code

mvn clean install

# Run Floreant POS
java -jar target/floreantpos-bin/floreantpos/floreantpos.jar 