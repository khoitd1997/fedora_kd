function MakeSymlinkIfAllowed {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SrcPath,

        [Parameter(Mandatory = $true)]
        [string]$DestPath
    )
    <#
        .SYNOPSIS
        Symlink requires admin access so it's not possible to do sometimes,
        in that case, copy the file instead
    #>

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

function MakeSymlinkUsingMkLink {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SrcPath,

        [Parameter(Mandatory = $true)]
        [string]$DestPath
    )
    <#
        .SYNOPSIS
        Symlink using New-Item require admin access but bat mklink doesn't seem to
        so use it instead
    #>

    if (Test-Path $DestPath) {
        $null = Remove-Item -Recurse $DestPath
    }
    cmd.exe /c "mklink `"$DestPath`" `"$SrcPath`""
}