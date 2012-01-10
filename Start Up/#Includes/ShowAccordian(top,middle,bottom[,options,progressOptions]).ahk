; Usage:
; ShowAccordian("Top","Middle","Bottom")
; The middle text will be in a larger font; the top and bottom will be displayed in a normal font.
; 

; Hides the accordian
HideAccordian(accordianOptions = "") {
	; The ShowAccordian function manages its own static variables, so we must tell it to hide:
	ShowAccordian("","","", accordianOptions)
}
ShowAccordianProgress(P, accordianOptions = "") {
	; The ShowAccordian function manages its own static variables, so we must tell it to update the progress:
	ShowAccordian(P,"","", accordianOptions)
}
ShowAccordianAt(Lines, SelectedIndex, accordianOptions = "", progressOptions = "") {
	; Let's split the text manually:
	Top =
	Middle := " "
	Bottom =
	StringSplit Lines, Lines, `n, `r
	Loop %Lines0%
	{
		If (A_Index < SelectedIndex) {
			If Top !=
				Top .= "`n"
			Top .= A_LoopField
		} Else If (A_Index = SelectedIndex) {
			Middle := A_LoopField
		} Else {
			If Bottom !=
				Bottom .= "`n"
			Bottom .= A_LoopField
		}
	}
	ShowAccordian(Top, Middle, Bottom, accordianOptions, progressOptions)
}
;;; <param name="accordianOptions">
;;; For now, please read the source code comments down below:
;;; </param>
ShowAccordian(Top, Middle, Bottom, accordianOptions = "", progressOptions = "") {
	; Add the defaults:
	accordianOptions .= " GuiKeyAccordian FontSmall12 FontLarge20 FontName'Verdana' XC Center YM Middle MonitorPrimary ForegroundBlack BackgroundTransparent Alpha255 "

;;;;;;;;;;;;;;; Parse out the accordianOptions ;;;;;;;;;;;;;;;;;

	CoordMode mouse, screen
	CoordMode caret, screen

	; GuiKey
	RegexMatch(accordianOptions, "ix) (?<=\bGK|\bGuiKey) \w+ \b", guiKey)				; Example: GuiKeyWhatever

	; Font small,large,name
	RegexMatch(accordianOptions, "ix) (?<=\bFS|\bFONTSMALL) \d+ \b", fontSmall) 		; Examples: FontSmall20, FS20
	RegexMatch(accordianOptions, "ix) (?<=\bFL|\bFONTLARGE) \d+ \b", fontLarge) 		; Examples: FontLarge40, FL40
	RegexMatch(accordianOptions, "ix) (?<=\bFN'|\bFONTNAME') [^']+ (?=')", fontName) 	; Examples: FontName'Times New Roman'
	
	; Determine which monitor to use for placement:
	RegexMatch(accordianOptions, "ix) (?<=\bMonitor|\bMon) (P|Primary|M|Mouse|C|Caret|\d+) \b", monitorNumber)	; Examples: MonitorPrimary, Mon1, Mon2, MonMouse, MonCaret
	If monitorNumber In P,Primary
		SysGet monitorNumber, MonitorPrimary
	Else If monitorNumber In M,Mouse,C,Caret
	{	If monitorNumber In M,Mouse
			MouseGetPos, X, Y
		Else {
			X := A_CaretX
			Y := A_CaretY
		}
		; Find the monitor that contains the X,Y location, defaulting to primary:
		SysGet monitorNumber, MonitorPrimary
		SysGet monitorCount, MonitorCount
		Loop, %monitorCount%
		{	SysGet screenArea, Monitor, %A_Index%
			If (screenAreaLeft <= X && X <= screenAreaRight && screenAreaTop <= Y && Y <= screenAreaBottom) {
				monitorNumber := A_Index
				break
			}
		}
	} 
	SysGet screenArea, MonitorWorkArea, %monitorNumber%

	; X Position; Example: XLeft XCenter XRight XCaret XMouse XR-100 XL+100 X100
	RegexMatch(accordianOptions, "ix) \b X(?<Relative>L|LEFT|C|CENTER|R|RIGHT|I|CARET|MOUSE)? (?<Value>[+-]?\d+)? \b", X)
		StringUpper XRelative, XRelative
		X := 0
		If 		XRelative In L,LEFT
			X := screenAreaLeft
		Else If XRelative In C,CENTER 
			X := screenAreaLeft + (screenAreaRight - screenAreaLeft)//2
		Else If XRelative In R,RIGHT
			X := screenAreaRight
		Else If XRelative In I,CARET
			X := A_CaretX
		Else If XRelative In MOUSE
			MouseGetPos, X,
		
		If XValue !=
			X += XValue
			
	; Y Position; Example: YTop YMiddle YBottom YCaret YMouse YB-100 YT+100 Y100
	RegexMatch(accordianOptions, "ix) \b Y(?<Relative>T|TOP|M|MIDDLE|B|BOTTOM|I|CARET|MOUSE)? (?<Value>[+-]?\d+)? \b", Y)
		StringUpper YRelative, YRelative
		Y := 0
		If 		YRelative In T,TOP
			Y := screenAreaTop
		Else If YRelative In M,MIDDLE
			Y := screenAreaTop + (screenAreaBottom - screenAreaTop)//2
		Else If YRelative In B,BOTTOM
			Y := screenAreaBottom
		Else If YRelative In I,CARET
			Y := A_CaretY + 14 - fontLarge * 12/10 ; Explanation: Caret size is typically 14 pixels, and font has 20% padding on the top and bottom.
		Else If YRelative In MOUSE
			MouseGetPos, ,Y
		
		If YValue !=
			Y += YValue
	
	; Anchor Direction & Text Align; Example: Top Left    Bottom Right    Middle Center
	RegexMatch(accordianOptions, "ix) \b(L|LEFT|C|CENTER|R|RIGHT)\b", hPosition)
		StringUpper hPosition, hPosition
		If hPosition = L
			hPosition = LEFT
		If hPosition = C
			hPosition = CENTER
		If hPosition = R
			hPosition = RIGHT
		; Text align is the opposite direction as hPosition
		If hPosition = LEFT
			textAlign = Right
		If hPosition = CENTER
			textAlign = Center
		If hPosition = RIGHT
			textAlign = Left
	RegexMatch(accordianOptions, "ix) \b(T|TOP|M|MIDDLE|B|BOTTOM)\b", vPosition)	
		StringUpper vPosition, vPosition
		If vPosition = T
			vPosition = TOP
		If vPosition = M
			vPosition = MIDDLE
		If vPosition = B
			vPosition = BOTTOM

	; Colors
	RegexMatch(accordianOptions, "ix) (?<=\bFG|\bFOREGROUND) ( \w+ | [A-Fa-f0-9]{6} ) \b", foregroundColor) ; Examples: FGWhite, FGYellow, FG00FF00
	RegexMatch(accordianOptions, "ix) (?<=\bBG|\bBACKGROUND) ( \w+ | [A-Fa-f0-9]{6} ) \b", backgroundColor) ; Examples: BGWhite, BGBlack, BGTransparent, BG00FF00
	RegexMatch(accordianOptions, "ix) (?<=\bA|\bALPHA) \d+ \b", alpha)



















	; To prevent flicker, we will alternate between 2 GUI windows.
	Static guiA := true

	
    If (Top = "" and Middle = "" and Bottom = "") {
		GUIUniqueDestroy(guiKey . "A")
		GUIUniqueDestroy(guiKey . "B")
		Return
	}
	Static MyProgress
	If (Middle = "" and Bottom = "") {
		; Just update the progress
		GuiUniqueDefault(guiKey . (guiA ? "B" : "A") )
		P := Top
		GUIControl,, MyProgress, %P%
		Return
	}

	; Swap the current GUI number:
	GUIUniqueDefault(guiKey . (guiA ? "A" : "B") )
	guiA := !guiA
	
    ; Create a test window to determine the maximum Width needed for our text:
	If (Top = "" and Bottom = "")
		testText = %middle%
	Else If (Top = "")
		testText = %middle%`n%bottom%
	Else if (Bottom = "")
		testText = %top%`n%middle%
	Else
		testText = %top%`n%middle%`n%bottom%
    GUI Margin, 0, 0
    GUI Font, Bold S%fontLarge%, %FontName%
    GUI Add, Text, %textAlign%, %testText%
    ; Render and measure:
    GUI Show, Hide ; Render
    GUI +LastFound
    WinGetPos ,,,Width,Height ; Measure
    GUI Destroy
    
    
    ; Create the actual GUI:
	; Set up the window:
	If (backgroundColor = "Transparent") {
		; Makes the gui just floating text
		GUI +AlwaysOnTop +Disabled +Owner -SysMenu
		; Make it transparent:
		GUI Color, 000055, %foregroundColor%
		GUI +LastFound
		WinSet TransColor, 000055
		If (0 < alpha && alpha < 255)
			WinSet Transparent, %alpha%
		WinSet ExStyle, +0x20 ; Prevents the window from ever getting focus
		GUI -Caption
	} Else {
		GUI +AlwaysOnTop +Disabled +Owner
		GUI Color, %backgroundColor%, %foregroundColor%
		GUI +LastFound
		If (0 < alpha && alpha < 255)
			WinSet Transparent, %alpha%
		WinSet ExStyle, +0x20 ; Prevents the window from ever getting focus
		GUI -Caption
	}

    
	GUI Margin, 0,0
	; Top:
    GUI Font, Norm S%fontSmall%, %FontName%
	If Top != 
		GUI Add, Text, W%Width% %textAlign% C%foregroundColor% y+0, %top%
	; Measure the current size:
	GUI Show, AutoSize Hide
	GUI +LastFound
	WinGetPos ,,,,TopHeight
	
    ; Middle:
	GUI Font, Bold S%fontLarge%, %FontName%
		GUI Add, Text, W%Width% %textAlign% C%foregroundColor% y+0, %middle%
	
    ; Bottom:
	GUI Font, Norm S%fontSmall%, %FontName%
	If Bottom !=
		GUI Add, Text, W%Width% %textAlign% C%foregroundColor% y+0, %bottom%


    ; Render the window so we can measure it:
    GUI Show, AutoSize Hide
    GUI +LastFound
    WinGetPos, ,,realWidth,realHeight

	; Progress:
	If (progressOptions) {
		GUI Add, Progress, -Smooth Vertical X+0 Y0 H%realHeight% W20 vMyProgress %progressOptions%
		realWidth += 20
	}


    ; Figure out the position:
    If hPosition contains LEFT
        X := X - realWidth
    If hPosition contains CENTER
        X := X - realWidth/2
    If vPosition contains TOP
        Y := Y - realHeight
    If vPosition contains MIDDLE
        Y := Y - TopHeight
    
    GUI Show, AutoSize NoActivate X%X% Y%Y%, Accordian%guiKey%

	GUIUniqueDestroy(guiKey . (guiA ? "A" : "B") )
	
}








