KeyboardMirror(enabled = True, TimeoutRevert = 5)
{
	Global kbLayout  := "12345qwertasdfgzxcvb-0987poiuy;lkjh/.,mn"
	Global kbMirrored := "-0987poiuy;lkjh/.,mn12345qwertasdfgzxcvb"
	Global kbMirrorTimeout := TimeoutRevert * 1000
	Global kbMirrorEnabled := enabled

	
	if (enabled = True) {
		enabled = On
	} else {
		enabled = Off
	}
	
	Loop, Parse, kbLayout
	{
		Hotkey *%A_LoopField%, SendHotKeyMirror, %enabled%
	}
	HotKey *``, SendHotKeyMirror, %enabled%
	HotKey *Tab, SendHotKeyMirror, %enabled%
	
	Gosub ResetKeyboardMirrorTimeout
	
}


SendHotKeyMirror:
	StringTrimLeft ThisHotKey, A_ThisHotKey, 1
	pressedKeyIndex := InStr(kbLayout, ThisHotKey )
	if (pressedKeyIndex > 0) {
		newKey := SubStr(kbMirrored, pressedKeyIndex, 1)
		if (GetKeyState("CapsLock", "T"))
			StringUpper newKey, newKey
		Send %newKey%
	} else {
		if (ThisHotKey = "``") {
			Send {BackSpace}
		} else if (ThisHotKey = "Tab") {
			Send {Enter}
		} else {
			msgbox Unrecognized Hot Key: %ThisHotKey%
		}
	}
	
	Gosub ResetKeyboardMirrorTimeout
Return

ResetKeyboardMirrorTimeout:
	SetTimer DisableKeyboardMirror, Off
	if (kbMirrorEnabled = True and kbMirrorTimeout > 0) {
		SetTimer DisableKeyboardMirror, %kbMirrorTimeout%
	}
return

DisableKeyboardMirror:
	KeyboardMirror(False, 0)
	SetTimer DisableKeyboardMirror, Off
	ShowToolTip("Keyboard Layout has been returned to normal")
return

