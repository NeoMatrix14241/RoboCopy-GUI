@echo off
title "RoboCopy GUI - PowerShell Script GUI for RoboCopy CLI"
color 0a
cls

set "scriptPath=%~dp0"
if "%scriptPath:~-1%"=="\" set "scriptPath=%scriptPath:~0,-1%"

where pwsh >nul 2>nul
if %errorlevel% neq 0 (
    powershell.exe -Command "Get-ChildItem -Path '%scriptPath%' -File | Where-Object { $_.Name -in @('robocopy.ps1', 'robocopy-gui.bat', 'ReadMe.txt') } | Unblock-File"
    powershell.exe -Command "Get-ChildItem -Path '%scriptPath%\setup' -Recurse -File | Unblock-File"
    powershell.exe -WindowStyle Hidden -ExecutionPolicy RemoteSigned -File "%scriptPath%\robocopy.ps1"
) else (
    pwsh -NoProfile -Command "exit" >nul 2>nul
    if %errorlevel% neq 0 (
        powershell.exe -Command "Get-ChildItem -Path '%scriptPath%' -File | Where-Object { $_.Name -in @('robocopy.ps1', 'robocopy-gui.bat', 'ReadMe.txt') } | Unblock-File"
        powershell.exe -Command "Get-ChildItem -Path '%scriptPath%\setup' -Recurse -File | Unblock-File"
        powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy RemoteSigned -File "%scriptPath%\robocopy.ps1"
    ) else (
        pwsh.exe -Command "Get-ChildItem -Path '%scriptPath%' -File | Where-Object { $_.Name -in @('robocopy.ps1', 'robocopy-gui.bat', 'ReadMe.txt') } | Unblock-File"
        pwsh.exe -Command "Get-ChildItem -Path '%scriptPath%\setup' -Recurse -File | Unblock-File"
        pwsh.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy RemoteSigned -File "%scriptPath%\robocopy.ps1"
    )
)