;Region Auto-Execute:
	CQE_Initialize:
	; Configure our defaults:
	CQEPattern = (.+)
	CQETemplate = {M1}
	CQEOptionS = 1
	CQEOptionM = 1
	CQEOptionI = 1
	CQEOptionX = 1
	CQEAppendAllJoin = \r\n
Return ;EndRegion

;Region " Keyboard Shortcuts "
#IfWinExist AccordianClipQueue ; Only active if the ClipQueue list is visible
	
	^e::
		OnCtrlKeyRelease = 
		GoSub CloseClipQueueWindow
		
		GoSub ShowClipQueueEditor
	Return
	
#IfWinExist ;EndRegion


	
CQE_Reset:
	GoSub CQE_Initialize
	GuiControl, , CQEPattern, %CQEPattern%
	GuiControl, , CQETemplate, %CQETemplate%
	GuiControl, , CQEOptionS, %CQEOptionS%
	GuiControl, , CQEOptionM, %CQEOptionM%
	GuiControl, , CQEOptionI, %CQEOptionI%
	GuiControl, , CQEOptionX, %CQEOptionX%
	GuiControl, , CQEAppendAllJoin, %CQEAppendAllJoin%
Return
CQE_LoadTooltips:
	; Create our tooltips:
	CQEPatternLabel_TT = 
	(ltrim comments
		This pattern is used to extract text from each item.
		The pattern is a Regular Expression.
		The following Regular Expression rules can be used:
		
		-- Single Character Classes --
		.		Matches any character		(see also Single Line)
		\w		Matches any alpha-numeric character
		\d		Matches any digit
		\s		Matches any whitespace
		[abc]		Matches a, b, or c
		[^abc]		Matches any character EXCEPT a, b, or c
		
		-- Quantity Modifiers --
		.*		Matches 0 or more characters
		.+		Matches 1 or more characters
		.?		Matches 0 or 1 character
		.{X,Y}		Matches at least X characters, at most Y characters
		.*?		Matches 0 or more characters (not greedy -- matches as few as possible)
		
		-- Special Characters --
		^		Matches the beginning of a line	(see also Multi Line)
		$		Matches the end of a line 	(see also Multi Line)
		
		-- Grouping --
		(...)		Creates a group.		This group will be captured as M1, M2, etc...
		(?<name>...)	Creates a named group.		This group will be captured as Mname.
		(?:...)		Creates an uncaptured group.
		\1		Backreference to group 1
		
		-- Look around --
		(?=...)		Look ahead group
		(?!...)		Negative look ahead group
		(?<=...)	Look behind group
		(?<!...)		Negative look behind group
		
		-- Conditional --
		(?(1)abc|def)	If group 1 was a match, then abc, else def.
		(?(?=...)abc|def)	If look around group matches, then abc, else def.
		;
		; (Not supported by AHK/PCRE, only by .NET)
		;-- Balancing Groups --
		;(?<open>[)	Pushes the bracket on the "open" stack
		;(?<contents-open>])	Pops the bracket from the "open" stack, and puts the in-between into "contents"
		;(?(open)(?!)) Fails if anything is left on the "open" stack
	)
	CQEOptionS_TT = Single Line: "." will match linefeed characters
	CQEOptionM_TT = Multi Line: "^" and "$" will match the beginning and end of each line
	CQEOptionI_TT = Ignore Case: the search will not be case-sensitive
	CQEOptionX_TT = Ignore Whitespace: spaces, tabs, and linefeeds in the pattern are ignored,`nand comments can be put at the end of a line (after the "#" character)
	CQEAppendButton_TT = Adds each checked item to the bottom of the Clipboard Queue, and closes this editor.
	CQEAppendAllButton_TT = Joins all checked items into one item, appends it to the bottom of the Clipboard Queue, and closes this editor.
	CQEAppendAllJoin_TT = This text will be used to join all checked items. `n You can use \n for LineFeed and \t for Tab.
Return	
	
	
	
	
	
	
	
	
	
ShowClipQueueEditor:
	; Show our special dialog:
	If (GuiUniqueDestroy("CQE"))
		GuiShowTooltips(false)
	GuiUniqueDefault("CQE")
	GuiShowTooltips()
	
	Gui, Font, cBlack ; (Enables CheckBoxes to have a Red color later)
	
	Gui, Add, Text, vCQEPatternLabel gDoNothing, Match the following pattern:
	Gui, Add, CheckBox, vCQEOptionS gCQE_UI_Changed Checked%CQEOptionM% x+10 yp, Single Line
	Gui, Add, CheckBox, vCQEOptionM gCQE_UI_Changed Checked%CQEOptionM% x+10 yp, Multi Line
	Gui, Add, CheckBox, vCQEOptionI gCQE_UI_Changed Checked%CQEOptionM% x+10 yp, Ignore Case
	Gui, Add, CheckBox, vCQEOptionX gCQE_UI_Changed Checked%CQEOptionM% x+10 yp, Ignore Whitespace
	Gui, Add, Button, gCQE_Reset x+10, Reset All
	Gui, Add, Edit, vCQEPattern gCQE_UI_Changed -wrap HScroll r3 x10 w810, %CQEPattern%
	
	Gui, Add, Text, vCQETemplateLabel gDoNothing , Use the following template: {M} = entire match, {M#} = group #, {Mname} = group name
	Gui, Add, Edit, vCQETemplate gCQE_UI_Changed -wrap HScroll r3 x10 w810, %CQETemplate%
	
	Gui, Add, Text, w300, Original:
	Gui, Add, Text, x+10 Section, Preview:
	Gui, Add, Button, vCQEAppendButton gCQE_AppendButton_Click x+10, Append Each to Clipboard Queue
	Gui, Add, Button, vCQEAppendAllButton gCQE_AppendAllButton_Click x+10, Append All to Clipboard Queue
	Gui, Add, ComboBox, vCQEAppendAllJoin x+10 w80, %CQEAppendAllJoin%||, |\r\n|\t| - | |
	Loop %cqCount%
	{
		checked := cqIndex <= A_Index ? 1 : 0
		Gui, Add, Text, -wrap x10 w300 r1 y+3, % clipDisplay%A_Index% ;%;%
		Gui, Add, CheckBox, vCQEPreview%A_Index% Checked%checked% -wrap xs yp w500 r1, ---------PREVIEW------------
	}
	
	Gui +AlwaysOnTop
	Gui, Show, , Clipboard Queue Editor
	GuiControl, Focus, CQEPattern
GoTo CQE_UI_Changed


; Append to Clipboard Queue:
CQE_AppendButton_Click:
	previewOnly := false
	appendAll := false
	index := cqCount
	GoSub _CQECreate
	cqIndex := index + 1
	OnCtrlKeyRelease =
	GoSub ShowClipQueueWindow
GoTo CQE_Close
CQE_AppendAllButton_Click:
	previewOnly := false
	appendAll := true
	index := cqCount
	GoSub _CQECreate
	cqIndex := index + 1
	OnCtrlKeyRelease =
	GoSub ShowClipQueueWindow
GoTo CQE_Close
; Cancel:
CQE_Escape:
CQE_Close:
	GuiUniqueDestroy("CQE")
	GuiShowTooltips(false)
	GoSub CQE_Unload
Return






CQE_UI_Changed:
	previewOnly := true
	GoTo _CQECreate
_CQECreate:
	; Reset the error labels:
	Gui, Font, cBlack
	GuiControl, Text, CQEPatternLabel, Match the following pattern:
	GuiControl, Font, CQEPatternLabel
	GuiControl, Text, CQETemplateLabel, Use the following template: {M} = entire match, {M#} = group #, {Mname} = group name
	GuiControl, Font, CQETemplateLabel

	
	; Retrieve all fields:
	GuiControlGet, CQETemplate
	GuiControlGet, CQEPattern
	GuiControlGet, CQEOptionS
	GuiControlGet, CQEOptionM
	GuiControlGet, CQEOptionI
	GuiControlGet, CQEOptionX
	GuiControlGet, CQEAppendAllJoin
	
	; Replace special characters in CQEAppendAllJoin:
	appendAllJoin := CQEAppendAllJoin
	StringReplace, appendAllJoin, appendAllJoin, \r\n, `r`n, All
	StringReplace, appendAllJoin, appendAllJoin, \n, `r`n, All
	StringReplace, appendAllJoin, appendAllJoin, \t, %A_Tab%, All

	pattern := "`a" ; `a tells the regex to match ANY type of new line, meaning `r, `n, `r`n, etc...
	pattern .= (CQEOptionS ? "s" : "") . (CQEOptionM ? "m" : "") . (CQEOptionI ? "i" : "") . (CQEOptionX ? "x" : "")
	pattern .= ")" . CQEPattern
	
	GoSub CQE_Load
	appendAllText =
	Loop %cqCount%
	{
		originalText := originalText%A_Index%
		
		regexErrors =
		formatErrors =
		; Break apart the originalText:
		If (!RegexMatch(originalText, pattern, M)) {
			regexErrors := ErrorLevel
			; No match
			Gui, Font, cRed
			GuiControl, Font, CQEPreview%A_Index%
			GuiControl, Text, CQEPreview%A_Index%, (not a match)
		} Else {
			; The match was a success!
			Gui, Font, cBlack
			GuiControl, Font, CQEPreview%A_Index%

			; Create the output:
			newText := SmartFormat(CQETemplate)
			
			; Output the preview:
			GuiControl, Text, CQEPreview%A_Index%, %newText%
			
			; Determine if we should just preview or if we should copy:
			If (!previewOnly) {
				; See if the item is checked:
				GuiControlGet, CQEPreview%A_Index%
				If (CQEPreview%A_Index%) {
					If (appendAll) {
						If appendAllText !=
							appendAllText .= appendAllJoin
						appendAllText .= newText
					} Else {
						; Append this item to the clipboard queue:
						GoSub CQSuspendMonitor
						clipboard := newText
						GoSub AppendClipboard
					}
				}
			}
		}
		
		
		If (regexErrors) {
			; Regex compile error.
			Gui, Font, cRed
			GuiControl, Text, CQEPatternLabel, Error in Regular Expression:
			GuiControl, Font, CQEPatternLabel
			GuiControl, Text, CQEPreview%A_Index%, (error in regex pattern)
			GuiControl, Font, CQEPreview%A_Index%
		}
		if (formatErrors)
		{	
			CQETemplateLabel_TT := formatErrors
			Gui, Font, cRed
			GuiControl, Text, CQETemplateLabel, %formatErrors%
			GuiControl, Font, CQETemplateLabel
		} Else {
			CQETemplateLabel_TT =
		}
	}
	
	If (!previewOnly AND appendAll) {
		; Append all items to the clipboard queue:
		GoSub CQSuspendMonitor
		clipboard := appendAllText
		GoSub AppendClipboard
	}
Return

CQE_Load:
	If (originalText0 = cqCount)
		Return ; The text is already loaded.
	
	GoSub CQE_LoadTooltips
	
	oldIndex := cqIndex
	; Load the full clipboard for each item:
	Loop %cqCount%
	{
		cqIndex := A_Index
		GoSub LoadClipboard
		originalText%A_Index% := clipboard
	}
	
	cqIndex := oldIndex
Return

CQE_Unload:
	; Unload all the clipboard text
	Loop %originalText0%
		originalText%A_Index% =
	originalText0 =
	
	; Unload tool tips:
	CQEPatternLabel_TT = 
	CQEOptionS_TT = 
	CQEOptionM_TT = 
	CQEOptionI_TT = 
	CQEOptionX_TT = 
	CQEAppendButton_TT =
	CQEAppendAllJoin_TT =
Return



