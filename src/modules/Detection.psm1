<#
.SYNOPSIS
    System Detection Module for Universal Windows Optimizer
.DESCRIPTION
    Dynamically identifies Windows version (10 vs 11), architecture (x86 vs x64),
    build number, and hardware type (laptop vs desktop).
#>

function Get-SystemProfile {
    [CmdletBinding()]
    param()

    $build = [System.Environment]::OSVersion.Version.Build
    $isWin11 = $build -ge 22000
    $osName = if ($isWin11) { "Windows 11" } else { "Windows 10" }
    $is64Bit = [System.Environment]::Is64BitOperatingSystem
    $arch = if ($is64Bit) { "x64" } else { "x86" }

    # Detect form factor (Laptop vs Desktop)
    $hasBattery = $false
    try {
        $battery = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
        if ($battery) { $hasBattery = $true }
    } catch {
        $hasBattery = $false
    }

    $chassisType = "Desktop"
    try {
        $chassis = Get-CimInstance Win32_SystemEnclosure -ErrorAction SilentlyContinue
        if ($chassis.ChassisTypes) {
            # 8, 9, 10, 11, 12, 14, 30, 31, 32 are laptop/portable form factors
            $portableTypes = @(8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32)
            foreach ($t in $chassis.ChassisTypes) {
                if ($portableTypes -contains [int]$t) {
                    $chassisType = "Laptop"
                    break
                }
            }
        }
    } catch {
        if ($hasBattery) { $chassisType = "Laptop" }
    }

    if ($hasBattery) { $chassisType = "Laptop" }

    return [PSCustomObject]@{
        OSName       = $osName
        Build        = $build
        IsWindows11  = $isWin11
        IsWindows10  = (-not $isWin11)
        Is64Bit      = $is64Bit
        Architecture = $arch
        FormFactor   = $chassisType
        HasBattery   = $hasBattery
    }
}

Export-ModuleMember -Function Get-SystemProfile
