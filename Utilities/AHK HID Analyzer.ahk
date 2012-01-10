; Source: http://www.autohotkey.com/forum/topic39574.html
;
; List all of the "Raw Input" devices available for use and allow
; capture of output
;
; There may be more than one 'raw' device per device actually attached
; to the system. This is because these devices generally represent
; "HID Collections", and there may be more than one HID collection per
; USB device. For example, the Natural Keyboard 4000 supports a normal
; keyboard HID collection, plus an additional HID collection that can
; be used for the zoom slider and other important buttons

; Replace any previous instance
#SingleInstance force

DetectHiddenWindows, on
OnMessage(0x00FF, "InputMessage")

SizeofRawInputDeviceList := 8
SizeofRidDeviceInfo := 32
SizeofRawInputDevice := 12

RIM_TYPEMOUSE := 0
RIM_TYPEKEYBOARD := 1
RIM_TYPEHID := 2

RIDI_DEVICENAME := 0x20000007
RIDI_DEVICEINFO := 0x2000000b

RIDEV_INPUTSINK := 0x00000100

RID_INPUT       := 0x10000003

DoCapture := 0
DoCaptureHID := 0

Gui, Add, Edit, HScroll w400 h140 x10 y10 vInfoOut -Wrap ReadOnly HwndInfoHwnd
Gui, Add, Edit, HScroll w400 h440 x10 y150 vEditOut -Wrap ReadOnly HwndEditHwnd
Gui, Add, Edit, VScroll HScroll w400 h600 x420 y10 vCodeOut -Wrap HwndCodeHwnd
Gui, Add, Button, Default gCapture vCaptureButton x10 y620, &Capture ALL Devices
Gui, Add, Button, gCaptureHID vCaptureHIDButton x+10, Capture &HID Devices Only
GUI, Add, Button, gClearOutput x+80, Clear Output
Gui, Show, , HIDList

HWND := WinExist("HIDList")

Res := DllCall("GetRawInputDeviceList", UInt, 0, "UInt *", Count, UInt, SizeofRawInputDeviceList)

InfoOutput("There are " . Count . " raw input devices`r`n`r`n")
CodeOutput("#Include AHK HID Register.ahk`r`n")

VarSetCapacity(RawInputList, SizeofRawInputDeviceList * Count)

Res := DllCall("GetRawInputDeviceList", UInt, &RawInputList, "UInt *", Count, UInt, SizeofRawInputDeviceList)

MouseRegistered := 0
KeyboardRegistered := 0

Loop %Count% {
   Handle := NumGet(RawInputList, (A_Index - 1) * SizeofRawInputDeviceList)
   Type := NumGet(RawInputList, (A_Index - 1) * SizeofRawInputDeviceList + 4)
   if (Type = RIM_TYPEMOUSE)
      TypeName := "RIM_TYPEMOUSE"
   else if (Type = RIM_TYPEKEYBOARD)
      TypeName := "RIM_TYPEKEYBOARD"
   else if (Type = RIM_TYPEHID)
      TypeName := "RIM_TYPEHID"
   else
      TypeName := "RIM_OTHER"

   ; Get the name length
   Res := DllCall("GetRawInputDeviceInfo", UInt, Handle, UInt, RIDI_DEVICENAME, UInt, 0, "UInt *", Length)
   ; Get the name
   VarSetCapacity(Name, Length + 2)
   Res := DllCall("GetRawInputDeviceInfo", UInt, Handle, UInt, RIDI_DEVICENAME, "Str", Name, "UInt *", Length)

   ; Get the extended info
   VarSetCapacity(Info, SizeofRidDeviceInfo)   
   NumPut(SizeofRidDeviceInfo, Info, 0)
   Length := SizeofRidDeviceInfo
   
   Res := DllCall("GetRawInputDeviceInfo", UInt, Handle, UInt, RIDI_DEVICEINFO, UInt, &Info, "UInt *", SizeofRidDeviceInfo)

   ; Append some of the obtained data to the output window:
   output = Device #%A_Index%:`t Handle: %Handle% `t Type: %Type% (%TypeName%) `t
   InfoOutput(output)

   if (Type = RIM_TYPEMOUSE)
      InfoOutput("Buttons: " . NumGet(Info, 4 * 3) . "`t Sample rate " . NumGet(Info, 4 * 4))
   else if (Type = RIM_TYPEKEYBOARD)
      InfoOutput("Mode: " . NumGet(Info, 4 * 4) . "`t Function keys: " . NumGet(Info, 4 * 5))
   else if (Type = RIM_TYPEHID)
   {     
      InfoOutput("VendorID: " . NumGet(Info, 4 * 2) . "`t ProductID: " . NumGet(Info, 4 * 3) . "`t Version: " . NumGet(Info, 4 * 4))
      UsagePage := NumGet(Info, (4 * 5), "UShort")
      Usage := NumGet(Info, (4 * 5) + 2, "UShort")
      InfoOutput("`t UsagePage: " . UsagePage . "`t Usage: " . Usage)
      CodeOutput("RegisterRawInputDevice(" . UsagePage . ", " . Usage . ") `; Registers the device with the Handle`: " . Handle . "`r`n")
   }

   InfoOutput("`t`t`t Name " . Name . "`r`n")


   ; Keyboards are always Usage 6, Usage Page 1, Mice are Usage 2, Usage Page 1,
   ; HID devices specify their top level collection in the info block   

   VarSetCapacity(RawDevice, SizeofRawInputDevice)
   NumPut(RIDEV_INPUTSINK, RawDevice, 4)
   NumPut(HWND, RawDevice, 8)
   
   DoRegister := 0
   
   if (Type = RIM_TYPEMOUSE && MouseRegistered = 0)
   {
      DoRegister := 1
      ; Mice are Usage 2, Usage Page 1
      NumPut(1, RawDevice, 0, "UShort")
      NumPut(2, RawDevice, 2, "UShort")
      MouseRegistered := 1
   }
   else if (Type = RIM_TYPEKEYBOARD && KeyboardRegistered = 0)
   {
      DoRegister := 1
      ; Keyboards are always Usage 6, Usage Page 1
      NumPut(1, RawDevice, 0, "UShort")
      NumPut(6, RawDevice, 2, "UShort")
      KeyboardRegistered := 1
   }
   else if (Type = RIM_TYPEHID)
   {
      DoRegister := 1
      NumPut(UsagePage, RawDevice, 0, "UShort")
      NumPut(Usage, RawDevice, 2, "UShort")     
   }
   
   if (DoRegister)
   {
      Res := DllCall("RegisterRawInputDevices", "UInt", &RawDevice, UInt, 1, UInt, SizeofRawInputDevice)
;~       if (Res = 0)
;~          InfoOutput("Failed to register for this device!`r`n")
;~       else
;~          InfoOutput("Registered for this device`r`n")
   }
}


Count := 1

InputMessage(wParam, lParam, msg, hwnd)
{
   global DoCapture, DoCaptureHID
   global RIM_TYPEMOUSE, RIM_TYPEKEYBOARD, RIM_TYPEHID
   global RID_INPUT
   
   if (DoCapture = 0)
      return
   
   Res := DllCall("GetRawInputData", UInt, lParam, UInt, RID_INPUT, UInt, 0, "UInt *", Size, UInt, 16)
     
   VarSetCapacity(Buffer, Size)
   
   Res := DllCall("GetRawInputData", UInt, lParam, UInt, RID_INPUT, UInt, &Buffer, "UInt *", Size, UInt, 16)

   ; AppendOutput(Mem2Hex(&Buffer, Size))
   
   Type := NumGet(Buffer, 0 * 4)
   Size := NumGet(Buffer, 1 * 4)
   Handle := NumGet(Buffer, 2 * 4)
   
   if (Type = RIM_TYPEHID)
   {
      SizeHid := NumGet(Buffer, (16 + 0))
      InputCount := NumGet(Buffer, (16 + 4))
      ;AppendOutput("HND " . Handle . " HID Size " . SizeHid . " Count " . InputCount . " Ptr " . &Buffer . "`r`n")
      Loop %InputCount% {
         Addr := &Buffer + 24 + ((A_Index - 1) * SizeHid)
         BAddr := &Buffer
         ;MsgBox, BAddr %BAddr% Addr %Addr%
         ;AppendOutput("Input " . Mem2Hex(Addr, SizeHid) . "`r`n")
         AppendOutput(Mem2Hex(Addr, SizeHid) . "`: `; Captured from Handle " . Handle . "`r`n")
         CodeOutput(Mem2Hex(Addr, SizeHid) . "`: `; Captured from Handle " . Handle . "`r`n`t `; Write code here`r`nReturn`r`n`r`n") 
      }
   }
   else if (DoCaptureHID != 1) {
      if (Type = RIM_TYPEMOUSE)
      {
         LastX := NumGet(Buffer, (16 + (4 * 3)), "Int")
         LastY := NumGet(Buffer, (16 + (4 * 4)), "Int")
         AppendOutput("HND " . Handle . " MOUSE LastX " . LastX . " LastY " . LastY . "`r`n")
      }
      else if (Type = RIM_TYPEKEYBOARD)
      {
         ScanCode := NumGet(Buffer, (16 + 0), "UShort")
         VKey := NumGet(Buffer, (16 + 6), "UShort")
         Message := NumGet(Buffer, (16 + 8))
         AppendOutput("HND " . Handle . " KBD ScanCode " . ScanCode . " VKey " . VKey . " Msg " . Message . "`r`n")
      }
      else
      {
         AppendOutput("HND " . Handle . " Unknown Type " . Type)
      }

   }
   
   return
}
return

Exit

Capture:
{
   if (DoCapture = 0)
   { 
      GuiControl, , CaptureButton, Stop &Capture
      DoCapture := 1
      DoCaptureHID := 0
   }
   else
   {
      GuiControl, , CaptureButton, &Capture ALL Devices
      DoCapture := 0
   }
   return
}
CaptureHID:
{
   If (DoCaptureHID = 0)
   {
      GuiControl, , CaptureHIDButton, &Stop Capture
      DoCapture := 1
      DoCaptureHID := 1
   }
   Else
   {
      GuiControl, , CaptureHIDButton, Capture &HID Devices Only
      DoCapture := 0
      DoCaptureHID := 0
   }
return
}



GuiClose:
ExitApp

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

InfoOutput(Text)
{
   global InfoHwnd
   GuiControlGet, InfoOut
   NewText := InfoOut . Text
   GuiControl, , InfoOut, %NewText%
   return
}
CodeOutput(Text)
{
   GuiControlGet, CodeOut
   IfNotInString, CodeOut, %Text%
   {
      NewText := CodeOut . Text
      GuiControl, , CodeOut, %NewText%
   }
   return
}

AppendOutput(Text)
{
   global EditHwnd
   GuiControlGet, EditOut
   NewText := EditOut . Text
   GuiControl, , EditOut, %NewText%
   ; WM_VSCROLL (0x115), SB_BOTTOM (7)
   ;MsgBox, %EditHwnd%
   SendMessage, 0x115, 0x0000007, 0, , ahk_id %EditHwnd%
   return
}
ClearOutput:
   GuiControlGet, EditOut
   GuiControl, , EditOut, 
   SendMessage, 0x115, 0x0000007, 0, , ahk_id %EditHwnd%
Return

F10::Reload
