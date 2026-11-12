# Creates your Tier0 admin account. Use it only on DC01, never on CL01.
param([string]$Name = 'adm-t0-rayan')
Import-Module ActiveDirectory
$domain = Get-ADDomain
$root = "OU=Scheldt,$($domain.DistinguishedName)"
$pw = Read-Host -AsSecureString 'Password'
New-ADUser -Name $Name -SamAccountName $Name -UserPrincipalName "$Name@$($domain.DNSRoot)" `
  -Path "OU=Tier0,OU=Admin,$root" -AccountPassword $pw -Enabled $true
Add-ADGroupMember 'Domain Admins'   -Members $Name
Add-ADGroupMember 'Protected Users' -Members $Name
