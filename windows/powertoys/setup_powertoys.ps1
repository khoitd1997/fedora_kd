$PowerToysAppDataDir = "$env:LOCALAPPDATA\Microsoft\PowerToys"

$null = New-Item -Path "$PowerToysAppDataDir\settings.json" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot/settings.json"`
    -Force
$null = New-Item -Path "$PowerToysAppDataDir\File Explorer\settings.json" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot/file_explorer/settings.json"`
    -Force
$null = New-Item -Path "$PowerToysAppDataDir\PowerToys Run\settings.json" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot/powertoys_run/settings.json"`
    -Force
