# Test plan

[Back to README](../README.md)

Every test has a command, a **target** (what a working lab must show, set before the build) and a
**measured** column that I fill in only after running it myself.

| # | Test | Command (host) | Target | Measured |
|---|---|---|---|---|
| 1 | Lab has internet through GW01 | `Test-NetConnection 1.1.1.1 -Port 443` (CL01) | `TcpTestSucceeded : True` | |
| 2 | Domain DNS works | `Resolve-DnsName ad.scheldt.lab` (CL01) | 10.10.10.10 | |
| 3 | DC is advertised | `Resolve-DnsName _ldap._tcp.dc._msdcs.ad.scheldt.lab -Type SRV` (CL01) | SRV to dc01.ad.scheldt.lab | |
| 4 | DC is healthy | `dcdiag /test:dns` (DC01) | all tests passed | |
| 5 | Client trust | `Test-ComputerSecureChannel` (CL01) | True | |
| 6 | Users created | count of users under `OU=Users,OU=Scheldt` | 60 | |
| 7 | GPOs apply | `gpresult /r /scope computer` (CL01) | SEC GPOs listed as applied | |
| 8 | LAPS works | `Get-LapsADPassword CL01 -AsPlainText` | password and expiry | |
| 9 | Lockout works | 10 wrong passwords for a test user | LockedOut True, event 4740 | |
| 10 | Tiering works | log on to CL01 as `adm-t0-*` | logon refused | |
| 11 | LLMNR off | registry `EnableMulticast` (CL01) | 0 | |
| 12 | Auditing works | create a user, read event 4720 (DC01) | event with my admin as subject | |
| 13 | Health score improved | PingCastle before and after | lower risk score | |
| 14 | Wazuh agents active | Wazuh dashboard, Agents | DC01 and CL01 active | |
| 15 | Spray detected | run `attack-simulation.sh`, check Threat Hunting | rules 60122 and 60204 on agent DC01 | |
| 16 | GW01 blocks inbound | `nmap` the GW01 WAN address from the Mac | only filtered ports | |
| 17 | Pi services up | `docker compose ps` (pi01) | 3 containers running | |
| 18 | Pi firewall | `sudo ufw status verbose` (pi01) | default deny incoming, LAN-only rules | |
| 19 | Pi SSH keys only | `ssh -o PubkeyAuthentication=no pi01` | Permission denied (publickey) | |

## Target output of 10-Test-Lab.ps1

What the script must print on a finished lab. If any line says FAIL, the matching troubleshooting
row in the [build guide](build-guide.md) is the first place to look.

```text
PASS  Internet via GW01
PASS  Domain DNS
PASS  DC SRV record
PASS  Secure channel
PASS  60 users created
PASS  LAPS password stored
PASS  LLMNR disabled
PASS  Password min length 14
```

## Issues found during the build

Things that broke and how I fixed them. Interviewers ask about this more than about what worked.

| Problem | Cause | Fix |
|---|---|---|
| _to fill in_ | | |
