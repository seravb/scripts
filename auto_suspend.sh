#!/bin/bash

# Script to activate the power for the usb's ports,
# By default in xubuntu 13.10 with kernel 3.11 the energy of the usb ports is deactivated after few seconds if you use a laptop with a
# battery and with the charger disconnected

for archivo in /sys/bus/usb/devices/*/power/level;
do
	# cat $archivo;
	echo on > $archivo;
	# echo auto > $archivo;
done
