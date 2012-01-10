
#IfWinActive Color ahk_class #32770
^v::
	clipValue := Clipboard
	R := ((clipValue & 0xff0000) // 0x010000) & (0xff)
	G := ((clipValue & 0xff00) // 0x0100) & (0xff)
	B := ((clipValue & 0xff) // 0x01) & (0xff)
	
	ControlFocus Edit3
	SendInput {Raw}`t%R%`t%G%`t%B%
Return 

^c::
	GoSub BackupClipboard
	
	clipboard =
	ControlFocus Edit3
	Send {Tab}^c
	ClipWait 1
	R := clipboard
	clipboard =
	Send {Tab}^c
	ClipWait 1
	G := clipboard
	clipboard =
	Send {Tab}^c
	ClipWait 1
	B := clipboard
	
	GoSub RestoreClipboard
	
	clipboard := ((R * 0x010000) + (G * 0x0100) + (B * 0x01))
Return
	

#IfWinActive
