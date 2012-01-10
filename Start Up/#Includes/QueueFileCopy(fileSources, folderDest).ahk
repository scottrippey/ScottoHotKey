
;;;Summary
;;; Copies all the fileSources to the folderDest folder.
;;; fileSources is a pipe-delimited list of files.
;;; folderDest is the destination folder, which will be created if necessary.
;;;EndSummary
QueueFileCopy(fileSources, folderDest) { ;Function
	return QueueFileMove(fileSources, folderDest, "FO_COPY")
} ;EndFunction

;;;Summary
;;; Moves all the fileSources to the folderDest folder.
;;; fileSources is a pipe-delimited list of files.
;;; folderDest is the destination folder, which will be created if necessary.
;;;EndSummary
QueueFileMove(fileSources, folderDest, command = "FO_MOVE", flags = "FOF_ALLOWUNDO|FOF_NOCONFIRMMKDIR") { ;Function
	; Queue the files to copy/move:
	

	; Create our "queue" folder:
	queueFolder = %A_AppData%\AutoHotKey\ShellFileOperation
	FileCreateDir %queueFolder%
	
	; Create the ini file:
	RegexMatch(fileSources . "|", "([^\\]+)[|]", firstFile)
	RegexMatch(folderDest . "|", "([^\\]+)[|]", firstLocation)
	
	iniFile = %queueFolder%\%A_Now% - Move %firstFile1% to %firstLocation1%.ini
	IniWrite %fileSources%, %iniFile%.tmp, ShellFileOperation, Source
	IniWrite %folderDest%, %iniFile%.tmp, ShellFileOperation, Destination
	IniWrite %command%, %iniFile%.tmp, ShellFileOperation, Command
	IniWrite %flags%, %iniFile%.tmp, ShellFileOperation, Flags
	; Rename the tmp file:
	FileMove %iniFile%.tmp,%iniFile%


	; Move the files:
	;
	; Note: Since "ShellFileOperation" is a blocking call, we have to execute it
	; in an external process!
	; 
	; See if the ShellFileOperation queue is already running
	; (in which case, it will automatically pick up our ini file):
	Process, Exist, ShellFileOperation.exe
	PID := ErrorLevel
	If (PID = 0) {
		; Script isn't running, so fire it up:
		Run %A_WorkingDir%\..\Utilities\ShellFileOperation\ShellFileOperation.exe "%queueFolder%"
	}
} ;EndFunction
