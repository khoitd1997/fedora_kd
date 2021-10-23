#Requires -RunAsAdministrator

$InstallWorkDir = "$env:TEMP/vitis_install_tmp"

$VitisInstallBaseName = "Xilinx_Unified_2020.1_0602_1208"
$VitisUpdateBaseName = "Xilinx_Vivado_Vitis_Update_2020.1.1_0805_2247"

$installed = `
    $null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "Xilinx Design Tools Vitis Unified Software Platform 2020.1 (C:\Xilinx)" })

Register-EngineEvent PowerShell.Exiting –Action { 
    # always remove the tmp directory on exit
    Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore
} >$nul

If (-Not $installed) {
    Write-Host "Vitis hasn't been installed yet, starting install process" -ForegroundColor black -BackgroundColor white

    try {
        Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore
        New-Item -ItemType Directory -Force -Path $InstallWorkDir
        Write-Host "Extracting Vitis install files, this will take a long time" -ForegroundColor black -BackgroundColor white
        Expand-Archive -LiteralPath "$PSScriptRoot/$VitisInstallBaseName.zip" -DestinationPath $InstallWorkDir
        Expand-Archive -LiteralPath "$PSScriptRoot/$VitisUpdateBaseName.zip" -DestinationPath $InstallWorkDir
        Write-Host "Finished Extracting Vitis install files" -ForegroundColor black -BackgroundColor white
    }
    catch {
        Write-Host "Can't find Vitis zip files, exitting" -ForegroundColor black -BackgroundColor white
        return 
    }

    Write-Host "Installing Vitis" -ForegroundColor black -BackgroundColor white
    $VitisSetupBatPath = "$InstallWorkDir/$VitisInstallBaseName/bin/xsetup.bat"
    Start-Process `
        -FilePath "$VitisSetupBatPath" `
        -ArgumentList "--config", "$PSScriptRoot/install_config_windows.txt", "--agree", "XilinxEULA,3rdPartyEULA,WebTalkTerms", "--batch", "Install" `
        -NoNewWindow `
        -Wait

    Write-Host "Updating Vitis" -ForegroundColor black -BackgroundColor white
    $VitisUpdateBatPath = "$InstallWorkDir/$VitisUpdateBaseName/bin/xsetup.bat"
    Start-Process `
        -FilePath "$VitisUpdateBatPath" `
        -ArgumentList "--batch", "Update" `
        -NoNewWindow `
        -Wait
}
else {
    Write-Host "Vitis is already installed, exitting"
}