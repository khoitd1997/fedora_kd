#Requires -RunAsAdministrator

Enable-PSRemoting -force

Set-Item WSMAN:\Localhost\Client\TrustedHosts -Value * -Force

# get group list via Get-LocalGroup
# Add-LocalGroupMember -Group "Remote Management Users" -Member "$env:UserName"