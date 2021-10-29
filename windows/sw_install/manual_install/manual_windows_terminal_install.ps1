. $PSScriptRoot\..\..\utils.ps1


# NOTE: Windows Terminal doesn't update itself so have to
# reinstall to get newer version
$MsixBundleSourceURL = "https://github.com/microsoft/terminal/releases/download/v1.12.2931.0/Microsoft.WindowsTerminalPreview_1.12.2931.0_8wekyb3d8bbwe.msixbundle"

DownloadAndInstallAppXPackage "$MsixBundleSourceURL" "Microsoft.WindowsTerminal"