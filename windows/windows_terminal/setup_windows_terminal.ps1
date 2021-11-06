. $PSScriptRoot\..\utils.ps1

LogHeader "Setting Up Windows Terminal"

$null = TryToMakeSymlink `
    "$PSScriptRoot\powershell_profile.ps1" `
    "$profile"

$myDocumentPath = [Environment]::GetFolderPath("MyDocuments")
$null = TryToMakeSymlink `
    "$PSScriptRoot\powershell_profile.ps1" `
    "$myDocumentPath\PowerShell\Microsoft.VSCode_profile.ps1"

# set up profile for powershell 7
pwsh -NoProfile -NonInteractive `
    -WorkingDirectory $PSScriptRoot `
    -c {
    . ..\utils.ps1
    $null = TryToMakeSymlink `
        "$((Get-Item -Path .\ -Verbose).FullName)\powershell_profile.ps1" `
        "$profile"
}

$TerminalAppDataDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe"
if (Test-Path -Path "$TerminalAppDataDir") {
    $null = TryToMakeSymlink `
        "$PSScriptRoot\terminal_settings.json" `
        "$TerminalAppDataDir\LocalState\settings.json"
}

$TerminalPreviewAppDataDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe"
if (Test-Path -Path "$TerminalPreviewAppDataDir") {
    $null = TryToMakeSymlink `
        "$PSScriptRoot\terminal_settings.json" `
        "$TerminalPreviewAppDataDir\LocalState\settings.json"
}

LogHeader "Finished Setting Up Windows Terminal"