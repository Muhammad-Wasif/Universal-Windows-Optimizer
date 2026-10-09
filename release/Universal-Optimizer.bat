@echo off
:: Universal Windows 10 & 11 Optimizer and Cleaner - Production Launcher
:: Architecture: x86 / x64 | Windows 10 & Windows 11
title Universal Windows Optimizer - Production Release

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ========================================================
    echo  Requesting Administrator Privileges...
    echo ========================================================
    if exist "%~dp0..\src\Universal-Optimizer.ps1" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0..\src\Universal-Optimizer.ps1"" %*' -Verb RunAs"
    ) else if exist "%~dp0Universal-Optimizer.ps1" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0Universal-Optimizer.ps1"" %*' -Verb RunAs"
    ) else (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0..\Universal-Optimizer.ps1"" %*' -Verb RunAs"
    )
    exit /b
)

if exist "%~dp0..\src\Universal-Optimizer.ps1" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\src\Universal-Optimizer.ps1" %*
) else if exist "%~dp0Universal-Optimizer.ps1" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Universal-Optimizer.ps1" %*
) else (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\Universal-Optimizer.ps1" %*
)
exit /b
