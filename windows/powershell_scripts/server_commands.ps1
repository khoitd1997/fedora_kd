function init-server-key {
    $SshKeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub"
    if (-not(Test-Path -Path "$SshKeyPath" -PathType Leaf)) {
        ssh-keygen.exe
    }

    Get-Content "$SshKeyPath" | ssh kd@"kd-server" "cat >> .ssh/authorized_keys"
}

function ssh-to-server {
    ssh kd@kd-server
}
function scp-to-big-file-download {
    param(
        [string]$SourceFilePath
    )

    scp -r $SourceFilePath kd@kd-server:"/bulk-storage-slow/nfs/general/big_file_storage"
}


function list-nfs-file {
    ssh kd@"kd-server" "source /bin/server_common.sh && tree -L 3 `${bulk_storage_share_dir}"
}

function mount-bulk-share {
    Write-Host "Powershell terminal seems to have problems when entering credentials, use cmd.exe if there is an issue"
    Write-Host "If asked for password, use Linux credentials (ie the kd account)"
    net use z: \\kd-server\Bulk_Storage_Share /savecred /persistent:yes
}
function umount-bulk-share {
    Write-Host "Unmounting bulk share"
    net use Z: /delete /y
}

function vscode-ssh {
    param(
        [string]$PathOnServer,
        [string]$ServerHostName = "kd-server"
    )

    Write-Output "Host: ${ServerHostName}"
    Write-Output "Path: ${PathOnServer}"

    code --folder-uri "vscode-remote://ssh-remote+${ServerHostName}/${PathOnServer}"
}