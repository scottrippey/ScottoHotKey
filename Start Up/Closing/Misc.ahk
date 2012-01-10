; auto-execute:'
	; RegisterTool("ShowEZTTTool", "&EZTT Tool", "Helps format text to insert into EZTT")
Return


#IfWinActive Microsoft Excel - Hours.xlsx
	^!Ins::
		; Duplicate 7 rows
		date := SmartFormat("{A_Now:M/d}")
		Send {Right}{Left}+{Space}+{Down 7}^{Insert}^+{=}{Left}{Right 2}
		Send %date%
		Send +{Right 4}!h!f!i!s{Enter}{Left}{Right}{Down 2}+{Down}+{Right 4}
	Return
	^t::
		; Insert the current time:
		time := SmartFormat("{A_Now:h:mm}")
		Send {Delete}{F2}%time%+{Left 2}
	Return
	
	^c::
		GoSub ClearClipboard
		Send ^c
		ClipWait, 1
		clip := clipboard

		clip := RegexReplace(clip, "i)\t", "{Right}")

		clipboard := clip
		GoSub AppendClipboard
		GoSub ShowClipQueueWindow
	Return
#IfWinActive


