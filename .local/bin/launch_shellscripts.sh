#!/usr/bin/env bash
# Script: rofi-script-runner.sh
# Description: List and execute or edit shell scripts using Rofi with manual entries

# --------------------------
# Define manual menu items
# Format: "Title - Description|path_to_script"
# --------------------------
MENU_ITEMS=$(
  cat <<EOF
Edit shell scripts launcher - Shell script launcher|$HOME/.local/bin/launch_shellscripts.sh
Edit config files of the applications - Dotfiles|$HOME/.local/bin/edit-dotfiles.sh
EOF
)

# --------------------------
# Show first menu via Rofi: select the script
# --------------------------
SELECTED_TITLE=$(echo "$MENU_ITEMS" | awk -F'|' '{print $1}' | rofi -dmenu -i -p "Select script:")

# Exit if user cancels
[[ -z "$SELECTED_TITLE" ]] && exit 0

# --------------------------
# Get the corresponding script path
# --------------------------
SCRIPT_PATH=$(echo "$MENU_ITEMS" | grep "^$SELECTED_TITLE" | awk -F'|' '{print $2}')

# Check if file exists
if [[ ! -f "$SCRIPT_PATH" ]]; then
  echo "Error: File not found: $SCRIPT_PATH" >&2
  exit 1
fi

# --------------------------
# Show second menu via Rofi: choose action
# --------------------------
ACTION=$(echo -e "Edit\nRun" | rofi -dmenu -i -p "Choose action for $SELECTED_TITLE:")

# Exit if user cancels
[[ -z "$ACTION" ]] && exit 0

# --------------------------
# Execute or edit based on selection
# --------------------------
case "$ACTION" in
Edit)
  echo "Editing: $SCRIPT_PATH"
  nvim "$SCRIPT_PATH"
  ;;
Run)
  echo "Running: $SCRIPT_PATH"
  bash "$SCRIPT_PATH"
  ;;
*)
  exit 0
  ;;
esac
