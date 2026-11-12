# Hardening

[Back to README](../README.md)

Measured with PingCastle before and after. The before report is taken on the fresh domain, right after
the users are created.

| PingCastle | Before | After |
|---|---|---|
| Global risk score (lower is better) | _to measure_ | _to measure_ |
| Stale objects | _to measure_ | _to measure_ |
| Privileged accounts | _to measure_ | _to measure_ |
| Trusts | _to measure_ | _to measure_ |
| Anomalies | _to measure_ | _to measure_ |

## 1. Password and lockout policy

Set in [09-Set-Hardening.ps1](../P1-active-directory/scripts/09-Set-Hardening.ps1).

| Setting | Value | Why |
|---|---|---|
| Minimum length | 14 | Length matters more than complexity rules |
| Complexity | on | Required by most audit frameworks |
| History | 24 | Stops cycling back to an old password |
| Maximum age | none | No forced rotation (NIST SP 800-63B, Microsoft baseline) |
| Lockout threshold | 10 | Stops online guessing, hard to abuse for mass lockout |
| Lockout duration / window | 15 min | Self-healing, no helpdesk ticket needed |

## 2. Windows LAPS

Every workstation gets a unique, random local administrator password that rotates every 30 days and is
stored encrypted in AD. Schema update and permissions in the hardening script; the policy is a GPO.

| GPO `SEC - LAPS`, linked to `Workstations` | Value |
|---|---|
| Configure password backup directory | Active Directory |
| Password complexity | upper + lower + numbers + specials |
| Password length | 20 |
| Password age | 30 days |
| Enable password encryption | Enabled |

## 3. Admin tiering

| GPO `SEC - Deny Tier0 on workstations`, linked to `Workstations` | Members |
|---|---|
| Deny log on locally | Domain Admins, Enterprise Admins |
| Deny log on through Remote Desktop Services | Domain Admins, Enterprise Admins |
| Deny access to this computer from the network | Domain Admins, Enterprise Admins |

Tier 0 accounts are also in **Protected Users**.

## 4. Attack surface

| Change | How | Attack it blocks |
|---|---|---|
| LLMNR off | GPO `SEC - Network hardening` on `Scheldt`: Turn off multicast name resolution = Enabled | Responder-style credential capture |
| Print Spooler off on DC01 | hardening script | PrintNightmare, printer bug coercion |
| SMBv1 off | default on Server 2025, verified | EternalBlue-class exploits |
| SMB signing required | verified with `Get-SmbServerConfiguration` | NTLM relay |
| Microsoft security baseline (optional) | Security Compliance Toolkit, imported as GPOs | broad baseline coverage |

Any baseline setting I relax gets a line in the table below with the reason. That exception list is the
part of a hardening job a client actually reads.

| Relaxed setting | Reason |
|---|---|
| _none yet_ | |

## 5. Audit policy

GPO `SEC - Audit DCs`, linked to `Domain Controllers`, under Advanced Audit Policy Configuration.
These are the events the SIEM depends on.

| Category | Subcategory | Audit | Key event IDs |
|---|---|---|---|
| Account Logon | Credential Validation | Success, Failure | 4776 |
| Account Logon | Kerberos Authentication Service | Success, Failure | 4768, 4771 |
| Account Management | User Account Management | Success, Failure | 4720, 4722, 4740 |
| Account Management | Security Group Management | Success, Failure | 4728, 4732, 4756 |
| Logon/Logoff | Logon, Special Logon | Success, Failure | 4624, 4625, 4672 |
| DS Access | Directory Service Changes | Success | 5136 |
| Detailed Tracking | Process Creation | Success | 4688 |

Also enabled: command line in process creation events, and a Security log of at least 1 GB.
Check with `auditpol /get /category:*`.
