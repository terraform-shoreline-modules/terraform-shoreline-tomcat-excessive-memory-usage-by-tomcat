
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Excessive memory usage by Tomcat.
---

This incident type refers to the situation where the Tomcat server is utilizing more memory than it should, causing system instability and performance issues. This can happen due to a variety of factors such as memory leaks, improper configuration, or application code issues. It is important to address this incident promptly to prevent system failures and ensure optimal application performance.

### Parameters
```shell
export PID="PLACEHOLDER"

export OLD_MEMORY_LIMIT="PLACEHOLDER"

export NEW_MEMORY_LIMIT="PLACEHOLDER"

export TOMCAT_CONFIG_DIR="PLACEHOLDER"

export NEW_THREAD_COUNT="PLACEHOLDER"

export TOMCAT_USER="PLACEHOLDER"

export TOMCAT_GROUP="PLACEHOLDER"
```

## Debug

### Check the current memory usage
```shell
free -m
```

### Check the processes running on the system
```shell
ps aux
```

### Find the PID of Tomcat
```shell
ps aux | grep tomcat
```

### Check the memory usage of Tomcat
```shell
pmap -x ${PID}
```

### Check the Java version that Tomcat is running on
```shell
ps -ef | grep tomcat | grep -v grep | awk '{print $11}' | xargs -r readlink -f | xargs -r dirname | xargs -r dirname | xargs -r readlink -f | xargs -r -I {} {}/bin/java -version
```

### Check the Tomcat configuration
```shell
cat /etc/tomcat/server.xml
```

### Check the Tomcat log files for errors or warnings
```shell
tail -n 100 /var/log/tomcat/catalina.out
```

### Check the heap usage of Tomcat
```shell
jstat -gcutil ${PID} 1000
```

### Check the thread usage of Tomcat
```shell
jstack -l ${PID} | grep -Ei 'daemon|java.lang.Thread.State'
```

### Check for any memory leaks
```shell
jmap -histo:live ${PID} | head -n 20
```

### Check the JVM arguments that are being used by Tomcat
```shell
ps -ef | grep tomcat | grep -v grep | awk '{print $11}' | xargs -r readlink -f | xargs -r dirname | xargs -r dirname | xargs -r readlink -f | xargs -r -I {} {}/bin/java -XX:+PrintFlagsFinal -version | grep -Ei 'heapsize|stacksize|metaspacesize|direct|verbose'
```

## Repair

### Increase the memory allocation for the Tomcat server.
```shell


#!/bin/bash



# Stop Tomcat

sudo systemctl stop tomcat



# Update the memory allocation in the Tomcat configuration file

sudo sed -i 's/-Xmx${OLD_MEMORY_LIMIT}/-Xmx${NEW_MEMORY_LIMIT}/g' /path/to/tomcat/conf/catalina.sh



# Start Tomcat

sudo systemctl start tomcat





chmod +x increase_tomcat_memory.sh


```

### Reduce the number of threads used by Tomcat.
```shell


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


```