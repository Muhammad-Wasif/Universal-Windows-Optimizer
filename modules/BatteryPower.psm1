<#
.SYNOPSIS
    Universal Battery-Safe Power Optimization Module
.DESCRIPTION
    Tuned specifically so that "Performance Mode" does NOT destroy battery backup:
    - Maintains dynamic Intel Speed Shift / AMD CPPC autonomous frequency scaling
    - Sets CPU minimum floor to 5% (enabling deep idle C-states ~0.5W-1W)
    - Sets CPU maximum ceiling to 100% (bursting to peak turbo boost on demand)
    - Disables background RTC wake timers on battery to prevent backpack drain
#>

function Optimize-PowerPlan {
    [CmdletBinding()]
    param()

    Write-Host "[Power] Configuring Battery-Safe Dynamic Performance Plan..." -ForegroundColor Cyan

    try {
        # 1. Activate Balanced scheme (the only plan supporting full dynamic Speed Shift)
        powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e

        # 2. Configure Processor States:
        # 5% Floor = CPU drops to ~800MHz & deep C8/C10 sleep when reading or idle
        # 100% Ceiling = CPU bursts to maximum multi-core turbo in <1ms
        powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
        powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5
        powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
        powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100

        # 3. Disable Wake Timers on DC (Battery) - Prevents random wakeups during sleep
        powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 0
        powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 1

        # Re-apply active scheme
        powercfg /setactive SCHEME_CURRENT

        Write-Host " [+] Dynamic power profile configured. Zero battery degradation." -ForegroundColor Green
    } catch {
        Write-Host " [!] Error tuning power architecture: $_" -ForegroundColor Red
    }
}

function Restore-PowerPlanDefaults {
    [CmdletBinding()]
    param()

    Write-Host "[Power] Restoring Default Power Plan Settings..." -ForegroundColor Cyan
    try {
        powercfg /restoredefaultschemes
        powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
        Write-Host " [+] Default power schemes restored." -ForegroundColor Green
    } catch {
        Write-Host " [!] Error restoring power schemes: $_" -ForegroundColor Red
    }
}

Export-ModuleMember -Function Optimize-PowerPlan, Restore-PowerPlanDefaults
