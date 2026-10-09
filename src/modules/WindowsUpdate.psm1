<#
.SYNOPSIS
    Universal Windows Update Management Module
.DESCRIPTION
    Provides complete control over Windows 10 & 11 automatic updates,
    Delivery Optimization P2P bandwidth hogging, and background wake scans.
#>

function Disable-WindowsUpdates {
    [CmdletBinding()]
    param()

    Write-Host "[Updates] Disabling Automatic Windows Updates & Delivery Optimization..." -ForegroundColor Cyan

    try {
        # 1. Group Policy: Set NoAutoUpdate and AUOptions to 2 (Notify only)
        $wuKey = "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
        reg add $wuKey /v "NoAutoUpdate" /t REG_DWORD /d 1 /f | Out-Null
        reg add $wuKey /v "AUOptions" /t REG_DWORD /d 2 /f | Out-Null
        reg add $wuKey /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d 1 /f | Out-Null

        # 2. Stop and Disable Services
        $services = @("wuauserv", "DoSvc", "UsoSvc")
        foreach ($svc in $services) {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        }

        # 3. Disable Update Orchestrator and Scan Scheduled Tasks
        $tasks = @(
            "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan",
            "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static",
            "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker",
            "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
        )
        foreach ($t in $tasks) {
            $taskName = $t.Split('\')[-1]
            $taskPath = $t.Substring(0, $t.LastIndexOf('\') + 1)
            Disable-ScheduledTask -TaskName $taskName -TaskPath $taskPath -ErrorAction SilentlyContinue | Out-Null
        }

        Write-Host " [+] Windows Update background services and forced scans disabled." -ForegroundColor Green
    } catch {
        Write-Host " [!] Error disabling updates: $_" -ForegroundColor Red
    }
}

function Enable-WindowsUpdates {
    [CmdletBinding()]
    param()

    Write-Host "[Updates] Re-enabling Windows Update & Delivery Optimization Services..." -ForegroundColor Cyan

    try {
        # 1. Remove Policies
        reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /f 2>$null | Out-Null
        reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /f 2>$null | Out-Null
        reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /f 2>$null | Out-Null

        # 2. Restore Services
        Set-Service -Name "wuauserv" -StartupType Manual -ErrorAction SilentlyContinue
        Set-Service -Name "DoSvc" -StartupType Automatic -ErrorAction SilentlyContinue
        Set-Service -Name "UsoSvc" -StartupType Manual -ErrorAction SilentlyContinue
        Start-Service -Name "wuauserv" -ErrorAction SilentlyContinue

        # 3. Re-enable Tasks
        $tasks = @(
            "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan",
            "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static",
            "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker",
            "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
        )
        foreach ($t in $tasks) {
            $taskName = $t.Split('\')[-1]
            $taskPath = $t.Substring(0, $task.LastIndexOf('\') + 1)
            Enable-ScheduledTask -TaskName $taskName -TaskPath $taskPath -ErrorAction SilentlyContinue | Out-Null
        }

        Write-Host " [+] Windows Update restored to default operation." -ForegroundColor Green
    } catch {
        Write-Host " [!] Error restoring updates: $_" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Disable-WindowsUpdates, Enable-WindowsUpdates
