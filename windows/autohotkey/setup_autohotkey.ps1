New-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\autohotkey_script.ahk" `
         -ItemType SymbolicLink `
         -Value "$PSScriptRoot\autohotkey_script.ahk" `
         -Force