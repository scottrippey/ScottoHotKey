; Auto-execute:
GroupAdd Emulators, ahk_class ZSNES
GroupAdd Emulators, Nestopia
GroupAdd Emulators, MEGASIS
EmulatorDir = C:\Users\Rippeys\Video Games\Emulators
Return


#IfWinNotActive ahk_group Emulators
Joy9:: ;start button
	actions =
	(ltrim
		Play Nintendo (Nestopia):PlayNES
		Play Super Nintendo (ZSNES):PlaySNES
		Play Sega Genesis (Megasis):PlayGenesis
		Play Game Boy Advance (VisualBoy):PlayGBA
	)
	MultiTapProgress(actions, 2000, " XR Left YB Top BGWhite A200 ")
Return
PlayNES:
	IfWinExist Nestopia
		WinActivate
	Else
		Run %EmulatorDir%\NES\Nestopia139bin\nestopia.exe
Return
PlaySNES:
	IfWinExist ZSNES
		WinActivate
	Else
		Run %EmulatorDir%\SNES\ZSnes\zsnesw.exe
Return
PlayGBA:
	IfWinExist VisualBoy
		WinActivate
	Else
		Run %EmulatorDir%\GBA\MC\VisualBoy.exe
PlayGenesis:
	IfWinExist MEGASIS
		WinActivate
	Else
		Run %EmulatorDir%\Sega Genesis\Megasis - Works Better!!!\megasis.exe
Return

#IfWinNotActive


; ; Joystick Test Script
; ; http://www.autohotkey.com
; ; This script helps determine the button numbers and other attributes
; ; of your joystick. It might also reveal if your joystick is in need
; ; of calibration; that is, whether the range of motion of each of its
; ; axes is from 0 to 100 percent as it should be. If calibration is
; ; needed, use the operating system's control panel or the software
; ; that came with your joystick.

; ; July 6, 2005: Added auto-detection of joystick number.
; ; May 8, 2005 : Fixed: JoyAxes is no longer queried as a means of
; ; detecting whether the joystick is connected.  Some joysticks are
; ; gamepads and don't have even a single axis.

; ; If you want to unconditionally use a specific joystick number, change
; ; the following value from 0 to the number of the joystick (1-16).
; ; A value of 0 causes the joystick number to be auto-detected:
; JoystickNumber = 0

; ; END OF CONFIG SECTION. Do not make changes below this point unless
; ; you wish to alter the basic functionality of the script.

; ; Auto-detect the joystick number if called for:
; if JoystickNumber <= 0
; {
	; Loop 16  ; Query each joystick number to find out which ones exist.
	; {
		; GetKeyState, JoyName, %A_Index%JoyName
		; if JoyName <>
		; {
			; JoystickNumber = %A_Index%
			; break
		; }
	; }
	; if JoystickNumber <= 0
	; {
		; MsgBox The system does not appear to have any joysticks.
		; ExitApp
	; }
; }

; #SingleInstance
; SetFormat, float, 03  ; Omit decimal point from axis position percentages.
; GetKeyState, joy_buttons, %JoystickNumber%JoyButtons
; GetKeyState, joy_name, %JoystickNumber%JoyName
; GetKeyState, joy_info, %JoystickNumber%JoyInfo
; Loop
; {
	; buttons_down =
	; Loop, %joy_buttons%
	; {
		; GetKeyState, joy%a_index%, %JoystickNumber%joy%a_index%
		; if joy%a_index% = D
			; buttons_down = %buttons_down%%a_space%%a_index%
	; }
	; GetKeyState, joyx, %JoystickNumber%JoyX
	; axis_info = X%joyx%
	; GetKeyState, joyy, %JoystickNumber%JoyY
	; axis_info = %axis_info%%a_space%%a_space%Y%joyy%
	; IfInString, joy_info, Z
	; {
		; GetKeyState, joyz, %JoystickNumber%JoyZ
		; axis_info = %axis_info%%a_space%%a_space%Z%joyz%
	; }
	; IfInString, joy_info, R
	; {
		; GetKeyState, joyr, %JoystickNumber%JoyR
		; axis_info = %axis_info%%a_space%%a_space%R%joyr%
	; }
	; IfInString, joy_info, U
	; {
		; GetKeyState, joyu, %JoystickNumber%JoyU
		; axis_info = %axis_info%%a_space%%a_space%U%joyu%
	; }
	; IfInString, joy_info, V
	; {
		; GetKeyState, joyv, %JoystickNumber%JoyV
		; axis_info = %axis_info%%a_space%%a_space%V%joyv%
	; }
	; IfInString, joy_info, P
	; {
		; GetKeyState, joyp, %JoystickNumber%JoyPOV
		; axis_info = %axis_info%%a_space%%a_space%POV%joyp%
	; }
	; ToolTip, %joy_name% (#%JoystickNumber%):`n%axis_info%`nButtons Down: %buttons_down%`n`n(right-click the tray icon to exit)
	; Sleep, 100
; }
; return
