#SingleInstance Force
GoTo AutoExecute
#Include %A_ScriptDir%\ShowToolTip.ahk
AutoExecute:
;-----------------------------------------------
; Proton IDE Include File Combiner
; I know there's probably a better title.
; This script will parse a ".bas" file for the "Include" statement, 
; and create a single file that contains the contents of all files.
;-----------------------------------------------

	; compiler = C:\Program Files (x86)\Crownhill\PDS\PrPlus.exe
	commandCount = %0%
	command1 = %1%
	command2 = %2%

	; Figure out the sourceFile:
	sourceFile = 
	if (commandCount >= 1)
		sourceFile := command1
	; Choose a file:
	FileSelectFile sourceFile, 1, %sourceFile%, Please select the source file to combine:, PicBasic Files (*.bas)
	If ErrorLevel = 1
	{	MsgBox Canceled!
		ExitApp
	}
	; Break it down:
	SplitPath sourceFile, , sourcePath, sourceExt, sourceFN
	If sourcePath =
		sourcePath := A_WorkingDir ; Just in case the filename was relative and the working dir was set
	; Set our working directory:
	SetWorkingDir %sourcePath%
	sourceFile = %sourcePath%\%sourceFN%.%sourceExt%
	
	
	; Figure out the destFile:
	destFile = %sourcePath%\%sourceFN% (Combo).%sourceExt% ; This is the default destFile
	If (commandCount >= 2)
		destFile := command2
	Else {
		FileSelectFile destFile, S16, %destFile%, Where do you want to save the combined file?, PicBasic Files (*.bas)
		If ErrorLevel = 1
		{	MsgBox Canceled!
			ExitApp
		}
	}
	
	IfNotExist %sourceFile%
	{	MsgBox The source file cannot be found!`n%sourceFile%
		ExitApp
	; } Else IfNotExist %compiler%
	; {	MsgBox The compiler cannot be found!`n%compiler%
		; ExitApp
	} 


	SplitPath destFile, fn, dir
	MsgBox, 
	(ltrim
		How to use File Combiner:
		While in Notepad++, press "F10".
		This will update and compile the following file: "%fn%"
		in the folder "%dir%"
	)


	; Make sure the destination folder exists:
	IfNotExist %dir%
		FileCreateDir %dir%

	CombineIncludes( sourceFile, destFile )
	; See if Proton is available:
	IfWinNotExist Proton IDE
	{	Run %destFile%
	}
	
Return


#IfWinActive ahk_class TMainForm ;Proton IDE
F10::
;	sourceFile = %1%
	send {End}{Space}{Backspace} ;this invalidates the file, making sure that "Save All" is available.
	Send !fv{Enter} ;save all
	Sleep 300
	
	ToolTip Combining Files...
	CombineIncludes(sourceFile, destFile) ;create the file
	Sleep 300

	ToolTip Reloading File...
	Send ^{Tab 10} ;sending Ctrl-Tab until a dialog pops up, indicating that we've found the "combined" file
	;Send !fr1 ; reopen the last file
	;Sleep 500
	
	Send !y ; hit "yes" to reopen the last file
	Send {F9} ;compile the combined program.
	
	ToolTip
Return

#IfWinActive ahk_class Notepad++ 
F10::

	ToolTip Combining Files...

	; Save-All
	Send ^+s
	Sleep 300
	
	CombineIncludes(sourceFile, destFile) ; Create the file
	Sleep 300
	
	ToolTip Reloading File...
	; See if Proton is available:
	IfWinNotExist Proton IDE
	{	Run %destFile%
		WinWait Proton IDE
		WinActivate
	} Else {
		WinActivate
		Send ^{Tab 10} ;sending Ctrl-Tab until a dialog pops up, indicating that we've found the "combined" file
		;Send !fr1 ; reopen the last file
		;Sleep 500
		
		Send !y ; hit "yes" to reopen the last file
		Send {F9} ;compile the combined program.
	}
	ToolTip
	; ; Time the compile:
		; StartTime := A_Now
		
		; ; Now compile the file:
		; RunWait, %compiler% "%destFile%", , , CompilerPID
		
		; ; Finished compiling, show a message:
		; ElapsedTime := A_Now
		; EnvSub ElapsedTime, %StartTime%, seconds
		; ShowToolTip("Compile complete, took " . ElapsedTime . " seconds", 5000)

		
Return
#IfWinActive

CombineIncludes(sourceFile, destFile) {

	FileRead source, %sourceFile%
	
	FileDelete %destFile%
	FormatTime now
	FileAppend, ''' This file was last updated at %now%`n, %destFile%
	
	lastFoundPos := 1
	Loop {
		;includePattern = im)^\s*Include "(?<FileName>.+\.bas)" ; Only include "*.bas"
		includePattern = im)^\s*Include "(?<FileName>.+)" ; Include every file
		FoundPos := RegexMatch(source, includePattern, includeStatement, lastFoundPos)

		if FoundPos = 0
			break
		
		;Append the source file:
		sourcePart := SubStr(source, lastFoundPos, FoundPos - lastFoundPos)
		FileAppend %sourcePart%, %destFile%

		FileAppend '''################################ Begin %includeStatementFileName% ################################`n, %destFile%
		
		; Read the include file:
		FileRead include, %includeStatementFileName%
		; Append the include file:
		FileAppend %include%, %destFile%


		FileAppend `n'''############################## %includeStatementFileName% Finished ###############################`n`n`n`n`n, %destFile%
		
		lastFoundPos := FoundPos + StrLen(includeStatement)
	}

	;Append the final part of the source file:
	sourcePart := SubStr(source, lastFoundPos)
	FileAppend %sourcePart%, %destFile%
	; ShowToolTip(destFile, 4000)
}
