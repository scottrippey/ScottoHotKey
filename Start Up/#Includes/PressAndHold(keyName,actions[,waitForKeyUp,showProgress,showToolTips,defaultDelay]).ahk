; Actions format:
; Title {:Method | =Hotkey} [, DelayMS ]  
; [ { | or ; or `n } ... ]
;
; Sample Code:
; CapsLock::
;	CapsLockActions = 
;	(ltrim comments
;		Press Enter={Enter}
;		Caps Lock:ToggleCapsLock,500
;		Cancel:
;	)
; OR:
;	CapsLockActions := "Press Enter={Enter}|Caps Lock:ToggleCapsLock|Cancel:"
;
;
; PressAndHold("CapsLock",CapsLockActions)
; Return


PressAndHold(KeyName, Actions, WaitForKeyUp = True, ShowProgress = True, ShowToolTips = True, DefaultDelay = 1000)
{
	; Break apart our Actions list:
	StringSplit Actions, Actions, |`n`;, %A_Space%%A_Tab%`r
	actionsCount := Actions0
	Loop %actionsCount%	{
		item := Actions%A_Index%
		If Not RegexMatch(item, "x)  (?<Title>[^:=,]*)  (?:  [:,](?<Method>[^,]*)  |  [=](?<Hotkey>[^,]*)  |  )  (?:,(?<Delay>\d+))?  ", item%A_Index%) {
			MsgBox "%item%" is not in the correct format for PressAndHold!`nActions List: `n%Actions%
			Return
		}
	}
	
	timePassed 	= 0
	actionIndex := 0
	
	;nextTitle =
	nextMethod =
	nextHK =
	
	
	Loop ; Keep looping as long as the button is held down
	{
		actionIndex++
		allActionTitles = 
		; Let's create a list of all actions:
		Top =
		Middle =
		Bottom =
		Loop %actionsCount%
		{
			itemTitle := item%A_Index%Title
			itemDelay := item%A_Index%Delay
			if (itemDelay = "") {
				;msgbox new delay %defaultDelay%
				itemDelay := defaultDelay
			}
			
			if (A_Index < actionIndex) {
				If (itemTitle != "") {
					If (Top != "")
						Top := Top . "`n"
					Top := Top . itemTitle
				}
			} else if (A_Index = actionIndex) {
				; This is the current item
				Middle := itemTitle
				
				title := itemTitle
				delayMS := itemDelay
				; method := itemMethod
				; hk := itemHotkey
				; delayMS := itemDelay
			} else if (A_Index = actionIndex+1) {
				;This is the next item
				Bottom := itemTitle
				; nextDelayMS := itemDelay
				; nextTitle := itemTitle
				; nextMethod := itemMethod
				; nextHK := itemHotkey
			} else {
				If (itemTitle != "")
					Bottom := Bottom . "`n" . itemTitle
			}
		}
		
		;Display our Progress Window:
		if (actionIndex > 0 And ShowProgress = True and title != "") {
			If (Top != "")
				Top = %Top%`n
			If (Bottom != "")
				Bottom = `n%Bottom%
			allActionTitles = %Top%>>> %Middle% <<<%Bottom%
			Progress ZX0 ZY0 B R0-%delayMS%, %allActionTitles%, %title%
			;progressOptions = Range0-%delayMS% P%delayMS%
			;ShowAccordian(Top, Middle, Bottom,12,40,"XC YC", "Left", "Middle", "Black", "Transparent", progressOptions)
		}
		if (actionIndex > 0 and ShowToolTips = True and title != "") {
			ToolTip %title%?
		}
		
		;Now, let's delay for the specified time or until the key is up:
		Loop {
			If (delayMS <= 0) { ; time elapsed; next item
				;actionIndex++
				Break ; time is up
			}
			
			GetKeyState keyState, %KeyName%,P
			if (keyState = "U")
				Break ; key is up
			
			if (actionIndex > 0 and ShowProgress = True and title != "") {
				; Update the progress:
				Progress %delayMS%
				;ShowAccordianProgress(delayMS)
			}
			
			delayMS -= 20
			Sleep 20
		}
		
		;There are 2 ways to exit: if the key is up, 
		; or if the actionIndex is the last one.
		If (delayMS > 0) { ; The key was released!
			Progress Off
			;HideAccordian()
			ToolTip 
			GoTo ExecuteTheMethod
		} Else If (actionIndex >= actionsCount)	{ ; We passed all actions, so do the last one!
			actionIndex := actionsCount
			title := item%actionsCount%Title
			If (WaitForKeyUp = True And ShowProgress = True) {
				Progress 0, %Top%>>> %Middle% <<<%Bottom%, (please release %KeyName%)
				;ShowAccordian(Top, Middle, "(please release " . KeyName . ")")
				KeyWait %KeyName%
			}
			
			Progress Off
			;HideAccordian()
			ToolTip 
			GoTo ExecuteTheMethod
		}
	}
	ExecuteTheMethod:
		method := item%actionIndex%Method
		hk := item%actionIndex%Hotkey
		if (method != "") {
			GoSub %method%
		} else if (hk != "") {
			Send %hk%
		} else {
			; Cancel
			ToolTip (%KeyName% Cancelled)
			SetTimer RemoveToolTip, 1000
		}
	Return
	RemoveToolTip:
		ToolTip ,
		SetTimer RemoveToolTip, Off
	Return
}
