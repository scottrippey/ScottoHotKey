;Auto-execute:

	; ahk_group IgnoreTripleNav
	GroupAdd, IgnoreTripleNav, ahk_class XLMAIN
Return

#IfWinNotActive ahk_group IgnoreTripleNav

	^Up::SendInput ^{Up 3}
	^Down::SendInput ^{Down 3}

	^PgUp::SendInput {Up 3}^{Up 3}{Up 3}^{Up 3}{Up 3}^{Up 3}{Up 3}^{Up 3}{Up 3}^{Up 3}
	^PgDn::SendInput {Down 3}^{Down 3}{Down 3}^{Down 3}{Down 3}^{Down 3}{Down 3}^{Down 3}{Down 3}^{Down 3}
	
#IfWinNotActive

