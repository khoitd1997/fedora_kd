. $PSScriptRoot\..\utils.ps1

try {
    # $CleanupFunc = MountTempNetworkDrive "TestDrive" "\\kd-server.local\Bulk_Storage_Share"
    $CleanupFunc = MountTempNetworkDrive "TestDrive" "\\fjkdalsjflkasdjfklasd"
    Write-Host "Calling cleanup function"
    & $CleanupFunc
}
catch {
    Write-Host $PSItem
}


# $ret = { write-host hello }.GetNewClosure()

# & $CleanupFunc

Write-Host "After cleanup"


# $job = Start-Job -scriptblock {
#     param (
#         [string]$Username
#     )

#     Write-Output $Username
#     $PSVersionTable
# } -ArgumentList "Arggggg"
# Receive-Job -Job $job -Wait

Exit
