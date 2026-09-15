@echo off
chcp 65001 >nul
title NSSM Complete Cleanup Utility

:: Request Administrative Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [Info] Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ===================================================
echo                   NSSM Uninstaller
echo ===================================================
echo.

:: Configuration Variables
set "SERVICE_NAME=PM2Service"

:: 1. Force Stop and Delete Service via NSSM or Windows SC
echo [Info] Cleaning up service: %SERVICE_NAME%...
where nssm >nul 2>nul
if %errorlevel% equ 0 (
    nssm stop %SERVICE_NAME% >nul 2>&1
    nssm remove %SERVICE_NAME% confirm >nul 2>&1
)

:: Secondary enforcement using native Windows 'sc' command
sc stop %SERVICE_NAME% >nul 2>&1
sc delete %SERVICE_NAME% >nul 2>&1

:: 2. Remove nssm.exe from System32
echo [Info] Removing nssm.exe binary from System32...
if exist "C:\Windows\System32\nssm.exe" (
    powershell -Command "Remove-Item -Path 'C:\Windows\System32\nssm.exe' -Force" >nul 2>&1
)

:: 3. Clean up residual Registry Keys
echo [Info] Cleaning up registry residue...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\%SERVICE_NAME%" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application\%SERVICE_NAME%" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application\nssm" /f >nul 2>&1

:: 4. Clean up temporary files and logs
echo [Info] Cleaning up temporary files...
powershell -Command "Remove-Item -Path '$env:TEMP\nssm*', '$env:TEMP\nssm.zip' -Recurse -Force -ErrorAction SilentlyContinue" >nul 2>&1

echo.
echo ===================================================
echo  NSSM and associated services completely removed!
echo ===================================================
pause