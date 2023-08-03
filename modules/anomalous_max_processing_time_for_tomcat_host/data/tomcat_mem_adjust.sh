

#!/bin/bash



# Define variables

TOMCAT_HOME="PLACEHOLDER"

TOMCAT_USER="PLACEHOLDER"



# Stop Tomcat service

sudo systemctl stop tomcat



# Increase memory allocation

sudo sed -i 's/-Xms512m/-Xms1024m/g' $TOMCAT_HOME/bin/setenv.sh

sudo sed -i 's/-Xmx1024m/-Xmx2048m/g' $TOMCAT_HOME/bin/setenv.sh



# Start Tomcat service

sudo systemctl start tomcat