#Requires -RunAsAdministrator

# need this to create symlink without extra permission
Write-Host "Turning on developer mode"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

read-host "Press ENTER to close..."