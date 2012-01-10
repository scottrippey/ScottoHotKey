#SingleInstance Force



	FileSelectFile, files, M1, , Please select the files you would like renamed, Office Files (*.doc; *.xls)
	If files =
		Return
		
	InputBox, newDate, Enter the new date:, What is the new date you would like to use?,,,,,,,, 1-1-10
	If newDate =
		Return
	If Not RegexMatch(newDate, "^(?<M>\d\d?)\D?(?<D>\d\d?)\D?(?<Y>\d\d(?:\d\d)?)$", newDate)
	{	MsgBox Invalid date format.  Please use MM-DD-YYYY!
		Return
	}
	newDateYY := newDateY
	If StrLen(newDateYY) = 2
		newDateYY = 20%newDateYY%
	newDateMM := newDateM
	If StrLen(newDateMM) = 1
		newDateMM = 0%newDateMM%
	newDateDD := newDateD
	If StrLen(newDateDD) = 1
		newDateDD = 0%newDateDD%

		
	FileSelectFolder, dest, , 1, Please select an output folder
	If dest =
		Return
		
		

	Loop, parse, files, `n
	{
		If A_Index = 1
		{	rootPath := A_LoopField
			continue
		}
		
		newFN := A_LoopField
		newFN := RegexReplace(newFN, "\d\d?-\d\d?-\d\d(\d\d)?", newDateM . "-" . newDateD . "-" newDateY)
		newFN = %dest%\%newFN%
		

		pattern = \d\d?\/\d\d?\/(\d\d)?\d\d
		replacement = %newDateM%/%newDateD%/${1}%newDateY%
		
		fileModderRegex = C:\Users\Scott\Documents\My Shared Stuff\AutoHotKey\Utilities\File Renamer\FileModderRegex\FileModderRegex\bin\Debug\FileModderRegex.exe
; MsgBox %fileModderRegex% "%rootPath%\%A_LoopField%" "%newFN%" "%pattern%" "%replacement%"
; continue
		RunWait %fileModderRegex% "%rootPath%\%A_LoopField%" "%newFN%" "%pattern%" "%replacement%", , UseErrorLevel
		If ErrorLevel
		{	FileCopy, %rootPath%\%A_LoopField%, %newFN%
			MsgBox Could not modify the following file, so it has been copied instead: `n%newFN%
		}
		
		
		; FileRead fileContents, %rootPath%\%A_LoopField%
		; ;fileContents := RegexReplace(fileContents, "\d\d?\/\d\d?\/\d\d", newDateM . "/" . newDateD . "/" newDateY)
; ; MsgBox % StrLen(fileContents)
; ; StringLeft short, fileContents, 500
; ; Msgbox %short%
		; IfExist %newFN%
			; FileDelete %newFN%
		; FileAppend %fileContents%, *%newFN%

		
		
		FileSetTime newDateYY . newDateMM . newDateDD, %newFN%, M
		FileSetTime newDateYY . newDateMM . newDateDD, %newFN%, C
		FileSetTime newDateYY . newDateMM . newDateDD, %newFN%, A
		


		
		count := A_Index
	}
	count--
	MsgBox %count% files were copied!
		
		
Return








^r::
	IfWinActive ahk_class Notepad++
		Send ^s
	ToolTip Reloading Test...
	Sleep 500
	ToolTip
	Reload
Return
