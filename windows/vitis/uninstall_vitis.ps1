#Requires -RunAsAdministrator

. $PSScriptRoot\..\utils.ps1

If (-Not (ProgramIsInstalledUsingHKLM "Vitis Unified Software Platform 2020.1")) {
    LogHeader "Vitis is already uninstalled, exitting"
}
else {
    LogHeader "Uninstalling Vitis"
    Start-Process `
        -FilePath "C:\Xilinx\.xinstall\Vitis_2020.1\bin\xsetup.bat" `
        -ArgumentList "-b", "Uninstall" `
        -NoNewWindow `
        -Wait
}

