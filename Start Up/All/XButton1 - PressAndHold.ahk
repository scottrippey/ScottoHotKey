;Actions Syntax:
;Action Title:ActionLabel,DelayMS
;Action Title=KeyStrokes,DelayMS
;KeyStrokes,DelayMS

XButton1::
	XB1Actions =
	(ltrim
		:PressBack,250
		Press Enter:PressEnter,500
		Copy:CopyToClip,500
		Cut:CutToClip,750
		Paste:PasteClip,750
		Cancel
	)
	PressAndHold("XButton1", XB1Actions, False)
return
PressBack:
	Send {XButton1}
return
PressEnter:
	Send {Enter}
return

CopyToClip:
	GoSub ClipQueueCopy
	ShowToolTip("Contents Copied to Clipboard")
return
CutToClip:
	GoSub ClipQueueCut
	ShowToolTip("Contents Cut to Clipboard")
return
PasteClip:
	GoSub ClipQueuePaste
	ShowToolTip("Contents Pasted from Clipboard")
return
