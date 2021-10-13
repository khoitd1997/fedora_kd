SetTitleMatchMode, 2 ; This let's any window that partially matches the given name get activated
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CapsLock::Esc

#IfWinActive, Google
Alt & j::
send {Down}
return ;

Alt & k::
send {Up}
return ;
#IfWinActive

; window file explorer
#IfWinActive, ahk_class CabinetWClass
Alt & j::
send {Down}
return ;

Alt & k::
send {Up}
return ;

Alt & h::
send {Left}
return ;

Alt & l::
send {Right}
return ;


Ctrl & h::
send {Backspace}
return ;
#IfWinActive

~LWin & q::
send !{F4}
return

#m::
Run, Code, max
return

#b::
Run, chrome, max
return

#Enter::
Run, Cmder, max
return