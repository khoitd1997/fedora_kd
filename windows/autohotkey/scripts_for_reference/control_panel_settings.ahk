; reload the script using Ctrl+Alt+A
; ^!a::Reload

; Run control.exe
; WinWait, Control Panel ahk_class CabinetWClass,, 3
; if ErrorLevel
; {
;     MsgBox, Control panel timed out
;     return
; }
; WinActivate, Control Panel ahk_class CabinetWClass

Run, rundll32.exe shell32.dll`,Control_RunDLL inetcpl.cpl`,`,0