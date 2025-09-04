# EnvironmentChecker

A simple PowerShell script that checks if servers are online or offline.  
Reads server list from a CSV file, pings them, and updates their status back in the same CSV.

## How it works
- Import server list from `EnvCheckerList.csv`
- Ping each server
- Update `LastStatus` field in the CSV
- Print changes (e.g., "Server1 is now online")

## Run
```powershell
# Run the script from PowerShell
.\EnvironmentChecker.ps1
```
## Example CSV Format

ServerName,LastStatus
Server1,Success
Server2,Failure

