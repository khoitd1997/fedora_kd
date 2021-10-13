# used for setting up windows software

Write-Host "Starting Windows Configuration"

& "$PSScriptRoot\..\test_setup.ps1"

# app install and other setup
.\setup.sh

# configure autohotkey
New-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\autohotkey_script.ahk" `
         -ItemType SymbolicLink `
         -Value "$PSScriptRoot\autohotkey\autohotkey_script.ahk" `
         -Force

# create tasks to automatically update choco
$action = New-ScheduledTaskAction -Execute 'choco' -Argument 'upgrade all -Y'

$trigger =  New-ScheduledTaskTrigger -AtLogon

$Stset = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "choco automatic upgrade" -Description "Automatically upgrade choco app" -RunLevel Highest -Settings $Stset