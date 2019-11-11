#!/bin/bash
currenttime=`date +"%H%M%S"`

echo "I am auto turn-off script"
shutdown -P 00:10
if [[ "$currenttime" > "001000" ]] && [[ "$currenttime" < "063000" ]]; then
  future_shutdown_time=$(date -d "3 minutes" +'%H:%M')
  shutdown -P ${future_shutdown_time}
fi