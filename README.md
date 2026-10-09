# ⚡ Universal Windows 10 & 11 Optimizer and Cleaner

[![OS: Windows 10](https://img.shields.io/badge/OS-Windows%2010-0078D6?logo=windows&logoColor=white)](https://microsoft.com)
[![OS: Windows 11](https://img.shields.io/badge/OS-Windows%2011-0080FF?logo=windows11&logoColor=white)](https://microsoft.com)
[![Arch: x86 / x64](https://img.shields.io/badge/Arch-32--bit%20%7C%2064--bit-success)](https://github.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PowerShell: 5.1+](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?logo=powershell&logoColor=white)](https://github.com)

A high-performance, **battery-safe** system cleaner and optimizer engineered for **both Windows 10 and Windows 11** across **32-bit (x86) and 64-bit (x64)** architectures. Features a **complete, 100% reversible rollback scene** so you can restore default Windows settings anytime with a single click.

---

## 🌟 Key Features

### 🔋 1. Battery-Safe Performance Mode
Unlike standard "tweakers" that force static 100% CPU clock schemes (destroying laptop battery life and causing high fan noise), this optimizer uses **Dynamic Autonomous Frequency Scaling (Intel Speed Shift / AMD CPPC)**:
- **Idle / Lightweight Use:** CPU drops to 800 MHz and enters deep low-power sleep states (C8/C10, ~0.5W–1.2W).
- **Active Workloads:** Instantly boosts to maximum turbo frequency in under 1 millisecond.
- **Sleep Protection:** Disables background wake timers on battery power to prevent laptop drain inside bags.

### 🚀 2. Ultra-Low UI Latency
- Disables window minimize/maximize animations, taskbar animations, and smooth scrolling.
- Turns off GPU-taxing acrylic transparency, saving graphics pipeline wattage.
- Drops menu hover delay from 400ms to 10ms for instantaneous menu rendering.
- **Keeps ClearType Font Smoothing intact** so text always looks sharp and readable.

### 🛡️ 3. Safe Bloatware & OneDrive Removal
- Safely removes background UWP bloat (Clipchamp, Bing News/Weather, Solitaire, To-Do, Feedback Hub, Xbox overlays).
- **Guaranteed Essential App Protection:** Never removes Microsoft Store, Calculator, Photos, Notepad, Paint, or Windows Terminal.
- Uninstalls and neutralizes OneDrive (per-user and machine-wide) across 32-bit and 64-bit paths without broken Explorer shortcuts.

### 🛑 4. Windows Updates & Delivery Optimization Control
- Disables automatic background update downloads and forced restarts.
- Completely shuts down Delivery Optimization (`DoSvc`) peer-to-peer network bandwidth hogging.
- Disables background update wake-up tasks.

### ⚡ 5. Background Process & CPU Scheduling Optimization
- Reallocates core scheduler priority: gives **90% CPU priority to foreground applications** (`SystemResponsiveness = 10`).
- Disables background telemetry services (`DiagTrack`, `dmwappushservice`).
- Disables heavy background scanners like `Microsoft Compatibility Appraiser` and Customer Experience Improvement tasks.
- Removes Microsoft Edge Startup Boost and background auto-launch (`--win-session-start`).

### 🧹 6. Deep System Junk Cleaner
Purges temporary folders, Windows Prefetch residue, SoftwareDistribution update cache, Delivery Optimization cache, error reporting queues, and crash dumps.

### 🔄 7. 100% Reversible Rollback Scene
Includes a dedicated rollback tool ([Restore-Defaults.bat](rollback/Restore-Defaults.bat)) that:
- Restores original Windows Update services (`wuauserv`, `DoSvc`, `UsoSvc`).
- Re-enables UI animations, transparency, and default menu delays.
- Re-enables telemetry services and default system responsiveness.
- Automatically saves state snapshots to `config/backup-state.json`.

---

## 🖥️ Compatibility Matrix

| Operating System | 32-bit (x86) | 64-bit (x64) | Form Factor |
| :--- | :---: | :---: | :---: |
| **Windows 11 (21H2, 22H2, 23H2, 24H2+)** | N/A (64-bit only) | ✅ Supported | Laptops & Desktops |
| **Windows 10 (1507 through 22H2)** | ✅ Supported | ✅ Supported | Laptops & Desktops |

---

## 🚀 Quick Start

### Option A: One-Click Launcher (Recommended)
1. Download or clone this repository:
   ```bash
   git clone https://github.com/Muhammad-Wasif/Universal-Windows-Optimizer.git
   ```
2. Right-click **`Universal-Optimizer.bat`** and select **Run as administrator** (or double-click; it will self-elevate).
3. Choose your desired action from the interactive menu:
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

### Option B: PowerShell Command Line (Automation & Scripts)
Run in an elevated PowerShell terminal:

```powershell
# Full Optimization
.\Universal-Optimizer.ps1 -All

# Junk Cleaner Only
.\Universal-Optimizer.ps1 -CleanOnly

# Debloat & OneDrive Removal Only
.\Universal-Optimizer.ps1 -DebloatOnly

# Disable Windows Updates Only
.\Universal-Optimizer.ps1 -DisableUpdates

# Rollback to Windows Defaults
.\Universal-Optimizer.ps1 -Restore
```

---

## 🔄 How to Roll Back Changes

If you ever wish to return to standard Windows settings:
1. Double-click **`rollback\Restore-Defaults.bat`** (or run `.\rollback\Restore-Defaults.ps1`).
2. The script will restore all update services, re-enable animations, and reset system scheduling.
3. Restart your PC.

---

## 📁 Repository Structure

```text
universal-windows-optimizer/
│
├── Universal-Optimizer.bat       # One-click auto-elevating runner
├── Universal-Optimizer.ps1       # Master interactive & CLI PowerShell script
├── README.md                     # Documentation & usage guide
├── LICENSE                       # MIT License
├── .gitignore                    # Git exclusions
│
├── modules/                      # Modular architecture components
│   ├── Detection.psm1            # OS (10/11), Arch (x86/x64), and device profiling
│   ├── RestorePoint.psm1         # Safety restore point & JSON state snapshots
│   ├── VisualLatency.psm1        # Animations, transparency, and menu delay
│   ├── Debloat.psm1              # Safe AppX debloater with essential app protections
│   ├── OneDrive.psm1             # Universal OneDrive uninstaller (32/64-bit paths)
│   ├── WindowsUpdate.psm1        # Update & Delivery Optimization management
│   ├── BackgroundThreads.psm1    # Foreground CPU priority & telemetry shutdown
│   ├── BatteryPower.psm1         # Dynamic Speed Shift battery preservation
│   └── SystemCleaner.psm1        # Deep junk, prefetch, and cache cleaner
│
├── rollback/
│   ├── Restore-Defaults.bat      # One-click rollback runner
│   └── Restore-Defaults.ps1      # Comprehensive restoration script
│
└── config/
    └── default-settings.json     # Configuration file and exclusions
```

---

## 🔒 Safety & System Integrity

* **System Restore Backup:** Registers a Windows System Restore point before touching system settings.
* **Non-Destructive Debloat:** Crucial dependencies (DirectX, VC++ Runtimes, Store, Calculator) are strictly safeguarded.
* **No Hardcoded Architecture Paths:** Dynamically resolves native vs `SysWOW64` and `Wow6432Node` paths to guarantee error-free execution on both 32-bit and 64-bit systems.

---

## 👤 Author

Developed by **Muhammad Wasif**  
- Email: [wasifalibhatti12517@gmail.com](mailto:wasifalibhatti12517@gmail.com)  
- GitHub: [@Muhammad-Wasif](https://github.com/Muhammad-Wasif)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
