;;;Summary 
;;; Displays a custom message box to a user, with an optional countdown.
;;; 
;;; Options:
;;;  Default[123] - Sets a button to be default
;;;  B[123]X[+-]###W[+-]### - Adjusts the position and width of a button
;;; Button text:
;;;  Can contain "{Time}" to represent the countdown
;;;  Leave blank to hide button
;;;
;;; Returns which button was pressed (1, 2, or 3);
;;;  if the timeout is reached, returns 4, or the first button that contains "{Time}"
;;;EndSummary
CustomMessageBox(title, message, options, button1Text, button2Text = "", button3Text = "", timeout = "") {
	
	options .= " Default1 B1X+0W+0 B2X+0W+0 B3X+0W+0 "
	
	SetTimer ChangeCountdownButtonNames, 50
	
	RegexMatch(options, "ix) (?<= \b DEFAULT ) [123] \b ", defaultButton)
	
	; Determine which message box to show:
	; Note: unfortunately we can't use a variable for the first MsgBox parameter,
	;       so we have to hard-code several different options:
	If defaultButton = 1
	{	If (button2Text = "" AND button3Text = "") 	; OK
			MsgBox 0x1040, %title%, %message%, %timeout%
		Else If (button3Text = "") 					; OK / Cancel
			MsgBox 0x1041, %title%, %message%, %timeout%
		Else 										; Yes / No / Cancel
			MsgBox 0x1043, %title%, %message%, %timeout%
	}
	Else If defaultButton = 2
	{	If (button2Text = "" AND button3Text = "") 	; OK
			MsgBox 0x1140, %title%, %message%, %timeout%
		Else If (button3Text = "") 					; OK / Cancel
			MsgBox 0x1141, %title%, %message%, %timeout%
		Else 										; Yes / No / Cancel
			MsgBox 0x1143, %title%, %message%, %timeout%
	}
	Else If defaultButton = 3
	{	If (button2Text = "" AND button3Text = "") 	; OK
			MsgBox 0x1240, %title%, %message%, %timeout%
		Else If (button3Text = "") 					; OK / Cancel
			MsgBox 0x1241, %title%, %message%, %timeout%
		Else 										; Yes / No / Cancel
			MsgBox 0x1243, %title%, %message%, %timeout%
	}



	SetTimer ChangeCountdownButtonNames, off
	SetTimer UpdateCountdownButtonNames, off
	
	; Return the index of the selected button:
	IfMsgBox TimeOut
	{	; Figure out which button was default, and return that value:
		IfInString button1Text, {Time}
			Return 1
		IfInString button2Text, {Time}
			Return 2
		IfInString button3Text, {Time}
			Return 3
		Return 4
	}
	If button3Text !=
	{	; It was a Yes/No/Cancel:
		IfMsgBox Yes
			Return 1
		IfMsgBox No
			Return 2
		Return 3
	}
	IfMsgBox Ok
		Return 1
	Return 2
	
	ChangeCountdownButtonNames:
		IfWinNotExist %title%
			return  ; Keep waiting another 50 ms
		SetTimer ChangeCountdownButtonNames, off
		SetTimer UpdateCountdownButtonNames, 1000

		; Analyze the options:
		
		; ; Set the default focused button:
		; RegexMatch(options, "ix) (?<= \b FOCUS ) [123] \b ", defaultButton)
		; ControlFocus, Button%defaultButton%
		
		; Set the width of each button:
		offset := 0
		Loop, 3
		{
			index := 4 - A_Index
			If Not RegexMatch(options, "ix) B" . index . "  ([XW][+-]?\d+)+  \b ", buttonSize)
				continue
			RegexMatch(buttonSize, "ix) (?<=X)  [+-]?\d+ ", buttonX)
			RegexMatch(buttonSize, "ix) (?<=W)  [+-]?\d+ ", buttonWidth)
			
			ControlGetPos, X,,W,,Button%index%
			If (RegexMatch(buttonWidth, "[+-]")) ; The width is relative.  Example: B1W+50 adds 50 pixels to the width
				buttonWidth += W
			If (RegexMatch(buttonX, "[+-]")) ; X is relative
				buttonX += X
			ControlMove, Button%index%, %buttonX%,,%buttonWidth%
		}


		firstRun := true
	UpdateCountdownButtonNames:
		IfWinNotExist %title%
			return
		
		; Update the button texts:
		global time
		time := TimeFromSeconds(timeout)

		If (InStr(button1Text, "{") OR (firstRun AND button1Text != ""))
		{
			controlText := SmartFormat(button1Text)
			ControlSetText Button1, %controlText%
		}
		If (InStr(button2Text, "{") OR (firstRun AND button2Text != ""))
		{
			controlText := SmartFormat(button2Text)
			ControlSetText Button2, %controlText%
		}
		If (InStr(button3Text, "{") OR (firstRun AND button3Text != ""))
		{
			controlText := SmartFormat(button3Text)
			ControlSetText Button3, %controlText%
		}
		IfInString message, {
		{
			controlText := SmartFormat(message)
			ControlSetText Static2, %controlText%
		}
		firstRun := false
		If timeout =
		{
			SetTimer UpdateCountdownButtonNames, Off
			Return
		}
		timeout--
	return
}


; SetButtonNames Usage:
; Call SetButtonNames immediately before creating a messagebox.  It will run once, setting the button names.
; Example:
;   SetButtonNames("Example", "Yep", "Nope", "Nevermind")
;   MsgBox 0x0003, Example, Does it?
SetButtonNames(title, button1, button2 = "", button3 = "") {
		static t, b1, b2, b3
		t := title
		b1 := button1
		b2 := button2 
		b3 := button3
		SetTimer _SetButtonNames, 50
	Return
	_SetButtonNames:
		IfWinNotExist %t% ahk_class #32770
			Return
		SetTimer _SetButtonNames, Off
		If b1 !=
			ControlSetText Button1, %b1%
		If b2 !=
			ControlSetText Button2, %b2%
		If b3 !=
			ControlSetText Button3, %b3%
	Return
}
