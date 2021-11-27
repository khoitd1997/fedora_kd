function sha256sum {
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        $FilePath
    )
    Get-FileHash $FilePath -Algorithm SHA256 | Format-List
}

function extract-tar {
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$FilePath,

        [System.IO.FileInfo]$DestPath = "."
    )
    tar -xvzf $FilePath -C $DestPath
}

function run-script-bypass {
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$ScriptPath
    )
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File $ScriptPath
}

function cd-to-download {
    $DownloadDir = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    cd $DownloadDir
}

