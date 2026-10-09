<#
.SYNOPSIS
    Visual Effects and UI Latency Optimization Module
.DESCRIPTION
    Tuned for Windows 10 & 11 (32-bit & 64-bit):
    - Disables window animations and taskbar animations
    - Disables transparency (acrylic effects) to save GPU rendering cycles
    - Keeps Font Smoothing (ClearType) ON for readability
    - Reduces MenuShowDelay to 10ms
#>

function Optimize-VisualPerformance {
    [CmdletBinding()]
    param()

    Write-Host "[Visual] Optimizing Visual Effects & Latency..." -ForegroundColor Cyan

    try {
        # 1. Turn off Transparency
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f | Out-Null
        
        # 2. Turn off Window Minimize / Maximize Animations
        reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f | Out-Null

        # 3. Turn off Taskbar & Shell Animations
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "IconsOnly" /t REG_DWORD /d 0 /f | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 0 /f | Out-Null

        # 4. Set VisualFXSetting to Best Performance (2)
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f | Out-Null

        # 5. Keep smooth edges for screen fonts (ClearType)
        reg add "HKCU\Control Panel\Desktop" /v "FontSmoothing" /t REG_SZ /d "2" /f | Out-Null

        # 6. Reduce Menu Delay
        reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "10" /f | Out-Null

        Write-Host " [+] Visual effects and animations set to ultra-responsive mode." -ForegroundColor Green
    } catch {
        Write-Host " [!] Error configuring visual effects: $_" -ForegroundColor Red
    }
}

function Restore-VisualDefaults {
    [CmdletBinding()]
    param()

    Write-Host "[Visual] Restoring Default Visual Effects & Animations..." -ForegroundColor Cyan
    try {
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 1 /f | Out-Null
        reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "1" /f | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 1 /f | Out-Null
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 0 /f | Out-Null
        reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "400" /f | Out-Null
        Write-Host " [+] Default visual effects restored." -ForegroundColor Green
    } catch {
        Write-Host " [!] Error restoring visual effects: $_" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Optimize-VisualPerformance, Restore-VisualDefaults
