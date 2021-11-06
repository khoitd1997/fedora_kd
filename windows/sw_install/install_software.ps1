. $PSScriptRoot\..\utils.ps1

if (IsUsingHomeConfig) {
    & "$PSScriptRoot\chocolatey.ps1"
    & "$PSScriptRoot\remove_unwanted_software.ps1"
}

& "$PSScriptRoot\powershell_modules.ps1"
