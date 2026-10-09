<#
.SYNOPSIS
    Universal Rollback & Restoration Script for Windows 10 and 11
.DESCRIPTION
    Safely rolls back all optimization tweaks to original Windows defaults:
    - Re-enables Windows Updates & Delivery Optimization
    - Re-enables UI animations & Transparency
    - Restores background services & telemetry
    - Restores default power scheme & system responsiveness
#>

# Ensure Administrator Elevation
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[!] Administrative privileges required. Requesting elevation..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"") -Verb RunAs
    Exit
}

$modulePath = "$PSScriptRoot\..\modules"
if (Test-Path "$modulePath\VisualLatency.psm1") {
    Import-Module "$modulePath\VisualLatency.psm1" -Force
    Import-Module "$modulePath\WindowsUpdate.psm1" -Force
    Import-Module "$modulePath\OneDrive.psm1" -Force
    Import-Module "$modulePath\BackgroundThreads.psm1" -Force
    Import-Module "$modulePath\BatteryPower.psm1" -Force
}

Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " UNIVERSAL WINDOWS OPTIMIZER - RESTORE DEFAULTS           " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

Write-Host "`n[1/5] Re-enabling Windows Updates & Delivery Optimization..." -ForegroundColor Yellow
if (Get-Command Enable-WindowsUpdates -ErrorAction SilentlyContinue) {
    Enable-WindowsUpdates
} else {
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /f 2>$null | Out-Null
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /f 2>$null | Out-Null
    Set-Service -Name "wuauserv" -StartupType Manual -ErrorAction SilentlyContinue
    Set-Service -Name "DoSvc" -StartupType Automatic -ErrorAction SilentlyContinue
    Set-Service -Name "UsoSvc" -StartupType Manual -ErrorAction SilentlyContinue
    Start-Service -Name "wuauserv" -ErrorAction SilentlyContinue
}

Write-Host "`n[2/5] Restoring Visual Animations & Transparency..." -ForegroundColor Yellow
if (Get-Command Restore-VisualDefaults -ErrorAction SilentlyContinue) {
    Restore-VisualDefaults
} else {
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f | Out-Null
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "1" /f | Out-Null
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 1 /f | Out-Null
}

Write-Host "`n[3/5] Restoring Background Process Defaults & Telemetry..." -ForegroundColor Yellow
if (Get-Command Restore-BackgroundDefaults -ErrorAction SilentlyContinue) {
    Restore-BackgroundDefaults
} else {
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f | Out-Null
    Set-Service -Name "DiagTrack" -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
}

Write-Host "`n[4/5] Restoring OneDrive System Integration..." -ForegroundColor Yellow
if (Get-Command Restore-UniversalOneDrive -ErrorAction SilentlyContinue) {
    Restore-UniversalOneDrive
} else {
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /f 2>$null | Out-Null
}

Write-Host "`n[5/5] Restoring Power Scheme Defaults..." -ForegroundColor Yellow
if (Get-Command Restore-PowerPlanDefaults -ErrorAction SilentlyContinue) {
    Restore-PowerPlanDefaults
} else {
    powercfg /restoredefaultschemes
}

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " RESTORATION COMPLETE! Default Windows settings restored. " -ForegroundColor Green
Write-Host " Restart your computer for all services to refresh.       " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "`nPress any key to exit..."
[void][System.Console]::ReadKey()
