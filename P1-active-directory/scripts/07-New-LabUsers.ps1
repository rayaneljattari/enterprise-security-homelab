# Creates lab users with random initial passwords. Lab only: delete the CSV after testing, never commit it.
param(
  [int]$Count = 60,
  [string]$OutFile = "$env:USERPROFILE\Desktop\lab-users.csv"
)
Import-Module ActiveDirectory
$domain = Get-ADDomain
$root   = "OU=Scheldt,$($domain.DistinguishedName)"
$first  = 'Lotte','Jens','Emma','Lars','Noor','Wout','Fien','Arne','Lien','Bram','Saar','Thijs'
$last   = 'Peeters','Janssens','Maes','Jacobs','Willems','Claes','Goossens','Wouters','DeSmet','Mertens'
$depts  = 'Finance','Operations','Sales','IT'
$chars  = [char[]]'abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
$created = foreach ($i in 1..$Count) {
  $fn = Get-Random $first; $ln = Get-Random $last; $dept = Get-Random $depts
  $sam = ('{0}.{1}{2:d2}' -f $fn, $ln, $i).ToLower()
  if ($sam.Length -gt 20) { $sam = $sam.Substring(0, 20) }
  $plain = (-join (1..16 | ForEach-Object { Get-Random $chars })) + '#7'
  New-ADUser -Name $sam -SamAccountName $sam -GivenName $fn -Surname $ln `
    -DisplayName "$fn $ln" -Department $dept `
    -UserPrincipalName "$sam@$($domain.DNSRoot)" `
    -Path "OU=$dept,OU=Users,$root" `
    -AccountPassword (ConvertTo-SecureString $plain -AsPlainText -Force) `
    -ChangePasswordAtLogon $true -Enabled $true
  Add-ADGroupMember -Identity "GG_$dept" -Members $sam
  [pscustomobject]@{ User = $sam; Department = $dept; InitialPassword = $plain }
}
$created | Export-Csv $OutFile -NoTypeInformation
Write-Host "Created $($created.Count) users. Lab only: delete $OutFile after testing."
