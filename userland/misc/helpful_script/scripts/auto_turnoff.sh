#!/bin/bash
currenttime=`date +"%H%M%S"`

evening_curfew="23:40"
echo "Evening curfew: ${evening_curfew}"
shutdown -q -P ${evening_curfew}
if [[ "$currenttime" > "001000" ]] && [[ "$currenttime" < "063000" ]]; then
  future_shutdown_time=$(date -d "3 minutes" +'%H:%M')
  shutdown -q -P ${future_shutdown_time}
fi
