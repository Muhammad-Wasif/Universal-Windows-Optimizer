<#
.SYNOPSIS
    Background Processes, CPU Scheduling, and Telemetry Optimization Module
.DESCRIPTION
    Reallocates CPU scheduling priorities to foreground applications and shuts
    down background telemetry collectors and heavy scheduled tasks.
#>

function Optimize-BackgroundProcesses {
    [CmdletBinding()]
    param()

    Write-Host "[Background] Prioritizing Foreground Tasks & Disabling Telemetry..." -ForegroundColor Cyan

    try {
        # 1. CPU Foreground Allocation: 90% core priority to active app
        $sysProfile = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        reg add $sysProfile /v "SystemResponsiveness" /t REG_DWORD /d 10 /f | Out-Null
        reg add $sysProfile /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f | Out-Null

        # 2. Disable GameDVR Background Video Recording
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f | Out-Null
        reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f | Out-Null

        # 3. Stop and Disable Telemetry Services
        $telemetryServices = @("DiagTrack", "dmwappushservice")
        foreach ($svc in $telemetryServices) {
            Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
            Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
        }

        # 4. Disable Heavy Diagnostic Scheduled Tasks
        $diagTasks = @(
            "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
            "\Microsoft\Windows\Application Experience\MareBackup",
            "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
            "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
            "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
            "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
        )
        foreach ($t in $diagTasks) {
            $taskName = $t.Split('\')[-1]
            $taskPath = $t.Substring(0, $t.LastIndexOf('\') + 1)
            Disable-ScheduledTask -TaskName $taskName -TaskPath $taskPath -ErrorAction SilentlyContinue | Out-Null
        }

        # 5. Disable Edge Pre-Launch and Startup Boost
        $edgeKey = "HKLM\SOFTWARE\Policies\Microsoft\Edge"
        reg add $edgeKey /v "StartupBoostEnabled" /t REG_DWORD /d 0 /f | Out-Null
        reg add $edgeKey /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f | Out-Null

        # Remove Edge user startup entry
        Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue |
            Get-Member -MemberType NoteProperty | Where-Object { $_.Name -like "MicrosoftEdgeAutoLaunch*" } | ForEach-Object {
                Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $_.Name -ErrorAction SilentlyContinue
            }

        # 6. Disable Windows Content Delivery Suggestions & Ads
        $cdmKey = "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        $cdmSettings = @(
            "SubscribedContent-338388Enabled",
            "SubscribedContent-338389Enabled",
            "SubscribedContent-353694Enabled",
            "SubscribedContent-353696Enabled",
            "SubscribedContent-353698Enabled",
            "SystemPaneSuggestionsEnabled",
            "SilentInstalledAppsEnabled",
            "SoftLandingEnabled",
            "RotatingLockScreenOverlayEnabled"
        )
        foreach ($setting in $cdmSettings) {
            reg add $cdmKey /v $setting /t REG_DWORD /d 0 /f | Out-Null
        }

        Write-Host " [+] CPU foreground prioritization enabled; background telemetry eliminated." -ForegroundColor Green
    } catch {
        Write-Host " [!] Error tuning background processes: $_" -ForegroundColor Red
    }
}

function Restore-BackgroundDefaults {
    [CmdletBinding()]
    param()

    Write-Host "[Background] Restoring Background Process Defaults..." -ForegroundColor Cyan

    try {
        $sysProfile = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        reg add $sysProfile /v "SystemResponsiveness" /t REG_DWORD /d 20 /f | Out-Null
        reg delete $sysProfile /v "NetworkThrottlingIndex" /f 2>$null | Out-Null

        # Restore Telemetry Services
        Set-Service -Name "DiagTrack" -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service -Name "DiagTrack" -ErrorAction SilentlyContinue

        # Re-enable Tasks
        $diagTasks = @(
            "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
            "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
        )
        foreach ($t in $diagTasks) {
            $taskName = $t.Split('\')[-1]
            $taskPath = $t.Substring(0, $t.LastIndexOf('\') + 1)
            Enable-ScheduledTask -TaskName $taskName -TaskPath $taskPath -ErrorAction SilentlyContinue | Out-Null
        }

        Write-Host " [+] Background defaults and scheduler responsiveness restored." -ForegroundColor Green
    } catch {
        Write-Host " [!] Error restoring background defaults: $_" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Optimize-BackgroundProcesses, Restore-BackgroundDefaults
