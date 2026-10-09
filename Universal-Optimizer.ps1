<#
.SYNOPSIS
    Universal Windows 10 & 11 Cleaner and Optimizer (x86 & x64)
.DESCRIPTION
    High-performance, battery-safe system optimizer and cleaner supporting:
    - Windows 10 and Windows 11
    - 32-bit (x86) and 64-bit (x64) architectures
    - Laptops (battery preservation) and Desktops
    - Fully reversible rollback scene
.PARAMETER All
    Applies all performance optimizations, debloats, disables updates, and cleans cache.
.PARAMETER CleanOnly
    Executes only the deep temporary file and cache cleaning.
.PARAMETER DebloatOnly
    Removes pre-installed bloatware and unlinks OneDrive.
.PARAMETER DisableUpdates
    Disables automatic Windows Updates, wake-up tasks, and Delivery Optimization.
.PARAMETER Restore
    Restores original Windows defaults.
#>

[CmdletBinding()]
param(
    [switch]$All,
    [switch]$CleanOnly,
    [switch]$DebloatOnly,
    [switch]$DisableUpdates,
    [switch]$Restore,
    [switch]$Silent
)

# 1. Administrator Elevation Check
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[!] Administrator privileges required. Requesting elevation..." -ForegroundColor Yellow
    $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    if ($All) { $argList += " -All" }
    if ($CleanOnly) { $argList += " -CleanOnly" }
    if ($DebloatOnly) { $argList += " -DebloatOnly" }
    if ($DisableUpdates) { $argList += " -DisableUpdates" }
    if ($Restore) { $argList += " -Restore" }
    if ($Silent) { $argList += " -Silent" }
    Start-Process powershell.exe -ArgumentList $argList -Verb RunAs
    Exit
}

# 2. Import Modules
$moduleRoot = Join-Path $PSScriptRoot "modules"
if (Test-Path "$moduleRoot\Detection.psm1") {
    Import-Module "$moduleRoot\Detection.psm1" -Force
    Import-Module "$moduleRoot\RestorePoint.psm1" -Force
    Import-Module "$moduleRoot\VisualLatency.psm1" -Force
    Import-Module "$moduleRoot\Debloat.psm1" -Force
    Import-Module "$moduleRoot\OneDrive.psm1" -Force
    Import-Module "$moduleRoot\WindowsUpdate.psm1" -Force
    Import-Module "$moduleRoot\BackgroundThreads.psm1" -Force
    Import-Module "$moduleRoot\BatteryPower.psm1" -Force
    Import-Module "$moduleRoot\SystemCleaner.psm1" -Force
}

# 3. Detect System Architecture & OS Version
$profile = if (Get-Command Get-SystemProfile -ErrorAction SilentlyContinue) {
    Get-SystemProfile
} else {
    [PSCustomObject]@{
        OSName       = if ([System.Environment]::OSVersion.Version.Build -ge 22000) { "Windows 11" } else { "Windows 10" }
        Build        = [System.Environment]::OSVersion.Version.Build
        Architecture = if ([System.Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
        FormFactor   = "Universal"
    }
}

function Show-Header {
    Clear-Host
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "     UNIVERSAL WINDOWS 10 & 11 CLEANER & OPTIMIZER (x86 & x64)         " -ForegroundColor Cyan
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host " OS: $($profile.OSName) (Build $($profile.Build)) | Arch: $($profile.Architecture) | Device: $($profile.FormFactor)" -ForegroundColor Yellow
    Write-Host " Mode: Battery-Preserving & Ultra-Low Latency" -ForegroundColor Green
    Write-Host "========================================================================`n" -ForegroundColor Cyan
}

function Run-FullOptimization {
    Show-Header
    Write-Host "[*] Executing Full System Optimization Pipeline...`n" -ForegroundColor White

    # Step 1: Safety & Restore Point
    if (Get-Command New-SystemRestoreBackup -ErrorAction SilentlyContinue) {
        New-SystemRestoreBackup
    }

    # Step 2: Visual Effects & UI Latency
    if (Get-Command Optimize-VisualPerformance -ErrorAction SilentlyContinue) {
        Optimize-VisualPerformance
    }

    # Step 3: Windows Updates & Delivery Optimization
    if (Get-Command Disable-WindowsUpdates -ErrorAction SilentlyContinue) {
        Disable-WindowsUpdates
    }

    # Step 4: Debloat & OneDrive
    if (Get-Command Invoke-UniversalDebloat -ErrorAction SilentlyContinue) {
        Invoke-UniversalDebloat -MachineWide
    }
    if (Get-Command Remove-UniversalOneDrive -ErrorAction SilentlyContinue) {
        Remove-UniversalOneDrive
    }

    # Step 5: Background Processes, CPU Threads & Telemetry
    if (Get-Command Optimize-BackgroundProcesses -ErrorAction SilentlyContinue) {
        Optimize-BackgroundProcesses
    }

    # Step 6: Power Plan Architecture (Battery Safe)
    if (Get-Command Optimize-PowerPlan -ErrorAction SilentlyContinue) {
        Optimize-PowerPlan
    }

    # Step 7: Deep Junk Cleaner
    if (Get-Command Invoke-DeepClean -ErrorAction SilentlyContinue) {
        Invoke-DeepClean
    }

    Write-Host "`n========================================================================" -ForegroundColor Cyan
    Write-Host " OPTIMIZATION PIPELINE FINISHED SUCCESSFULLY!                           " -ForegroundColor Green
    Write-Host " Your system is fully tuned, debloated, and protected against battery   " -ForegroundColor Green
    Write-Host " drain. Restart your computer to finalize all background changes.       " -ForegroundColor Green
    Write-Host "========================================================================" -ForegroundColor Cyan
}

# 4. Handle CLI Arguments or Show Interactive Menu
if ($All) {
    Run-FullOptimization
    if (-not $Silent) {
        Write-Host "`nPress any key to exit..."
        [void][System.Console]::ReadKey()
    }
    Exit
}

if ($CleanOnly) {
    Show-Header
    if (Get-Command Invoke-DeepClean -ErrorAction SilentlyContinue) { Invoke-DeepClean }
    if (-not $Silent) {
        Write-Host "`nPress any key to exit..."
        [void][System.Console]::ReadKey()
    }
    Exit
}

if ($DebloatOnly) {
    Show-Header
    if (Get-Command Invoke-UniversalDebloat -ErrorAction SilentlyContinue) { Invoke-UniversalDebloat -MachineWide }
    if (Get-Command Remove-UniversalOneDrive -ErrorAction SilentlyContinue) { Remove-UniversalOneDrive }
    if (-not $Silent) {
        Write-Host "`nPress any key to exit..."
        [void][System.Console]::ReadKey()
    }
    Exit
}

if ($DisableUpdates) {
    Show-Header
    if (Get-Command Disable-WindowsUpdates -ErrorAction SilentlyContinue) { Disable-WindowsUpdates }
    if (-not $Silent) {
        Write-Host "`nPress any key to exit..."
        [void][System.Console]::ReadKey()
    }
    Exit
}

if ($Restore) {
    Show-Header
    & "$PSScriptRoot\rollback\Restore-Defaults.ps1"
    Exit
}

# 5. Interactive Terminal Menu
do {
    Show-Header
    Write-Host " [1] Run Full Optimization (Recommended: All Tweaks + Debloat + Battery-Safe)" -ForegroundColor White
    Write-Host " [2] Deep System Junk Cleaner Only" -ForegroundColor White
    Write-Host " [3] Disable Windows Updates & Delivery Optimization Only" -ForegroundColor White
    Write-Host " [4] Remove Bloatware & OneDrive Only" -ForegroundColor White
    Write-Host " [5] Optimize UI Animations & Latency Only" -ForegroundColor White
    Write-Host " [6] Rollback / Restore Original Windows Defaults" -ForegroundColor Yellow
    Write-Host " [0] Exit`n" -ForegroundColor Gray

    $choice = Read-Host " Select an option [0-6]"
    switch ($choice) {
        "1" { Run-FullOptimization; break }
        "2" { Show-Header; Invoke-DeepClean; break }
        "3" { Show-Header; Disable-WindowsUpdates; break }
        "4" { Show-Header; Invoke-UniversalDebloat -MachineWide; Remove-UniversalOneDrive; break }
        "5" { Show-Header; Optimize-VisualPerformance; break }
        "6" { & "$PSScriptRoot\rollback\Restore-Defaults.ps1"; break }
        "0" { Exit }
        default { Write-Host "Invalid selection. Please choose 0-6." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
    Write-Host "`nPress any key to continue..."
    [void][System.Console]::ReadKey()
} while ($true)
