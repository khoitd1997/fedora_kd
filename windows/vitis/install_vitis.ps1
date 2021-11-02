#Requires -RunAsAdministrator

. $PSScriptRoot\..\utils.ps1

$InstallWorkDir = "$env:TEMP/vitis_install_tmp"

$VitisInstallBaseName = "Xilinx_Unified_2020.1_0602_1208"
$VitisUpdateBaseName = "Xilinx_Vivado_Vitis_Update_2020.1.1_0805_2247"

Register-EngineEvent PowerShell.Exiting –Action { 
    # always remove the tmp directory on exit
    Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore
} >$nul

If (-Not (ProgramIsInstalledUsingHKLM "Vitis Unified Software Platform 2020.1")) {
    LogHeader "Vitis hasn't been installed yet, starting install process"

    try {
        Remove-Item "$InstallWorkDir" -Recurse -ErrorAction Ignore
        New-Item -ItemType Directory -Force -Path $InstallWorkDir
        LogHeader "Extracting Vitis install files, this will take a long time"
        Expand-Archive -LiteralPath "$PSScriptRoot/$VitisInstallBaseName.zip" -DestinationPath $InstallWorkDir
        Expand-Archive -LiteralPath "$PSScriptRoot/$VitisUpdateBaseName.zip" -DestinationPath $InstallWorkDir
        LogHeader "Finished Extracting Vitis install files"
    }
    catch {
        LogHeader "Can't find Vitis zip files, exitting"
        return 
    }

    LogHeader "Installing Vitis"
    $VitisSetupBatPath = "$InstallWorkDir/$VitisInstallBaseName/bin/xsetup.bat"
    Start-Process `
        -FilePath "$VitisSetupBatPath" `
        -ArgumentList "--config", "$PSScriptRoot/install_config_windows.txt", "--agree", "XilinxEULA,3rdPartyEULA,WebTalkTerms", "--batch", "Install" `
        -NoNewWindow `
        -Wait
    # TODO: It freezes right after install, so need to do something to get it unstuck

    LogHeader "Updating Vitis"
    $VitisUpdateBatPath = "$InstallWorkDir/$VitisUpdateBaseName/bin/xsetup.bat"
    Start-Process `
        -FilePath "$VitisUpdateBatPath" `
        -ArgumentList "--batch", "Update" `
        -NoNewWindow `
        -Wait
}
else {
    LogHeader "Vitis is already installed, exitting"
}