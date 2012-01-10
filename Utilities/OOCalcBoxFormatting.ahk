#SingleInstance Force
GoTo AutoExecute
^r::
	Send ^s
	ToolTip Reloading Test...
	Sleep 500
	ToolTip
	Reload
Return
; Temporary Hotkeys:
AutoExecute:





Return


#IfWinActive ahk_class SALFRAME ; OpenOffice Calc
^b::
	Send {AppsKey}f
	WinWait Format Cells
	WinActivate
	Send {Click,  66, 111} ; Outer Borders
	Send {Click, 265, 174} ; 2.50 pt
	Send {Click,  97, 186} ; Inner Border
	Send {Click, 265, 128} ; 0.05 pt
	Send {Enter}
	;Send {Click, 265, 158} ; 1.00 pt
Return
^+b::
	Send {AppsKey}f
	WinWait Format Cells
	WinActivate
	Send {Click,  66, 111} ; Outer Borders
	Send {Click, 265, 174} ; 2.50 pt
	;Send {Click,  97, 186} ; Inner Border
	;Send {Click, 265, 128} ; 0.05 pt
	;Send {Enter}
Return

; !e:: ;up
	; border = TOP
	; GoTo SetBorders
; !f:: ;right
	; border = RIGHT
	; GoTo SetBorders
; !c:: ;down
	; border = BOTTOM
	; GoTo SetBorders
; !s:: ;left
	; border = LEFT
	; GoTo SetBorders
; !d:: ; Around
	; border = AROUND
	; GoTo SetBorders
; SetBorders:


; ; ahk_class SALSUBFRAME ; Borders
	; Click 709, 104 ; Borders
	; Sleep 1000
	; If border = LEFT
		; Click 735, 125 ; Left
	; If border = RIGHT
		; Click 760, 125 ; Right
	; If border = TOP
		; Click 710, 155 ; Top
	; If border = BOTTOM
		; Click 735, 155 ; Bottom
	; If border = AROUND
		; Click 785, 155 ; Around
	; If border = ALL
		; Click 785, 185 ; All

; Return



