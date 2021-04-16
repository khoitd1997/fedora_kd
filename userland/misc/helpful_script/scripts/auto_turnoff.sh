#!/bin/bash
currenttime=`date +"%H%M"`

evening_curfew="22:30"
shutdown -P ${evening_curfew}
if [[ "$currenttime" > "2230" ]] || [[ "$currenttime" < "0730" ]]; then
  future_shutdown_time=$(date -d "2 minutes" +'%H:%M')
  shutdown -P ${future_shutdown_time}
fi
