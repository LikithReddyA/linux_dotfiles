#!/usr/bin/env bash

/usr/bin/emacs --daemon &
waypaper --restore &
picom &

# Start MPD if not already running
if ! pgrep -x "mpd" > /dev/null; then
    (sleep 2 && mpd) &
fi
