@echo off
chcp 65001 >nul
title PM2 Service Uninstaller (NSSM)

:: Request Administrative Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [Info] Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ===================================================
echo     PM2 Windows Service Uninstaller by NSSM
echo ===================================================
echo.

:: Configuration Variables
set "SERVICE_NAME=PM2Service"

:: Check if NSSM is installed
where nssm >nul 2>nul
if %errorlevel% neq 0 (
    echo [Error] NSSM is not installed or not in System PATH!
    echo Please ensure nssm.exe is available in System PATH.
    echo.
    pause
    exit /b 1
)

:: Stop and remove service
echo [Info] Stopping Service: %SERVICE_NAME%...
nssm stop %SERVICE_NAME%

echo [Info] Removing Service: %SERVICE_NAME%...
nssm remove %SERVICE_NAME% confirm

echo.
echo ===================================================
echo  %SERVICE_NAME% has been successfully removed!
echo ===================================================
pause