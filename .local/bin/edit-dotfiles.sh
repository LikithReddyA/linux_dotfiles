#!/usr/bin/env bash
# ────────────────────────────────────────────────
# Script: edit-dotfile-menu.sh
# Purpose: Interactive editor for application dotfiles
# Requires: dmenu (or rofi -dmenu)
# Usage: ./edit-dotfile-menu.sh
# ────────────────────────────────────────────────

# Use your existing 'vi' alias/command as the editor
EDITOR_CMD="kitty -e nvim"

# Dotfiles base directory
CONFIG_DIR="${HOME}/.config"

# List of applications and their config paths
declare -A DOTFILES=(
  [nvim - likith]="$CONFIG_DIR/nvim-likith/init.lua"
  [nvim]="$CONFIG_DIR/nvim/init.lua"
  [kitty]="$CONFIG_DIR/kitty/kitty.conf"
  [alacritty]="$CONFIG_DIR/alacritty/alacritty.toml"
  [xmonad]="$CONFIG_DIR/xmonad/xmonad.hs"
  [polybar]="$CONFIG_DIR/polybar/config.ini"
  [picom]="$CONFIG_DIR/picom/picom.conf"
  [qutebrowser]="$CONFIG_DIR/qutebrowser/config.py"
  [starship]="$CONFIG_DIR/starship.toml"
  [fastfetch]="$CONFIG_DIR/fastfetch/config.jsonc"
  [mpv]="$CONFIG_DIR/mpv/mpv.conf"
  [zsh]="$HOME/.zshrc"
  [bash]="$HOME/.bashrc"
  [git]="$HOME/.gitconfig"
)

# Build the menu items
MENU_ITEMS=$(printf "%s\n" "${!DOTFILES[@]}" | sort)

# Show rofi menu
SELECTED=$(echo "$MENU_ITEMS" | rofi -dmenu -i -p "Edit dotfile:" -theme-str 'window {width: 40%;}')

# Exit if nothing selected
if [ -z "$SELECTED" ]; then
  echo "No selection. Exiting."
  exit 0
fi

# Get the file path
FILE="${DOTFILES[$SELECTED]}"

# Ensure directory exists
mkdir -p "$(dirname "$FILE")"

# Create file if it doesn't exist
if [ ! -f "$FILE" ]; then
  touch "$FILE"
fi

# Open in your aliased editor
$EDITOR_CMD "$FILE"
