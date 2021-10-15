Write-Host @"
CUSTOM COMMAND LIST:

ssh-to-server: ssh to home server
mount-bulk-share: mount the bulk share to Z: drive

"@ -ForegroundColor black -BackgroundColor white

function ssh-to-server {
    ssh kd@kd-server
}

function mount-bulk-share {
    Write-Host "Powershell terminal seems to have problems when entering credentials, use cmd.exe if there is an issue"
    Write-Host "If asked for password, use Linux credentials (ie the kd account)"
    net use z: \\kd-server\Bulk_Storage_Share /savecred /persistent:yes
}

if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
    Import-Module PSFzf

    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
    
    Import-Module posh-git
    Import-Module oh-my-posh
    Set-PoshPrompt -Theme paradox
}