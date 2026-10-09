# Technical Architecture & Systems Engineering

This document outlines the architectural design, kernel-level scheduler interactions, and safety guarantees of the Universal Windows Optimizer.

---

## 1. Execution Model & Architecture Independence

The engine is engineered to run seamlessly across both 32-bit (x86) and 64-bit (x64) Windows environments without requiring architecture-specific builds.

```
                  ┌──────────────────────────────┐
                  │    Universal-Optimizer.bat   │
                  │ (Self-Elevating Bootstrapper)│
                  └──────────────┬───────────────┘
                                 │
                                 ▼
                  ┌──────────────────────────────┐
                  │   Universal-Optimizer.ps1    │
                  │   (Core Orchestration Engine)│
                  └──────────────┬───────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         ▼                       ▼                       ▼
┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  Detection.psm1  │    │  BatteryPower    │    │   Debloat.psm1   │
│  - OS Detection  │    │  - Speed Shift   │    │  - AppX Filter   │
│  - Arch (x86/x64)│    │  - C-State Floor │    │  - Protected List│
└──────────────────┘    └──────────────────┘    └──────────────────┘
```

### Dynamic Architecture Routing
- **Native Registry Isolation:** On 64-bit Windows, standard 32-bit processes are virtualized under `Wow6432Node`. On 32-bit installations, accessing `Wow6432Node` can cause driver conflicts or invalid key errors. The engine queries `[System.Environment]::Is64BitOperatingSystem` and conditionally routes shell hooks (`CLSID`) to native and WoW64 hives strictly when appropriate.
- **Dynamic Binary Discovery:** System binary paths are dynamically constructed rather than hardcoded, ensuring uninstaller hooks for components like OneDrive locate executables across `SysWOW64`, `System32`, and user profile directories without breaking.

---

## 2. Power Architecture & Frequency Scheduling

Standard Windows power tweaks frequently force minimum CPU throttle states to 100% (`PROCTHROTTLEMIN = 100`). While this minimizes governor ramp latency, it permanently disables deep hardware CPU C-states (C8/C10 package sleep), keeping core voltages high and causing battery drain.

### Our Strategy: Autonomous Dynamic Scheduling (EPP)
The suite uses **Intel Speed Shift** (Hardware-Controlled P-States / HWP) and **AMD CPPC**:
1. **Dynamic Frequency Floor:** Sets CPU floor to 5%. This permits the package to drop to 800 MHz and enter sleep modes drawing ~0.5W–1.2W when idle.
2. **Instant Turbo Ceiling:** Sets maximum state to 100%. When an application thread is scheduled, the hardware autonomous controller boosts frequency to peak turbo clock in under 1 millisecond.
3. **RTC Wake Prevention:** Disables background wake timers specifically on battery (`SUB_SLEEP RTCWAKE 0`), preventing modern standby drain during transit.

---

## 3. Multimedia Thread & CPU Scheduler Prioritization

Windows by default allocates a static reservation of CPU time to background services via the Multimedia Class Scheduler Service (MMCSS).

* **SystemResponsiveness Key:** Located at `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile`.
* **Default Setting:** `20` (reserves 20% CPU resources for background processes even under heavy foreground load).
* **Optimized Setting:** `10` (reallocates 90% priority to foreground interactive applications, dramatically lowering input latency and window draw times).
* **NetworkThrottlingIndex:** Configured to `0xFFFFFFFF` to eliminate network packet throughput throttling during concurrent compute tasks.

---

## 4. Reversibility & Rollback Guarantee

Every modification adheres to a strict 1:1 rollback invariant. Prior to state alteration:
1. A **Windows System Restore Point** (`Universal-Optimizer-PreRestore`) is triggered.
2. A machine state snapshot is captured to `config/backup-state.json`.
3. Running `Restore-Defaults.bat` or `Restore-Defaults.ps1` executes matching reversal routines across all subsystems.
