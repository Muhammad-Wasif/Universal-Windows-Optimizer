<#
.SYNOPSIS
    Universal OneDrive Removal and Restoration Module (x86 & x64)
.DESCRIPTION
    Safely uninstalls and disables OneDrive across 32-bit and 64-bit systems.
#>

function Remove-UniversalOneDrive {
    [CmdletBinding()]
    param()

    Write-Host "[OneDrive] Removing and Neutralizing OneDrive..." -ForegroundColor Cyan

    $is64Bit = [System.Environment]::Is64BitOperatingSystem

    # 1. Kill active OneDrive processes
    Stop-Process -Name "OneDrive", "OneDriveSetup", "FileCoAuth" -Force -ErrorAction SilentlyContinue

    # 2. Block OneDrive via Group Policy
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f | Out-Null

    # 3. Remove from Startup (HKCU and HKLM)
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "OneDrive" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "OneDrive" -ErrorAction SilentlyContinue

    # 4. Hide from File Explorer Navigation Pane (Safe x86 & x64)
    reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f | Out-Null
    reg add "HKLM\SOFTWARE\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f 2>$null | Out-Null

    if ($is64Bit) {
        reg add "HKCU\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f 2>$null | Out-Null
        reg add "HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f 2>$null | Out-Null
    }

    # 5. Locate and execute uninstaller across 32-bit and 64-bit candidate paths
    $candidatePaths = @(
        "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDriveSetup.exe",
        "$env:SystemRoot\System32\OneDriveSetup.exe"
    )

    if ($is64Bit) {
        $candidatePaths += "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
    }

    # Also check versioned folder in LocalAppData
    $versioned = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Filter "OneDriveSetup.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($versioned) {
        $candidatePaths += $versioned.FullName
    }

    $setupExe = $candidatePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($setupExe) {
        Write-Host " [-] Executing silent OneDrive uninstaller from: $setupExe" -ForegroundColor Gray
        Start-Process -FilePath $setupExe -ArgumentList "/uninstall" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }

    Write-Host " [+] OneDrive removed and blocked from restarting." -ForegroundColor Green
}

function Restore-UniversalOneDrive {
    [CmdletBinding()]
    param()

    Write-Host "[OneDrive] Restoring OneDrive System Integration..." -ForegroundColor Cyan
    $is64Bit = [System.Environment]::Is64BitOperatingSystem

    # Remove Group Policy Block
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /f 2>$null | Out-Null

    # Re-enable Explorer sidebar pin
    reg add "HKCU\Software\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 1 /f | Out-Null
    if ($is64Bit) {
        reg add "HKCU\Software\Classes\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 1 /f 2>$null | Out-Null
    }

    Write-Host " [+] OneDrive policy and Explorer pin restored." -ForegroundColor Green
}

Export-ModuleMember -Function Remove-UniversalOneDrive, Restore-UniversalOneDrive
