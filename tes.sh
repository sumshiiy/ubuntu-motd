#!/bin/bash
# Debian MOTD setup script by ChatGPT

# Colors
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}===========================================${NC}"
echo -e "${GREEN}  Custom Debian MOTD Setup${NC}"
echo -e "${CYAN}===========================================${NC}"
echo ""
read -p "Enter your server subdomain (e.g., serv1.aisbirnusantara.com): " SERVER_SUBDOMAIN

if [ -z "$SERVER_SUBDOMAIN" ]; then
    echo "❌ You must enter a subdomain!"
    exit 1
fi

echo ""
echo -e "${YELLOW}→ Removing default Contabo MOTD...${NC}"
rm -f /etc/motd
rm -f /etc/update-motd.d/*contabo* 2>/dev/null

echo -e "${YELLOW}→ Creating new MOTD script...${NC}"
cat <<EOF > /etc/update-motd.d/00-custom
#!/bin/bash

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

# System info
HOSTNAME=\$(hostname)
OS=\$(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')
DATE=\$(date)
LOAD=\$(uptime | awk -F'load average:' '{print \$2}' | xargs)
PROCESSES=\$(ps -e --no-headers | wc -l)
CPU_MODEL=\$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | sed 's/^ *//')
IP=\$(hostname -I | awk '{print \$1}')

# Memory info
MEM_TOTAL=\$(free -m | awk '/Mem:/ {print \$2}')
MEM_USED=\$(free -m | awk '/Mem:/ {print \$3}')
MEM_PCT=\$(( 100 * MEM_USED / MEM_TOTAL ))

SWAP_TOTAL=\$(free -m | awk '/Swap:/ {print \$2}')
SWAP_USED=\$(free -m | awk '/Swap:/ {print \$3}')
if [ "\$SWAP_TOTAL" -gt 0 ]; then
  SWAP_PCT=\$(( 100 * SWAP_USED / SWAP_TOTAL ))
else
  SWAP_PCT=0
fi

# Disk info
DISK_TOTAL=\$(df -h / | awk 'NR==2 {print \$2}')
DISK_USED=\$(df -h / | awk 'NR==2 {print \$3}')

# Uptime
UPTIME=\$(uptime -p | sed 's/up //')

# Banner
clear
echo ""
figlet -c "IPAN.ID"
echo ""
echo -e "\${CYAN}Welcome to \${OS}\${NC}"
echo -e "\${YELLOW}Server: $SERVER_SUBDOMAIN (\${IP})\${NC}"
echo ""
echo -e "\${GREEN} * Hallo, Apa kabar?"
echo ""
echo -e "\${CYAN} System information as of: \${DATE}\${NC}"
echo -e "\${YELLOW}----------------------------------------\${NC}"

printf "  %-18s %s\n" "System load:" "\$LOAD"
printf "  %-18s %s\n" "Processes:" "\$PROCESSES"
printf "  %-18s \${RED}%s%%\${NC}\n" "Memory usage:" "\$MEM_PCT"
printf "  %-18s \${RED}%s%%\${NC}\n" "Swap usage:" "\$SWAP_PCT"
printf "  %-18s %s\n" "Uptime:" "\$UPTIME"
printf "  %-18s %s\n" "CPU Model:" "\$CPU_MODEL"
printf "  %-18s %s / %s\n" "Disk Usage:" "\$DISK_USED" "\$DISK_TOTAL"
echo ""
EOF

chmod +x /etc/update-motd.d/00-custom

# Optional: remove static /etc/motd file (Debian uses dynamic MOTD)
echo -e "${YELLOW}→ Cleaning up old MOTD files...${NC}"
rm -f /etc/motd 2>/dev/null

# Ensure figlet installed
if ! command -v figlet >/dev/null 2>&1; then
    echo -e "${YELLOW}→ Installing figlet...${NC}"
    apt-get update -qq && apt-get install -y figlet >/dev/null
fi

echo ""
echo -e "${GREEN}✅ Custom MOTD installed successfully!${NC}"
echo -e "Reconnect SSH to see your new banner."
echo -e "${CYAN}-------------------------------------------${NC}"
echo -e "Server subdomain: ${YELLOW}$SERVER_SUBDOMAIN${NC}"
echo -e "${CYAN}-------------------------------------------${NC}"
