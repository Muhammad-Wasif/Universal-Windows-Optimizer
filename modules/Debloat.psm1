<#
.SYNOPSIS
    Universal Debloat Module for Windows 10 and Windows 11
.DESCRIPTION
    Safely removes bloatware apps while strictly protecting essential tools
    like Microsoft Store, Calculator, Photos, Paint, and Terminal.
#>

$BloatwareCatalog = @(
    # General Telemetry & Bloat
    "Microsoft.BingNews",
    "Microsoft.BingWeather",
    "Microsoft.BingSearch",
    "Microsoft.BingFinance",
    "Microsoft.BingSports",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.Todos",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.YourPhone",
    "Microsoft.People",
    "Microsoft.MicrosoftOfficeHub",
    "Clipchamp.Clipchamp",

    # Windows 10 Specific 3D/VR Bloat
    "Microsoft.Microsoft3DViewer",
    "Microsoft.Print3D",
    "Microsoft.MixedReality.Portal",
    "Microsoft.SkypeApp",

    # Xbox Background Services (Overlay, Speech, UI)
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxGameCallableUI",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.Xbox.TCUI"
)

# Critical system apps that must NEVER be removed
$ProtectedCatalog = @(
    "Microsoft.WindowsStore",
    "Microsoft.WindowsCalculator",
    "Microsoft.Windows.Photos",
    "Microsoft.WindowsNotepad",
    "Microsoft.Paint",
    "Microsoft.WindowsTerminal",
    "Microsoft.ScreenSketch",
    "Microsoft.DesktopAppInstaller"
)

function Invoke-UniversalDebloat {
    [CmdletBinding()]
    param(
        [switch]$MachineWide
    )

    Write-Host "[Debloat] Removing Pre-Installed Bloatware Packages..." -ForegroundColor Cyan

    # 1. Machine-Wide De-provisioning (if elevated and requested)
    if ($MachineWide) {
        try {
            $provisioned = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
            if ($provisioned) {
                foreach ($pkg in $provisioned) {
                    $name = $pkg.DisplayName
                    # Verify not in protected list
                    $isProtected = $ProtectedCatalog | Where-Object { $name -match [regex]::Escape($_) }
                    if (-not $isProtected) {
                        $isBloat = $BloatwareCatalog | Where-Object { $name -match [regex]::Escape($_) }
                        if ($isBloat) {
                            Write-Host " [-] De-provisioning: $name" -ForegroundColor Gray
                            Remove-AppxProvisionedPackage -Online -PackageName $pkg.PackageName -ErrorAction SilentlyContinue | Out-Null
                        }
                    }
                }
            }
        } catch {
            Write-Host " [i] Note: De-provisioning requires administrator privileges." -ForegroundColor Gray
        }
    }

    # 2. Current User AppX Removal
    foreach ($pattern in $BloatwareCatalog) {
        # Double-check protection guard
        $isProtected = $ProtectedCatalog | Where-Object { $pattern -match [regex]::Escape($_) }
        if ($isProtected) { continue }

        $packages = Get-AppxPackage -Name "*$pattern*" -AllUsers -ErrorAction SilentlyContinue
        if (-not $packages) {
            $packages = Get-AppxPackage -Name "*$pattern*" -ErrorAction SilentlyContinue
        }

        foreach ($p in $packages) {
            Write-Host " [-] Uninstalling: $($p.Name)" -ForegroundColor Gray
            Remove-AppxPackage -Package $p.PackageFullName -ErrorAction SilentlyContinue | Out-Null
        }
    }

    Write-Host " [+] Universal debloat completed safely. Essential system utilities preserved." -ForegroundColor Green
}

Export-ModuleMember -Function Invoke-UniversalDebloat
