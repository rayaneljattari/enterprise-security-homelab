#!/usr/bin/env bash
# Run on GW01 as root after copying this folder: sudo bash setup-gw01.sh <WAN_IF> <LAN_IF>
set -euo pipefail
WAN=${1:?usage: setup-gw01.sh WAN_IF LAN_IF}; LAN=${2:?usage: setup-gw01.sh WAN_IF LAN_IF}
apt-get update && apt-get install -y nftables
sed "s/LAN_IF/$LAN/g" interfaces.append >> /etc/network/interfaces
cp 99-router.conf /etc/sysctl.d/99-router.conf && sysctl --system
sed -e "s/WAN_IF/$WAN/" -e "s/LAN_IF/$LAN/" nftables.conf > /etc/nftables.conf
nft -c -f /etc/nftables.conf
systemctl enable --now nftables && systemctl restart nftables
systemctl restart networking
ip -br a && nft list ruleset
