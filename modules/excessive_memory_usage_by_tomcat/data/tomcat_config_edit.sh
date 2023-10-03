

#!/bin/bash



# Stop the Tomcat service

sudo service tomcat stop



# Navigate to the Tomcat configuration directory

cd ${TOMCAT_CONFIG_DIR}



# Backup the original configuration file

sudo cp server.xml server.xml.bak



# Edit the server.xml file to reduce the number of threads

sudo sed -i 's/Connector port="8080"/Connector port="8080" maxThreads="${NEW_THREAD_COUNT}"/' server.xml



# Save and close the configuration file

sudo chmod 644 server.xml

sudo chown ${TOMCAT_USER}:${TOMCAT_GROUP} server.xml



# Restart the Tomcat service

sudo service tomcat start