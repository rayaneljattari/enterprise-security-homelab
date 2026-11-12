# pi01 · Raspberry Pi edge services

A Raspberry Pi 4 or 5 on the home network, running Raspberry Pi OS Lite 64-bit.

| Service | Port | Purpose |
|---|---|---|
| Pi-hole | 53, web 8080 | DNS filtering for the home network |
| WireGuard (wg-easy) | 51820/udp, web 51821 | VPN back into the home network |
| Uptime Kuma | 3001 | Uptime monitoring of the other services |

## Setup

```bash
LAN=192.168.1.0/24 bash harden-pi.sh   # check SSH key login works first: passwords get disabled
curl -fsSL https://get.docker.com | sh
cp .env.example .env && nano .env       # never commit .env
docker compose up -d
```

## Hardening in [harden-pi.sh](harden-pi.sh)

- SSH: keys only, no root login, 3 auth tries, no forwarding
- ufw: deny incoming by default, services only reachable from the home LAN, WireGuard port open
- fail2ban for SSH, unattended security upgrades

Note: Docker publishes ports past ufw's rules. The Pi stays behind the home router and only 51820/udp
is forwarded, if remote VPN access is needed at all.
