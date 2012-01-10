#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Sleep 5000 		;a few seconds helps nero detect all the drives correctly

IfWinExist ahk_class #32770
{
	WinClose
	WinWaitClose
}

Run C:\Program Files\Nero\Nero 7\Nero Recode\Recode.exe
WinWait ahk_class #32770
Sleep 2000
WinActivate
Click 172, 313 		;click "Recode entire DVD to DVD"
Sleep 2000
WinActivate
Click 700, 145		;click "Import"
Sleep 5000
;WinActivate
;Send {Enter}		;click "OK" on folder dialog
Click 192, 310		;click "OK" on folder dialog
Sleep 4 * 60 * 1000	;wait 4 minutes

WinActivate
Click 725,540
Sleep 5000
WinActivate
Click 725,540
Sleep 5000
