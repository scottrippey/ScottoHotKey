#SingleInstance force


; Usage Mode 1:
; Copy/Move a file.
;	Copies or moves multiple files at once, in a seperate, non-blocking process.
; Syntax:
; 	Run ShellFileOperation.exe 
;		[FO_MOVE|FO_COPY|FO_DELETE|FO_RENAME]
;		"Sources|Sources|Sources"
;		"Destination"
;		[FOF_MULTIDESTFILES|FOF_CONFIRMMOUSE|FOF_SILENT|FOF_RENAMEONCOLLISION
;		 |FOF_NOCONFIRMATION|FOF_WANTMAPPINGHANDLE|FOF_ALLOWUNDO|FOF_FILESONLY
;		 |FOF_SIMPLEPROGRESS|FOF_NOCONFIRMMKDIR|FOF_NOERRORUI|FOF_NOCOPYSECURITYATTRIBS
;		 |FOF_NORECURSION|FOF_NO_CONNECTED_ELEMENTS|FOF_WANTNUKEWARNING|FOF_NORECURSEREPARSE]

; Usage Mode 2:
; Process all INI files within a folder.
;	This allows you to queue several files for copying,
;	so that only 1 copying process occurs at once.
; Syntax:
;	Run ShellFileOperation.exe
;		"FolderToProcess"
;
; FolderToProcess should contain INI files in the following format:
;	[ShellFileOperation]
;	Command=[FO_MOVE|FO_COPY|FO_DELETE|FO_RENAME]
;	Source=...
;	Destination=...
;	Flags=[FOF_MULTIDESTFILES|FOF_CONFIRMMOUSE|FOF_SILENT|FOF_RENAMEONCOLLISION
;		   |FOF_NOCONFIRMATION|FOF_WANTMAPPINGHANDLE|FOF_ALLOWUNDO|FOF_FILESONLY
;		   |FOF_SIMPLEPROGRESS|FOF_NOCONFIRMMKDIR|FOF_NOERRORUI|FOF_NOCOPYSECURITYATTRIBS
;		   |FOF_NORECURSION|FOF_NO_CONNECTED_ELEMENTS|FOF_WANTNUKEWARNING|FOF_NORECURSEREPARSE]

	If 2 =
		GoSub ProcessFolder
	Else
		GoSub ProcessFile
	ExitApp
Return

ProcessFile:
	; Rebuild the arguments from the command args:
	fileOp = %1%
	fSource = %2%
	fTarget = %3%
	flags = %4%



	ShellFileOperation(fileOp, fSource, fTarget, flags)
Return


ProcessFolder:
	folder = %1%
	Loop
	{
		hasFiles := false
		Loop, %folder%\*.ini
		{
			; Read the source, target, and settings from the INI file:
			IniRead fileOp, %A_LoopFileFullPath%, ShellFileOperation, Command, ERROR
			IniRead fSource, %A_LoopFileFullPath%, ShellFileOperation, Source, ERROR
			IniRead fTarget, %A_LoopFileFullPath%, ShellFileOperation, Destination, ERROR
			IniRead flags, %A_LoopFileFullPath%, ShellFileOperation, Flags, ERROR
			
			If (fileOp = "ERROR" OR fSource = "ERROR" OR fTarget = "ERROR" OR flags = "ERROR") {
				MsgBox Error with ShellFileOperation for %A_LoopFileName%!
				; Rename the file so we don't keep hitting it,
				; but don't delete it because it can serve as a error log:
				FileMove %A_LoopFileFullPath%, %A_LoopFileFullPath%.error
				continue
			}

			; Signal that a copy/move operation is taking place:
			hasFiles := true

			ShellFileOperation(fileOp, fSource, fTarget, flags)
			
			; Delete the file after we've finished:
			FileDelete %A_LoopFileFullPath%
		}
		
		If (hasFiles = false)
			Break
	}
Return




#Include ShellFileOperation(FO,Source,Target,FOF).ahk
#Include StrGet(Address).ahk
