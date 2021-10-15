Write-Host @"
CUSTOM COMMAND LIST:

ssh-to-server: ssh to home server

"@ -ForegroundColor black -BackgroundColor white

function ssh-to-server {
    ssh kd@kd-server
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