# Run on DC01 (as admin) after renaming it to DC01 and rebooting. The server reboots at the end.
$if = (Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1).Name
New-NetIPAddress -InterfaceAlias $if -IPAddress 10.10.10.10 -PrefixLength 24 -DefaultGateway 10.10.10.1
Set-DnsClientServerAddress -InterfaceAlias $if -ServerAddresses 127.0.0.1
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName 'ad.scheldt.lab' -DomainNetbiosName 'SCHELDT' -InstallDns `
  -SafeModeAdministratorPassword (Read-Host -AsSecureString 'DSRM password')
