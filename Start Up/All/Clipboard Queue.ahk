;Auto-Execute
;Region " Instructions "
	; Clipboard Queue by Scott Rippey
	; Version 1.1.3.4
	;Region " Basic Instructions "
	; --- Copying Instructions ---
	; Copy or cut anything to the clipboard, and it 
	; will automatically be added to the bottom of 
	; the Clipboard Queue.  The list will briefly 
	; pop up, with the new item in bold.
	; 
	; --- Pasting Instructions ---
	; Press and release Ctrl+V to paste the current item.
	; To cycle through items in the Clipboard Queue,
	; press Ctrl+V, and while holding Ctrl, continue to
	; press V.  Release Ctrl to paste the selected item.
	;
	;EndRegion
	;
	;Region " Advanced Instructions "
	;
	; --- Manipulating the Clipboard Queue ---
	;
	; The Clipboard Queue list will remain visible 
	; as long as you hold down the Ctrl key.  Therefore,
	; to manipulate the list, bring it up by pressing
	; Ctrl+C, Ctrl+X, or Ctrl+V, and continue holding Ctrl 
	; to manipulate the list as follows:
	;
	clipQueueHelp =
    ; --------Shortcut-----------:---------Action------------------------------
	(ltrim
    ;|----------------------------------------------------------------------------------------------
    ;| Selecting An Item To Paste
    ;|----------------------------------------------------------------------------------------------
    ;|  Next    | Ctrl+V    or Ctrl+Down      | Select next item            (Release Ctrl to paste)
    ;|  Prev    | Ctrl+F    or Ctrl+Up        | Select previous item        (Release Ctrl to paste)
    ;|  Home    | Ctrl+Home    Ctrl+End       | Select first / last item    (Release Ctrl to paste)
    ;|  Cancel  | Ctrl+Esc  or Ctrl+Space     | Close the Clipboard Queue without pasting
    ;|----------------------------------------------------------------------------------------------
    ;| Deleting and Locking Items
    ;|----------------------------------------------------------------------------------------------
    ;|  Delete  | Ctrl+X    or Ctrl+Delete    | Delete selected item (unless the item is locked)
    ;|  Clear   | Ctrl+0    or Ctrl+NumPad0   | Clear the entire Clipboard Queue (except for locked items)
    ;  Clear 1 | Ctrl+1    or Ctrl+NumPad1   | Clear all items in the Clipboard Queue EXCEPT the selected item (except for locked items)
    ;  Clear ^ | Ctrl+2    or Ctrl+Shift+Up  | Clear all items in the Clipboard Queue ABOVE the selected item (except for locked items)
    ;  Clear v | Ctrl+3    or Ctrl+Shift+Dn  | Clear all items in the Clipboard Queue BELOW the selected item (except for locked items)
    ;  Lock    | Ctrl+L    or Ctrl+*         | Locks or unlocks the selected item.  Locked items cannot be deleted.  
	;          |                             |         Locked items are marked with an asterix *.
    ;----------------------------------------------------------------------------------------------
    ; Organizing the List
    ;----------------------------------------------------------------------------------------------
    ;  Move    | Ctrl+Left or Ctrl+Right     | Move selected item up / down
    ;  Rotate  | Ctrl+PgUp or Ctrl+PgDn      | Rotate all items up / down
    ;  Rename  | Ctrl+R                      | Renames an item, changing the display text
    ;  Reverse | Ctrl+/    or Ctrl+NumPad/   | Reverse all items from the selected item down
    ;  Sort    | Ctrl+S                      | Sorts the selected item and all items below it.
	;          |                             |         Sorts using a Natural Sort (where "Item 2" comes before "Item 10").
	;----------------------------------------------------------------------------------------------
    ; Compatibility with other applications
    ;----------------------------------------------------------------------------------------------
    ;  Copy    | Ctrl+C    or Ctrl+Insert    | Copy the selected item to the "actual clipboard"
    ;          |                             |         Note: The "actual clipboard" contains the most recently copied or pasted contents.
    ;          |                             |         Since the Clipboard Queue is only activated by first pressing Ctrl+V, you
    ;          |                             |         can bypass the Clipboard Queue by Right-Clicking and choosing Paste, or
    ;          |                             |         by pressing Shift+Insert (a standard Windows shortcut equivalent to Ctrl+V).
    ;          |                             |         These methods will paste the "actual clipboard" contents.
	;----------------------------------------------------------------------------------------------
    ; Special Functions
    ;----------------------------------------------------------------------------------------------
    ;  Type    | Ctrl+T                      | "Type-Paste" : Simulates paste by typing the clipboard contents
    ;  Type *  | Ctrl+Y                      | "Type-Paste Special" : Simulates paste by typing the clipboard contents, 
	;          |                             |         but also interprets special keystrokes such as "{Home}" etc...
    ;  Split   | Ctrl+\                      | Splits the selected item into separate clipboard entries. 
    ;          |                             |         Splits the selected item on one of the following:
    ;          |                             |         Linefeed, comma, tab, pipe, ampersand, equals, space, underscore, CamelCase 
    ;          |                             |         \n,\t|&&= _
    ;          |                             |         whichever is found first.
    ;  Combine | Ctrl+Shift+                 | Combines the selected item and all items below it into a single new item,
    ;          |        (Enter, Comma, Pipe, |         with the corresponding key inserted between items.
    ;          |         Tab, Space)         |
    )
	;EndRegion
	;
	;Region " What's New? "
	; Version 1.1.4.0
	; • Added Ctrl+S: "Sort"
	;   Sorts the items in the list using a Natural Sort (where "Item 2" comes before "Item 10").
	; Version 1.1.3.5
	; • Enhanced Ctrl+\: "Split Text"
	;   Added splitting on ampersand, equals, space, underscore, and CamelCase.
	; Version 1.1.3.4
	; • Added Ctrl+T: "Type-Paste"
	;   Simulates pasting the clipboard text by typing it instead of sending Ctrl+V.
	;   This can be used with applications that do not support paste (such as the command prompt).
	; • Added Ctrl+Y: "Type-Paste Special"
	;   Same as "Type-Paste", except special keystrokes can be sent.
	;   For example, if the clipboard contains "Hello {Home}{Left 2}^s", the following keys will
	;   be sent: H-e-l-l-o-Space-Home-Left-Left-Ctrl+S.
	;   This allows you to create quick, temporary macros!
	; Version 1.1.3.3
	; • Added Ctrl+R: "Rename Item"
	;   Allows you to change the display text of an item
	; • Added Ctrl+L: "Lock Item"
	;   If there is a clipboard item you don't want to accidentally delete,
	;   you can lock it to protect it.  
	;   To delete the item, you must first unlock it by pressing Ctrl+L again.
	;   Locked items are marked with an asterix *
	; • Added Ctrl+2: "Clear Above", Ctrl+3: "Clear Below"
	;   Clears the Clipboard Queue, keeping the selected item and items below it.
	;   This is useful for clearing out old items in the Clipboard Queue.
	; • Enhanced Ctrl+\: "Split Text"
	;   Now, it will check the text for a linefeed, comma, tab, or pipe, 
	;   and will split using the first one of those it finds (in that order).
	; • Added (and Modified) Ctrl+Shift+(Enter, Comma, Pipe, Tab, Space): "Combine Text"
	;   Combines the selected item with all items below it, with the corresponding key inserted between items.
	;   Use Ctrl+Shift+Alt+Space to combine items without any extra space in between.
	; Version 1.1.3.1
	; • Greatly improved performance when pasting
	; • Fixed the Delayed Copy bug for better copying performance
	; Version 1.1.3.0
	; • Added Ctrl+1 to clear the entire Clipboard Queue except for the selected item
	; • Added a "Cancel Color"
	;     - Provides a visual indication of what will happen when you release Ctrl
	;     - Items will appear Black* if they will be pasted on release - For example, Ctrl+V
	;     - Items will appear Gray* if nothing will happen on release - For example, Ctrl+Left
	;       (* actual colors depend on color scheme)
	;     
	; Version 1.1.2.0
	; • Improved Multi-Monitor support - the Clipboard Queue window will pop up on the monitor that contains the blinking caret |
	; • Added Ctrl+Enter shortcut to cycle color schemes (display modes)
	; • Added Ctrl+Space to cancel paste
	; • Added Ctrl+\ to split lines, Ctrl+Shift+\ to combine them
	;
	; Version 1.1
	; • Created the What's New section
	;EndRegion
	;
	;Region " Known Issues "
	; --- Known Issues ---
	; • Unusual Duplicate Copying: When certain applications 
	;   start up or close, they occassionally cause Clipboard 
	;   Queue to duplicate the last-copied item.
	;   I think this is because these applications modify the
	;   clipboard every time they start or exit.
	;  -Affects:
	;   Word and Excel are known for doing this.
	;  -How to Recreate:
	;   Open Word/Excel, type some text, copy it, and exit.
	;   The copied text will be copied again as it exits.
	;   -Workaround:
	;   Manually delete the duplicate items (press Ctrl+(V, X) )
	;EndRegion
;EndRegion

;Region " Auto-Execute "
	; Reload all the *.clip files from the temp directory:
	cqCount := 0
	cqIndex := 0
	cqIndexOfActualClipboard := -1
	; Load all the *.clip files from the temp directory:
	; Loop, %A_Temp%\Clipboard Queue\*.clip
	Loop, %A_AppData%\AutoHotKey\Clipboard Queue\*.clip
	{	
		RegexMatch(A_LoopFileName, "i)^\d+ - (.*)\.clip$", filename)
		ClipFile%A_Index% := A_LoopFileFullPath
		ClipDisplay%A_Index% := filename1
		ClipLock%A_Index% := FileExist(A_LoopFileFullPath . ".lock")
		cqCount := A_Index
	}
	
	; Suspend the first OnClipBoardChange that always fires after the script loads:
	GoSub CQSuspendMonitor
	
	
	ClipQueueOptionsIndex = 1
	GoSub NextDisplayMode
Return ;EndRegion

;Region " Include Files "
	; ; The following lines need to be un-commented to work as a stand-alone:
	; #SingleInstance force
	; #Include #Includes\ShowToolTip(tip[,time]).ahk
	; #Include #Includes\GUIUniqueDefault().ahk
	; #Include #Includes\ShowAccordian(top,middle,bottom[,options,progressOptions]).ahk
;EndRegion



;Region " Clipboard Change Event "

	OnClipBoardChange:
		If (cqSuspend != false)
			Return

		If A_EventInfo = 0 ; Clipboard is now empty
			Return

		; Quickly register the ctrlState, before we call AppendClipboard:
		GetKeyState ctrlState,CTRL
		ctrlKeyDownTemp := false
		If ctrlState = D
			ctrlKeyDownTemp := true
		
		; See if this window is "ignored":
		IfWinActive ahk_group ClipQueueIgnore
			Return
		
		GoSub AppendClipboard

		OnCtrlKeyRelease =
		GoSub ShowClipQueueWindow
		
		; Register quick Ctrl+C presses:
		if (ctrlKeyDownTemp = true)
			ctrlKeyDown := true
	Return
		
;EndRegion

;Region " Keyboard Shortcuts "	
	
	;Region " Pasting "
	
	; Pressing Ctrl+V activates the paste dialog:
	^v:: ;;; The $ sign is to prevent the shortcut from firing from "Send ^v"
		; Make sure the cqIndex is in-bounds
		If (cqIndex < 1)
			cqIndex := 1
		If (cqIndex > cqCount)
			cqIndex := cqCount
			
		OnCtrlKeyRelease = SendPasteCommand
		GoSub ShowClipQueueWindow
		ctrlKeyDown := true ; this makes sure we register quick Ctrl+V presses.
	Return
	~^c Up:: ; ~ doesn't block the native action
	~^x Up::
		ctrlKeyDown := true ; This might help the delayed copy in some cases,
							; but it definitely doesn't solve the issue
	Return
	
	;EndRegion

	#IfWinExist AccordianClipQueue ; Only active if the ClipQueue list is visible

		;Region " Help "
		
		; Manipulation Methods to use while holding down the Ctrl key:
		#IfWinExist Clipboard Queue Help...
			^F1::
			^h::
			ClipQueueHelp_Escape:
			ClipQueueHelp_Close:
				GuiUniqueDestroy("ClipQueueHelp")
			Return
		#IfWinExist AccordianClipQueue ; Only active if the ClipQueue list is visible

		^F1::
		^h::
			; Show Help

			OnCtrlKeyRelease =
			GoSub CloseClipQueueWindow

			;ShowAccordian("","",clipQueueHelp, " GuiKeyHelpClipQueue FontName'Consolas' XL YT Right Bottom " . ClipQueueDisplayOptions)
			GuiUniqueDefault("ClipQueueHelp")
			Gui, Font, s10, Consolas
			Gui, Add, Text, , %clipQueueHelp%
			Gui, Show, , Clipboard Queue Help...
		Return
		
		;EndRegion
	
		;Region " Navigation and Manipulation "
	
		^Space::
			; Close the window
			OnCtrlKeyRelease =
			GoSub CloseClipQueueWindow
		Return
		^Esc::
			; Suspend for 10 seconds:
			GoSub CQSuspendMonitor10
			ShowToolTip("Clipboard Queue is suspended for 10 seconds...", 10000)
			; Close the window
			OnCtrlKeyRelease =
			GoSub CloseClipQueueWindow
		Return
		
		
		

		^Down::
		^v::
			; Move selection down
			GoSub NextClip

			OnCtrlKeyRelease = SendPasteCommand
			GoSub ShowClipQueueWindow
		Return
		^Up::
		^f::
			; Move selection up
			GoSub PrevClip

			OnCtrlKeyRelease = SendPasteCommand
			GoSub ShowClipQueueWindow
		Return
		^Delete::
		^x::
			; Delete selection
			GoSub RemoveClip

			OnCtrlKeyRelease = 
			GoSub ShowClipQueueWindow
		Return
		^Insert::
		^c::
			; Copy the selected item to the "actual" clipboard
			cqIndexOfActualClipboard := -1 ; Make sure we always load the clipboard
			GoSub LoadClipboard
			
			ShowToolTip("Item Copied to Real Clipboard")
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^d::
			; Duplicate the selected item
			If (cqIndex > cqCount OR cqCount = 0) {
				; We are out-of-bounds, aka "(Cancel Paste)"
				; So, instead of duplicating the current item,
				; let's just create a new entry for the current clipboard.
				If clipboard =
					Return
				cqIndex := cqCount + 1
			} Else {
				cqIndexOfActualClipboard := -1 ; Make sure we always load the clipboard
				GoSub LoadClipboard
				
				; Remove special formatting:
				clipboard := clipboard
			}

			; Duplicate this item:
			lastIndex := cqIndex
			GoSub AppendClipboard
			cqIndex := lastIndex
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		
		
		^Left::
			; Move clip up
			GoSub MoveClipUp

			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^Right::
			; Move clip down
			GoSub MoveClipDown

			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^PgUp::
			; Rotate clips up
			GoSub RotateClipsUp
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^PgDn::
			; Rotate clips down
			GoSub RotateClipsDown
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^/::
		^NumPadDiv::
			; Reverse clips from the current item:
			GoSub ReverseClips
		
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		
		^Home::
			; Move selection to first
			cqIndex := 1
			
			OnCtrlKeyRelease = SendPasteCommand
			GoSub ShowClipQueueWindow
		Return
		^End::
			; Move selection to last
			cqIndex := cqCount
			
			OnCtrlKeyRelease = SendPasteCommand
			GoSub ShowClipQueueWindow
		Return
		
		;EndRegion
		
		;Region " Clear Items "
		
		^0::
		^NumPad0::
			; Clear all items
			GoSub ClipQueueClear
			
			OnCtrlKeyRelease = 
			GoSub ShowClipQueueWindow
		Return
		^1::
		^NumPad1::
			; Clear all items except the selected item
			GoSub ClipQueueClear1
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^+Up::
		^3::
		; ^NumPad3::
			; Clear all items above the selected item
			GoSub ClipQueueClearAbove
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^+Down::
		^2::
		; ^NumPad2::
			; Clear all items below the selected item
			GoSub ClipQueueClearBelow
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		
		;EndRegion
		
		;Region " Splitting and combining "
		
		^\:: ; Split clip into separate lines:
			GoSub SplitClips
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		
		^+\:: ; Combine all items from the ClipQueue
			CombineClipsWith := "|"
			GoSub CombineClips
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^+!\:: ; Combine all items from the ClipQueue
			CombineClipsWith := "\"
			GoSub CombineClips
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^+Enter:: ; Combine all items from the ClipQueue
			CombineClipsWith := "`r`n"
			GoSub CombineClips
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return 
		^+Tab:: ; Combine all items from the ClipQueue
			CombineClipsWith := "	"
			GoSub CombineClips
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return 
		^+,:: ; Combine all items from the ClipQueue
			CombineClipsWith := ", "
			GoSub CombineClips
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return 
		^+Space:: ; Combine all items from the ClipQueue
			CombineClipsWith := " "
			GoSub CombineClips
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		^!+Space:: ; Combine all items from the ClipQueue
			CombineClipsWith := "" ; (Combine with nothing)
			GoSub CombineClips
			
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return

		;EndRegion

		;Region " Sorting "
			^s::
				GoSub SortClipQueue
			
				OnCtrlKeyRelease =
				GoSub ShowClipQueueWindow
			Return
		;EndRegion

		;Region " Display Options "
		
		^Enter:: ; Change the display options:
			GoSub NextDisplayMode
			
			OnCtrlKeyRelease = DoNothing ; Makes the display normal, but does nothing on release.
			GoSub ShowClipQueueWindow
		Return
		NextDisplayMode:
			clipQueueOptions =
			(ltrim comments
					Very Transparent (Default)		= Alpha40
					Semi Transparent 				= Alpha160
					Solid 							= Alpha254
					Black Text						= _CFGGray   ForeGroundBlack  BackGroundTransparent
					White Text						= _CFGGray   ForeGroundWhite  BackGroundTransparent
					Yellow Text						= _CFGAAAA55 ForeGroundFFFF99 BackGroundTransparent
					Blue Text						= _CFG5599AA ForeGround99CCFF BackGroundTransparent
			)
			clipQueueDefaults 						= _CFGGray ForeGroundBlack BackGroundWhite     GuiKeyClipQueue MonitorCaret FS12 FL20 
			; Note: _CFG---- is the ForeGround color if there is no action on release.
			StringSplit options, clipQueueOptions, `n
			; Increment & loop the index:
			clipQueueOptionsIndex++
			If (clipQueueOptionsIndex > options0)
				clipQueueOptionsIndex = 1
			
			StringSplit options, options%ClipQueueOptionsIndex%, =
			ClipQueueDisplayOptions := options2 . " " . clipQueueDefaults . " "
		Return
		
		;EndRegion

		;Region " Locking "
				
		^l:: ; Toggle locking on an item:
		^NumPadMult::
		^8::
			GoSub ToggleLock
		
			OnCtrlKeyRelease =
			GoSub ShowClipQueueWindow
		Return
		
		;EndRegion
		
		;Region " Renaming "
		
		^r::
			OnCtrlKeyRelease =
			GoSub CloseClipQueueWindow
			
			If (cqIndex > cqCount)
				Return
				
			; Display an input box:
			display := ClipDisplay%cqIndex%
			InputBox newDisplay, Rename a Clipboard Queue Item..., Please enter the new display text for this item.  This will only affect the display text -- it will not affect the actual clipboard contents., , , , , , , , %display%
			If (ErrorLevel OR newDisplay = "")
				Return
			
			ClipDisplay%cqIndex% := newDisplay
			GoSub ShowClipQueueWindow
		Return
		
		;EndRegion

		;Region " Type-Paste "
			^t:: ; "Type-Paste"
				; Simulates paste by typing the clipboard contents
				OnCtrlKeyRelease = 
				GoSub CloseClipQueueWindow
				
				GoSub LoadClipboard
				SendInput {Raw}%clipboard%
			Return
			^y:: ; "Type-Paste Special"
				; Simulates paste by typing the clipboard contents, but allows special keystrokes such as "{Home}" etc...
				OnCtrlKeyRelease = 
				GoSub CloseClipQueueWindow
				
				GoSub LoadClipboard
				SendInput %clipboard%
			Return
		;EndRegion
		
	#IfWinExist
	
;EndRegion



	;Region " Special Functions "
		SplitClips: ; Splits the selected clipboard into separate items
		
			index := cqIndex ; We want to restore the selected item later

			; Load the selected item:
			GoSub LoadClipboard
			clip := clipboard
			
			; Determine how to split the text:
			SplitClipsIgnore := " 	"
			IfInString clip, `n
			{	SplitClipsOn := "`n"
				SplitClipsIgnore .= "`r"
			} 
			Else IfInString clip, `,
				SplitClipsOn := "CSV"
			Else IfInString clip, %A_Tab%
				SplitClipsOn := A_Tab
			Else IfInString clip, |
				SplitClipsOn := "|"
			Else IfInString clip, & ; Split a query string like "http://www.example.com/default?a=1&b=2&c=3"
				SplitClipsOn := "?&"
			Else IfInString clip, \ ; Split filenames and paths
				SplitClipsOn := "\"
			Else IfInString clip, = ; Split elements of a query string, like "property=value"
				SplitClipsOn := "="
			Else IfInString clip, %A_Space%
				SplitClipsOn := " "
			Else IfInString clip, _
				SplitClipsOn := "_"
			Else
				GoTo SplitClipsOther
			
			; Split the clipboard by line:
			Loop, parse, clip, %SplitClipsOn%, %SplitClipsIgnore%
			{	
				If RegexMatch(A_LoopField, "^\s*$") ; Empty or spaces?
					continue

				GoSub CQSuspendMonitor
				clipboard := A_LoopField
				GoSub AppendClipboard
			}
			
			cqIndex := index ; Restore the selected item
				
		Return
		SplitClipsOther:
			; Split by CamelCase
			; Make sure we have varying case:
			If clip IS UPPER
				return
			If clip IS LOWER
				return
			
			; Split:
			camel := ""
			camel0 := 0
			wasUpper := true
			Loop, parse, clip
			{
				If A_LoopField IS UPPER
				{
					If (NOT wasUpper) {
						; Add this item to our array:
						camel0++
						camel%camel0% := camel
						camel =

						wasUpper := true
					}
				} else {
					wasUpper := false
				}
				camel .= A_LoopField
			}
			; Add the very last item:
			camel0++
			camel%camel0% := camel
			
			; If there's only 1 item, don't bother:
			If (camel0 = 1)
				Return
			
			
			; Append the items to the Queue:
			GoSub CQSuspendMonitor
			Loop, %camel0%
			{
				camel := camel%A_Index%
				If RegexMatch(camel, "^\s*$") ; Empty or spaces?
					continue
				clipboard := camel
				GoSub AppendClipboard
			}

			cqIndex := index ; Restore the selected item
		Return
		CombineClips: ; Combines all items from the ClipQueue, starting with the selected item
			If (cqCount = 0 OR cqIndex >= cqCount)
				return
			
			index := cqIndex ; We want to restore the selected item later
			
			
			allText =
			Loop, %cqCount%
			{
				If (A_Index < cqIndex)
					continue ; Skip

				; Load the selected item:
				cqIndex := A_Index
				GoSub LoadClipboard
				
				clip := clipboard
				If clip =
					continue
				allText .= clip
				; If the string ends with a linebreak, we don't need to insert our own:
				; (this is for Visual Studio)
				if (CombineClipsWith = "`r`n" and RegexMatch(clip, "\r\n\s*$"))
					continue
				If (A_Index < cqCount)
					allText .= CombineClipsWith
			}
			if allText !=
			{	
				GoSub CQSuspendMonitor
				clipboard := allText
				cqIndex := index ; Insert the clipboard at the current location
				GoSub InsertClipboard
			}
			cqIndex := index ; Restore the selected item
			
		Return
		
		
		SortClipQueue:
			; Sort the items, based on the display name:
			; "Bubble sort":
			Loop
			{
				done := true
				Loop %cqCount%
				{
					If (A_Index <= cqIndex)
						continue
					s := A_Index - 1
					d := A_Index
					If (NaturalCompare(ClipDisplay%s%, ClipDisplay%d%, 1) > 0) {
						GoSub SwapClips
						done := false
					}
				}
				If (done)
					break
			}
		Return
		; Source obtained from http://www.autohotkey.com/forum/topic35835.html
		NaturalCompare(x,y,offset)
		{
			RegEx := "S)(\D*)(\d*)(.*)"
		   
			Loop
			{
				RegExMatch(x, RegEx, x)
				RegExMatch(y, RegEx, y)
			   
				if (x1 != y1)
					return x1 < y1 ? -1 : 1
				   
				if (x2 != y2)
					return x2 < y2 ? -1 : 1
				   
				if (x3 = "" || y3 = "")
					break
				   
				x := x3
				y := y3
			}

			if (x3 != "")
			{
				;x is "longer"
				return 1
			}
			else if (y3 != "")
			{
				;y is "longer"
				return -1
			}
			else
			{
				;equal - maintain original order (stable)
				return -offset
			}
		}
		
	;EndRegion
	
	;Region " BackupClipboard / RestoreClipboard "
		; These can be used by other scripts that will use the clipboard so that they won't interfere with this script
		BackupClipboard:
			SetTimer CQResumeMonitor, Off
			cqSuspend := true
			restoreClip := ClipboardAll ; Backup Clipboard
			Clipboard = ; Clear Clipboard
		Return
		RestoreClipboard:
			Clipboard := restoreClip ; Restore Clipboard
			Sleep 20 ; Let the OnClipBoardChange event pass
			cqSuspend := false
		Return
		ClearClipboard:
			GoSub CQSuspendMonitor
			clipboard = 
			cqIndexOfActualClipboard := -1
		Return 
	;EndRegion

	;Region " ClipQueueClear/Copy/Cut/Paste/PasteNext "
		ClipQueueClear: ; Removes all items
			;cqIndex := cqCount ; This helps optimize RemoveClip by telling it to remove from the end
			; Clear all items:
			start := 1
			count := cqCount
			
			GoSub _ClipQueueClear
		Return
		ClipQueueClear1: ; Removes all items except the selected item
			; Always keep at least 1 item:
			If (cqIndex > cqCount)
				cqIndex := cqCount
			
			; ; Delete the items above:
			; count := cqIndex - 1
			; GoSub _ClipQueueClear
			; ; Swap to the bottom:
			; s := cqIndex
			; d := cqCount
			; GoSub SwapClips
			; ; Delete the items below:
			; count := cqCount - 1
			; GoTo _ClipQueueClear
			
			; Delete the items below:
			start := cqIndex + 1
			count := cqCount - start + 1
			GoSub _ClipQueueClear
			; Delete the items above:
			start := 1
			count := cqIndex - start
			GoSub _ClipQueueClear
		Return
		ClipQueueClearAbove: ; Removes all items above the selected item
			; Always keep at least 1 item:
			If (cqIndex > cqCount)
				cqIndex := cqCount
			; If we're at the top of the Queue, there's nothing to delete:
			If (cqIndex <= 1)
				Return
			; Delete the items above:
			start := 1
			count := cqIndex - start
			GoSub _ClipQueueClear
		Return
		ClipQueueClearBelow: ; Removes all items below the selected item
			; If we're at the bottom, there's nothing to delete:
			If (cqIndex >= cqCount)
				Return
			; Delete the items below:
			start := cqIndex + 1
			count := cqCount - start + 1
			GoSub _ClipQueueClear
		Return
		_ClipQueueClear: ; Removes "count" items from "start":
			oldIndex := cqIndex
			Loop %count%
			{
				cqIndex := count + start - A_Index ; Remove backwards
				If (cqIndex <= oldIndex AND NOT ClipLock%cqIndex%)
					oldIndex-- ; Keep track of the changed index
				GoSub RemoveClip
			}
			cqIndex := oldIndex
			If (cqIndex < 1)
				cqIndex = 1
			If (cqIndex > cqCount)
				cqIndex = cqCount
		Return

			
		ClipQueueCopy:
			Send ^c
		Return
		ClipQueueCut:
			Send ^x
		Return
	

		ClipQueuePasteNext: ; Pastes the next in the queue
			GoSub ClipQueuePaste
			cqIndex += 1
		Return

		;Region " ClipQueuePaste[1-20] "

		ClipQueuePaste1:
			cqIndex := 1
			GoTo ClipQueuePaste
		ClipQueuePaste2:
			cqIndex := 2
			GoTo ClipQueuePaste
		ClipQueuePaste3:
			cqIndex := 3
			GoTo ClipQueuePaste
		ClipQueuePaste4:
			cqIndex := 4
			GoTo ClipQueuePaste
		ClipQueuePaste5:
			cqIndex := 5
			GoTo ClipQueuePaste
		ClipQueuePaste6:
			cqIndex := 6
			GoTo ClipQueuePaste
		ClipQueuePaste7:
			cqIndex := 7
			GoTo ClipQueuePaste
		ClipQueuePaste8:
			cqIndex := 8
			GoTo ClipQueuePaste
		ClipQueuePaste9:
			cqIndex := 9
			GoTo ClipQueuePaste
		ClipQueuePaste10:
			cqIndex := 10
			GoTo ClipQueuePaste
		ClipQueuePaste11:
			cqIndex := 11
			GoTo ClipQueuePaste
		ClipQueuePaste12:
			cqIndex := 12
			GoTo ClipQueuePaste
		ClipQueuePaste13:
			cqIndex := 13
			GoTo ClipQueuePaste
		ClipQueuePaste14:
			cqIndex := 14
			GoTo ClipQueuePaste
		ClipQueuePaste15:
			cqIndex := 15
			GoTo ClipQueuePaste
		ClipQueuePaste16:
			cqIndex := 16
			GoTo ClipQueuePaste
		ClipQueuePaste17:
			cqIndex := 17
			GoTo ClipQueuePaste
		ClipQueuePaste18:
			cqIndex := 18
			GoTo ClipQueuePaste
		ClipQueuePaste19:
			cqIndex := 19
			GoTo ClipQueuePaste
		ClipQueuePaste20:
			cqIndex := 20
			GoTo ClipQueuePaste
	;EndRegion
	;EndRegion

	;Region " NextClip / PrevClip / MoveClipUp / MoveClipDown / RotateClipsUp / RotateClipsDown / SwapClips / ClearClip / RemoveClip / ToggleLock "

		NextClip: ; Move to the next clip
			cqIndex++
			If (cqIndex >= cqCount + 2)
				cqIndex := 1
		Return
		PrevClip: ; Move to the previous clip
			cqIndex--
			If (cqIndex <= 0)
				cqIndex := cqCount + 1
		Return

		MoveClipUp: ; Moves the selected clip up the queue
			If (cqIndex > cqCount) {
				cqIndex := cqCount
				Return
			} 
			If (cqIndex = 1) {
				; Move the clip to the bottom:
				GoSub RotateClipsUp
				cqIndex := cqCount
				Return
			}
			; Swap the selected item with the one above it:
			s := cqIndex
			d := cqIndex - 1
			If (d <= 0)
				d := cqCount

			GoSub SwapClips
			cqIndex := d
		Return
		MoveClipDown: ; Moves the selected clip down the queue
			If (cqIndex > cqCount) {
				cqIndex := 1
				Return
			}
			If (cqIndex = cqCount) {
				; Move the clip to the top:
				GoSub RotateClipsDown
				cqIndex := 1
				Return
			}
			; Swap the selected item with the one above it:
			s := cqIndex
			d := cqIndex + 1
			If (d > cqCount)
				d := 1

			GoSub SwapClips
			cqIndex := d
		Return


		RotateClipsUp:
			GoSub ShiftClipsUp
			
			s := 0
			d := cqCount
			GoSub SwapClips
			GoSub ClearClip
		Return
		RotateClipsDown:
			GoSub ShiftClipsDown

			s := cqCount + 1
			d := 1
			GoSub SwapClips
			GoSub ClearClip
		Return

		ShiftClipsUp: ; Shifts all clips Up; x,1,2,3 becomes 0,1,2,x
			Loop %cqCount%
			{	
				s := A_Index
				d := s - 1
				GoSub SwapClips
			}
		Return
		ShiftClipsDown: ; Shifts all clips Down; 1,2,3,x becomes x,2,3,4
			Loop %cqCount%
			{
				s := cqCount + 1 - A_Index
				d := s + 1
				GoSub SwapClips
			}
		Return
		ShiftClipsDownFromIndex:
			Loop %cqCount%
			{
				s := cqCount + 1 - A_Index
				d := s + 1
				If (s < cqIndex)
					Return
				GoSub SwapClips
			}
		Return
		
		ReverseClips:
			count := (cqCount - cqIndex + 1)/2
			Loop %count%
			{
				s := cqIndex + (A_Index - 1)
				d := cqCount - (A_Index - 1)
				GoSub SwapClips
			}
		Return
		
		
		
		RemoveClip: ; Removes the currently selected clip
			; Validate:
			If (cqCount = 0)
				return
			If (cqIndex > cqCount)
				return
			If (ClipLock%cqIndex%)
				return
			
			; Delete and clear the item:
			removeFile := ClipFile%cqIndex%
			IfExist %removeFile%
				FileDelete %removeFile%
			s := cqIndex
			GoSub ClearClip
			
			; Shift out the deleted item (and shift higher ones down)
			cqCount--
			Loop, %cqCount%
			{	
				If (A_Index < cqIndex)
					continue
				s := A_Index
				d := A_Index + 1
				GoSub SwapClips
			}
			If (cqIndex > cqCount)
				cqIndex := cqCount
		Return
		RemoveLock:
			ClipLock%cqIndex% = 1
			; Fall through:
		ToggleLock: ; Toggles the lock on the selected clip
			; Validate:
			If (cqCount = 0)
				return
			If (cqIndex > cqCount)
				return
			
			ClipLockFile := ClipFile%cqIndex% . ".lock"
			If (ClipLock%cqIndex%) {
				; Remove the lock:
				ClipLock%cqIndex% = 
				FileDelete, %ClipLockFile%
			} Else {
				; Add the lock:
				ClipLock%cqIndex% = 1
				FileAppend, Clip is Locked, %ClipLockFile%
			}
		Return

	;EndRegion

	;Region " SwapClips / ClearClip "
		SwapClips: ; Inputs s and d as source and dest indices
			; Swap File, Display, Lock:
			swapFile := ClipFile%d%
			swapDisplay := ClipDisplay%d%
			swapLock := ClipLock%d%
			ClipFile%d% := ClipFile%s%
			ClipDisplay%d% := ClipDisplay%s%
			ClipLock%d% := ClipLock%s%
			ClipFile%s% := swapFile
			ClipDisplay%s% := swapDisplay
			ClipLock%s% := swapLock
			If (cqIndexOfActualClipboard = s)
				cqIndexOfActualClipboard := d
			Else If (cqIndexOfActualClipboard = d)
				cqIndexOfActualClipboard := s
		Return
		ClearClip: ; Inputs s as source and clears it
			ClipFile%s% =
			ClipDisplay%s% =
			ClipLock%s% =
			If (cqIndexOfActualClipboard = s)
				cqIndexOfActualClipboard := -1
		Return
	
	;EndRegion
	
	;Region " AppendClipboard / PrependClipboard "

		AppendClipboard:
			cqCount++
			; Append the clipboard to the end:
			cqIndex := cqCount			
			GoTo _InsertClipboard
		PrependClipboard:
			; Move all clips down:
			GoSub ShiftClipsDown
			cqCount++
			; Prepend the clipboard to the front:
			cqIndex := 1
			GoTo _InsertClipboard
		InsertClipboard:
			; Insert the clipboard to the current index:
			; Move all clips down (after the current one):
			GoSub ShiftClipsDownFromIndex
			cqCount++
			; Insert the clipboard:
			GoTo _InsertClipboard
		_InsertClipboard:
			; Get the contents of the clipboard:
			clip := clipboard
			clipAll := ClipboardAll
			; Format the clipboard to something displayable:
			GoSub FormatDisplay
			ClipDisplay%cqIndex% := display
			
			; Let's create a valid filename:
			fn := RegexReplace(display, "[\\/:*?""<>|\x00-\x1F]+", "_")
			FileCreateDir %A_AppData%\AutoHotKey\Clipboard Queue
			ClipFile%cqIndex% = %A_AppData%\AutoHotKey\Clipboard Queue\%A_Now%%cqIndex% - %fn%.clip
			ClipFile := ClipFile%cqIndex%
			ClipLock%cqIndex% =
			
			; Write the clipboard to the file:
			FileAppend %clipAll%, %ClipFile%
			If ErrorLevel
			{	GoSub RemoveClip
				MsgBox Clipboard Queue Error: %ErrorLevel%`n%ClipFile%
			}
			
			; Keep track of the "active clipboard"
			cqIndexOfActualClipboard := cqIndex
		Return


	;EndRegion

	;Region " FormatDisplay "
		FormatDisplay:
			; Inputs 
			;	clip
			; Outputs 
			;	display
			display =
			files =
			FileCount = 0
			FolderCount = 0
			; Determine how to display this clipboard data:
			Loop, parse, clip, `n, `r ; Let's see if this contains files and/or folders
			{	
				SplitPath A_LoopField, filename, , , , fileDrive
				If (FileDrive = "" or FileName = "" or InStr(FileDrive, "//")) {
					files =
					break
				}
				IfExist %A_LoopField%
				{	; Determine if its a file or folder
					FileGetAttrib attr, %A_LoopField%
					IfInString attr, D
						FolderCount++
					Else
						FileCount++
				} Else {
					FileCount++
				}
				If A_Index <= 2
				{	If files !=
						files .= ", "
					files .= RegexReplace(filename, "^(.{12}).{4,}(.{3}\..*)$", "$1...$2")
				} ;Else If A_Index = 3
					;files .= "..."
				; Else
					; break
			}
			If files != ; The clipboard contained all files
			{	
				fileCountS := fileCount = 1 ? "" : "s"
				folderCountS := folderCount = 1 ? "" : "s"
				If (fileCount > 0 and folderCount > 0)
					display = (%folderCount% folder%folderCountS%, %fileCount% file%fileCountS%) %files%
				Else If (fileCount > 0)
					display = (%fileCount% file%fileCountS%) %files%
				Else If (folderCount > 0)
					display = (%folderCount% folder%folderCountS%) %files%
				If (folderCount + fileCount > 2)
					display := display . " (+" . (-2 + folderCount + fileCount) . " more)"
			} 
			Else If RegexMatch(clip, "i)^(https?://[^/]+)/(.*)/([^?]*)(\?.*)?", url) ; Maybe it's a URL?
			{	; Test: http://www.abcdefg.com/abcdefg/abcdefg/abcdefg/abcdefg/abcdefg/default.html?query,can,be,very,long
				
				maxLen := 50

				If StrLen(url) <= maxLen {	
					display := url
				} Else {
					; Determine how much to trim:
					trim := StrLen(url) - maxLen
					If trim > 0 
					{	If StrLen(url4) > trim
						{	length := StrLen(url4) - trim
							url4 := SubStr(url4, 1, length)
							url4 = %url4%...
							trim = 0
						} Else 
						{	trim -= StrLen(url4)
							url4 = ...
						}
					}
					If trim > 0
					{	If StrLen(url2) > trim
						{	url2 := SubStr(url2, trim)
							url2 = ...%url2%
							trim = 0
						} Else
						{	trim -= StrLen(url2)
							url2 = ...
						}
					}
						
					display = %url1%/%url2%/%url3%%url4%
				}
			} Else {
				; Hopefully it is a string type
				; Normalize the newline characters:
				StringReplace clip, clip, `r`n, `n, All
				StringReplace clip, clip, `n, `r`n, All
				; Remove tabs:
				StringReplace clip, clip, %A_Tab%, %A_Space%, All
				; Count the number of lines, and only display the first:
				StringSplit lines, clip, `n, `r
				display := lines1
				
				; Let's try to trim it to 40 letters:
				RegexMatch(clip, "\S.{0,40}(?=(\s|.)?)", display)
				If display1 !=
					display .= "... (" . (lines0 > 1 ? lines0 . " lines, " : "" ) . StrLen(clip) . " chars)"
			}
			clip =

			; Make sure its a valid display:
			If display =
			{	; We still haven't found display text, so let's use the title of the active window:
				length := StrLen(clipAll)
				WinGetTitle display, A
				display = (%display% - %length% bytes)
			}
		Return
	;EndRegion

	;Region " Internal Methods: SendPasteCommand / CQSuspendMonitor / CQResumeMonitor "

		ClipQueuePaste:
		SendPasteCommand:
			If (cqCount = 0 OR cqIndex < 0 OR cqCount < cqIndex) ; Make sure index is in bounds
				Return ; (don't paste if we're out-of-bounds)
			; Load the clipboard from the selected file:
			GoSub LoadClipboard
			; Paste the contents:
			Send ^v
		Return
		LoadClipboard: ; Inputs cqIndex and loads the clipboard
			; Improve performance by keeping track of the actual clipboard
			if (cqIndex = cqIndexOfActualClipboard) ; We don't need to re-load the clipboard!
				return
			GoSub CQSuspendMonitor
			ClipFile := ClipFile%cqIndex%
			FileRead clipboard, *c %ClipFile%
			; Keep track of the "active clipboard"
			cqIndexOfActualClipboard := cqIndex
		Return
		CQSuspendMonitor10:
			cqSuspend := true
			SetTimer CQResumeMonitor, -10000
		Return
		CQSuspendMonitor:
			cqSuspend := true
			SetTimer CQResumeMonitor, -500
		Return
		CQResumeMonitor:
			cqSuspend := false
		Return

	;EndRegion

	;Region " ShowClipQueueWindow / CloseClipQueueWindow "
		ShowClipQueueWindow:
			; First let's get the ctrlState
			GetKeyState ctrlState,CTRL
			ctrlKeyDown := false
			If ctrlState = D
				ctrlKeyDown := true
				
			; Create our "Accordian" display:
			AccordianText =
			Top =
			Middle =
			Bottom =
			Loop, %cqCount%
			{	
				display := ClipDisplay%A_Index%
				If (ClipLock%A_Index%)
					display := "* " . display
				
				If (A_Index < cqIndex) {
					If Top !=
						Top .= "`n"
					Top .= display
				} Else If (A_Index = cqIndex) {
					Middle := display
				} Else {
					If Bottom !=
						Bottom .= "`n"
					Bottom .= display
				}
			}
			
			If Middle =
				Middle := " "
			If (cqIndex > cqCount)
				Middle := "(Cancel paste)"
			If (cqCount = 0)
				Middle := "(Clipboard Queue is empty)"
			
			; Create our list of options:
			accordianOptions := ClipQueueDisplayOptions
			; Choose an alternate FG color if there is no action on release:
			If (OnCtrlKeyRelease = "" OR cqIndex > cqCount OR cqCount = 0)
				StringReplace accordianOptions, accordianOptions, _CFG, ForeGround, All
			
			ShowAccordian(Top, Middle, Bottom, accordianOptions)
			
			
			_SplashClipQueueWindowDelay := 1500
			SetTimer _SplashClipQueueWindow, 15
			Return
			
			_SplashClipQueueWindow:
				_SplashClipQueueWindowDelay -= 15
				
				; Get the status of the Ctrl key:
				GetKeyState ctrlState,CTRL
				If ctrlState = D
				{	ctrlKeyDown := true
					Return ; Keep waiting for the Ctrl key release
				}
				
				; The Ctrl key must be up:
				
				; See if we should hide the window:
				If (!ctrlKeyDown AND _SplashClipQueueWindowDelay > 0) ; The Ctrl key was never down, so we are still waiting
					Return

			CloseClipQueueWindow:
				; Hide the window:
				HideAccordian(" GuiKeyClipQueue ")
				SetTimer _SplashClipQueueWindow, Off
				; Execute the final command:
				If OnCtrlKeyRelease !=
					GoSub %OnCtrlKeyRelease%
					
			Return
		Return
		
	;EndRegion

