#!/bin/bash

# 1. Wait 5 seconds for Line 4 to finish loading the default stuff
sleep 5

# 2. Kill the default wallpaper engine so it stops fighting us
pkill swww
pkill swww-daemon
pkill hyprpaper

# 3. Start our own engine fresh
swww-daemon &
sleep 1


# 1. Set the folder where your images are
DIR=$HOME/Downloads/Walls/

# 2. Set the time interval (300s = 5 mins)
INTERVAL=60

# 3. Start the daemon correctly if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 1 # Give it a sec to breathe
fi

# 4. Infinite loop
while true; do
    # Find a random file
    RANDOM_IMG=$(find "$DIR" -type f | shuf -n 1)

    # Apply the wallpaper
    swww img "$RANDOM_IMG" --transition-type grow --transition-pos 0.5,0.5 --transition-fps 240 --transition-step 90

    # Wait
    sleep $INTERVAL
done
