; Sample script for reference on how to automate tasks
; that involves many GUI, things like click this, wait for that
; then type this, etc

#SingleInstance Force

; reload the script using Ctrl+Alt+A
; ^!a::Reload

; NOTE The hotkey used for activating the actions might affect the click
; For example, if Ctrl is invovled, it will combine with the click to
; be come Ctrl+click which might have unintended consequence
; SOME ITEMS COORDINATES MAY NOT WORK
F1::

Run, "steam://rungameid/552500"
; wait for the program to become available with 3s timeout
WinWait, Launcher ahk_exe launcher.exe,, 3
if ErrorLevel
{
    MsgBox, Verminticide Launcher Timed Out!
    return
}

WinActivate, Launcher ahk_exe launcher.exe
Click, 745 52

WinActivate, GameSettings ahk_exe launcher.exe
; set Debug Mode to On
Click, 372 329 ; activate dropdown menu
Click, 306 350 ; select the dropdown option

; accept the warning by clicking "OK"
WinWait, WARNING! ahk_exe launcher.exe
ControlClick, OK,WARNING! ahk_exe launcher.exe,,,,NA

Click, 78 443 ; click Accept to save the setting

return