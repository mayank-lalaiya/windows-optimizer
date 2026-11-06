@echo off
TITLE Windows Speed & Performance Optimizer
cd /d "%~dp0"

:: Check for Administrative Rights
net session >nul 2>&1
if %errorLevel% == 0 (
    echo ========================================================
    echo  Launching Windows Optimizer (Administrator Mode)
    echo ========================================================
    powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -File "%~dp0App.ps1"
    if %errorlevel% neq 0 (
        echo.
        echo [ERROR] The application closed unexpectedly (Exit Code: %errorlevel%).
        pause
    )
) else (
    echo Requesting Administrator privileges (UAC Prompt)...
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process '%~f0' -Verb RunAs"
)
