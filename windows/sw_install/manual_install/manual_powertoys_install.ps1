#Requires -RunAsAdministrator

. $PSScriptRoot\..\..\utils.ps1

if (-Not (ProgramIsInstalledUsingWMI "PowerToys")) {
    $InstallerDownloadURL = "https://github.com/microsoft/PowerToys/releases/download/v0.49.0/PowerToysSetup-0.49.0-x64.exe"
    $InstallWorkDir = "$env:TEMP/${AppName}_install_tmp"
    $ExeDest = "$InstallWorkDir/${AppName}"

    DownloadAndInstallGenericExe `
        -AppName "PowerToys" `
        -InstallerDownloadURL $InstallerDownloadURL `
        -ArgList @("--silent")
}
else {
    LogHeader "PowerToys has already been installed"
}