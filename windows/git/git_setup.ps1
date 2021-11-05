. $PSScriptRoot\..\utils.ps1

LogHeader "Starting Git Configuration"

git lfs install

$UserFullName = $(Get-WMIObject Win32_UserAccount | where caption -eq $(whoami) | Select-Object -First 1).FullName
git config --global user.name "$UserFullName"
git config --global user.email "khoidinhtrinh@gmail.com"

# to make sure executable bits and other permission isn't messed up
git config --global core.filemode false

git config --global core.editor "code --wait"

git config --global core.autocrlf true

LogHeader "Finished Git Configuration"