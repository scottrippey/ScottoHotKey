SciTE4AutoHotkey v2.0
=====================

Copy the contents of this archive to:
%AhkPath%\SciTE

where %AhkPath% is the directory where AutoHotkey resides.

If you are using Windows 95/98/ME, delete the following files:

ahk.properties
toolbar.properties

and rename the following files to:

ahk.win9x.properties -> ahk.properties
toolbar.win9x.properties -> toolbar.properties

If you want the PSPad syntax highlighting style,
delete the ahk.style.properties file and rename the
ahk.style.pspad.properties to ahk.style.properties.

If you want to turn off the auto-backup function,
change the following line in ahk.properties:

make.backup=1

to:

make.backup=0

Enjoy!