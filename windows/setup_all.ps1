#Requires -RunAsAdministrator

. $PSScriptRoot\utils.ps1

LogHeader "Starting Windows Configuration"

# TODO: Configure git
# https://stackoverflow.com/questions/6476513/git-file-permissions-on-windows
try {
    & "$PSScriptRoot\sw_install\install_software.ps1"

    & "$PSScriptRoot\autohotkey\setup_autohotkey.ps1"

    & "$PSScriptRoot\vscode\setup_vscode.ps1"

    & "$PSScriptRoot\windows_terminal\setup_windows_terminal.ps1"

    & "$PSScriptRoot\wsl\wsl_setup.ps1"

    & "$PSScriptRoot\git\git_setup.ps1"

    & "$PSScriptRoot\misc_setup.ps1"
}
catch {
    LogError "$PSItem"
}

LogHeader "Finished Windows Configurations"

Start-Sleep -Seconds 60