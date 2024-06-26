#!/usr/bin/env sh

enable_battery=false
battery_charging=false

for battery in /sys/class/power_supply/*BAT*; do
  if [[ -f "$battery/uevent" ]]; then
    enable_battery=true
    if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
      battery_charging=true
    fi
    break
  fi
done

if [[ $enable_battery == true ]]; then
  if [[ $battery_charging == true ]]; then
    printf " "
  else
    printf " "
  fi
  printf "%s%%" "$(cat /sys/class/power_supply/*/capacity | head -1)"
fi

echo ''
