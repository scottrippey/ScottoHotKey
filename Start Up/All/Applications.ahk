;Application Shortcuts:
#space::Run firefox.exe
#f::Run("firefox.exe", "ahk_group Firefox")
#g::Run www.google.com

#n::Run("notepad.exe", "ahk_class Notepad")
#m::Run(A_ProgramFiles . "\Notepad++\Notepad++.exe", "ahk_class Notepad++")
#i::Run("iexplore.exe", "ahk_class IEframe")
#c::Run("PowerCalc.exe", "PowerToy Calc")
;#e::Run explore

; Application-specific hot keys:
#IfWinActive Scott's Passwords.kdb - KeePass Password Safe
	Esc::Send !{F4}
#IfWinActive ahk_class ShImgVw:CPreviewWnd ; (Windows Picture and Fax Viewer)
	Esc::Send !{F4}
#IfWinActive

#IfWinActive ahk_class XLMAIN
	;Ins::Send {AppsKey}i{Enter}!d ; Insert, shift rows down
	;Ins::Send {AppsKey}i!d{Enter} ; Insert, shift rows down
	Ins::Send ^+{=}d{Enter} ; Insert, shift rows down
#IfWinActive

; Runs a program, and activates the window once it's open.
; If you specify a title and the window exists already and isn't active, 
; then it will be activated instead.
Run(exe, title="") {
	If (title != "" AND WinExist(title) AND !WinActive(title)) {
		WinActivate
		Return
	}
	Run %exe%, , , exePid
	WinWait ahk_pid %exePid%, , 5
	WinActivate
}
