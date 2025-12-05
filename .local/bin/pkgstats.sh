#!/usr/bin/env bash
#
# pkgstats.sh — show Arch Linux package statistics
# Works with pacman; optionally uses yay or paru for AUR details

set -euo pipefail

# Colors
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
MAGENTA="\033[1;35m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${MAGENTA}==============================${RESET}"
echo -e "${CYAN}📦 Arch Linux Package Stats${RESET}"
echo -e "${MAGENTA}==============================${RESET}\n"

# Detect AUR helper if present
if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
else
    AUR_HELPER=""
fi

# Count totals
TOTAL_PKGS=$(pacman -Q | wc -l)
EXPLICIT_PKGS=$(pacman -Qe | wc -l)
DEPENDENCY_PKGS=$(pacman -Qd | wc -l)
OFFICIAL_PKGS=$(pacman -Qn | wc -l)
FOREIGN_PKGS=$(pacman -Qm | wc -l)

echo -e "${YELLOW}Total installed packages      :${RESET} ${GREEN}$TOTAL_PKGS${RESET}"
echo -e "${YELLOW}Explicitly installed packages :${RESET} ${GREEN}$EXPLICIT_PKGS${RESET}"
echo -e "${YELLOW}Dependency packages           :${RESET} ${GREEN}$DEPENDENCY_PKGS${RESET}"
echo -e "${YELLOW}Official repo packages        :${RESET} ${GREEN}$OFFICIAL_PKGS${RESET}"
echo -e "${YELLOW}AUR/Foreign packages          :${RESET} ${GREEN}$FOREIGN_PKGS${RESET}\n"

# ---------------------------
# Recently installed packages
# ---------------------------
echo -e "${CYAN}🕒 Recently installed packages (last 10):${RESET}"

# Extract last 10 installed packages
RECENT_PKGS=$(grep "\[ALPM\] installed" /var/log/pacman.log | tail -n 10 | cut -d' ' -f4-)

# Number and colorize
echo "$RECENT_PKGS" | nl -w2 -s'. ' | awk -v CYAN="$CYAN" -v GREEN="$GREEN" -v RESET="$RESET" \
'{printf "%s%2d.%s %s%s%s\n", CYAN, $1, RESET, GREEN, substr($0,index($0,$2)) , RESET}'

echo

# ---------------------------
# AUR / Foreign packages
# ---------------------------
if [[ -n "$AUR_HELPER" ]]; then
    echo -e "${CYAN}🌐 AUR / Foreign packages:${RESET}"
    $AUR_HELPER -Qm | nl -w2 -s'. ' | awk -v CYAN="$CYAN" -v GREEN="$GREEN" -v RESET="$RESET" \
    '{printf "%s%2d.%s %s%s%s\n", CYAN, $1, RESET, GREEN, substr($0,index($0,$2)) , RESET}'
    echo
fi

# ---------------------------
# Top 10 Largest Installed Packages
# ---------------------------
echo -e "${CYAN}📦 Top 10 Largest Installed Packages:${RESET}\n"

LC_ALL=C pacman -Qi | awk '
/^Name/{name=$3}
/^Installed Size/{
    match($0, /Installed Size *: *([0-9.]+) (KiB|MiB|GiB)/, arr)
    number=arr[1]
    unit=arr[2]

    # Convert to bytes for sorting
    if(unit=="KiB") {bytes=number*1024}
    else if(unit=="MiB") {bytes=number*1024*1024}
    else if(unit=="GiB") {bytes=number*1024*1024*1024}
    else {bytes=number}

    print bytes, number, unit, name
}' | sort -rn | head -n 10 | \
awk -v CYAN="$CYAN" -v YELLOW="$YELLOW" -v GREEN="$GREEN" -v RESET="$RESET" \
'{printf "%s%2d.%s %s%-10s%s %s%s%s\n", CYAN, NR, RESET, YELLOW, $2" "$3, RESET, GREEN, $4, RESET}'

# ---------------------------
# Summary
# ---------------------------
echo -e "\n${RED}✅ Done.${RESET} Generated on: ${MAGENTA}$(date)${RESET}\n"
