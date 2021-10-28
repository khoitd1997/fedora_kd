#Requires -RunAsAdministrator

. $PSScriptRoot\utils.ps1

LogHeader "Starting Windows Configuration"

try {
    & "$PSScriptRoot\sw_install\install_software.ps1"

    & "$PSScriptRoot\autohotkey\setup_autohotkey.ps1"

    & "$PSScriptRoot\powertoys\setup_powertoys.ps1"

    & "$PSScriptRoot\xyplorer\setup_xyplorer.ps1"

    & "$PSScriptRoot\vscode\setup_vscode.ps1"

    & "$PSScriptRoot\windows_terminal\setup_windows_terminal.ps1"

    & "$PSScriptRoot\wsl\wsl_setup.ps1"

    & "$PSScriptRoot\git\git_setup.ps1"

    & "$PSScriptRoot\misc_setup.ps1"

    & "$PSScriptRoot\vitis\setup_vitis.ps1"
}
catch {
    LogError "$PSItem"
}

LogHeader "Finished Windows Configurations"

Start-Sleep -Seconds 60