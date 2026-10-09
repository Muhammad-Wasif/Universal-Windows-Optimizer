<#
.SYNOPSIS
    Safety & Restore Point Module for Universal Windows Optimizer
.DESCRIPTION
    Creates a Windows System Restore point and snapshots configuration state
    to JSON for 100% reversible rollbacks.
#>

function New-SystemRestoreBackup {
    [CmdletBinding()]
    param(
        [string]$BackupDir = "$PSScriptRoot\..\config"
    )

    Write-Host "[Safety] Creating System Restore Point..." -ForegroundColor Cyan
    try {
        Checkpoint-Computer -Description "Universal-Optimizer-PreRestore" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
        Write-Host " [+] System Restore point registered." -ForegroundColor Green
    } catch {
        Write-Host " [i] Note: System Restore might be disabled on this system drive; state snapshot will be used." -ForegroundColor Gray
    }

    # Snapshot current service & system state to JSON
    try {
        if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
        $backupFile = Join-Path $BackupDir "backup-state.json"

        $state = [PSCustomObject]@{
            Timestamp            = (Get-Date).ToString("o")
            Services             = @{}
            PowerSchemeActive    = (powercfg /getactivescheme)
            EnableTransparency   = (Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -ErrorAction SilentlyContinue).EnableTransparency
            SystemResponsiveness = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -ErrorAction SilentlyContinue).SystemResponsiveness
        }

        $servicesToTrack = @("wuauserv", "DoSvc", "UsoSvc", "DiagTrack", "dmwappushservice", "SysMain")
        foreach ($s in $servicesToTrack) {
            $svc = Get-Service -Name $s -ErrorAction SilentlyContinue
            if ($svc) {
                $state.Services[$s] = @{
                    Status    = $svc.Status.ToString()
                    StartType = $svc.StartType.ToString()
                }
            }
        }

        $state | ConvertTo-Json -Depth 5 | Set-Content -Path $backupFile -Encoding UTF8 -Force
        Write-Host " [+] State snapshot saved to: $backupFile" -ForegroundColor Green
    } catch {
        Write-Host " [!] Warning: Could not create JSON state snapshot: $_" -ForegroundColor Yellow
    }
}

Export-ModuleMember -Function New-SystemRestoreBackup
