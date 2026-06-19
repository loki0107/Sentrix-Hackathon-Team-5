#!/bin/bash

echo "==============================="
echo " Suricata Auto Configuration"
echo "==============================="

# Detect interface
IFACE=$(ip route | grep default | awk '{print $5}' | head -1)

echo "[+] Detected Interface: $IFACE"

# Backup config
sudo cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.bak

# Configure AF-PACKET interface
sudo sed -i "/af-packet:/,/cluster-id:/ s/interface:.*/interface: $IFACE/" /etc/suricata/suricata.yaml

echo "[+] Updating rules..."
sudo suricata-update

echo "[+] Enabling and restarting Suricata..."
sudo systemctl enable suricata
sudo systemctl restart suricata

sleep 5

echo
echo "==============================="
echo " Suricata Status"
echo "==============================="
sudo systemctl --no-pager status suricata | head -15

echo
echo "==============================="
echo " Log Files"
echo "==============================="
ls -lh /var/log/suricata/

echo
echo "==============================="
echo " Last 10 Alerts"
echo "==============================="
sudo tail -10 /var/log/suricata/fast.log 2>/dev/null

echo
echo "==============================="
echo " To Monitor Logs Live"
echo "==============================="
sudo tail -f /var/log/suricata/fast.log
sudo tail -f /var/log/suricata/eve.json

echo
echo "==============================="
echo " Generate Alerts From Kali"
echo "==============================="
nmap -sS <Ubuntu-IP>
nmap -A <Ubuntu-IP>
nmap -p- <Ubuntu-IP>