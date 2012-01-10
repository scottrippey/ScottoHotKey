;This script will turn Win+V into a special paste, where the entire clipboard contents
;will be typed instead of just pasted.  This will allow you to paste places
;where paste isn't supported.
#v::
	KeyWait LWin ; Wait for Win key to be released so Win+L doesn't accidentally register.
	SendInput {RAW}%Clipboard%
return

