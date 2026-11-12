# Run on CL01 (as admin) to manage AD, GPO and DNS from the workstation.
Get-WindowsCapability -Online |
  Where-Object { $_.Name -like 'Rsat.ActiveDirectory*' -or $_.Name -like 'Rsat.GroupPolicy*' -or $_.Name -like 'Rsat.Dns*' } |
  Add-WindowsCapability -Online
