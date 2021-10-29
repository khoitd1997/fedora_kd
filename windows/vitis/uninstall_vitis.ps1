#Requires -RunAsAdministrator

. $PSScriptRoot\..\utils.ps1

If (-Not (ProgramIsInstalled "Vitis Unified Software Platform 2020.1")) {
    Write-Host "Vitis is already uninstalled, exitting" -ForegroundColor black -BackgroundColor white
}
else {
    Write-Host "Uninstalling Vitis" -ForegroundColor black -BackgroundColor white
    Start-Process `
        -FilePath "C:\Xilinx\.xinstall\Vitis_2020.1\bin\xsetup.bat" `
        -ArgumentList "-b", "Uninstall" `
        -NoNewWindow `
        -Wait
}

