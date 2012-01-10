;Better Rename functionality:
;Highlights the filename, not extension.
;Example:  "filename.txt" F2 -> "|filename|.txt"
#IfWinActive ahk_group AllExplorer
~F2:: 
	GoSub BackupClipboard
	clipboard =
	Send ^c
	ClipWait 1
	clip := Clipboard
	
	If (RegexMatch(clip, "i)^(Copy of |Shortcut to )+(.+)", fileName)) {
		clip := filename2
		clipboard := filename2
		Send ^v^{Home}^+{End}
	}
	
	; Highlight just the filename:
	StringGetPos ExtensionPos, clip, ., R
	if (ExtensionPos != -1)	{
		Position := StrLen(clip) - ExtensionPos
		SendInput +{Left %Position%}
	}
	GoSub RestoreClipboard
Return

#IfWinActive
