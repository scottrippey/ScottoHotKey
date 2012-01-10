
;When you press Ctrl-F2, this will add the date to the folder name

;Better Rename functionality:
;Highlights the filename, not extension.
;Example:  "filename.txt" F2 -> "|filename|.txt"
#IfWinActive ahk_group AllExplorer
^F2::
	Send {F2}
	Sleep 100
	Send {Home}
	Send %A_YYYY% %A_MM%-%A_DD%{Space}
	Send +{Home}
return
; ^Backspace::
	; GoSub BackupClipboard
	; Send {F2}
	; Sleep 100
	; Send ^c
	; ClipWait 1
	; clip := clipboard
	; count := InStr(clip, "[") - 2
	; SendInput {Left}{Right}^+{Home}+{Right %count%}{Backspace}
	; GoSub RestoreClipboard
	
; Return

#IfWinActive
