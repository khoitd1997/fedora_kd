#!/bin/bash
currenttime=`date +"%H%M%S"`

evening_curfew="21:30"
shutdown -P ${evening_curfew} > /dev/null 2>&1
if [[ "$currenttime" > "213000" ]] && [[ "$currenttime" < "073000" ]]; then
  future_shutdown_time=$(date -d "3 minutes" +'%H:%M')
  shutdown -P ${future_shutdown_time} > /dev/null 2>&1
fi
