#!/bin/bash

treshold=80
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
disk_usage=$(df)
net_cpu_usage=${cpu_usage%.*}
total_memory=$(free -h | grep Mem | awk '{print $2}')
used_memory=$(free -h | grep Mem | awk '{print $3}')
free_memory=$(free -h | grep Mem | awk '{print $4}')
top_processes=$(ps aux --sort=-%mem | head -n 5 )
file_name="results.log"

echo "Monitoring System $(date)" >> "$file_name"
echo "---------------------------------------------------------------------------------" >> "$file_name"

while getopts "t:f:" option; do
  case $option in
    t) threshold=$OPTARG ;;
    f) file_name=$OPTARG ;;
    \?) echo "Invalid Option"
        exit 1 ;;
  esac
done

echo "Disk Usage:" >> " $file_name"
echo "$disk_usage" >> "$file_name"
echo "----------------------------------------------------------------------------------" >> " $file_name"

if [ "$net_cpu_usage" -gt "$treshold" ]; then
    echo "High CPU Usage! CPU is at ${cpu_usage}%! Check running processes" | mail -s "Server Warning!"  basmasabry33333@gmail.com
    echo -e "\e[31m⚠️ High CPU Usage! CPU is at ${cpu_usage}%! Check running processes.\e[0m" >> "$file_name"
fi

echo "CPU Usage:" >> "$file_name"
echo "Current CPU Usage: $cpu_usage %" >> "$file_name"

echo "----------------------------------------------------------------------------------" >> "$file_name"

echo "Memory Usage:" >> "$file_name"
echo "Total Memory: $total_memory " >> "$file_name"
echo "Used Memory: $used_memory " >> "$file_name"
echo "Free Memory: $free_memory " >> "$file_name"
echo "----------------------------------------------------------------------------------" >> "$file_name"

echo "Top 5 Memory-Consuming Processes:" >> "$file_name"
echo "$top_processes" >> "$file_name"
echo "----------------------------------------------------------------------------------" >> "$file_name"
