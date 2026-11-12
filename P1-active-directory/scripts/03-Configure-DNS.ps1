# Run on DC01 after the forest reboot.
Add-DnsServerForwarder -IPAddress 1.1.1.1, 9.9.9.9
Add-DnsServerPrimaryZone -NetworkId '10.10.10.0/24' -ReplicationScope Forest
