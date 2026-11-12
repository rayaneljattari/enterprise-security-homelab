# Run as a domain admin (DC01 or CL01 with RSAT).
Import-Module ActiveDirectory
$domainDN = (Get-ADDomain).DistinguishedName
$root = "OU=Scheldt,$domainDN"

New-ADOrganizationalUnit -Name 'Scheldt' -Path $domainDN
$ous = @(
  @{ Name = 'Admin';           Path = $root },
  @{ Name = 'Tier0';           Path = "OU=Admin,$root" },
  @{ Name = 'Tier1';           Path = "OU=Admin,$root" },
  @{ Name = 'Tier2';           Path = "OU=Admin,$root" },
  @{ Name = 'Users';           Path = $root },
  @{ Name = 'Computers';       Path = $root },
  @{ Name = 'Workstations';    Path = "OU=Computers,$root" },
  @{ Name = 'Servers';         Path = "OU=Computers,$root" },
  @{ Name = 'Groups';          Path = $root },
  @{ Name = 'ServiceAccounts'; Path = $root },
  @{ Name = 'Disabled';        Path = $root }
)
foreach ($ou in $ous) { New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path }

foreach ($dept in 'Finance', 'Operations', 'Sales', 'IT') {
  New-ADOrganizationalUnit -Name $dept -Path "OU=Users,$root"
  New-ADGroup -Name "GG_$dept" -GroupScope Global -GroupCategory Security -Path "OU=Groups,$root"
}

# New computers land in Workstations instead of the default Computers container
redircmp "OU=Workstations,OU=Computers,$root"
Get-ADComputer CL01 -ErrorAction SilentlyContinue | Move-ADObject -TargetPath "OU=Workstations,OU=Computers,$root"
