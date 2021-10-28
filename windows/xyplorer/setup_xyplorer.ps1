. $PSScriptRoot\xyplorer_common.ps1

function CreateXYPlorerShortcut() {
    $WshShell = New-Object -comObject WScript.Shell

    # Icon was automatically obtained from the thing it points to
    $Shortcut = $WshShell.CreateShortcut($XYPlorerShortcutPath)
    $Shortcut.TargetPath = "$XYPlorerInstallDestDir\XYplorer.exe"
    $Shortcut.Save()
}

# NOTE: Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\
# trick doesn't work because xyplorer is fully portable so check install path instead
if (-not (Test-Path -Path "$XYPlorerInstallDestDir")) {
    Write-Host "XYplorer hasn't been installed yet, starting install process" -ForegroundColor black -BackgroundColor white

    $InstallWorkDir = "$env:TEMP/xyplorer_install"
    Register-EngineEvent PowerShell.Exiting –Action { 
        # always remove the tmp directory on exit
        Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore
    } >$nul

    $null = Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore
    $null = New-Item -ItemType Directory -Force -Path $InstallWorkDir

    wget --output-document "$InstallWorkDir/xyplorer_full_noinstall.zip" "https://www.xyplorer.com/download/xyplorer_full_noinstall.zip"
    New-Item -ItemType Directory -Force -Path $XYPlorerInstallDestDir
    Expand-Archive -LiteralPath "$InstallWorkDir/xyplorer_full_noinstall.zip" -DestinationPath $XYPlorerInstallDestDir

    CreateXYPlorerShortcut

    # NOTE: Doesn't look like it works with symlink settings file
    Copy-Item "$PSScriptRoot/XYplorer.ini" -Destination "$XYPlorerAppDataDir"
}
else {
    Write-Host "XYplorer is already installed" -ForegroundColor black -BackgroundColor white
}