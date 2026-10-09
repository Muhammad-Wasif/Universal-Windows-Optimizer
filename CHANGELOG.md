# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-09

### Added
- **Universal Multi-Architecture Support**: Native dynamic execution on both x86 (32-bit) and x64 (64-bit) architectures without architecture path conflicts.
- **Dual OS Engine**: Unified optimization pipeline compatible with Windows 10 (1507 to 22H2) and Windows 11 (21H2 to 24H2+).
- **Battery-Preserving Performance Architecture**: Dynamic Intel Speed Shift and AMD CPPC energy performance scaling (5% floor / 100% burst ceiling).
- **Non-Destructive Safe Debloat Engine**: Automated removal of telemetry and promotional AppX packages while strictly preserving core utilities (Store, Calculator, Photos, Notepad, Paint, Windows Terminal).
- **OneDrive Neutralization & Unlinking**: Safe unpinning from Explorer namespace and policy disablement across 32-bit and 64-bit binaries.
- **Windows Update & Delivery Optimization Management**: Policy-driven update pausing, P2P telemetry cutoff, and wake timer prevention.
- **Foreground Process Prioritization**: 90% CPU priority allocated to foreground threads via Multimedia Scheduler tuning.
- **Deep Cache & Temporary File Purging**: Safe purging of `%TEMP%`, Windows Prefetch, and SoftwareDistribution caches.
- **100% Reversible Rollback Engine**: Full restoration script (`Restore-Defaults.bat` / `Restore-Defaults.ps1`) restoring all services, scheduler priority, and visual features.
- **Modular Architecture**: Split into isolated PowerShell modules (`modules/*.psm1`).
- **One-Click Production Launchers**: Auto-elevating batch scripts located in `release/`.
