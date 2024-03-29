#!/bin/bash
currenttime=$(date +"%H%M")

evening_curfew="22:30"
shutdown -P ${evening_curfew} > /dev/null 2>&1
if [[ "$currenttime" -gt "2230" ]] || [[ "$currenttime" -lt "0730" ]]; then
  shutdown -h now > /dev/null 2>&1
fi
