#!/bin/bash
DIR="$HOME/Downloads/Walls"
CACHE="$HOME/.cache/wallpapers"

# Create cache folder if it doesn't exist
mkdir -p "$CACHE"

# 1. Ensure the daemon is running
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 1
fi

# 2. Build the list for Rofi (Images + Videos)
LIST=""
for file in "$DIR"/*; do
    [ -e "$file" ] || continue
    name=$(basename "$file")
    
    if [[ "$file" == *.mp4 || "$file" == *.mkv || "$file" == *.webm ]]; then
        LIST+="$name\0icon\x1fvideo-x-generic\n"
    elif [[ "$file" == *.jpg || "$file" == *.jpeg || "$file" == *.png || "$file" == *.gif ]]; then
        thumb="$CACHE/${name}.jpg"
        if [ ! -f "$thumb" ]; then
            magick "$file" -thumbnail 300x300^ -gravity center -extent 300x300 "$thumb"
        fi
        LIST+="$name\0icon\x1f$thumb\n"
    fi
done

# 3. Show the Rofi menu
SELECT=$(echo -e "$LIST" | rofi -dmenu -p "󰸉 Wallpapers" -config ~/.config/rofi/config.rasi)

# 4. Apply selection (Unified Logic)
if [ -n "$SELECT" ]; then
    # Stop existing background processes
    pkill -f wallpaper_slideshow.sh
    pkill mpvpaper
    
    # Handle Video Wallpapers
    if [[ "$SELECT" == *.mp4 || "$SELECT" == *.mkv || "$SELECT" == *.webm ]]; then
        mpvpaper -o "no-audio --loop-playlist hwdec=auto panscan=1.0" "*" "$DIR/$SELECT"
    else
        # Handle Static Images with a single, smooth transition
        # NVIDIA Fix: Use 'fade' if 'grow' continues to stutter
        awww img "$DIR/$SELECT" \
            --transition-type wipe \
            --transition-fps 240 \
            --transition-step 100 \
            --transition-duration 3 || awww img "$DIR/$SELECT" --transition-type none
    fi
fi
