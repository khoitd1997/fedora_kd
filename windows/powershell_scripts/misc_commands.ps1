function sha256sum {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )
    Get-FileHash $FilePath -Algorithm SHA256 | Format-List
}

function extract-tar {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        [string]$DestPath = "."
    )
    tar -xvzf $FilePath -C $DestPath
}

function run-script-bypass {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath
    )
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $ScriptPath
}

