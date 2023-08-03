

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