@echo off
:: Universal Windows Optimizer - Production Rollback Launcher
title Universal Windows Optimizer - Rollback Engine

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ========================================================
    echo  Requesting Administrator Privileges for Rollback...
    echo ========================================================
    if exist "%~dp0..\src\Restore-Defaults.ps1" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0..\src\Restore-Defaults.ps1"" %*' -Verb RunAs"
    ) else if exist "%~dp0Restore-Defaults.ps1" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0Restore-Defaults.ps1"" %*' -Verb RunAs"
    ) else (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0..\Restore-Defaults.ps1"" %*' -Verb RunAs"
    )
    exit /b
)

if exist "%~dp0..\src\Restore-Defaults.ps1" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\src\Restore-Defaults.ps1" %*
) else if exist "%~dp0Restore-Defaults.ps1" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-Defaults.ps1" %*
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\Restore-Defaults.ps1" %*
)
exit /b
