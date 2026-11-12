# Run on CL01 as a domain admin with RSAT installed. Prints PASS/FAIL per check.
$root = 'OU=Scheldt,DC=ad,DC=scheldt,DC=lab'
function Check($name, [scriptblock]$test) {
  try { if (& $test) { "PASS  $name" } else { "FAIL  $name" } } catch { "FAIL  $name ($($_.Exception.Message))" }
}
Check 'Internet via GW01'      { (Test-NetConnection 1.1.1.1 -Port 443 -WarningAction SilentlyContinue).TcpTestSucceeded }
Check 'Domain DNS'             { (Resolve-DnsName ad.scheldt.lab -Type A).IPAddress -contains '10.10.10.10' }
Check 'DC SRV record'          { Resolve-DnsName _ldap._tcp.dc._msdcs.ad.scheldt.lab -Type SRV }
Check 'Secure channel'         { Test-ComputerSecureChannel }
Check '60 users created'       { (Get-ADUser -Filter * -SearchBase "OU=Users,$root").Count -ge 60 }
Check 'LAPS password stored'   { Get-LapsADPassword -Identity CL01 }
Check 'LLMNR disabled'         { (Get-ItemProperty 'HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient' -Name EnableMulticast).EnableMulticast -eq 0 }
Check 'Password min length 14' { (Get-ADDefaultDomainPasswordPolicy).MinPasswordLength -ge 14 }
