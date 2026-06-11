#!/bin/sh

# Script to run in background svxbridge.py
# manually test and adapt the ports and output input devices
# if someone speaks on the ROOM it doesn't work so you have to restart it manually
python /opt/svxbridge/svxbridge.py > /dev/null 2>&1 &
