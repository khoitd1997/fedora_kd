. $PSScriptRoot\..\utils.ps1

if ((IsUsingHomeConfig) -and (-not(IsRunningAsAdmin))) {
    LogError "For home config, script must be run as admin"
    read-host "Press ENTER to close..."
    exit
}
if ((IsUsingWorkConfig) -and (IsRunningAsAdmin)) {
    LogError "For work config, script SHOULD NOT BE RUN AS ADMIN"
    read-host "Press ENTER to close..."
    exit
}

LogHeader "Starting Windows Configuration"

$PowershellRootDir = "$PSScriptRoot\.."

try {
    & "$PowershellRootDir\sw_install\install_software.ps1"

    & "$PowershellRootDir\autohotkey\setup_autohotkey.ps1"

    & "$PowershellRootDir\powertoys\setup_powertoys.ps1"

    if (IsUsingHomeConfig) {
        & "$PowershellRootDir\xyplorer\setup_xyplorer.ps1"
    }

    & "$PowershellRootDir\vscode\setup_vscode.ps1"

    & "$PowershellRootDir\windows_terminal\setup_windows_terminal.ps1"

    if (IsUsingHomeConfig) {
        & "$PowershellRootDir\wsl\wsl_setup.ps1"
    }

    if (IsUsingHomeConfig) {
        & "$PowershellRootDir\git\git_setup.ps1"
    }

    & "$PowershellRootDir\misc_setup.ps1"
}
catch {
    LogError "$PSItem"
}

LogHeader "Finished Windows Configurations"

read-host "Press ENTER to close..."