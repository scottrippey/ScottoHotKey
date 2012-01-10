; auto-execute:'
	; RegisterTool("ShowEZTTTool", "&EZTT Tool", "Helps format text to insert into EZTT")
	ToadCommand = 
Return

#IfWinActive Toad

	#HotString b0
	; Capture SQL commands:
	::SELECT ::
		Send {Space}
		ToadCommand = SELECT
	Return
	::JOIN ::
		Send {Space}
		ShowToolTip("Select an item and press Enter")
		ToadCommand = JOIN
	Return
	::EXEC ::
		Send {Space}
		ShowToolTip("Select an item and press Enter")
		ToadCommand = EXEC
	Return
	::INSERT INTO ::
		Send {Space}
		ShowToolTip("Select an item and press Enter")
		ToadCommand = INSERT INTO
	Return
	::IF OBJ::
		Send JECT_ID
		Send +{Left 6}
		ShowToolTip("Press Enter to autocomplete")
		ToadCommand = IF OBJECT_ID
	Return
	
	; Clear SQL Command:
	Esc::
		If ToadCommand =
			Send {Esc}
		Else
			ShowToolTip("ToadCommand '" . ToadCommand . "' cleared")
		ToadCommand =
	Return
	
	; Execute custom logic after a SQL Command:
	Enter::
		If ToadCommand =
		{
			Send {Enter}
			Return
		} 
		Else if ToadCommand = SELECT
		{
			ToadCommand = 
		}
		Else If ToadCommand = JOIN
		{
			Send {Enter}
			Send {Home}^{Right}^+{Right 3}+{Left}^f{Enter}{Esc}+{F3}
			ToadCommand = JOIN2
		} 
		Else If ToadCommand = JOIN2
		{
			InputBox alias, Type an Alias
			If alias =
				Return
			Send {Right} %alias%{F3}%alias%{End}
			ToadCommand = 
		}
		Else If ToadCommand = EXEC
		{
			GoSub ClearClipboard
			Send {Enter}{Esc}+{End}^c
			ClipWait 1
			; Count the number of commas:
			StringSplit, splits, clipboard, `,
			splits0--
			Send {Left}{Enter}{Space 2}^{Right} = null
			Loop %splits0%
			{
				Send {Enter}{Right 2}^{Right} = null
			}
			ToadCommand = 
		}
		Else If ToadCommand = INSERT INTO
		{	
			Send {Enter}{Space}
			ToadCommand = INSERT INTO2
			ShowToolTip("Select an item and press Enter")
		}
		Else If ToadCommand = INSERT INTO2
		{
			Send {Enter}{Up 2}+{Up 8}
			ToadCommand = INSERT INTO3
			ShowToolTip("Select the insert columns and press Enter")
		}
		Else If ToadCommand = INSERT INTO3
		{
			GoSub ClearClipboard
			Send ^c
			ClipWait 1
			; Count the number of commas:
			StringSplit, splits, clipboard, `,
			Send {Up}{End}^{Delete}{End}
			splits0--
			Loop %splits0%
			{
				Send ^{Delete}{End}
			}
			Send ^{Delete}^{Right}{Enter}{Down}^{Right 2}
			ToadCommand = 
		}
		Else If ToadCommand = IF OBJECT_ID
		{
			InputBox name, Type the name of the object:
			If name =
				Return
			Send {End}('%name%') IS NOT NULL{Enter}    DROP PROCEDURE %name%
			Send {Home}^{Right}+^{Right}
			ToadCommand =
		}
		
	Return
	
	#HotString b

#IfWinActive
