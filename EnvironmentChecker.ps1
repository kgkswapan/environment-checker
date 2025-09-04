# Resolve script root (works both in console and script)
$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

# Build full path to CSV in same folder as script
$ServerListFilePath = [System.IO.Path]::GetFullPath('.\EnvCheckerList.csv', $ScriptRoot)

# Import server list
$ServerList = Import-Csv -Path $ServerListFilePath -Delimiter ','

# Prepare export container
$Export = [System.Collections.ArrayList]@()

foreach ($Server in $ServerList) {
    $ServerName  = $Server.ServerName
    $LastStatus  = $Server.LastStatus

    # Test connectivity (one ping attempt, quiet output)
    $Connection = Test-Connection -ComputerName $ServerName -Count 1 -Quiet

    if ($Connection) {
        # Server responded (Success)
        if ($LastStatus -ne "Success") {
            Write-Output "$ServerName is now online"
        }
        else {
            Write-Output "$ServerName is online"
        }
        $Server.LastStatus = "Success"
    }
    else {
        # Server did not respond (Failure)
        if ($LastStatus -eq "Success") {
            Write-Output "$ServerName is now offline"
        }
        else {
            Write-Output "$ServerName is still offline"
        }
        $Server.LastStatus = "Failure"
    }

    # Add to export list
    [void]$Export.Add($Server)
}

# Export updated server list back to CSV
$Export | Export-Csv -Path $ServerListFilePath -Delimiter ',' -NoTypeInformation
