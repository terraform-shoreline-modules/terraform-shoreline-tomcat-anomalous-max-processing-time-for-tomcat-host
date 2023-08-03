
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Anomalous max processing time for Tomcat host
---

This incident type typically refers to a situation where there is an anomaly in the Tomcat max processing time on a host. The maximum amount of time it takes for the server to process one request, from the time an available thread starts processing the request to the time it returns a response, has exceeded the expected threshold. This could indicate that a JSP page isn’t loading or an associated process (such as a database query) is taking too long to complete.

### Parameters
```shell
# Environment Variables

export PID="PLACEHOLDER"

export USERNAME="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export DESIRED_NETWORK_THRESHOLD="PLACEHOLDER"

export DESIRED_MEMORY_THRESHOLD="PLACEHOLDER"
```

## Debug

### Check if the Tomcat service is running
```shell
systemctl status tomcat
```

### Check the Tomcat access and error logs for any relevant messages
```shell
tail -n 50 catalina_out.log

tail -n 50 localhost_access.log

tail -n 50 localhost.log
```

### Check the CPU and memory usage of the server
```shell
top
```

### Check the network connections to the server
```shell
netstat -an
```

### Check the current JVM settings
```shell
jcmd ${PID} VM.flags
```

### Check the database server for performance issues
```shell
psql -U ${USERNAME} -d ${DATABASE_NAME} -c "SELECT * FROM pg_stat_activity;"
```

### The server may be experiencing a high load of requests, causing the Tomcat max processing time to spike.
```shell


#!/bin/bash



# Check CPU usage

CPU_USAGE=$(top -bn1 | grep load | awk '{print $(NF-2)}' | sed 's/,//')

CPU_THRESHOLD=80



if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then

    echo "CPU usage is high: ${CPU_USAGE}%"

else

    echo "CPU usage is normal: ${CPU_USAGE}%"

fi



# Check memory usage

MEM_USAGE=$(free | awk '/Mem/{printf("%.2f\n"), $3/$2*100}')

MEM_THRESHOLD=${DESIRED_MEMORY_THRESHOLD}



if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then

    echo "Memory usage is high: ${MEM_USAGE}%"

else

    echo "Memory usage is normal: ${MEM_USAGE}%"

fi



# Check network usage

NET_USAGE=$(netstat -an | grep :80 | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -n 10)

NET_THRESHOLD=${DESIRED_NETWORK_THRESHOLD}



if (( $(echo "$NET_USAGE > $NET_THRESHOLD" | bc -l) )); then

    echo "Network usage is high: ${NET_USAGE}"

else

    echo "Network usage is normal: ${NET_USAGE}"

fi


```

## Repair

### Increase the resources allocated to the Tomcat server, such as CPU, memory, or network bandwidth.
```shell


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


```