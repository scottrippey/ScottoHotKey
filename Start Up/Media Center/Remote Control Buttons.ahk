
;Region " Firefox "

#IfWinActive ahk_class MozillaUIWindowClass ; (Firefox)
	!F4::Send ^{F4}
	NumpadAdd::Send {WheelUp 2}
	NumpadSub::Send {WheelDown 2}

	Esc::Send {MButton}
	sc130::Send ^{NumPadAdd} ; Volume Up => Zoom +
	sc12E::Send ^{NumPadSub} ; Volume Down => Zoom -
	
;EndRegion

;Region " Global "
; Remap some of the Media buttons:
#IfWinNotActive ahk_class eHome Render Window ; (Media Center)

	; Remap volume controls:
	sc130::Send {Tab} ; Volume Up => Tab
	sc12E::Send +{Tab} ; Volume Down => Shift+Tab
	; Scroll wheel:
	NumpadAdd::Send {WheelUp}
	NumpadSub::Send {WheelDown}

;EndRegion

;Region " Shift + Arrow Shortcuts "

#IfWinActive ahk_group AllExplorer ; (Explorer, Desktop, etc)
	sc122::
		; Pause => Toggle Shift
		ToggleShift := !ToggleShift
		ShowToolTip("Toggle Shift " . (ToggleShift ? "On" : "Off"), 3000)
	Return
	Up::Send % ToggleShift ? "+{Up}" : "{Up}"
	Down::Send % ToggleShift ? "+{Down}" : "{Down}"
	Left::Send % ToggleShift ? "+{Left}" : "{Left}"
	Right::Send % ToggleShift ? "+{Right}" : "{Right}"

#IfWinActive µTorrent
	sc122::
		; Pause => Toggle Shift
		ToggleShift := !ToggleShift
		ShowToolTip("Toggle Shift " . (ToggleShift ? "On" : "Off"), 3000)
	Return
	Up::Send % ToggleShift ? "+{Up}" : "{Up}"
	Down::Send % ToggleShift ? "+{Down}" : "{Down}"
	Left::Send % ToggleShift ? "+{Left}" : "{Left}"
	Right::Send % ToggleShift ? "+{Right}" : "{Right}"
	
;EndRegion

;Region " Media Center "

#IfWinActive ahk_class eHome Render Window ; (Media Center)
	!F4::
		actions =
		(ltrim comments
			;Switch=!{Esc}
			Minimize:Minimize
			Restore=!{Enter}
			Close Media Center=!{F4}
			Task Manager=^+{Esc}
		)
		MultiTapProgress(actions, 1000)
		;PressAndHold("F4", actions)
	Return
	MCRestoreMinimize:
		; Determine if MC is maximized or windowed:
		;WinGet mcMinMax, MinMax, A ;This doesn't work for MC
		WinGetPos x,y,w,h, ahk_class eHome Render Window
		;SysGet, m, MonitorPrimary
		;If (x = mLeft AND y = mTop)
		If (x = 0 and y = 0)
			mcMinMax = 1 ; Maximized
		Else
			mcMinMax = 0 ; Windowed
		
		; Toggle Max/Win/Min:
		If (mcMinMax = 1) { ; MC is maximized
			Send !{Enter} ; Windowed mode
		} Else If (mcMinMax = 0) { ; MC is windowed
			WinMinimize ahk_class eHome Render Window
		; } Else {
			; WinRestore ; (don't think this is possible)
		}
; msg =
; (ltrim
; mcMinMax:%mcMinMax%
; Win: %x%, %y%, %w%x%h%
; Mon: %mLeft%,%mTop%, %mRight%, %mBottom%
; )
; ShowToolTip(msg, 10000)
	Return
	; ; Remote {#} is sent as !3!5:
	; !NumPad3::Return
	; !NumPad5::Send ^w

;EndRegion
	
#IfWinActive
