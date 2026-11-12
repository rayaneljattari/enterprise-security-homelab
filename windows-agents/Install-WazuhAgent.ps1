# Run on DC01 and CL01 as admin. Easiest: copy the exact command from the Wazuh dashboard
# (Agents > Deploy new agent > Windows) and use that. This script does the same with a version you set.
param(
  [string]$Version = '4.x.x',          # set to the version shown in your dashboard, e.g. 4.14.0
  [string]$Manager = '10.10.10.30'
)
$msi = "$env:TEMP\wazuh-agent.msi"
Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-$Version-1.msi" -OutFile $msi
Start-Process msiexec.exe -Wait -ArgumentList "/i `"$msi`" /q WAZUH_MANAGER=$Manager WAZUH_AGENT_NAME=$env:COMPUTERNAME"
Start-Service WazuhSvc
Get-Service WazuhSvc
