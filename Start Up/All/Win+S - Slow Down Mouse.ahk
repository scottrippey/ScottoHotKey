;Auto-execute:
; Autohotkey script "Toggle Mouse sensitivity"
;=================================================================================
	SlowMouseSpeed      := 1	; the "slow" speed
	NormalMouseSpeed    := true ; State of Mouse pointer speed
	UserMouseSpeed      := 0    ; Speed sensed before slow down
	MouseThreshold1     := 6
	MouseThreshold2     := 10
	MouseEnhance        := 1

	;Constants:
	SPI_GETMOUSESPEED   := 0x70
	SPI_SETMOUSESPEED   := 0x71
	SPI_SETMOUSE        := 0x04 

Return

;=================================================================================
#s::
	NormalMouseSpeed := true
	toggleMouseSpeed()
	KeyWait LWin
	toggleMouseSpeed()
return

;=================================================================================
toggleMouseSpeed() {
	global
    ; SET LOW SPEED
    if( NormalMouseSpeed )
    {
        ; SENSE BEFORE
        DllCall("SystemParametersInfo", UInt,SPI_GETMOUSESPEED, UInt,0, UIntP,prevSpeed, UInt,0)
		
        ; Temporarily reduces the mouse cursor's speed.
        ; Retrieve the current speed so that it can be restored later
        DllCall("SystemParametersInfo", UInt,SPI_GETMOUSESPEED, UInt,0, UIntP,UserMouseSpeed, UInt,0)
        ; Slow down mouse speed
        DllCall("SystemParametersInfo", UInt,SPI_SETMOUSESPEED, UInt,0, UInt,SlowMouseSpeed, UInt,0)

        ; SENSE AFTER
        DllCall("SystemParametersInfo", UInt,SPI_GETMOUSESPEED, UInt,0, UIntP,currentSpeed, UInt,0)
        ShowToolTip("Your mouse is now Slow!")

        ; REMEMBER CURRENT STATE
        NormalMouseSpeed := false
    }
    ; RESTORE SPEED
    else {
        ; SENSE BEFORE
        DllCall("SystemParametersInfo", UInt,SPI_GETMOUSESPEED, UInt,0, UIntP,prevSpeed, UInt,0)

        ; Restore the original speed.
        DllCall("SystemParametersInfo", UInt, SPI_SETMOUSESPEED, UInt,0, UInt,UserMouseSpeed, UInt,0)

        ; Restore the original speed acceleration thresholds and speed
        VarSetCapacity(MySet, 32, 0) 
        InsertInteger(MouseThreshold1, MySet, 0)
        InsertInteger(MouseThreshold2, MySet, 4)
        InsertInteger(MouseEnhance   , MySet, 8)
        DllCall("SystemParametersInfo", UInt,SPI_SETMOUSE, UInt,0, Str,MySet, UInt,1) 

        ; SENSE AFTER
        DllCall("SystemParametersInfo", UInt,SPI_GETMOUSESPEED, UInt,0, UIntP,currentSpeed, UInt,0)
        ShowToolTip("Mouse Speed Restored")

        ; REMEMBER CURRENT STATE
        NormalMouseSpeed := true
    }
}
;=================================================================================
InsertInteger(pInteger, ByRef pDest, pOffset = 0, pSize = 4) {
    ; Copy each byte in the integer into the structure as raw binary data. 
    Loop %pSize%
    DllCall("RtlFillMemory", "UInt",&pDest + pOffset + A_Index-1, "UInt", 1, "UChar", pInteger >> 8*(A_Index-1) & 0xFF) 
}
