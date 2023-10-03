

#!/bin/bash



# Stop Tomcat

sudo systemctl stop tomcat



# Update the memory allocation in the Tomcat configuration file

sudo sed -i 's/-Xmx${OLD_MEMORY_LIMIT}/-Xmx${NEW_MEMORY_LIMIT}/g' /path/to/tomcat/conf/catalina.sh



# Start Tomcat

sudo systemctl start tomcat





chmod +x increase_tomcat_memory.sh