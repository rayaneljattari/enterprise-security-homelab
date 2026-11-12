# Wazuh agents for Windows

Install on DC01 and CL01, as administrator. The easiest route is the command the Wazuh dashboard
generates (Agents, Deploy new agent, Windows). [Install-WazuhAgent.ps1](Install-WazuhAgent.ps1) does the
same with a version number you pass in:

```powershell
.\Install-WazuhAgent.ps1 -Version 4.x.y -Manager 10.10.10.30
```

Not yet verified on Windows ARM64. If the agent does not run there, that goes in the test plan as a finding.
