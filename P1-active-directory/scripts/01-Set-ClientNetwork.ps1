# Run on CL01 (as admin) after renaming it to CL01 and rebooting.
param([string]$Ip = '10.10.10.21', [string]$Dns = '1.1.1.1')
$if = (Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1).Name
New-NetIPAddress -InterfaceAlias $if -IPAddress $Ip -PrefixLength 24 -DefaultGateway 10.10.10.1
Set-DnsClientServerAddress -InterfaceAlias $if -ServerAddresses $Dns
Test-NetConnection 1.1.1.1 -Port 443
