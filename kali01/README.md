# KALI01 · attack simulation

Kali Linux ARM64 at 10.10.10.66. [attack-simulation.sh](attack-simulation.sh) runs four steps against the
lab subnet only: service scan, SMB enumeration, Kerberos username enumeration and a password spray.
Output is saved to `~/evidence` for the write-up.

**Only run this against a lab you own.** Scanning or spraying someone else's network without written
permission is illegal.

Techniques, expected Windows events and what Wazuh should show: [docs/attack-and-detection.md](../docs/attack-and-detection.md).
