
$PathToImport = "$env:KD_SCRIPT_DIR/server_commands.ps1"
if (Test-Path "$PathToImport" -PathType Leaf) {
    . "$PathToImport"
}

$PathToImport = "$env:KD_SCRIPT_DIR/misc_commands.ps1"
if (Test-Path "$PathToImport" -PathType Leaf) {
    . "$PathToImport"
}

function print-reminder {
    Write-Host @"

REMINDER LIST:

- rufus and etcher are installed
- mobaxterm and putty are installed
- bat, nvim, weget are installed
- use powertoys win+R for quick navigations
- use Everything(bound to ctrl+alt+r) for file search
- use powertoys win+V for clipboard history

- USE AUTOHOTKEY FUNCTIONALITIES
"@ -ForegroundColor black -BackgroundColor white -NoNewline
    Write-Host ([char]0xA0)
}

function print-cmd-list {
    Write-Host @"
CUSTOM COMMAND LIST:

- print-cmd-list: print this list

- vscode-ssh <path-on-server> [server-host-name]: open a remote vscode session

- init-server-key: for first time initialization of ssh key
- ssh-to-server: ssh to home server
- scp-to-big-file-download <local-file-path>: copy local file to big download folder on the server
- scp-from-big-file-download <file-to-copy-name> [destination-path]: copy remote file to local, if destination not specified then download to the Downloads folder

- list-nfs-file: list bulk storage files
- mount-bulk-share: mount the bulk share to Z: drive
- umount-bulk-share: unmount the bulk share

- cd-to-download: cd to the download folder
- sha256sum <file_path>: take sha256 hash of a file
- extract-tar <file-to-extract> [destination]: extract a .tar.gz file
- run-script-bypass <path-to-script>: run a script with bypassing execution policy
"@ -ForegroundColor black -BackgroundColor white -NoNewline
    Write-Host ([char]0xA0)
}

print-cmd-list

print-reminder

if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
    Import-Module PSFzf

    Import-Module posh-git

    $global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = "@$(hostname)`n"
    $global:GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = 'Cyan'
    $GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Orange'

    if ($PSVersionTable.PSVersion.Major -gt 5) {
        # Emacs mode seems to break tab completion
        Set-PSReadlineOption -EditMode Emacs
    }
    else {
        # emulate some necessary keys
        Set-PSReadlineKeyHandler -Key ctrl+a -Function BeginningOfLine
        Set-PSReadlineKeyHandler -Key ctrl+e -Function EndOfLine
    }

    Set-Alias -Name vim -Value nvim
    Set-Alias -Name vi -Value nvim

    # NOTE: This sections needs to be below here otherwise Ctrl+r doesn't work
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
}