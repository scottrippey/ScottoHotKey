; Auto-Execute:
	SmartCapsText = abc smart caps is off
Return

; This file uses ShowAccordian.ahk for its GUI
; How to use the MultiTap:

; Simple Example:
; Numpad2::MultiTap("A|B|C|2")

; Complex Example:
; Numpad0::MultiTap("Open Firefox:FF|New Tab=^t|Close Tab=^w", 1000)
; FF:
;   Run Firefox.exe
; Return
;
; Description:
; The first parameter is a list of pipe-separated commands.
; Each call to MultiTap selects the next command and resets a timer.
; The command will be sent when either the timer expires,
; or when another call to MultiTap is made with different commands.
; 
; If a command contains an = sign, then the first part is
; the "display text" and the second part is the "sent text".
; In the complex example, the 2nd command would display "New Tab" 
; but it would send "^t".
; If a command contains a :, then the first part is
; the "display text" and the second part is a subroutine to execute.
; 
; The command can also be a modifier: ^!+# = Ctrl, Alt, Shift, Win
; Modifiers can be stacked, and affect the next key sent.
MultiTapProgress(actionsList, multitapOptions = "", accordianOptions = "") {
	MultiTap(actionsList, multitapOptions, accordianOptions, true)
}
MultiTapCancel() {
	MultiTap("","","","","CANCEL")
}
MultiTapAccept() {
	MultiTap("","","","","ACCEPT")
}
; MultiTapAddModifier(mods) {
	; MultiTap(mods,"","","","ADDMODIFIER")
; }

MultiTap(actionsList, multitapOptions = "", accordianOptions = "", progressOptions = "", SpecialFunction = "") {
	; Determine the defaults for our parameters:
	multitapOptions .= " Delay400 LoopOff" ; Defaults
	; Defaults for accordianOptions:
	accordianOptions .= " GuiKeyMultiTap "
	If CanGetCaret() ; Some known programs don't properly support the Caret position.
		accordianOptions .= " XI+10 Right YI Middle " ; Default: follow the caret
	Else
		accordianOptions .= " XR Left YB Top BGWhite A200 " ; bottom right of the screen
	

	; Parse out our multitapOptions:
	RegexMatch(multitapOptions, "ix) (?<=\bDelay|\bD|\b) \d+     \b", defaultDelay)
	RegexMatch(multitapOptions, "ix) (?<=\bLoop)        (On|Off) \b", LoopOnOrOff)
		StringUpper LoopOnOrOff, LoopOnOrOff
		If LoopOnOrOff = On
			ShouldLoop := true
		Else
			ShouldLoop := false
	
	
	; turn off the timer:
	SetTimer SendQueuedCharTimer, Off

	; Use static variables (so they will be locally contained)
	Static actions := ""
	Static actionIndex = 0
	Static mods
	
	
	; See if we're supposed to Accept or Cancel
	If SpecialFunction = ACCEPT
	{	GoTo SendQueuedChar
	} Else If SpecialFunction = CANCEL
	{	actions =
		actionHotKey =
		actionMethod =
		HideAccordian(accordianOptions)
		Return
	; } Else If SpecialFunction = ADDMODIFIER
	; {	Loop, parse, actionsList
		; {	IfInString mods, %A_LoopField%
				; StringReplace mods, mods, %A_LoopField%, , All ; Remove the mod
			; Else
				; mods .= A_LoopField ; Add the mod
		; }
		; Return
	}
	
	; Determine if we have any modifiers
	modText =
	IfInString mods, #
		modText .= "Win+"
	IfInString mods, ^
		modText .= "Ctrl+"
	IfInString mods, !
		modText .= "Alt+"
	IfInString mods, +
		modText .= "Shift+"
	
	
	
	; Determine if this is the same actionsList as before, or if it is different/new
	If (actions != actionsList) {
		; The lists are different, so send the last item,
		; and then advance to the first item
		If (actionIndex != 0)
			GoSub SendQueuedChar

		actions := actionsList
		actionIndex = 1
	} else {
		; The lists are the same, so advance to the next item:
		actionIndex++
	}
	
	; Break apart our actions list:
	StringSplit actions, actions, |`n`;, %A_Space%%A_Tab%`r
	actionsCount := actions0

	; Loop around if we've reached the end of the actions
	If (actionIndex > actionsCount) {
		If (ShouldLoop) {
			actionIndex = 1 ; (loop)
		} else {
			actions =
			actionHotKey =
			actionMethod =
			HideAccordian(accordianOptions)
			Return
		}
	}
	
	
	; Display a GUI:
	Top =
	Middle =
	Bottom =
	Loop %actionsCount%	{

		; First, break down our actionsList:
		
		If actions%A_Index% !=
		{	If Not RegexMatch(actions%A_Index%, "x)  (?<Title>.[^:=,]*)  (?:  [:,](?<Method>[^,]*)  |  [=](?<Hotkey>[^,]*)  |  )  (?:,(?<Delay>\d+))?  ", actions%A_Index%) 
			{	MsgBox % "'" . actions%A_Index% . "' is not in the correct format for MultiTap!`nActions List: `n" . Actions 				;%;%;%;%
				Return
			}
		}
		If actions%A_Index%Delay =
			actions%A_Index%Delay := defaultDelay
			
		; Determine the title:
		If actions%A_Index%Method = 
		{	; It's a hotkey
			If actions%A_Index%Hotkey =
			{	; Since there is no Hotkey, we will use the Title
				; Determine if the hotkey should be upper or lower case:
				If GetKeyState("Capslock", "T")	{
					StringUpper actions%A_Index%Title, actions%A_Index%Title
				} Else {
					StringLower actions%A_Index%Title, actions%A_Index%Title
				}
				If (SmartCapsStatus = 1) {
					StringUpper actions%A_Index%Title, actions%A_Index%Title
				}
			}
			
			title := mods . actions%A_Index%Title
		} Else { ; It's a method, so don't add modifiers:
			title := actions%A_Index%Title
		}

			
			

		; Now build our GUI:
			
		; Skip empty items (they're used as spacers)
		If actions%A_Index% =
		{	if (A_Index = actionIndex)
				actionIndex++
			title =
		}
		If (A_Index < actionIndex) {
			If A_Index != 1
				Top .= "`n"
			Top .= title
		} Else If (A_Index = actionIndex) {
			Middle := title
		} Else {
			If (A_Index != actionIndex+1)
				Bottom .= "`n"
			Bottom .= title
		}
	}
	
	; Display the GUI:
	ShowAccordian(Top, Middle, Bottom, accordianOptions, progressOptions)
	
	
	
	
	; Set the countdown timer:
	Static interval 
	interval = 20
	Static smallDelayTotal
	Static smallDelayCount
	smallDelayTotal := actions%actionIndex%Delay // interval + 1
	smallDelayCount := smallDelayTotal
	interval -= 3
	SetTimer SendQueuedCharTimer, %interval%

	Static actionMethod, actionHotkey
	actionMethod := actions%actionIndex%Method
	actionHotkey := actions%actionIndex%HotKey
	If actionHotKey =
		actionHotKey := actions%actionIndex%Title
		
		
;Return

	
	
	SendQueuedCharTimer:
		smallDelayCount--
		ShowAccordianProgress(100 * smallDelayCount / smallDelayTotal, accordianOptions . " GuiKeyMultiTap ")
		If (smallDelayCount > 0)
			Return
		HideAccordian(accordianOptions . " GuiKeyMultiTap ")
		SetTimer SendQueuedCharTimer, Off
	SendQueuedChar:
		If (actionMethod != "") {
			SetTimer %actionMethod%, -50
		} else if InStr("^!+#", actionHotKey) {
			IfInString mods, %actionHotKey%
				StringReplace mods, mods, %actionHotKey%, , All ; Remove the control character
			Else
				mods .= actionHotKey ; Add the control character
		} else if (actionHotKey != "") {
			; If GetKeyState("Capslock", "T")
				; StringUpper actionHotKey, actionHotKey
			; Else
				; StringLower actionHotKey, actionHotKey
		   
			Send %mods%%actionHotKey%
			mods =
			GoSub UpdateSmartCapsStatus
		}
		actions =
		actionHotKey =
		actionMethod =
		HideAccordian(accordianOptions . " GuiKeyMultiTap ")
	Return
	
	
	Static SmartCapsMode = 1
	Static SmartCapsStatus = 1
	Global SmartCapsText
	ToggleSmartCaps:
		SmartCapsMode++
		If SmartCapsMode > 1
			SmartCapsMode = 0
		SmartCapsStatus := SmartCapsMode
	; DebugBreak("B", "SmartCapsMode")	
		; Fall-through:
	UpdateSmartCapsText:
		If SmartCapsMode = 0
			SmartCapsText = Abc Smart Caps Is On
		; Else If SmartCapsMode = 1
			; SmartCapsText = ABC ALL CAPS IS ON
		; Else If SmartCapsMode = 2
		Else If SmartCapsMode = 1
			 SmartCapsText = abc smart caps is off
	Return
	UpdateSmartCapsStatus:
		If SmartCapsMode = 0 ; Disabled
		{	SmartCapsStatus = 0
			Return
		}
		; If InStr("{Enter}`r`n{Space} {Escape}{BackSpace}.,;!?#$%^&*()[]{}\/-+=", actionHotKey) ; See if the Hotkey is a word separator
		If RegexMatch(actionHotKey, "^[\w\d]$")
			SmartCapsStatus = 0
		Else
			SmartCapsStatus = 1
		; GoSub UpdateSmartCapsText
	Return
	
}
	
	
	
	
; This function will return False if the current application
; is known not to report Caret position correctly.
CanGetCaret() {
	IfWinActive ahk_class MozillaUIWindowClass
		Return false
	IfWinActive Microsoft Word
		Return false
		
	Return true
}

#IfWinExist AccordianMultiTap

NumpadEnter::
Enter::
	MultiTapAccept()
Return

BackSpace::
Esc::
	MultiTapCancel()
Return
	
#IfWinExist
	
	
	
	
	
	
	
	
	
	
	
	
	
	
