ShowToolTip(tip,time = 1500)
{
	ToolTip %tip%
	SetTimer RemoveThisToolTip, -%time% ;specifying a negative time will cause the timer to run only once.
}
RemoveThisToolTip:
	ToolTip ,
return
