
; ; Emulate the Windows 7 shortcuts:
; #Right::
	; ; We will work with the Active window:
	; WinExist("A")
	; dock := FindCurrentDock()
; DebugWrite("dockLocations", "dock=" dock)
; Return

; FindCurrentDock() {
	; ; Determine the current window's position, and 
	; ; try to determine if it is already docked:

	; ; See if its maximized
    ; WinGet, maximized, MinMax
	; If (maximized)
		; Return "Maximized"
	
	; ; Get the window bounds:
    ; WinGetPos, x, y, w, h
	; r := x+w
	; b := y+h
	; ; Get the monitor bounds:
	; m := GetMonitorAt2(x+w/2,y+h/2)
	; GoSub CalcMonitorStats2
	
	; ; Items are in Left,Top,Right,Bottom order:
	; Maximized=%monLeft%,%monTop%,%monRight%,%monBottom%
	; LeftDock=%monLeft%,%monTop%,%monCenter%,%monBottom%
	; RightDock=%monCenter%,%monTop%,%monRight%,%monBottom%
	; TopDock=%monLeft%,%monTop%,%monRight%,%monMiddle%
	; BottomDock=%monLeft%,%monMiddle%,%monRight%,%monBottom%
	
	; dockLocations = Maximized|LeftDock|RightDock|TopDock|BottomDock
	; Loop, parse, dockLocations, |
	; {	dockName := A_LoopField		
		; RegexMatch(%dockName%, "(.*)=(.*)", dockLocation)
		; If (x "," y "," r "," b = dockLocation2) {
			; Return dockLocation1
		; }
	; }
	; Return "None"
	
	; CalcMonitorStats2:
		; ; Get work area (excludes taskbar-reserved space.)
		; SysGet, mon, MonitorWorkArea, %m%
		; monWidth  := monRight - monLeft
		; monHeight := monBottom - monTop
		; monCenter := Round(monLeft + monWidth/2)
		; monMiddle := Round(monTop + monHeight/2)
	; return
; }	


; GetMonitorAt2(x, y, default=1)
; {
    ; SysGet, m, MonitorCount
    ; ; Iterate through all monitors.
    ; Loop, %m%
    ; {   ; Check if the window is on this monitor.
        ; SysGet, Mon, Monitor, %A_Index%
        ; if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom)
            ; return A_Index
    ; }

    ; return default
; }
