;#Include C:\Users\Scott\Shared Stuff\AutoHotKey\Utilities\AutoReload.ahk

;STARTOFSCRIPT
SetTimer,UPDATEDSCRIPT,1000

UPDATEDSCRIPT:
FileGetAttrib,attribs,%A_ScriptFullPath%
IfInString,attribs,A
{
FileSetAttrib,-A,%A_ScriptFullPath%
GoTo ReloadMe
}
Return
;ENDOFSCRIPT

^r::
	Send ^s
ReloadMe:
	SplashTextOn,,,Updated script,
	Sleep,500
	Reload
Return
