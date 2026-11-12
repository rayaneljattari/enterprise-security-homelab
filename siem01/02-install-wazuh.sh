#!/usr/bin/env bash
# Wazuh all-in-one (indexer + server + dashboard) on SIEM01. Needs 8 GB RAM, 4 vCPU.
# Check https://documentation.wazuh.com/current/quickstart.html for the current version path if 4.x has moved.
set -euo pipefail
sudo hostnamectl set-hostname siem01
curl -sO https://packages.wazuh.com/4.x/wazuh-install.sh
sudo bash ./wazuh-install.sh -a
echo "Dashboard: https://10.10.10.30  (admin password printed above; also in wazuh-install-files.tar)"
