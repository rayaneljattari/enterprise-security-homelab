#!/usr/bin/env bash
# Base hardening for Raspberry Pi OS Lite 64-bit (Pi 4 or Pi 5). Run as your normal user with sudo.
# Make sure your SSH key login works BEFORE running: password login gets disabled.
set -euo pipefail
sudo apt-get update && sudo apt-get -y full-upgrade
sudo apt-get install -y ufw fail2ban unattended-upgrades

# SSH: keys only, no root
sudo tee /etc/ssh/sshd_config.d/10-hardening.conf >/dev/null <<'CONF'
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
MaxAuthTries 3
X11Forwarding no
AllowTcpForwarding no
CONF
sudo systemctl restart ssh

# Firewall: only what the services need, from the home LAN
LAN=${LAN:-192.168.1.0/24}   # set LAN=... to your home subnet
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from $LAN to any port 22 proto tcp
sudo ufw allow from $LAN to any port 53
sudo ufw allow from $LAN to any port 8080 proto tcp   # Pi-hole web
sudo ufw allow from $LAN to any port 3001 proto tcp   # Uptime Kuma
sudo ufw allow from $LAN to any port 51821 proto tcp  # WireGuard web UI
sudo ufw allow 51820/udp                              # WireGuard VPN
sudo ufw --force enable

# Automatic security updates + fail2ban for SSH
sudo dpkg-reconfigure -f noninteractive unattended-upgrades
sudo systemctl enable --now fail2ban
sudo ufw status verbose
