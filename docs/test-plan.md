# Test plan

[Back to README](../README.md)

Every test has a command, an expected result, and a result column that I fill in after running it.
`10-Test-Lab.ps1` runs the automated subset and prints PASS or FAIL per line.

| # | Test | Command (host) | Expected | Result |
|---|---|---|---|---|
| 1 | Lab has internet through GW01 | `Test-NetConnection 1.1.1.1 -Port 443` (CL01) | `TcpTestSucceeded : True` | _pending_ |
| 2 | Domain DNS works | `Resolve-DnsName ad.scheldt.lab` (CL01) | 10.10.10.10 | _pending_ |
| 3 | DC is advertised | `Resolve-DnsName _ldap._tcp.dc._msdcs.ad.scheldt.lab -Type SRV` (CL01) | SRV to dc01.ad.scheldt.lab | _pending_ |
| 4 | DC is healthy | `dcdiag /test:dns` (DC01) | all tests passed | _pending_ |
| 5 | Client trust | `Test-ComputerSecureChannel` (CL01) | True | _pending_ |
| 6 | Users created | count of users under `OU=Users,OU=Scheldt` | 60 | _pending_ |
| 7 | GPOs apply | `gpresult /r /scope computer` (CL01) | SEC GPOs listed as applied | _pending_ |
| 8 | LAPS works | `Get-LapsADPassword CL01 -AsPlainText` | password and expiry | _pending_ |
| 9 | Lockout works | 10 wrong passwords for a test user | LockedOut True, event 4740 | _pending_ |
| 10 | Tiering works | log on to CL01 as `adm-t0-*` | logon refused | _pending_ |
| 11 | LLMNR off | registry `EnableMulticast` (CL01) | 0 | _pending_ |
| 12 | Auditing works | create a user, read event 4720 (DC01) | event with my admin as subject | _pending_ |
| 13 | Health score improved | PingCastle before and after | lower risk score | _pending_ |
| 14 | Wazuh agents active | Wazuh dashboard, Agents | DC01 and CL01 active | _pending_ |
| 15 | Spray detected | run `attack-simulation.sh`, check Threat Hunting | failed logon alerts on DC01 | _pending_ |
| 16 | GW01 blocks inbound | `nmap` the GW01 WAN address from the Mac | only filtered ports | _pending_ |
| 17 | Pi services up | `docker compose ps` (pi01) | 3 containers running | _pending_ |
| 18 | Pi firewall | `sudo ufw status verbose` (pi01) | default deny incoming, LAN-only rules | _pending_ |
| 19 | Pi SSH keys only | `ssh -o PubkeyAuthentication=no pi01` | Permission denied (publickey) | _pending_ |

## Issues found during the build

Things that broke and how I fixed them. Interviewers ask about this more than about what worked.

| Problem | Cause | Fix |
|---|---|---|
| _to fill in_ | | |
