LogHeader "Setting Up Windows Terminal"

New-Item -Path "$profile" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot\powershell_profile.ps1"`
    -Force

$myDocumentPath = [Environment]::GetFolderPath("MyDocuments")
New-Item `
    -Path "$myDocumentPath\PowerShell\Microsoft.VSCode_profile.ps1" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot\powershell_profile.ps1" `
    -Force

# set up profile for powershell 7
pwsh -c { New-Item -Path "$profile" -ItemType SymbolicLink -Value "$((Get-Item -Path .\ -Verbose).FullName)\powershell_profile.ps1" -Force } -WorkingDirectory $PSScriptRoot

New-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot\terminal_settings.json"`
    -Force

LogHeader "Finished Setting Up Windows Terminal"