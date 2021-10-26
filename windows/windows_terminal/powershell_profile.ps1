function print-reminder {
    Write-Host @"

rufus and etcher are installed

mobaxterm and putty are installed

bat, nvim, weget are installed

use powertoys win+R for quick navigations

use Everything(bound to ctrl+alt+r) for file search

use powertoys win+V for clipboard history

"@ -ForegroundColor black -BackgroundColor white

}

function print-cmd-list {
    Write-Host @"
CUSTOM COMMAND LIST:

print-cmd-list: print this list

vscode-ssh <path-on-server> [server-host-name]: open a remote vscode session

init-server-key: for first time initialization of ssh key
ssh-to-server: ssh to home server
scp-to-big-file-download <local-file-path>: copy local file to big download folder on the server

list-nfs-file: list bulk storage files
mount-bulk-share: mount the bulk share to Z: drive
umount-bulk-share: unmount the bulk share

sha256sum <file_path>: take sha256 hash of a file
extract-tar <file-to-extract> [destination]: extract a .tar.gz file

"@ -ForegroundColor black -BackgroundColor white
}


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

function sha256sum {
    param (
        [string]$FilePath
    )
    Get-FileHash $FilePath -Algorithm SHA256 | Format-List
}

function extract-tar {
    param (
        [string]$FilePath,
        [string]$DestPath = "."
    )
    tar -xvzf $FilePath -C $DestPath
}

print-cmd-list

print-reminder

if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
    Import-Module PSFzf

    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    
    Import-Module posh-git
    Import-Module oh-my-posh
    Set-PoshPrompt -Theme paradox

    Set-Alias -Name vim -Value nvim
    Set-Alias -Name vi -Value nvim
}