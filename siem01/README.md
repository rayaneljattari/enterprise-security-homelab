# SIEM01 · Wazuh

Ubuntu Server 24.04 ARM64 at 10.10.10.30, running Wazuh all-in-one (manager, indexer, dashboard).

1. Copy [01-netplan.yaml](01-netplan.yaml) to `/etc/netplan/50-lab.yaml`, replace `LAN_IF`, `sudo netplan apply`.
   Use DNS 1.1.1.1 until DC01 exists, then switch to 10.10.10.10.
2. Run [02-install-wazuh.sh](02-install-wazuh.sh). It needs about 6-8 GB RAM and 4 vCPU.
3. Store the admin password it prints somewhere safe. `wazuh-install-files.tar` holds all generated
   passwords and is blocked by `.gitignore`.

Agents for DC01 and CL01: see [windows-agents](../windows-agents/).
What to look for after the attack run: [docs/attack-and-detection.md](../docs/attack-and-detection.md).
