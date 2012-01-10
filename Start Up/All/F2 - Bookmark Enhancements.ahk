
;Region " Visual Studio Shortcut "
#IfWinActive Microsoft Visual Studio
	F2::PressAndHold("F2", "={F2},500|Ctrl+F2=^{F2},1000|(Nevermind)=,0")
;EndRegion

;Region " Notepad++ "
#IfWinActive ahk_class Notepad++
	F2::PressAndHold("F2", "={F2},500|Ctrl+F2=^{F2},1000|(Nevermind)=,0")
;EndRegion

#IFWinActive
