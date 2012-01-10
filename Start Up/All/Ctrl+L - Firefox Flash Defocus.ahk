
; Firefox Flash Defocus
#IfWinActive ahk_class MozillaUIWindowClass
	; ^t::
		; GoSub DefocusFlash
		; Send ^t
	; Return
		
	; ^Tab::
		; GoSub DefocusFlash
		; Send ^{Tab}
	; Return
	
	^l::
	DefocusFlash:
		WinGetPos, , , W, , A
		X=0
		Y=0
		SysGet fX, 32    ;SM_CXSIZEFRAME
		SysGet fY, 33    ;SM_CYSIZEFRAME
		SysGet cY, 4     ;SM_CYCAPTION
		SysGet mY, 15    ;SM_CYMENU
		
		; Click the address bar,
		; which we will assume to be
		; below the file menu
		; by about 20 pixels:
		X += fX + (W/2)
		Y += fY + cY + mY + 20
		Send {Click Right %X%,%Y%}{Click Left}
		;Send {Click Right %X%,%Y%}{Esc}
		;MouseMove %X%,%Y%
		;Click right
		;Send {Esc}
	Return
#IfWinActive
