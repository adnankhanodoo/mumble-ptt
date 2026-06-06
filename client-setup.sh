#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   SMS IoT — Mumble PTT Client Setup${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

SERVER_IP="100.84.208.88"
SERVER_PORT="64738"

echo -e "${YELLOW}Step 1: Installing NetBird...${NC}"
if ! command -v netbird &>/dev/null; then
    curl -fsSL https://pkgs.netbird.io/install.sh | sh
fi
netbird up --setup-key AD2E59A4-8795-4574-B121-2A51B9C1D4D6
sleep 3

echo ""
echo -e "${YELLOW}Step 2: Installing Mumble desktop client...${NC}"
sudo apt update -qq
sudo apt install -y mumble

echo ""
echo -e "${YELLOW}Step 3: Configuring auto-connect...${NC}"
mkdir -p "$HOME/.local/share/data/Mumble/Mumble"

cat > "$HOME/.local/share/data/Mumble/Mumble/mumble.sqlite" << 'EOF'
EOF

# Create autostart script
cat > "$HOME/start-ptt.sh" << EOF
#!/bin/bash
mumble mumble://$SERVER_IP:$SERVER_PORT
EOF
chmod +x "$HOME/start-ptt.sh"

# Create desktop shortcut
cat > "$HOME/Desktop/PTT.desktop" << EOF
[Desktop Entry]
Name=SMS IoT PTT
Exec=mumble mumble://$SERVER_IP:$SERVER_PORT
Icon=mumble
Type=Application
Terminal=false
EOF
chmod +x "$HOME/Desktop/PTT.desktop" 2>/dev/null || true

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}  ✓ Client Setup Complete!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "  ${GREEN}Connect command:${NC} mumble mumble://$SERVER_IP:$SERVER_PORT"
echo ""
echo -e "  ${YELLOW}First time only — set continuous mode:${NC}"
echo -e "  Configure → Settings → Audio Input"
echo -e "  Transmission → Continuous → OK"
echo ""

# Auto launch mumble
echo -e "${YELLOW}Launching Mumble...${NC}"
mumble mumble://$SERVER_IP:$SERVER_PORT &
