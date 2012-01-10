^CapsLock::
	; Toggle CapsLock:
	If GetKeyState("CapsLock", "T")
		SetCapsLockState Off
	Else
		SetCapsLockState On
Return
*CapsLock::Return ; Disable CapsLock
;Region " Left-Hand Arrow Keys "
		;^CapsLock::Return ;Send {CapsLock Up}
		;+CapsLock::Return
		ShowCapsLockArrowsHint:
			hint =
			(ltrim
				1	2	3	4	5	=>				(^)				<=	6	7	8	9	0
				q	w	e	r	t	=>		(«)	 «	 ^	[^]	(+)		<=	y	u	i	o	p
				a	s	d	f	g	=>		(<)	 <	 v	 >	(>)		<=	h	j	k	l	;
				z	x	c	v	b	=>		(»)	  »	(v)	[v]	(-)		<=	n	m	,	.	/
				(Ctrl), [PageUp/PageDown], « Home, » End,	Press CapsLock + Space to hide this message.
			)
			ShowAccordian("", "Left-Handed Arrow Keys", hint, " GuiKeyLeftHandArrowKeys  XRight YBottom Top Left MonitorCaret FGBlack BGWhite Alpha224 ")
		Return
		#IfWinExist AccordianLeftHandArrowKeys
			CapsLock & Space::
				HideAccordian(" GuiKeyLeftHandArrowKeys ")
			Return
		#IfWinExist
		
		; Left hand arrow keys:
		CapsLock & s:: Send {Left}
		CapsLock & d:: Send {Down}
		CapsLock & f:: Send {Right}
		CapsLock & e:: Send {Up}
		CapsLock & a:: Send ^{Left}
		CapsLock & g:: Send ^{Right}
		CapsLock & 3:: Send ^{Up}
		CapsLock & c:: Send ^{Down}

		CapsLock & w:: Send {Home}
		CapsLock & x:: Send {End}
		CapsLock & q:: Send ^{Home}
		CapsLock & z:: Send ^{End}

		CapsLock & r:: Send {PgUp}
		CapsLock & v:: Send {PgDn}
		CapsLock & t:: Send ^{NumpadAdd}
		CapsLock & b:: Send ^{NumpadSub}

		CapsLock & LAlt:: Send {AppsKey}
		
		; Right hand:
		CapsLock & j:: Send {Left}
		CapsLock & l:: Send {Right}
		CapsLock & i:: Send {Up}
		CapsLock & k:: Send {Down}
		CapsLock & h:: Send ^{Left}
		CapsLock & `;:: Send ^{Right}
		CapsLock & 8:: Send ^{Up}
		CapsLock & ,:: Send ^{Down}

		CapsLock & u:: Send {Home}
		CapsLock & m:: Send {End}
		CapsLock & y:: Send ^{Home}
		CapsLock & n:: Send ^{End}

		CapsLock & o:: Send {PgUp}
		CapsLock & .:: Send {PgDn}
		CapsLock & p:: Send ^{NumpadAdd}
		CapsLock & /:: Send ^{NumpadSub}

		CapsLock & `:: Send {Backspace}
	#IfWinExist

;EndRegion

;Region " Mirrored Keyboard "
	CapsLock & Space::
		middle := "Mirrored Keyboard is Enabled"
		bottom =
		(ltrim
			Hold 'Space' to invert keys, 
			'Control' to invert and capitalize,
			or press 'CapsLock + Space' to disable.
		)
		options := " GuiKeyMirroredKeyboardEnabled XRight YBottom Top Left MonitorCaret FGBlack BGWhite Alpha224 "
		ShowAccordian("",middle, bottom, options)
	Return
	#IfWinExist AccordianMirroredKeyboardEnabled ahk_class AutoHotkeyGUI
		CapsLock & Space::
			HideAccordian(" GuiKeyMirroredKeyboardEnabled ")
			GoSub ShowCapsLockArrowsHint
		Return
		
		; Control keys:
		Space:: Send {Space}
		Space & CapsLock:: Send {Enter}
		Space & Tab:: Send {Backspace}

		; Space + LeftHand = Lowercase
		Space & 1:: Send 0
		Space & 2:: Send 9
		Space & 3:: Send 8
		Space & 4:: Send 7
		Space & q:: Send p
		Space & w:: Send o
		Space & e:: Send i
		Space & r:: Send u
		Space & t:: Send y
		Space & a:: Send `;
		Space & s:: Send l
		Space & d:: Send k
		Space & f:: Send j
		Space & g:: Send h
		Space & z:: Send /
		Space & x:: Send .
		Space & c:: Send `,
		Space & v:: Send m
		Space & b:: Send n

		; ; Ctrl + LeftHand = Uppercase
		^1:: Send )
		^2:: Send (
		^3:: Send *
		^4:: Send &
		^q:: Send P
		^w:: Send O
		^e:: Send I
		^r:: Send U
		^t:: Send Y
		^a:: Send :
		^s:: Send L
		^d:: Send K
		^f:: Send J
		^g:: Send H
		^z:: Send ?
		^x:: Send >
		^c:: Send <
		^v:: Send M
		^b:: Send N

	#IfWinExist	
;EndRegion
