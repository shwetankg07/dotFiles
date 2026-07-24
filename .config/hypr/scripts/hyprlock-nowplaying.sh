#!/bin/bash
# Emits "  Title · Artist" for the current player, or nothing if idle.
playerctl metadata --format '󰎈  {{title}} · {{artist}}' 2>/dev/null | head -c 60
