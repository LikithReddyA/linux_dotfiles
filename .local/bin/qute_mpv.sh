#!/bin/bash
# ~/bin/play_in_mpv.sh

# Fix PATH and environment in case qutebrowser has a minimal one
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin"
export TMPDIR="/tmp"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export HOME="$HOME"

# Optional: set mpv configuration path explicitly
# export MPV_HOME="$HOME/.config/mpv"

# Check if a URL argument was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL="$1"

echo "Playing: $URL"

# Run mpv with the URL
exec mpv --fullscreen "$URL"
