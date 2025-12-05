#!/bin/bash
set -e

echo "[INFO] Downloading latest menu installer..."

sudo wget -qO /opt/menu_install.sh \
https://raw.githubusercontent.com/Arentis-Limited/va-speedtest-agent/main/menu_install.sh

sudo chmod +x /opt/menu_install.sh

echo "[INFO] Starting installer menu..."
sudo /opt/menu_install.sh
