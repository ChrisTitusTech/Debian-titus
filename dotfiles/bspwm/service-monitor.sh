#!/bin/bash
serv=$1
sstat=dead
systemctl status $serv | grep -i 'running\|dead' | awk '{print $3}' | sed 's/[()]//g' | while read output;
do
echo $output
if [ "$output" == "$sstat" ]; then
    systemctl start $serv
    echo "$serv service is UP now.!"
  else
    echo "$serv service is running"
  fi
done
