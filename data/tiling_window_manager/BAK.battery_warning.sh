#!/bin/bash

THRESHOLD=10 # percent

acpi_path=$(find /sys/class/power_supply/ -name 'BAT*')
energy_now=$(cat "$acpi_path/energy_now")
energy_full_design=$(cat "$acpi_path/energy_full_design")
charge_status=$(cat "$acpi_path/status")
charge_percent=$(printf '%.0f' $(echo "$energy_now / $energy_full_design * 100" | bc -l))
message="Battery running low at $charge_percent%!"

if [[ $charge_status == 'Discharging' ]] && [[ $charge_percent -le $THRESHOLD ]]; then
   DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus /usr/bin/notify-send --urgency=critical 'WARNING! WARNING! WARNING!' "$message"
fi

