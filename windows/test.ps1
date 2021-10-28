# File is used mostly for scratch work
try {
    %USERPROFILE%\AppData\Local\Microsoft\PowerToys

}
catch {
    LogError "$PSItem"
}