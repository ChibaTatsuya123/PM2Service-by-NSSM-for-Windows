@echo off
chcp 65001 >nul
title PM2 Service Installer (NSSM)

:: Request Administrative Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [Info] Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ===================================================
echo     PM2 Windows Service Installer by NSSM
echo ===================================================
echo.

:: Configuration Variables
set "SERVICE_NAME=PM2Service"
set "NODE_PATH=C:\Program Files\nodejs\node.exe"
set "PM2_PATH=%APPDATA%\npm\node_modules\pm2\bin\pm2"
set "APP_DIR=%APPDATA%\npm"

:: Check if NSSM is installed
where nssm >nul 2>nul
if %errorlevel% neq 0 (
    echo [Error] NSSM is not installed or not in System PATH!
    echo Please run SetupNSSM.bat first.
    echo.
    pause
    exit /b 1
)

echo [Info] Installing Service: %SERVICE_NAME%...

:: Install and configure service using NSSM
nssm install %SERVICE_NAME% "%NODE_PATH%" "%PM2_PATH%" resurrect
nssm set %SERVICE_NAME% AppDirectory "%APP_DIR%"
nssm set %SERVICE_NAME% Description "PM2 Process Manager Service"

:: Set up logging
nssm set %SERVICE_NAME% AppStdout "%APP_DIR%\pm2-service-out.log"
nssm set %SERVICE_NAME% AppStderr "%APP_DIR%\pm2-service-error.log"

:: Start the service
echo [Info] Starting Service: %SERVICE_NAME%...
nssm start %SERVICE_NAME%

echo.
echo ===================================================
echo  %SERVICE_NAME% has been successfully installed!
echo ===================================================
pause