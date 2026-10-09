@echo off
:: Universal Windows Optimizer - Restore Defaults Launcher
echo Requesting Administrator privileges to restore system defaults...
powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%~dp0Restore-Defaults.ps1""' -Verb RunAs"
exit
