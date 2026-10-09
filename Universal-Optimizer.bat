@echo off
:: Universal Windows 10 & 11 Optimizer and Cleaner Launcher
:: Auto-elevates to Administrator and launches the PowerShell interface
title Universal Windows Optimizer

:: Check for Administrative Rights
net session >nul 2>&1
if %errorlevel% == 0 (
    goto :run_optimizer
) else (
    goto :elevate
)

:elevate
echo ========================================================
echo  Requesting Administrator Privileges...
echo ========================================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0Universal-Optimizer.ps1"" %*' -Verb RunAs"
exit /b

:run_optimizer
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Universal-Optimizer.ps1" %*
exit /b
