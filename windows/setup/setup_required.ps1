# this script sets up basic things that most of the script needs
# for example, set up Execution Policy to allow running script locally

$WindowsProductName = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

if ($WindowsProductName -like "*Home") {
    Write-Host "Running Windows Home, using home config"

    Start-Process -FilePath "powershell.exe" -Verb RunAs -Wait `
        -ArgumentList "-NoProfile", "$PSScriptRoot/setup_required_home.ps1", "-ExecutionPolicy", "Bypass"
}
elseif ($WindowsProductName -like "*Enteprise") {
    Write-Host "Running Windows Enteprise, using work config"

    Start-Process -FilePath "powershell.exe" -Wait `
        -ArgumentList "-NoProfile", "$PSScriptRoot/setup_required_work.ps1", "-ExecutionPolicy", "Bypass"
}
else {
    Write-Host "Unknown Windows type, exitting"
    exit
}
