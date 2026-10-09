<#
.SYNOPSIS
    Universal Deep System Cleaner Module
.DESCRIPTION
    Safely purges temporary files, cache directories, crash dumps, and
    downloaded update residue to reclaim disk space and reduce fragmentation.
#>

function Invoke-DeepClean {
    [CmdletBinding()]
    param()

    Write-Host "[Cleaner] Purging System Junk and Cache Directories..." -ForegroundColor Cyan

    $cleanTargets = @(
        $env:TEMP,
        "C:\Windows\Temp",
        "C:\Windows\Prefetch",
        "C:\Windows\SoftwareDistribution\Download",
        "C:\ProgramData\Microsoft\Windows\WER\ReportQueue",
        "C:\ProgramData\Microsoft\Windows\WER\ReportArchive",
        "$env:LOCALAPPDATA\Microsoft\Windows\Explorer" # Thumbnails cache
    )

    $deletedCount = 0

    foreach ($target in $cleanTargets) {
        if (Test-Path $target) {
            Write-Host " [-] Cleaning: $target" -ForegroundColor Gray
            try {
                $files = Get-ChildItem -Path $target -Recurse -Force -ErrorAction SilentlyContinue |
                    Where-Object { -not $_.PSIsContainer }
                
                foreach ($f in $files) {
                    try {
                        Remove-Item -Path $f.FullName -Force -ErrorAction SilentlyContinue
                        $deletedCount++
                    } catch {
                        # Locked files in use are skipped safely
                    }
                }
            } catch {
                # Target in use
            }
        }
    }

    # Empty Recycle Bin
    try {
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue
        Write-Host " [-] Emptied Recycle Bin" -ForegroundColor Gray
    } catch {
        # Silent
    }

    Write-Host " [+] Deep cleaning complete. Purged $deletedCount temporary files." -ForegroundColor Green
}

Export-ModuleMember -Function Invoke-DeepClean
