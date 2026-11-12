# Run as a domain admin. GPO settings (LAPS policy, baselines, tiering, LLMNR, audit) are set in GPMC: see the P1 doc.
Import-Module ActiveDirectory
$domain = Get-ADDomain
$root = "OU=Scheldt,$($domain.DistinguishedName)"

# Password and lockout policy
Set-ADDefaultDomainPasswordPolicy -Identity $domain.DNSRoot `
  -MinPasswordLength 14 -ComplexityEnabled $true -PasswordHistoryCount 24 `
  -MaxPasswordAge '00:00:00' `
  -LockoutThreshold 10 -LockoutDuration '00:15:00' -LockoutObservationWindow '00:15:00'

# Windows LAPS: schema + let workstations write their own password
Update-LapsADSchema -Confirm:$false
Set-LapsADComputerSelfPermission -Identity "OU=Workstations,OU=Computers,$root"

# Print Spooler off on the domain controller (run this part on DC01)
if ($env:COMPUTERNAME -eq 'DC01') { Stop-Service Spooler; Set-Service Spooler -StartupType Disabled }

Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol, RequireSecuritySignature
