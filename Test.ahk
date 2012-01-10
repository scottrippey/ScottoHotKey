#SingleInstance Force


^r::Reload
Space::Send {Enter}
!Space::Send {Space}

#IfWinActive ahk_class Chrome_WidgetWin_0
;LButton::Send ^{LButton}
;^LButton:Send {LButton}
RButton::Send {RButton}{Sleep 50}{Down 4} ;{Enter}
Del::Send ^{F4}
Right::Send ^{Tab}
Left::Send ^+{Tab}
	

; GoSub AutoRun
; #Include C:\Users\Scott\Shared Stuff\AutoHotKey\Utilities\AutoReload.ahk


; ^t::
; AutoRun:
; ; ****************************
; ; Insert your test code here:
; ; ****************************





; Return




; ; ; Test how "closure" works in a function:

; ; TestFunc("hello")
; ; TestFunc("what?")
; ; TestFunc("scott")

; ; Return

; ; TestFunc(param1) {
	; ; SetTimer TestFuncLabel, -100
	
	
	; ; static sparam1
	; ; sparam1 := param1
	
	; ; Return
	
	; ; TestFuncLabel:
		; ; MsgBox sparam1: %sparam1%
	; ; Return

; ; }


; ; ****************************
; ; ****************************
; ; ****************************


; #Include C:\Users\Scott\Shared Stuff\AutoHotKey\Start Up\#Includes\GUIUniqueDefault().ahk

