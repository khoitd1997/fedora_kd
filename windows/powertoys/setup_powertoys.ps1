. $PSScriptRoot\..\utils.ps1

LogHeader "Setting up PowerToys"

$PowerToysAppDataDir = "$env:LOCALAPPDATA\Microsoft\PowerToys"

$null = MakeSymlinkUsingMkLink `
    "$PSScriptRoot/settings.json" `
    "$PowerToysAppDataDir\settings.json"

$null = MakeSymlinkUsingMkLink `
    "$PSScriptRoot/file_explorer/settings.json" `
    "$PowerToysAppDataDir\File Explorer\settings.json" 

$null = MakeSymlinkUsingMkLink `
    "$PSScriptRoot/powertoys_run/settings.json" `
    "$PowerToysAppDataDir\PowerToys Run\settings.json" 

$null = MakeSymlinkUsingMkLink `
    "$PSScriptRoot/fancyzones/settings.json" `
    "$PowerToysAppDataDir\FancyZones\settings.json"

LogHeader "Finished Setting up PowerToys"