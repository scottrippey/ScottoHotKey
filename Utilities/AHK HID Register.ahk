; Source: http://www.autohotkey.com/forum/topic39574.html
;
; First, use the HID Preview script to figure out the UsagePage and Usage values for your HID device.
; Then, register the device using RegisterRawInputDevice(UsagePage, Usage)
; Finally, create labels for the keys you want to remap!
;
; ; Example:
; RegisterRawInputDevice(12, 1) ; MS Natural KB 4000
; ; These are some of the MS Natural KB 4000 keys:
; 0100006700010000: ; NumberPad Equals Key
;	Send =
; Return
; 010000B600010000: ; NumberPad Open Parenthesis Key
; 	send (
; Return
; 010000B700010000: ; NumberPad Close Parenthesis Key
; 	send )
; Return




	; Keyboards are always Usage 6, Usage Page 1, Mice are Usage 2, Usage Page 1,
	; HID devices specify their top level collection in the info block   
RegisterRawInputDevice(UsagePage, Usage) 
{
	; Create the hidden InputSink window:
	DetectHiddenWindows, on
	OnMessage(0x00FF, "InputMessage")

	static HWND
	IfWinNotExist, HIDCaptureWindow
	{
		Gui, Show, Hide, HIDCaptureWindow
		HWND := WinExist("HIDCaptureWindow")
	}

	; Constants:
	SizeofRawInputDeviceList := 8
	SizeofRidDeviceInfo := 32

	global RIM_TYPEMOUSE, RIM_TYPEKEYBOARD, RIM_TYPEHID
	global RID_INPUT
   
	RIM_TYPEMOUSE := 0
	RIM_TYPEKEYBOARD := 1
	RIM_TYPEHID := 2

	RIDI_DEVICENAME := 0x20000007
	RIDI_DEVICEINFO := 0x2000000b

	RIDEV_INPUTSINK := 0x00000100

	RID_INPUT       := 0x10000003

	; Combine our variables into the correct structure:
	VarSetCapacity(RawDevice, 12)
	NumPut(UsagePage, RawDevice, 0, "UShort")
	NumPut(Usage, RawDevice, 2, "UShort")     
	NumPut(RIDEV_INPUTSINK, RawDevice, 4)
	NumPut(HWND, RawDevice, 8)

    ; http://msdn.microsoft.com/en-us/library/ms645600(VS.85).aspx
	Res := DllCall("RegisterRawInputDevices", "UInt", &RawDevice, UInt, 1, UInt, 12)
	if (Res = 0)
	   MsgBox, Failed to register this input device!
}

InputMessage(wParam, lParam, msg, hwnd)
{
   global DoCapture ; enables you to deactivate the input handling
   global RIM_TYPEMOUSE, RIM_TYPEKEYBOARD, RIM_TYPEHID
   global RID_INPUT
   
   if (DoCapture = 0)
	  return
   
   ; Get the size, then get the data:
   Res := DllCall("GetRawInputData", UInt, lParam, UInt, RID_INPUT, UInt, 0, "UInt *", Size, UInt, 16)
   VarSetCapacity(Buffer, Size)
   Res := DllCall("GetRawInputData", UInt, lParam, UInt, RID_INPUT, UInt, &Buffer, "UInt *", Size, UInt, 16)
   
   ; Parse the returned structure
   Type := NumGet(Buffer, 0 * 4)
   Size := NumGet(Buffer, 1 * 4)
   Handle := NumGet(Buffer, 2 * 4)
   
;~    if (Type = RIM_TYPEHID)
;~    {
	  SizeHid := NumGet(Buffer, (16 + 0))
	  InputCount := NumGet(Buffer, (16 + 4))
	  ;Debug("HND " . Handle . " HID Size " . SizeHid . " Count " . InputCount . " Ptr " . &Buffer . "`r`n")
	  Loop %InputCount% {
		 Addr := &Buffer + 24 + ((A_Index - 1) * SizeHid)
		 BAddr := &Buffer
		 ;MsgBox, BAddr %BAddr% Addr %Addr%
		 Input := Mem2Hex(Addr, SizeHid)
		 ;Debug("Input " . Input . "`r`n")
		 if (IsLabel(Input))
			Gosub, %Input%
	  }
;~    }
   
   return
}

Mem2Hex( pointer, len )
{
 A_FI := A_FormatInteger
 SetFormat, Integer, Hex
 Loop, %len%  {
                   Hex := *Pointer+0
                   StringReplace, Hex, Hex, 0x, 0x0
                   StringRight Hex, Hex, 2           
                   hexDump := hexDump . hex
                   Pointer ++
                 }
 SetFormat, Integer, %A_FI%
 StringUpper, hexDump, hexDump
Return hexDump
}
