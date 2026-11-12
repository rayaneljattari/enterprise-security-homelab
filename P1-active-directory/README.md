# P1 · Active Directory domain and hardening

Router configs and the numbered PowerShell scripts for the Scheldt Logistics domain `ad.scheldt.lab`.
Run them in order; each script says at the top where to run it. Design and reasoning are in
[docs/ad-design.md](../docs/ad-design.md) and [docs/hardening.md](../docs/hardening.md).

| Script | Host | What it does |
|---|---|---|
| [configs/gw01/setup-gw01.sh](configs/gw01/setup-gw01.sh) | GW01 | LAN interface, IP forwarding, nftables ruleset with NAT |
| [01-Set-ClientNetwork.ps1](scripts/01-Set-ClientNetwork.ps1) | CL01 | Static IP 10.10.10.21 |
| [02-Install-DC01.ps1](scripts/02-Install-DC01.ps1) | DC01 | Static IP, AD DS role, new forest (asks for DSRM password) |
| [03-Configure-DNS.ps1](scripts/03-Configure-DNS.ps1) | DC01 | DNS forwarders and reverse zone |
| [04-Join-CL01.ps1](scripts/04-Join-CL01.ps1) | CL01 | DNS to DC01, join the domain |
| [05-Install-RSAT.ps1](scripts/05-Install-RSAT.ps1) | CL01 | AD, GPO and DNS admin tools |
| [06-New-OUStructure.ps1](scripts/06-New-OUStructure.ps1) | CL01 | Company OUs, department groups, computer redirect |
| [07-New-LabUsers.ps1](scripts/07-New-LabUsers.ps1) | CL01 | 60 users with random initial passwords |
| [08-New-AdminAccount.ps1](scripts/08-New-AdminAccount.ps1) | CL01 | Tier 0 admin in Domain Admins and Protected Users |
| [09-Set-Hardening.ps1](scripts/09-Set-Hardening.ps1) | DC01 | Password and lockout policy, LAPS schema, Print Spooler off |
| [10-Test-Lab.ps1](scripts/10-Test-Lab.ps1) | CL01 | PASS/FAIL checks for the whole domain |

No passwords are hard-coded. Scripts that need one ask for it with `Read-Host -AsSecureString`.
