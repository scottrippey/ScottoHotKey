
^#x::
	addX = 0
	addY = 0
	InputBox, addX, Add to X, How many pixels would you like to add to X?
	If addX =
		Return
	GoTo AddXY
^#y::
	addX = 0
	addY = 0
	InputBox, addY, Add to Y, How many pixels would you like to add to Y?
	If addY =
		Return
	GoTo AddXY
AddXY:

	newClip =
	clip := clipboard
	Loop, parse, clip, `n
	{	
		If newClip !=
			newClip .= "`n"

		If (addX != 0) AND RegexMatch(A_LoopField, "i)(?<=\bx)\d+\b", out) {
			newClip .= RegexReplace(A_LoopField, "i)(?<=\bx)\d+\b", out + addX)
		}
		Else If (addY != 0) AND RegexMatch(A_LoopField, "i)(?<=\by)\d+\b", out) {
			newClip .= RegexReplace(A_LoopField, "i)(?<=\by)\d+\b", out + addY)
		}
		Else {
			newClip .= A_LoopField
		}
	}
	clipboard := newClip
	newClip =
Return
	
	