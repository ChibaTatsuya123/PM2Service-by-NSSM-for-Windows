@echo off
chcp 65001 >nul
title NSSM Downloader ^& Installer

:: Request Administrative Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [Info] Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ===================================================
echo             NSSM Downloader ^& Installer
echo ===================================================
echo.

echo [Info] Downloading NSSM...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://nssm.cc/release/nssm-2.24.zip' -OutFile \"$env:TEMP\nssm.zip\""

echo [Info] Extracting ZIP file...
powershell -Command "Expand-Archive -Path \"$env:TEMP\nssm.zip\" -DestinationPath \"$env:TEMP\nssm\" -Force"

echo [Info] Copying nssm.exe to System32...
powershell -Command "Copy-Item \"$env:TEMP\nssm\nssm-2.24\win64\nssm.exe\" -Destination 'C:\Windows\System32' -Force"

echo [Info] Cleaning up temporary files...
powershell -Command "Remove-Item -Path \"$env:TEMP\nssm.zip\", \"$env:TEMP\nssm\" -Recurse -Force"

echo.
echo ===================================================
echo  NSSM has been successfully installed to System32!
echo ===================================================
pause