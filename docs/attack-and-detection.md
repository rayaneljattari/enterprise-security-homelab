# Attack simulation and detection

[Back to README](../README.md)

All attacks run from KALI01 against my own lab subnet `10.10.10.0/24`. The script is
[kali01/attack-simulation.sh](../kali01/attack-simulation.sh). Never point these tools at a network you
do not own or have written permission to test.

## Scenario

An attacker has a foothold on the office network (a rogue device, or a compromised laptop) but no
credentials yet. They map the network, find valid usernames and try one common password against many
accounts. The question for the client: **would anyone notice?**

## Steps, techniques and expected evidence

The "Expected" columns come from how Windows auditing and Wazuh's default ruleset work. The "Observed"
column is filled in from my own run, including anything that did not trigger.

| # | Step | Tool | MITRE ATT&CK | Expected on DC01 | Expected in Wazuh | Observed |
|---|---|---|---|---|---|---|
| 1 | Service scan of the subnet | `nmap -sV` | T1046 Network Service Discovery | nothing in the Security log | nothing | _pending_ |
| 2 | SMB enumeration (signing, OS, shares) | `netexec smb` | T1135 Network Share Discovery | possibly anonymous logons | little or nothing | _pending_ |
| 3 | Username enumeration via Kerberos | `kerbrute userenum` | T1087.002 Account Discovery: Domain Account | 4768 requests, including failures for unknown users | depends on rule coverage | _pending_ |
| 4 | Password spray over SMB | `netexec smb -p` | T1110.003 Password Spraying | burst of 4625 and 4776 failures across many users | logon failure alerts, then a multiple-failures alert | _pending_ |

## How I check it in Wazuh

1. Dashboard at `https://10.10.10.30`, **Threat Hunting**.
2. Filter `agent.name: DC01` and the time window of the run.
3. Look at `rule.groups: authentication_failed` and the Windows event IDs above.
4. Note the rule IDs and levels that fired in the table below.

| Wazuh rule ID | Description | Level | Count during spray |
|---|---|---|---|
| _fill in_ | | | |

## Gaps I expect to find

- **Steps 1 and 2 are invisible to a host-based SIEM.** A network sensor (Suricata or Zeek) on GW01 would
  see them. This is the next item on the roadmap.
- **Kerberos enumeration may not raise an alert out of the box.** A custom Wazuh rule on many 4768
  failures from one source IP in a short window would close that.
- **A slow spray** (one attempt per user per hour) would stay under any frequency threshold. That is a
  reason to add MFA and banned-password lists, not just detection.

## What I would tell the client

One short paragraph, written after the run, in plain language: what the attacker could do, what was
detected, how fast, and the two or three fixes that matter most.

> _To write after the attack run._
