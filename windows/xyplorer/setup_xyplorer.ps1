#Requires -RunAsAdministrator

# NOTE: for some reasons, the 
# Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\
# trick doesn't work so check for folder existence instead
if (-not (Test-Path -Path "C:\Program Files (x86)\XYplorer")) {
    Write-Host "XYplorer hasn't been installed yet, starting install process" -ForegroundColor black -BackgroundColor white

    $InstallWorkDir = "$env:TEMP/xyplorer_install"
    Register-EngineEvent PowerShell.Exiting –Action { 
        # always remove the tmp directory on exit
        Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore
    } >$nul

    $null = Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore
    $null = New-Item -ItemType Directory -Force -Path $InstallWorkDir

    wget --output-document "$InstallWorkDir/xyplorer_full.zip" "https://www.xyplorer.com/download/xyplorer_full.zip"
    Expand-Archive -LiteralPath "$InstallWorkDir/xyplorer_full.zip" -DestinationPath $InstallWorkDir

    $exe_name = (Get-ChildItem $InstallWorkDir | Where-Object Name -match ("_Install.exe"))[0].Name
    Start-Process `
        -FilePath "$InstallWorkDir/$exe_name" `
        -NoNewWindow `
        -Wait
}
else {
    Write-Host "XYplorer is already installed" -ForegroundColor black -BackgroundColor white
}

$xyplorerAppDataFolder = "$env:APPDATA/XYplorer"
$null = New-Item -Path "$xyplorerAppDataFolder/XYplorer.ini" `
    -ItemType SymbolicLink `
    -Value "$PSScriptRoot/XYplorer.ini" `
    -Force
