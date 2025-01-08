@echo off
start /min powershell.exe -WindowStyle Hidden -ExecutionPolicy RemoteSigned -File "robocopy.ps1"
exit