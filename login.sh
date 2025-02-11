#!/bin/bash

# Define ANSI color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color
PUBLIC_IP=$(curl -s https://checkip.pterodactyl-installer.se/)
# Uptime calculation
UPTIME_DAYS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 / 86400)
UPTIME_HOURS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 % 86400 / 3600)
UPTIME_MINUTES=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 % 86400 % 3600 / 60)

# Get CPU model
CPU_MODEL=$(grep -m 1 "model name" /proc/cpuinfo | cut -d ':' -f2 | sed 's/^[ \t]*//')

# Get disk usage (root partition)
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')  # Total disk size
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')   # Used disk space

# Use figlet for ASCII banner
figlet -c "Sushi Neverlose"
echo ""
echo -e "${CYAN}Welcome to $(lsb_release -ds) (GNU/Linux)${NC}"
echo ""
echo -e "${GREEN} * Halo Mas Ipan, Tetap semangat ya!${NC}"
echo -e "${YELLOW} -------------------------------------------${NC}"
echo -e " * IP Local: ${RED}$(hostname -I | awk '{print $1}')${NC}"
echo -e " * Public IP: ${GREEN}$PUBLIC_IP${NC}"
echo ""
echo -e "${CYAN} System information as of $(date)${NC}"
echo -e "${YELLOW}----------------------${NC}"

# Formatting with aligned columns and colored values
printf "  %-20s %-25s %-20s %-20s\n" "System load:" "$(uptime | awk '{print $10}')" "Processes:" "$(ps aux --no-headers | wc -l)"
printf "  %-20s ${RED}%-25s${NC} %-20s ${GREEN}%-20s${NC}\n" "Memory usage:" "$(free -m | awk 'NR==2{printf "%.0f%%", $3*100/$2 }')" "Uptime:" "$UPTIME_DAYS days, $UPTIME_HOURS hours, $UPTIME_MINUTES minutes"
printf "  %-20s ${RED}%-25s${NC}\n" "Swap usage:" "$(free -m | awk 'NR==3{printf "%.0f%%", $3*100/$2 }')"
printf "  %-20s ${GREEN}%-25s${NC}\n" "CPU Model:" "$CPU_MODEL"
printf "  %-20s ${GREEN}Total: $DISK_TOTAL, Used: $DISK_USED${NC}\n" "Disk Usage:"

echo ""
