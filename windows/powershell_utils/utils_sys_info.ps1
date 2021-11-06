function IsUsingWindowPowershell {
    return -not($PSVersionTable.PSVersion.Major -gt 5)
}

function IsRunningAsAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function IsUsingHomeConfig {
    return (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName -like "*Home"
}
function IsUsingWorkConfig {
    return (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName -like "*Enteprise"
}