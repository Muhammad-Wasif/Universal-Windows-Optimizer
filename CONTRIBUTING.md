# Contributing to Universal Windows Optimizer

Thank you for your interest in contributing to the Universal Windows Optimizer project. We welcome contributions that improve system stability, reduce latency, or enhance portability across Windows versions.

## Development Principles

1. **Safety First**: Optimizations must never break essential Windows infrastructure (Windows Store, Calculator, accessibility features, or system drivers).
2. **Reversibility**: Every optimization must have an exact 1:1 corresponding rollback routine implemented in `modules/*` and `Restore-Defaults.ps1`.
3. **Architecture Portability**: Code must execute flawlessly on both 32-bit (x86) and 64-bit (x64) environments. Never assume `Wow6432Node` or 64-bit file system redirects exist without checking architecture flags.
4. **Battery Preservation**: Do not force static 100% CPU clock schemes. Respect autonomous frequency scaling (Intel Speed Shift / AMD CPPC).

## Pull Request Guidelines

1. Fork the repository and create your branch from `main`.
2. Follow standard PowerShell coding conventions (PascalCase cmdlet names, explicit parameter binding).
3. Test changes on a clean virtual machine or sandbox environment across both Windows 10 and Windows 11.
4. Ensure the rollback routine (`Restore-Defaults.ps1`) cleanly reverts any added modifications.
5. Submit a pull request with clear description and benchmark / test verification notes.
