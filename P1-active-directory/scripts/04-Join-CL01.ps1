# Run on CL01 (as local admin).
$if = (Get-NetAdapter | Where-Object Status -eq 'Up' | Select-Object -First 1).Name
Set-DnsClientServerAddress -InterfaceAlias $if -ServerAddresses 10.10.10.10
Resolve-DnsName ad.scheldt.lab
Add-Computer -DomainName 'ad.scheldt.lab' -Credential 'SCHELDT\Administrator' -Restart
