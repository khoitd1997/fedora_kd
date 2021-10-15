LogHeader "Setting Up Windows Terminal"

New-Item -Path "$profile" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot\powershell_profile.ps1"`
    -Force

New-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot\terminal_settings.json"`
    -Force

LogHeader "Finished Setting Up Windows Terminal"