#!/bin/bash
echo none > /sys/class/leds/blue:wifi/trigger
echo none > /sys/class/leds/green:internet/trigger
echo none > /sys/class/leds/mmc0::/trigger
if [ "${LED_OFF}" == 1 ]
then
        echo 0 > /sys/class/leds/green:internet/brightness
        echo 0 > /sys/class/leds/blue:wifi/brightness
        echo 0 > /sys/class/leds/mmc0::/brightness
        exit 0
fi

connected_users=$(who | grep -cv localhost)
echo "connected_users: $connected_users"
if [ "$connected_users" -gt 0 ]
then
        echo 0 > /sys/class/leds/green:internet/brightness
        echo 1 > /sys/class/leds/blue:wifi/brightness
else
        echo 0 > /sys/class/leds/blue:wifi/brightness
        echo 1 > /sys/class/leds/green:internet/brightness
fi
cpu_used=$(top -b -n1 | grep -F "Cpu(s)" | tail -1 | awk -F'id,' '{split($1, vs, ","); v=vs[length(vs)]; sub(/\s+/, "", v);sub(/\s+/, "", v); printf "%s\n", 100-v; }')
threshold=50.0
is_overloading=$(echo "$cpu_used > $threshold" | bc)
echo "cpu used: $cpu_used is overloading:$is_overloading"
if [ "$is_overloading" -eq 1 ]
then
        echo 1 > /sys/class/leds/mmc0::/brightness
else
        echo 0 > /sys/class/leds/mmc0::/brightness
fi