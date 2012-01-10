; Pop-up file menu
; For now, it only works with N++:
#IfWinActive ahk_class Notepad++

	^space::
		; Get the path of the currently opened file:
		WinGetTitle filename, A
		filename := RegexReplace(filename, "^\*", "")
		filename := RegexReplace(filename, " - Notepad++", "")
		folder := RegexReplace(filename, "\\[^\\]*$", "")
		
		; See if there's any text highlighted:
		GoSub BackupClipboard
		clipboard =
		Send ^c
		ClipWait, 0.2
		If (ErrorLevel = 0 AND clipboard != "") {
			highlighted := clipboard
			If (InStr(highlighted, "\") = 1) {
				StringTrimLeft highlighted, highlighted, 1
			}
			; See if the highlighted text exists as a relative or absolute path:
			attr := FileExist(folder . "\" . highlighted)
			If (attr != "") {
				highlighted := folder . "\" . highlighted
			} Else {
				attr := FileExist(highlighted)
			}
			
			If (attr = "") {
				; File Not Found
			} Else If (InStr(attr, "D")) {
				; Its a directory
				folder := highlighted
				Send {Right}
			} Else {
				; Its a file
				filenameLength := StrLen(highlighted)
				folder := RegexReplace(highlighted, "\\[^\\]*$", "")
				filenameLength := filenameLength - StrLen(folder) - 1
				Send {Right}
				SendInput +{Left %filenameLength%}
			}
		}
		GoSub RestoreClipboard
		
		
	ShowFolder:
		; Clear menu:
		Menu, Folders, Add, Empty, FolderClicked
		Menu, Folders, Delete
		itemCount = 0


		Menu, Folders, Add, .., FolderClicked
		
		Loop, %folder%\*, 2 ; Add all folders
		{
			Menu, Folders, Add, %A_LoopFileName%, FolderClicked
			itemCount++
		}

		Menu, Folders, Add ; Blank line

		Loop, %folder%\*, 0 ; Add all files
		{
			Menu, Folders, Add, %A_LoopFileName%, FileClicked
			itemCount++
		}

		
		If (itemCount = 0) {
			Menu, Folders, Add, No Folders or Files found, DoNothing
		}

		Menu, Folders, Show, %A_CaretX%, %A_CaretY%
	Return

	DoNothing:
	Return
	FolderClicked:
		Sleep 100 ; Wait for the menu to close
		SendInput {Raw}%A_ThisMenuItem%\
		Sleep 50 ; Updates the caret position
		folder .= "\" . A_ThisMenuItem
		GoTo ShowFolder
	FileClicked:
		Sleep 100 ; Wait for the menu to close
		SendInput {Raw}%A_ThisMenuItem%
		Sleep 50 ; Updates the caret position
	Return


#IfWinActive
