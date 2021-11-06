. $PSScriptRoot\..\utils.ps1

LogHeader "Setting up PowerToys"

$PowerToysAppDataDir = "$env:LOCALAPPDATA\Microsoft\PowerToys"

$null = TryToMakeSymlink `
    "$PSScriptRoot/settings.json" `
    "$PowerToysAppDataDir\settings.json"

$null = TryToMakeSymlink `
    "$PSScriptRoot/file_explorer/settings.json" `
    "$PowerToysAppDataDir\File Explorer\settings.json" 

$null = TryToMakeSymlink `
    "$PSScriptRoot/powertoys_run/settings.json" `
    "$PowerToysAppDataDir\PowerToys Run\settings.json" 

$null = TryToMakeSymlink `
    "$PSScriptRoot/fancyzones/settings.json" `
    "$PowerToysAppDataDir\FancyZones\settings.json"

LogHeader "Finished Setting up PowerToys"