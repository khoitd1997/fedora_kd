. "$PSScriptRoot/utils_sys_info.ps1"

function TryToMakeSymlink {
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$SrcPath,

        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$DestPath
    )
    <#
        .SYNOPSIS
        Symlink requires admin access so it's not possible to do sometimes,
        in that case, copy the file instead
    #>

    if (IsUsingHomeConfig) {
        if (Test-Path $DestPath) {
            $null = Remove-Item -Recurse $DestPath
        }
        cmd.exe /c "mklink `"$DestPath`" `"$SrcPath`""
    }
    else {
        try {
            $null = New-Item -Path "$DestPath" `
                -ItemType SymbolicLink `
                -Value "$SrcPath" `
                -Force -Erroraction stop
        }
        catch [System.UnauthorizedAccessException] {
            Write-Host "Permission denied to create symlink for file $SrcPath, trying to copy instead"
            $null = Copy-Item "$SrcPath" -Destination "$DestPath"
        }
    }
}

function MountTempNetworkDrive {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DriveName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DriveUrl
    )

    try {
        # NOTE: This needs to be null otherwise the callback is messed up
        $null = New-PSDrive -Name "$DriveName" -Root "$DriveUrl" -PSProvider "FileSystem" -Scope "Global" -Erroraction stop
    }
    catch {
        LogError "$PSItem"
        throw [System.IO.IOException] "Error mounting drive $DriveName"
    }

    return { 
        Write-Host "Unmounting Drive $DriveName"
        Remove-PSDrive $DriveName 
    }.GetNewClosure()
}