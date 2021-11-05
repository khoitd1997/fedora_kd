$KdServerBigFileDirectory = "/bulk-storage-slow/nfs/general/big_file_storage"
$KdServerHostName = "kd-server.local"
$KdServerSshAddress = "kd@$KdServerHostName"

function init-server-key {
    $SshKeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub"
    if (-not(Test-Path -Path "$SshKeyPath" -PathType Leaf)) {
        ssh-keygen.exe
    }

    Get-Content "$SshKeyPath" | ssh $KdServerSshAddress "cat >> .ssh/authorized_keys"
}

function ssh-to-server {
    ssh $KdServerSshAddress
}
function scp-to-big-file-download {
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$SourceFilePath
    )

    scp -r $SourceFilePath ${KdServerSshAddress}:"$KdServerBigFileDirectory"
}
function scp-from-big-file-download {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$NameOfFileToCopy,

        [System.IO.FileInfo]$DestPath = "$((New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path)"
    )

    scp -r ${KdServerSshAddress}:"${KdServerBigFileDirectory}/${NameOfFileToCopy}" "$DestPath"
}


function list-nfs-file {
    ssh $KdServerSshAddress "source /bin/server_common.sh && tree -L 3 `${bulk_storage_share_dir}"
}

function mount-bulk-share {
    Write-Host "Powershell terminal seems to have problems when entering credentials, use cmd.exe if there is an issue"
    Write-Host "If asked for password, use Linux credentials (ie the kd account)"

    Write-Host "Mounting to Z Drive"
    New-PSDrive -Name "Z" -Root "\\${KdServerHostName}\Bulk_Storage_Share" -Persist -PSProvider "FileSystem" -Scope "Global"
}
function umount-bulk-share {
    Write-Host "Unmounting bulk share"
    Remove-PSDrive -Name "Z"
}

function vscode-ssh {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$PathOnServer,

        [string]$TargetHostName = "$KdServerHostName"
    )

    Write-Output "Host: ${TargetHostName}"
    Write-Output "Path: ${PathOnServer}"

    code --folder-uri "vscode-remote://ssh-remote+${TargetHostName}/${PathOnServer}"
}