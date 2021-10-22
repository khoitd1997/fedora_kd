#Requires -RunAsAdministrator

$installed = `
    $null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq "Xilinx Design Tools Vitis Unified Software Platform 2020.1 (C:\Xilinx)" })
If (-Not $installed) {
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

