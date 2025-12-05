#!/bin/bash

REPO="Arentis-Limited/va-speedtest-agent"
AGENT_DIR="/opt/va-speedtest-agent"
SERVICE_FILE="/etc/systemd/system/va-speedtest.service"

get_latest_zip() {
    echo "[INFO] Checking latest release on GitHub..."
    LATEST_URL=$(wget -qO- https://api.github.com/repos/$REPO/releases/latest | grep "browser_download_url" | grep ".zip" | cut -d '"' -f 4)

    if [ -z "$LATEST_URL" ]; then
        echo "[ERROR] Could not find release ZIP."
        read -p "Press Enter..."
        return 1
    fi

    echo "[INFO] Latest package: $LATEST_URL"
    echo "[INFO] Downloading..."
    sudo wget -qO /opt/va-agent-latest.zip "$LATEST_URL"
    echo "[INFO] Downloaded to /opt/va-agent-latest.zip"
}

reset_installation() {
    echo "[INFO] Resetting installation..."

    sudo systemctl stop va-speedtest.service 2>/dev/null || true
    sudo systemctl disable va-speedtest.service 2>/dev/null || true
    sudo rm -f "$SERVICE_FILE"
    sudo systemctl daemon-reload
    sudo rm -rf "$AGENT_DIR"
    sudo rm -f /opt/va-agent-latest.zip

    echo "[OK] Reset complete."
    read -p "Press Enter..."
}

install_agent() {
    get_latest_zip || return

    echo "[INFO] Extracting ZIP..."
    sudo unzip -o /opt/va-agent-latest.zip -d /opt/

    echo "[INFO] Running installer..."
    cd /opt
    sudo bash install.sh

    echo "[OK] Installation completed."
    read -p "Press Enter..."
}

uninstall_agent() {
    echo "[INFO] Uninstalling agent..."

    sudo systemctl stop va-speedtest.service 2>/dev/null || true
    sudo systemctl disable va-speedtest.service 2>/dev/null || true
    sudo rm -f "$SERVICE_FILE"
    sudo systemctl daemon-reload
    sudo rm -rf "$AGENT_DIR"

    echo "[OK] Agent removed."
    read -p "Press Enter..."
}

service_status() {
    clear
    echo "SERVICE STATUS"
    systemctl status va-speedtest.service || true
    echo "--------------------------------------------------"
    journalctl -u va-speedtest -n 20 --no-pager || true
    echo "--------------------------------------------------"
    read -p "Press Enter..."
}

while true; do
    clear
    echo "======================================================"
    echo "        VA SPEEDTEST AGENT – INSTALL MENU"
    echo "======================================================"
    echo "1) Install latest version"
    echo "2) Reset old installation"
    echo "3) Uninstall agent"
    echo "4) Show service status"
    echo "5) Exit"
    echo "======================================================"
    read -p "Select option (1–5): " CHOICE

    case "$CHOICE" in
        1) install_agent ;;
        2) reset_installation ;;
        3) uninstall_agent ;;
        4) service_status ;;
        5) exit 0 ;;
        *) echo "Invalid option"; sleep 1 ;;
    esac
done
