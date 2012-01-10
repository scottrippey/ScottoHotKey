#SingleInstance Force
;Region " AutoInclude ReadMe "
	; When you run this AutoInclude script, it will
	; search through the specified directories for *.ahk,
	; and will create and execute a "master file" that
	; includes all scripts found.
	;
	;
	; You should not run this script directly.  It should be included
	; in a script that sets up the options.
	; Uncomment the following section of code and place it 
	; in a separate file.
	;
	;

			; SetWorkingDir C:\Users\Rippeys\Shared Stuff\AutoHotKey\Start Up
			; #Include      C:\Users\Rippeys\Shared Stuff\AutoHotKey\Start Up

			; ; @IncludeFolders:
			; ;	A list of all the folders to search:
			; IncludeFolders = 
			; (comments ltrim
				; %A_WorkingDir%\#Includes
				; %A_WorkingDir%\All
				; %A_WorkingDir%\Dual Monitor
				; %A_WorkingDir%\Media Center
				; %A_WorkingDir%\Single Monitor
				; %A_WorkingDir%\Tablet
				; %A_WorkingDir%\Win7
				; %A_WorkingDir%\XP
			; )
			; ; @IncludeOrCombine:
			; ;	Determines the action to perform.
			; ;	INCLUDE: Uses "#Include" statements to create the master file.  Good for normal use and for frequently updated scripts.
			; ;	COMBINE: Reads the contents of each file, and appends them to the master file.  Good for portability.
			; ;	COMPILE: Outputs a compiled EXE.  Good for maximum portability.
			; ;	ASK: Prompts the user
			; IncludeOrCombine := "INCLUDE"
			; ; @OutputFileName:
			; ;	The output filename of the master file.
			; ;	ASK (default): Prompts the user
			; OutputFileName = %A_AppData%\AutoHotKey\AutoInclude.ahk
			; ; @FinalAction:
			; ;	What to do once the master file is created.
			; ;	"" (default): Do nothing
			; ;	RUN: Runs the script
			; ;	OPENFOLDER: Opens the folder in explorer
			; ;	ASK: Prompts the user
			; FinalAction := "RUN"
			
			; #Include AutoInclude.ahk
				
;EndRegion

	
	
;Region " IncludeOrCombine / OutputFileName "
	

	If (IncludeOrCombine = "" OR IncludeOrCombine = "ASK") {
		; Ask if we should COMBINE or INCLUDE
		msg =
		(ltrim
			COMBINE, INCLUDE, or COMPILE?
			
			Choose "COMBINE" to create a single AHK script with all code.
			This single script can be used anywhere AutoHotKey is installed.
			
			Choose "INCLUDE" to create a master script that links to every 
			file in the project.  This script is easier to debug and alter.
			
			Choose "COMPILE" to create a portable EXE file that can be
			used on any computer.
		)
		SetButtonNames("COMBINE, INCLUDE or COMPILE?", "&COMBINE", "&INCLUDE", "COM&PILE")
		MsgBox 0x1023, COMBINE`, INCLUDE or COMPILE?, %msg%
		IfMsgBox Yes ; COMBINE
			IncludeOrCombine = COMBINE
		IfMsgBox No ; INCLUDE
			IncludeOrCombine = INCLUDE
		IfMsgBox Cancel ; COMPILE
			IncludeOrCombine = COMPILE
	}
	
	
	
	
	If (OutputFileName = "" OR OutputFileName = "ASK") {
		; Ask for the file destination:
		If IncludeOrCombine = COMPILE
		{	FileSelectFile CompiledFileName, S16, , Where would you like to save the compiled file?, Executable File (*.exe)
			If CompiledFileName =
				Return
			SplitPath CompiledFileName, , CompiledDir
			OutputFileName = %CompiledDir%\temp %A_Now%.ahk
		}
		Else
			FileSelectFile OutputFileName, S16, , Where would you like to save the generated file?, AutoHotKey Script (*.ahk)
		
		If OutputFileName =
			Return
	}
		
		

;EndRegion

;Region " AutoCombine "

	mainWorkingDir := A_WorkingDir

	; Let's collect all the Auto-Execute lines from each file,
	; as well as all the code from each file, 
	; and create a new script that includes all of them!

	InitializeFunctions = 
	IncludeFiles = 

	; We have to "Split" the folders list for each line:
	Loop Parse, IncludeFolders, `n
	{
		IncludeFolder := A_LoopField
		If IncludeOrCombine = COMBINE
		{
			; Set the Include Path:
			IncludeFiles =
			(ltrim
											%IncludeFiles%
											
											; #Include %IncludeFolder%
											;The following files were found in this Include folder:
			)
		} Else {
			; Set the Include Path:
			IncludeFiles =
			(ltrim
											%IncludeFiles%
											
											#Include %IncludeFolder%
											;The following files were found in this Include folder:
			)
		}

		;Let's load all the files from the folder:
		SetWorkingDir %IncludeFolder%
		Loop *.ahk,0,1 ;recursive
		{
			; Ignore any files with "exclude" in the title:
			If RegexMatch(A_LoopFileFullPath, "i)\bEXCLUDE\b")
				continue
		
			; We are going to create an "#Include" directive for each file, but just in case
			; there is an auto-execute initialize function, let's be sure to copy that.

			FirstLineOfFile =
			FileReadLine FirstLineOfFile, %A_LoopFileFullPath%, 1
			
			; See if the first line of the file contains the text "auto execute"
			If RegexMatch(FirstLineOfFile, "i)auto.*execute") {
				; Create a label:
				label := A_LoopFileFullPath
				label := RegExReplace(label, "[-+'=,.!$#() `t\^[\]\\]", "_") ; Replace all filename characters that are not valid for labels
				InitializeFunctions =
				(ltrim
											%InitializeFunctions%
											GoSub %label%_Init ; Run the Auto-Execute code for this file
				)
				IncludeFiles =
				(ltrim
										%IncludeFiles%
										%label%_Init: ; Run the Auto-Execute code for this file
				)
			}
			

			If IncludeOrCombine = COMBINE
			{	FileRead FullFile, %A_LoopFileFullPath%
				IncludeFiles = 
				(ltrim
											%IncludeFiles%
											;Region "%A_LoopFileFullPath%"
											; #############################################################################
											; ###################################### Beginning of file %A_LoopFileFullPath%
											; #############################################################################
											%FullFile%
											; #############################################################################
											; ###################################### End Of File %A_LoopFileFullPath%
											; #############################################################################
											;EndRegion
				)
			} Else If IncludeOrCombine = INCLUDE
			{	
				IncludeFiles = 
				(ltrim
											%IncludeFiles%
											#Include %A_LoopFileFullPath%
				)
			} Else If IncludeOrCombine = COMPILE ; Do the same as INCLUDE
			{
				IncludeFiles = 
				(ltrim
											%IncludeFiles%
											#Include %A_LoopFileFullPath%
				)
			} 
		}
	}	
		

	FileDelete %OutputFileName%
	;Create our new file:
	FileAppend ,
	(ltrim
										;This file was automatically created from all the scripts found in the IncludeFolder
										#SingleInstance Force
										SetWorkingDir %mainWorkingDir%

										;The following Initialize functions were extracted from their corresponding #Include files:
											%InitializeFunctions%
										Return ;this will guarantee that no AutoExecute code will be called

										%IncludeFiles%
	)
	, %OutputFileName%

	If IncludeOrCombine = COMPILE
	{	ToolTip Compiling AutoHotKey Script...
	
		Compile(OutputFileName, CompiledFileName)
		FileDelete %OutputFileName%
		
		ToolTip
	
		OutputFileName := CompiledFileName
	}
	
;EndRegion

;Region " FinalAction "

	If (FinalAction = "ASK") {
		msg =
		(ltrim 
			The file has been created.  
			Would you like to run it now or open the folder?
		)
		SetButtonNames("Run or Open Folder?", "Run", "Open Folder", "Do Nothing")
		MsgBox 0x1023, Run or Open Folder?, %msg%
		IfMsgBox Yes
			FinalAction := "RUN"
		IfMsgBox No
			FinalAction := "OPENFOLDER"
		IfMsgBox Cancel
			FinalAction =
	}
	
	If (FinalAction = "RUN")
		Run %OutputFileName%
	If (FinalAction = "OPENFOLDER")
	{	SplitPath OutputFileName, , TempFolder
		Run %TempFolder%
		; Run explore "%OutputFileName%"
	}

	

Return ;EndRegion







;Region " SetButtonNames "
SetButtonNames(title, button1, button2 = "", button3 = "") {
	static t, b1, b2, b3
	t := title
	b1 := button1
	b2 := button2 
	b3 := button3
	SetTimer _SetButtonNames, 50
	Return
	_SetButtonNames:
		IfWinNotExist %t% ahk_class #32770
			Return
		SetTimer _SetButtonNames, Off
		If b1 !=
			ControlSetText Button1, %b1%
		If b2 !=
			ControlSetText Button2, %b2%
		If b3 !=
			ControlSetText Button3, %b3%
	Return
} ;EndRegion

;Region " Compile "
;http://www.autohotkey.com/forum/topic50385.html
;
; Compile() - 0.32 - by gwarble - oct 09
;  a simple function to auto-compile your scripts
;
; Compile(Action,Name,Password)
;    Action   []        -waits for the compiler to finish before returning
;             Run       -to run the compiled script and close the running script
;             NoWait    -starts compiling and continues running your script
;             Recompile -closes the running .exe and launches the .ahk (if compiled)
;
;    Name     []        -uses filename of script for exe/ico/bin filenames
;             Other     -specify a different name for the input ico/bin and output exe
;    Password **        -compilation password
;
;    Return   1 on success
;             0 on failure, compiler not found, already compiled...
;
;    Note     save custom icon as ScriptName.ico (subdir ok) or
;             save modified AutoHotkeySC.bin as ScriptName.AHK.bin
;
Compile(InputAHK,OutputEXE,Action="",Name="",Password="") {
	; If A_IsCompiled
		; If Action = Recompile
		; {
			; SplitPath, A_ScriptFullPath , , , , ScriptName  ;=== find script info
			; Run, %ScriptName%.ahk
			; ExitApp
		; }
		; Else
			; Return 0   ;=== does nothing when running already compiled
	SplitPath, InputAHK , , ScriptDir, ScriptExt, ScriptName  ;=== find script info
	If (Name)                                           ;=== override .ahk's file name
		ScriptName := Name                                 ;=  (add support for .scr)?
		
		
	; ; Find the ICON file:
	
	; Icon := ExeFile := ScriptDir "\" ScriptName ".exe"  ;=== output exe file
	ExeFile := OutputEXE

	; Loop, %ScriptName%.AHK.bin, 0, 1 ;=== use first file found named
		; IfExist %A_LoopFileFullPath%    ;=== ScriptName.AHK.bin
		; {                               ;=== as the AutoHotkeySC.bin file when compiling
			; Icon := CompilerBin := A_LoopFileFullPath
			; Break
		; }
	; If (CompilerBin = "") ;= should .ico override .bin or .bin override .ico (now)?
		; Loop, %ScriptName%.ico, 0, 1   ;=== use first icon found under
			; IfExist %A_LoopFileFullPath%  ;=== ScriptDir\ named ScriptName.ico
			; {
				; ScriptIcon = /icon "%A_LoopFileFullPath%"
				; Icon = %A_LoopFileFullPath%
				; Break
			; }

	; Find the Compiler:
	SplitPath, A_AhkPath , , Compiler, , ,             ;=== find compiler
	Compiler := Compiler "\Compiler\Ahk2Exe.exe"
	IfNotExist %Compiler%                              ;=== check registry if not found
	{
		RegRead, Compiler, HKCR, AutoHotkeyScript\Shell\Compile\Command
		StringReplace, Compiler, Compiler, ",,All									;";";"
		StringReplace, Compiler, Compiler, % "/in %l"
		IfNotExist %Compiler%                             ;=== check StartMenu if not found
		{
			Loop %A_StartMenuCommon%\*.*, 0, 1
				If A_LoopFileName contains convert .ahk to .exe
				{
					FileGetShortcut, % A_LoopFileFullPath, Compiler 				;%;%
					Break
				}
			IfNotExist %Compiler%
				Loop, %A_ScriptDir%\Ahk2Exe.exe, 0, 1           ;=== check local dir for ahk2exe
					Compiler := %A_LoopFileFullPath%               ;=== as a last resort
		}
		IfNotExist %Compiler%
			Return 0                                         ;=== compiler couldn't be found
	}

	; Close the EXE file if it's running:
	
	Prev_DetectHiddenWindows := A_DetectHiddenWindows  ;=== kill if running
	DetectHiddenWindows On                             ;=== saves script's setting
	WinClose, % ExeFile,,5                             ;%;%=== closes the .exe if running
	DetectHiddenWindows %Prev_DetectHiddenWindows%     ;=== restore setting
	
	; ; Setup Password:
	
	; If (Password)                                      ;=== sets compilation password
		; Password := "/pass " Password

	; ; Copy the bin files:
	
	; Loop, %ScriptName%.AHK.bin, 0, 1                   ;=== use first file found named
		; IfExist %A_LoopFileFullPath%                      ;=== ScriptName.AHK.bin as the
		; {                                                 ;=== AutoHotkeySC.bin file when compiling
			; SplitPath, Compiler , , CompilerDir, , ,         ;=== find compiler's AutoHotkeySC.bin
			; CompilerBin := CompilerDir "\AutoHotkeySC.bin"
			; FileCopy, % CompilerBin, % CompilerDir "\AutoHotkeySC.Last.bin", 1
			; FileCopy, % CompilerBin, % CompilerDir "\AutoHotkeySC.Orig.bin", 0
			; FileCopy, % A_LoopFileFullPath ,   % CompilerBin, 1
			; Break
		; }
		
	; Compile:

	RunLine = %Compiler% /in "%InputAHK%" /out "%ExeFile%" %ScriptIcon% %Password%

	If Action = NoWait
		Run,     % RunLine, % A_ScriptDir, Hide
	Else
		RunWait, % RunLine, % A_ScriptDir, Hide

	; If (CompilerBin)
		; FileCopy, % CompilerDir "\AutoHotkeySC.Last.bin", % CompilerBin, 1

	; ; Run the exe:
	; If Action = Run
	; {
		; Run, % ScriptName											;%;%
		; ExitApp
	; }

Return 1
} ;EndRegion







