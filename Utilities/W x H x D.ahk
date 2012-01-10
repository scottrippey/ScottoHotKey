#SingleInstance Force

; Format = \W'-\Wi"(w) x \H'-\Hi"(h)
; Format2 := " x \D'-\Di""(d)"
W = 0
H = 
D = 
Wi = 0
Hi = 
Di = 

help =
(ltrim comments
	Instructions:
	Press Win+W to bring up the input box.
	
	Type the width, height, and depth.  Press any non-numeric key to advance to the next box.
	
	Press Enter to type the output.  Press Escape to cancel.
	;
	; You can change the "format" any way you like.  Use \W \H \D \Wi \Hi \Di as placeholders.
)


GoSub ShowGUI
Return


ShowGUI:
#w::
	Gui Destroy
	
	Gui +AlwaysOnTop +Owner
	Gui Color, FFFFAA
	; Gui +LastFound
	; WinSet TransColor, 000055
	Gui -Caption
	Gui Margin, 2, 2
	
	Gui, Add, Text, x2 y5 w10 h20 , W
	Gui, Add, Edit, x12 y2 w30 h20  vW gW_TextChanged, %W%
	Gui, Add, Edit, x42 y2 w30 h20  vWi gWi_TextChanged, %Wi%

	Gui, Add, Text, x72 y5 w10 h20 , H ;" x H
	Gui, Add, Edit, x82 y2 w30 h20  vH gH_TextChanged, %H%
	Gui, Add, Edit, x112 y2 w30 h20  vHi gHi_TextChanged, %Hi%

	Gui, Add, Text, x142 y5 w10 h20 , D ;" x D
	Gui, Add, Edit, x152 y2 w30 h20  vD gD_TextChanged, %D%
	Gui, Add, Edit, x182 y2 w30 h20  vDi gDi_TextChanged, %Di%

	; Gui, Add, Edit, x2 y24 w140 h20  vFormat gFormat_TextChanged, %Format%
	; Gui, Add, Edit, x142 y24 w70 h20  vFormat2 gFormat_TextChanged, %Format2%

	GoSub FormatText ; Gets the default output
	Gui, Add, Text, x2 y25 w190 h16 vPreview, %Output%
	Gui, Add, Button, x192 y22 w20 h20 gHelp_Click, ?
	
	Gui, Show, AutoSize Hide ; Make this the default size, so that the next controls are hidden by default
	
	Gui, Add, Button, x214 y22 w70 h20  Default gDone_Click, Type »
	Gui, Add, Text, x2 y42 w250 , %Help%

	
	CoordMode Caret, Screen
	X := A_CaretX + 5
	Y := A_CaretY
	; Generated using SmartGUI Creator 4.0
	Gui, Show, x%X% y%Y% , Dimensions
Return
GuiEscape:
GuiClose:
GuiCancel:
	Gui Destroy
Return


Help_Click:
	Gui Show, AutoSize


Return


W_TextChanged:
	GuiControlGet W
	If RegexMatch(W, "^[0-9.]+[^0-9.]$")
		Send {End}{Backspace}{Tab}
	GoSub Format_TextChanged
Return
H_TextChanged:
	GuiControlGet H
	If RegexMatch(H, "^[0-9.]+[^0-9.]$")
		Send {End}{Backspace}{Tab}
	GoSub Format_TextChanged
Return
D_TextChanged:
	GuiControlGet D
	If RegexMatch(D, "^[0-9.]+[^0-9.]$")
		Send {End}{Backspace}{Tab}
	GoSub Format_TextChanged
Return
Wi_TextChanged:
	GuiControlGet Wi
	If RegexMatch(Wi, "^[0-9.]+[^0-9.]$")
		Send {End}{Backspace}{Tab}
	GoSub Format_TextChanged
Return	
Hi_TextChanged:
	GuiControlGet Hi
	If RegexMatch(Hi, "^[0-9.]+[^0-9.]$")
		Send {End}{Backspace}{Tab}
	GoSub Format_TextChanged
Return
Di_TextChanged:
	GuiControlGet Di
	If RegexMatch(Di, "^[0-9.]+[^0-9.]$")
		Send {End}{Backspace}{Tab}
	GoSub Format_TextChanged
Return



Format_TextChanged:
	; GuiControlGet Format
	; GuiControlGet Format2
	; Update the preview:
	GoSub FormatText
	GuiControl, , Preview, %Output%
Return
Done_Click:
	Gui Submit
	Gui Destroy
	GoSub FormatText
	SendInput {Raw}%Output%
Return


FormatText:
	;Determine what format we will use:
	If (Wi = "" AND Hi = "" AND Di = "") {
		If (D = "")
			Output = \W'(w) x \H'(h)
		Else
			Output = \W'(w) x \H'(h) x \D'(d)
	} Else If (W = "" AND H = "" AND D = "") {
		If (Di = "")
			Output = \Wi"(w) x \Hi"(h)
		Else
			Output = \Wi"(w) x \Hi"(h) x \Di"(d)
	} Else If (D = "" AND Di = "") {
		Output = \W'\Wi"(w) x \H'\Hi"(h)
	} Else {
		Output = \W'\Wi"(w) x \H'\Hi"(h) x \D'\Di"(d)
	}
	
	; ; ; Use the "format" to determine the output:
	; ; Output = %Format%
	; ; If (D != "" OR Di != "")
		; ; Output .= Format2
	value := Wi = "" ? 0 : Wi
	StringReplace Output, Output, \Wi, %value%, All
	value := Hi = "" ? 0 : Hi
	StringReplace Output, Output, \Hi, %value%, All
	value := Di = "" ? 0 : Di
	StringReplace Output, Output, \Di, %value%, All
	value := W = "" ? 0 : W
	StringReplace Output, Output, \W, %value%, All
	value := H = "" ? 0 : H
	StringReplace Output, Output, \H, %value%, All
	value := D = "" ? 0 : D
	StringReplace Output, Output, \D, %value%, All

Return

	

^r::
	Send ^s
	Reload
Return
