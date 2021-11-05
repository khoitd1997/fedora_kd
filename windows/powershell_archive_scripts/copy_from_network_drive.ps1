. $PSScriptRoot\..\utils.ps1

try {
    $DriveName = "TestDrive"
    $CleanupFunc = MountTempNetworkDrive $DriveName "\\kd-server.local\Bulk_Storage_Share"

    Write-Host "Copying file"
    Copy-Item "${DriveName}:big_file_storage/Xilinx_Vivado_Vitis_Update_2020.1.1_0805_2247.tar.gz" -Destination "$((New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path)"
    Write-Host "Finished Copying file"

    & $CleanupFunc
}
catch {
    Write-Host $PSItem
}