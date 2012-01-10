#SingleInstance Force
instructions =
(ltrim
	How to use this form-filler helper:
	Method One:
	- Position your mouse over the text box, and press F1.
	- Position your mouse over the label for the text box, and press F1.
	Method Two:
	- Position your mouse over the text box, and press F2.
	Method Three:
	- Focus the text box you want, and press F3.
	
	
	Examples:
	WindowsForms10.EDIT.app.0.2004eee8 = customerCompany
	WindowsForms10.EDIT.app.0.2004eee6 = customerName
	WindowsForms10.EDIT.app.0.2004eee28 = customerPhone
	WindowsForms10.EDIT.app.0.2004eee25 = customerAddress
	WindowsForms10.EDIT.app.0.2004eee26 = customerAddress2
	WindowsForms10.EDIT.app.0.2004eee24 = customerCity
	WindowsForms10.EDIT.app.0.2004eee22 = customerState
	WindowsForms10.EDIT.app.0.2004eee20 = customerZip
	WindowsForms10.EDIT.app.0.2004eee14 = customerCountry
	WindowsForms10.EDIT.app.0.2004eee7 = customerType
	WindowsForms10.EDIT.app.0.2004eee21 = customerEmail
	WindowsForms10.EDIT.app.0.2004eee4 = customerPhoneExt
)


Gui Add, Button, x10 y10 gClearAll, Clear All
Gui Add, Button, x90 y10 gCopyAll, Copy All
Gui Add, Button, x170 y10 gHighlightAll, Highlight All

Gui Add, Text, x10 y40 w500 r1 vInfo, 
Gui Add, Edit, w500 h20 vWinTitle gSaveAllText, (window title goes here)
Gui Add, Edit, w500 h400 vAllText gSaveAllText, %instructions%

Gui +AlwaysOnTop
Gui Show, , Form Filler Helper

SetTimer UpdateInfo, 250

Return
UpdateInfo:
	MouseGetPos, , , w, c
	ControlGetText, text, %c%, ahk_id %w%
	StringReplace text, text, `r, , All
	StringReplace text, text, `n, , All
	
	StringLeft text, text, 40
	;msg = Under the mouse: %c% (%text%)
	msg = Under the mouse: %c% ("%text%")
	
	ToolTip %msg%, , , 20
	
	
	GuiControl, , Info, %msg%
	;GuiControl, , AllText, %msg%
Return

GuiClose:
	SetTimer UpdateInfo, Off
	GoSub HideAllTooltips
	Gui Cancel
	Gui Destroy
	;ExitApp
Return






CopyAll:
	clip = %WinTitle%`n%AllText%
	StringReplace, clip, clip, `n, `r`n, All
	clipboard := clip
Return
ClearAll:
	WinTitle =
	AllText =
	GuiControl, , WinTitle, %WinTitle%
	GuiControl, , AllText, %ALlText%
Return
SaveAllText:
	GuiControlGet, WinTitle
	GuiControlGet, AllText
Return

HighlightAll:
	
	FillForm(WinTitle, AllText, "TESTSHOW")
Return
#Include C:\Users\Scott\Shared Stuff\AutoHotKey\Start Up\#Includes\Form Filler.ahk






#IfWinExist Form Filler Helper
F3::
	;MouseGetPos, , , wind, ctrl
	wind := WinExist("A")
	ControlGetFocus, ctrl, A
	lastCtrl := ctrl

	rightClickIndex = 1
	
	GoTo AddControl
F2::
	MouseGetPos, , , wind, ctrl
	lastCtrl := ctrl
	rightClickIndex = 1
	GoTo AddControl
F1::
	lastCtrl := ctrl
	MouseGetPos, , , wind, ctrl
	
	
AddControl:
	ControlGetText, text, %ctrl%, ahk_id %wind%
	StringReplace text, text, `r, , All
	StringReplace text, text, `n, ``n, All
	
	
	rightClickIndex++
	If (rightClickIndex = 1) {
		; append = %ctrl% = 
		append =
	} Else {
		append = %lastCtrl% = (%text%) `; %text% `n
		rightClickIndex =
	}

	AllText .= append
	GuiControl, , AllText, %AllText%
	
	WinGetClass, WinTitle, ahk_id %wind%
	WinTitle = ahk_class %WinTitle%
	GuiControl, , WinTitle,  %WinTitle%
	
	
	; Place a tooltip over the new item:
	If toolTipIndex =
		toolTipIndex = 1
	CoordMode, ToolTip, Screen
	If (rightClickIndex = 1) {
		WinGetPos, wX, wY, , , ahk_id %wind%
		ControlGetPos, cX, cY, , , %ctrl%, ahk_id %wind%

		ToolTip, %ctrl%, % wX + cX, % wY + cY, %toolTipIndex%
	} Else {
		ToolTip, %lastCtrl% = %text%, % wX + cX, % wY + cY, %toolTipIndex%
		toolTipIndex := mod(toolTipIndex, 19) + 1
	}
	SetTimer HideAllTooltips, -5000

	
	
return

; HideAllTooltips:
	; Loop, 20
		; ToolTip, , , , %A_Index%
; Return



#IfWinExist




^r::
	Send ^s
	ToolTip Reloading Test...
	Sleep 500
	ToolTip
	Reload
Return
