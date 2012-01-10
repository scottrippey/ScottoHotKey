
;Region " Functions "

	AddHistory(newItem) { ;Region
		; global f3History1, f3History2, f3History3, f3History4, f3History5
		; f3HistoryCount := 5
		; ; Se iff this item already exists, or add it to the stack:
		; Loop, %f3HistoryCount%
		; {
			; If (newItem = f3History%A_Index%) {
				; If (A_Index = 1)
					; break
				; Else {
					; ; Swap the first item with this item
					; swap := f3History1
					; f3History1 := f3History%A_Index%
					; f3History%A_Index% := swap
					; break
				; }
			; } Else If (A_Index = f3HistoryCount) {
				; ; The new item isn't contained in our list, so move all items down
				; Loop, %f3HistoryCount%
				; {	
					; bIndex := f3HistoryCount - A_Index + 1
					; aIndex := f3HistoryCount - A_Index
					; If (aIndex = 0)
						; f3History1 := newItem
					; Else
						; f3History%bIndex% := f3History%aIndex%
				; }
			; }
		; }

		; global f3History
		; f3History =
		; Loop %f3HistoryCount%
		; {	display := f3History%A_Index%
			; If display =
				; continue
			; display := RegexReplace(display, "[=:,\r\n]", "_")
			; ; StringReplace display, display, `,, `_, All
			; ; StringReplace display, display, =, `_, All
			; ; StringReplace display, display, :, `_, All
			; ; StringReplace display, display, `r`n, `_, All
			; ; StringReplace display, display, `n, `_, All
			; If (StrLen(display) > 20)
				; display := SubStr(display, 1, 20) . "..." ; maximum of 20 chars
			; f3History = %f3History%|Find "%display%":SendF3History%A_Index%,1000
		; }
	} ;EndRegion

	SendF3History: ;Region
		; Send ^f
		; SendInput {RAW}%toSend%
		; Send {Enter}
		; Send {Esc}
	; Return
	; SendF3History1:
		; toSend := f3History1
		; GoTo SendF3History
	; SendF3History2:
		; toSend := f3History2
		; GoTo SendF3History
	; SendF3History3:
		; toSend := f3History3
		; GoTo SendF3History
	; SendF3History4:
		; toSend := f3History4
		; GoTo SendF3History
	; SendF3History5:
		; toSend := f3History5
		; GoTo SendF3History
	;EndRegion
		
;EndRegion

;Region " Visual Studio Shortcut "
	;----------------------------------------------
	;Visual Studio Shortcut:
	;----------------------------------------------
	#IfWinActive Microsoft Visual Studio
	F3::PressAndHold("F3", "={F3},500|Ctrl+F3:VSCtrlF3,1000|(Nevermind)=,0")
	VSCtrlF3:
	^F3::
		; GoSub BackupClipboard
		; SendInput ^c
		
		SendInput ^f
		Sleep 10
		SendInput !l{Home} ; Current Document
		SendInput {Enter}{Esc}
		SendInput +{F3}

		; ClipWait 1
		; ; Add the history item:
		; AddHistory(clipboard)

		; GoSub RestoreClipboard
	Return
;EndRegion

;Region " Expression Web "
	;----------------------------------------------
	;Expression Web Shortcut:
	;----------------------------------------------
	#IfWinActive ahk_class FrontPageExplorerWindow40
	F3::PressAndHold("F3", "={F3},500|Ctrl+F3:EWCtrlF3,1000|(Nevermind)=,0")
	EWCtrlF3:
	^F3::
		; GoSub BackupClipboard
		; Send ^c
			
		Send +^{F3}
		Send ^{F3}
		
		; ClipWait 1
		; ; Add the history item:
		; AddHistory(clipboard)
		; GoSub RestoreClipboard
	Return
;EndRegion

;Region " Notepad++ "
	;----------------------------------------------
	;Notepad++ Shortcut:
	;----------------------------------------------
	#IfWinActive ahk_class Notepad++

	F3::PressAndHold("F3", "={F3},500|Ctrl+F3:NPPCtrlF3,1000|(Nevermind)=,0")
	NPPCtrlF3:
	^F3::
		; GoSub BackupClipboard
		
		Send ^f
		Sleep 10
		; Send ^c
		Send {Enter}
		Send {Esc}
		Send +{F3}

		; ClipWait 1
		; AddHistory(clipboard)
		; GoSub RestoreClipboard
	Return
;EndRegion

;Region " Notepad "
	;----------------------------------------------
	;Notepad Shortcut:
	;----------------------------------------------
	#IfWinActive ahk_class Notepad

	F3::PressAndHold("F3", "={F3},500|Ctrl+F3:NCtrlF3,1000|(Nevermind)=,0")
	NCtrlF3:
	^F3::
		GoSub BackupClipboard
		
		Send ^c^f^v
		; ClipWait 1
		; ; Add the history item:
		; AddHistory(clipboard)
		
		Send !u{Enter} ; Search UP
		Sleep 50
		IfWinActive Notepad ; Cannot find
			Send {Esc}
			
		Send !d{Enter} ; Search Down
		Sleep 50
		IfWinActive Notepad ; Cannot find
			Send {Esc}
		Send {Esc}
		
		GoSub RestoreClipboard
	Return

;EndRegion

;Region " Toad "
	#IfWinActive Toad for SQL Server 
	
	F3::PressAndHold("F3", "={F3},500|Ctrl+F3:ToadCtrlF3,1000|(Nevermind)=,0")
	ToadCtrlF3:
	^F3::
		; Add the history item:
		; GoSub BackupClipboard
		; Send ^c
		
		; Find and then go back:
		Send ^f
		Sleep 10
		Send {Enter}
		Send {Esc}
		Send +{F3}

		; ClipWait 1
		; AddHistory(clipboard)
		; GoSub RestoreClipboard
	Return
	
	#IfWinActive

;EndRegion

;Region " Excel "
#IfWinActive ahk_class XLMAIN ; Excel
	F3::Send ^f{Enter}{Esc}
;EndRegion



#IFWinActive
