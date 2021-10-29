. $PSScriptRoot\..\utils.ps1

LogHeader "Setting Up Autohotkey"

$StartupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

LogHeader "Removing Current ahk Script in the startup folder"
Get-ChildItem "$StartupFolder" -Filter *.ahk | 
Foreach-Object {
    Remove-Item "$($_.FullName)"
}

Get-ChildItem "$PSScriptRoot\scripts_loaded_at_startup" -Filter *.ahk | 
Foreach-Object {
    $null = New-Item -Path "${StartupFolder}\$($_.Name)" `
        -ItemType SymbolicLink `
        -Value "$($_.FullName)" `
        -Force
}

LogHeader "Finished Setting Up Autohotkey"