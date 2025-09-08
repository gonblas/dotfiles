#!/bin/bash

mic_source=$(pactl info | awk -F': ' '/Default Source:/ {print $2}')

if [ "$1" == "1" ]; then
  pactl set-source-mute "$mic_source" toggle
fi

mic_status=$(pactl list sources | awk -v mic_source="$mic_source" '
  $0 ~ "^Source #" {in_source=0}
  $0 ~ "Name: " mic_source {in_source=1}
  in_source && /Mute:/ {print $2; exit}
')

if [ "$mic_status" == "yes" ]; then
  echo -e "󰍭"
else
  echo -e "󰍬"
fi

