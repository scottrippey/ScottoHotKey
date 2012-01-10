; Auto-execute:
	
Return

;;
;; Temporary:

; F2::
	; ToolTip Hi?
	; MultiTapProgress("Show Menu={Alt down}{Tab}|Cancel:")
; Return
; #IfWinExist ahk_class #32771 ; This is Window's Alt-Tab menu
	; ~*Enter::Send {Enter}{Alt up}
	; ~*Escape::Send {Escape}{Alt up}
; #IfWinExist




#IfWinActive ahk_class MozillaUIWindowClass
	; ^t::
		; Send c{Tab}{Sleep 30}{Home}+{End}{Tab}{Enter}{Tab 3}{Enter}
		; Sleep 3000
		; ;Send {Tab 18}
	; Return
	; ^f::
		; Send Inherit Fidelity{Tab 2}{Right}{Tab 2}{Right}{Tab}{Sleep 100}{Left}+{Tab}{Sleep 100}+{Tab}ff
		; Send {Tab 3}{Down}+{Tab}{Sleep 100}{Tab 2}{Space}
	; Return

#IfWinExist AccordianClipQueue ; Only active if the ClipQueue list is visible
	


#IfWinActive ahk_class Notepad++
; F4::
	; count++
	; If count < 514
		; count = 514
	; Send %count%{Down}{Left 3}^d{F3}
; RETURN
; #t::
	; result := CustomMessageBox("Testing CustomMessageBox", "Counting down ({time} remaining)...", " B1X-40W+40 ", "&Now {time}", "", "", 5)
	; Msgbox Messagebox Result: %result%
; Return

#IfWinActive vavi.js ; ahk_class Microsoft Visual Studio ; Visual Studio
	F5::
		IfWinExist Vavi - 
		{
			GoSub CQSuspendMonitor
			clipboard =
			Send {End} ^a^c^z^{Up 5}
			ClipWait, 1
			
			WinActivate
			Sleep 100
			Send ^l^v{Enter}
		}
	Return

#IfWinActive ahk_class Notepad
#IfWinActive



; ^a::
	; ; Wrap the highlighted text in an anchor tag that links to the current clipboard:
	; link := clipboard
	; If Not RegexMatch(link, "i)^http:")
	; {	InputBox link, No link on clipboard..., Please enter a link:, ,,,,,,,http://www..com
		; If link =
			; Return
	; }
	; wrapStart = <a href="%link%">
	; wrapEnd = ;</a> (automatically gets added)
	; GoSub WrapText
; Return
; ^b::
	; wrapStart = <strong>
	; wrapEnd = ; auto
	; GoSub WrapText
; Return
; ^i::
	; wrapStart = <em>
	; wrapEnd = ; auto
	; GoSub WrapText
; Return

	; WrapText:
	; GoSub BackupClipboard
	
		; Send ^c
		; ClipWait, 1
		; linkText := clipboard
		
		; SendInput {Raw}%wrapStart%%linkText%%wrapEnd%
	
	; GoSub RestoreClipboard
; Return





#IfWinActive
