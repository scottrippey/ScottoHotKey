; Notes:
; Open this file with AutoHotKey to run or compile the Order Helper program.

	SetWorkingDir C:\Users\Scott\Shared Stuff\AutoHotKey\Start Up
	#Include      C:\Users\Scott\Shared Stuff\AutoHotKey\Start Up

	; @IncludeFolders:
	;	A list of all the folders to search:
	IncludeFolders = 
	(comments ltrim
		%A_WorkingDir%\#Includes
		%A_WorkingDir%\Work\Order Helper
		%A_WorkingDir%\Work\Order Helper\Standalone Project Files (exclude)
	)
	; @IncludeOrCombine:
	;	Determines the action to perform.
	;	INCLUDE: Uses "#Include" statements to create the master file.  Good for normal use and for frequently updated scripts.
	;	COMBINE: Reads the contents of each file, and appends them to the master file.  Good for portability.
	;	COMPILE: Outputs a compiled EXE.  Good for maximum portability.
	;	ASK: Prompts the user
	IncludeOrCombine := "ASK"
	; @OutputFileName:
	;	The output filename of the master file.
	;	ASK (default): Prompts the user
	OutputFileName := "ASK"
	; @FinalAction:
	;	What to do once the master file is created.
	;	"" (default): Do nothing
	;	RUN: Runs the script
	;	OPENFOLDER: Opens the folder in explorer
	;	ASK: Prompts the user
	FinalAction := "ASK"
	
	#Include AutoInclude.ahk
	