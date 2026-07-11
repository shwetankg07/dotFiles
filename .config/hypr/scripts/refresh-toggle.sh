#!/usr/bin/env bash
# Cycle the internal panel through refresh rates (panel-verified list).
# Runtime-only change (hyprctl keyword) — config files are never touched,
# so a reboot or `hyprctl reload` always restores the default mode.
# Usage: refresh-toggle.sh          -> cycle to next rate in RATES
#        refresh-toggle.sh <rate>   -> jump straight to that rate
set -euo pipefail

# Edit this list to taste. Panel accepts: 60 90 100 120 144 165 180 240
RATES=(240 120 60)

mon=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("eDP"))')
if [[ -z "$mon" ]]; then
  notify-send -u critical "Refresh toggle" "No internal (eDP) panel found"
  exit 1
fi

name=$(jq -r '.name' <<<"$mon")
width=$(jq -r '.width' <<<"$mon")
height=$(jq -r '.height' <<<"$mon")
scale=$(jq -r '.scale' <<<"$mon")
x=$(jq -r '.x' <<<"$mon")
y=$(jq -r '.y' <<<"$mon")
rate=$(jq -r '.refreshRate | round' <<<"$mon")

if [[ $# -ge 1 ]]; then
  target=$1
else
  # find current rate in the list, pick the next one (wrap around)
  target=${RATES[0]}
  for i in "${!RATES[@]}"; do
    if (( RATES[i] == rate )); then
      target=${RATES[(i + 1) % ${#RATES[@]}]}
      break
    fi
  done
fi

hyprctl keyword monitor "${name},${width}x${height}@${target},${x}x${y},${scale}" >/dev/null

actual=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$name\") | .refreshRate | round")
if (( actual == target )); then
  notify-send -t 2500 "Refresh rate" "${rate}Hz → ${actual}Hz"
else
  notify-send -u critical "Refresh toggle" "Asked for ${target}Hz but panel reports ${actual}Hz"
fi
