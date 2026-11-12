# Evidence

Screenshots and command output from the running lab. Nothing here is mocked up: if a file is missing, that
part has not been verified yet.

## What to capture

| File | Shows | Redact |
|---|---|---|
| `01-wazuh-agents.png` | Wazuh Agents page, DC01 and CL01 active | nothing |
| `02-aduc-ou-structure.png` | Active Directory Users and Computers, `Scheldt` OU tree | nothing |
| `03-gpo-overview.png` | Group Policy Management with the `SEC -` GPOs and their links | nothing |
| `04-laps-password.png` | `Get-LapsADPassword CL01` output | **the password** |
| `05-pingcastle-before-after.png` | PingCastle score before and after hardening, side by side | domain SID if shown |
| `06-kali-spray.png` | Kali terminal running the password spray | nothing (lab passwords only) |
| `06-wazuh-spray-alert.png` | Wazuh Threat Hunting with the resulting alerts on DC01 | nothing |
| `07-test-lab.png` | `10-Test-Lab.ps1` PASS/FAIL list | nothing |
| `08-gw01-nft-ruleset.png` | `sudo nft list ruleset` on GW01 | nothing |
| `09-pi-docker-ufw.png` | `docker compose ps` and `sudo ufw status verbose` on pi01 | home public IP |
| `10-uptime-kuma.png` | Uptime Kuma dashboard | hostnames you would rather not share |

Text output (nmap, netexec, kerbrute) can go in as `.txt` files from `~/evidence` on KALI01.

## Rules

- No passwords, `.env` files, `lab-users.csv`, private keys or WireGuard configs. `.gitignore` blocks most
  of them, but check `git status` before every commit.
- File names without spaces, numbered so they sort in the order of the README.
- After adding screenshots, update the Results table and Screenshots section in the main README.
