# ⚡ Universal Windows Optimizer & Latency Suite

[![Release](https://img.shields.io/github/v/release/Muhammad-Wasif/Universal-Windows-Optimizer?color=blue&logo=github)](https://github.com/Muhammad-Wasif/Universal-Windows-Optimizer/releases)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen?logo=github-actions)](https://github.com/Muhammad-Wasif/Universal-Windows-Optimizer/actions)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%20Windows%2011-0078D6?logo=windows&logoColor=white)](https://microsoft.com)
[![Architecture](https://img.shields.io/badge/Arch-x86%20%7C%20x64-success)](docs/ARCHITECTURE.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PowerShell: 5.1+](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?logo=powershell&logoColor=white)](https://microsoft.com)

A production-grade, **battery-safe** systems optimizer, debloater, and latency tuning framework engineered for enterprise workstations, gaming systems, and mobile laptops running **Windows 10 and Windows 11** across **32-bit (x86) and 64-bit (x64)** architectures.

Includes a **100% reversible rollback engine** with automated system snapshots, ensuring complete disaster recovery and compliance with IT management standards.

---

## 🚀 Key Architectural Highlights

* **🔋 Battery-Safe Dynamic Power Tuning:** Unlike aggressive tweakers that lock CPU clock multipliers to 100% (causing high idle wattage and thermal throttling), this suite leverages **Autonomous Hardware P-States (Intel Speed Shift / AMD CPPC)**. Core frequencies scale from a 5% idle floor up to full turbo boost in <1ms, enabling deep C8/C10 low-power states (~0.5W–1.2W).
* **⚡ Foreground Thread Scheduler Optimization:** Tunes the Windows Multimedia Class Scheduler Service (MMCSS) to reserve **90% CPU priority for foreground applications** (`SystemResponsiveness = 10`), eliminating input latency, micro-stutters, and window redraw delays.
* **🛡️ Safe Non-Destructive Debloat:** Automatically strips telemetric and promotional UWP packages while strictly safeguarding essential system utilities (*Microsoft Store, Calculator, Photos, Notepad, Paint, Windows Terminal*).
* **🛑 Complete Windows Update & Telemetry Control:** Disables background update scans, Delivery Optimization P2P network saturation, and heavy diagnostic services like `Microsoft Compatibility Appraiser` and `DiagTrack`.
* **📁 Architecture-Agnostic Execution:** Dynamically handles native hives and `Wow6432Node` registries, guaranteeing stable execution across both 32-bit and 64-bit kernels.
* **🔄 Full Reversibility (Rollback Scene):** Every modification includes an exact 1:1 reversal routine to return any machine to vanilla Microsoft baseline settings.

---

## 📦 Production Releases & Launchers

Pre-packaged production launchers and standalone distributions are located in the [`release/`](release/) directory:

| Component | Path | Description |
| :--- | :--- | :--- |
| **Production Launcher** | [`release/Universal-Optimizer.bat`](release/Universal-Optimizer.bat) | One-click auto-elevating runner with interactive menu |
| **Production Rollback** | [`release/Restore-Defaults.bat`](release/Restore-Defaults.bat) | One-click disaster recovery restoring default Windows state |
| **Core Automation Engine** | [`src/Universal-Optimizer.ps1`](src/Universal-Optimizer.ps1) | Master orchestration script with CLI flags |
| **Restoration Engine** | [`src/Restore-Defaults.ps1`](src/Restore-Defaults.ps1) | Full state restoration script |

---

## 💻 Quick Start Guide

### 1. Interactive Production Launcher
1. Clone or download the repository:
   ```cmd
   git clone https://github.com/Muhammad-Wasif/Universal-Windows-Optimizer.git
   ```
2. Navigate to [`release/`](release/) and launch **`Universal-Optimizer.bat`** as Administrator.
3. Select your deployment option from the interactive terminal interface:
   ```text
   ========================================================================
        UNIVERSAL WINDOWS 10 & 11 CLEANER & OPTIMIZER (x86 & x64)
   ========================================================================
    OS: Windows 11 (Build 26300) | Arch: x64 | Device: Laptop
    Mode: Battery-Preserving & Ultra-Low Latency
   ========================================================================

    [1] Run Full Optimization (Recommended: All Tweaks + Debloat + Battery-Safe)
    [2] Deep System Junk Cleaner Only
    [3] Disable Windows Updates & Delivery Optimization Only
    [4] Remove Bloatware & OneDrive Only
    [5] Optimize UI Animations & Latency Only
    [6] Rollback / Restore Original Windows Defaults
    [0] Exit
   ```

---

## 🛠️ Enterprise & Silent Automation (CI/CD, Intune, SCCM)

For automated IT deployments, MDM policies, or unattended installation pipelines, run `Universal-Optimizer.ps1` with CLI switches:

```powershell
# Full Silent Optimization Deployment
.\src\Universal-Optimizer.ps1 -All -Silent

# Deep Junk & Temp Cache Purge Only
.\src\Universal-Optimizer.ps1 -CleanOnly -Silent

# Strip Pre-Installed Bloatware & OneDrive Only
.\src\Universal-Optimizer.ps1 -DebloatOnly -Silent

# Freeze Windows Update Background Services
.\src\Universal-Optimizer.ps1 -DisableUpdates -Silent

# Unattended Disaster Recovery / Rollback to Microsoft Defaults
.\src\Universal-Optimizer.ps1 -Restore -Silent
```

---

## 🔄 Disaster Recovery & Rollback

To revert all modifications and return system services, scheduler priorities, and update settings to factory defaults:
1. Run [`release/Restore-Defaults.bat`](release/Restore-Defaults.bat) (or run `.\src\Restore-Defaults.ps1` in elevated PowerShell).
2. The engine will restore services (`wuauserv`, `DoSvc`, `UsoSvc`, `DiagTrack`), re-enable UI animations and transparency, and reset power policies.
3. Restart the host machine.

---

## 📁 Repository Structure

```text
Universal-Windows-Optimizer/
│
├── .github/
│   └── workflows/
│       └── ci.yml                     # Continuous integration script validation
│
├── docs/
│   ├── ARCHITECTURE.md                # System scheduling & power state internals
│   └── BENCHMARKS.md                  # Latency & power efficiency benchmarks
│
├── src/                               # Core Source Code
│   ├── modules/                       # Production PowerShell modules
│   │   ├── Detection.psm1             # Hardware & kernel profile discovery
│   │   ├── RestorePoint.psm1          # Safety snapshots & state backups
│   │   ├── VisualLatency.psm1         # UI rendering & compositor latency
│   │   ├── Debloat.psm1               # AppX package debloat engine
│   │   ├── OneDrive.psm1              # Multi-architecture OneDrive removal
│   │   ├── WindowsUpdate.psm1         # Update & Delivery Optimization management
│   │   ├── BackgroundThreads.psm1     # Scheduler priority & telemetry control
│   │   ├── BatteryPower.psm1          # Autonomous frequency scaling (Speed Shift/CPPC)
│   │   └── SystemCleaner.psm1         # Deep cache, prefetch & junk cleaner
│   │
│   ├── Universal-Optimizer.ps1        # Master automation engine
│   └── Restore-Defaults.ps1           # Master rollback engine
│
├── release/                           # Distribution Binaries & Launchers
│   ├── Universal-Optimizer.bat        # Production launcher
│   └── Restore-Defaults.bat           # Production rollback launcher
│
├── config/
│   └── default-settings.json          # Enterprise policy configuration
│
├── CHANGELOG.md                       # Semantic version release notes
├── CONTRIBUTING.md                    # Developer guidelines
├── SECURITY.md                        # Security & vulnerability reporting
├── LICENSE                            # MIT License
└── README.md                          # Documentation
```

---

## 🛡️ Safety Invariants

* **Non-Destructive Debloat:** Critical runtime dependencies (DirectX, VC++ Runtimes, .NET Framework, Store framework) are strictly protected.
* **Pre-Execution Checkpoint:** Automatically triggers a Windows System Restore point before touching registry or system policies.
* **State Snapshotting:** Captures initial system parameters into `config/backup-state.json` for validation.

---

## 📄 License

This software is released under the [MIT License](LICENSE).
