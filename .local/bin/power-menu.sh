#!/bin/bash

# Define options
options="Shutdown\nRestart\nSleep\nLogout"

# Show options in dmenu and store the choice
choice=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu:")

case "$choice" in
Shutdown)
  systemctl poweroff
  ;;
Restart)
  systemctl reboot
  ;;
Sleep)
  systemctl suspend
  ;;
Logout)
  # Terminate the current user session to logout from xmonad
  loginctl terminate-session $XDG_SESSION_ID
  ;;
*)
  # If no valid option chosen or canceled
  exit 0
  ;;
esac
