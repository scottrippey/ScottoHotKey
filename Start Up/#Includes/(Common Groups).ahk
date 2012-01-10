;Auto-Execute:
; Create a set of commonly used groups:

	; ahk_group Explorer : Represents all Explorer windows
	GroupAdd Explorer, ahk_class CabinetWClass ;my computer
	GroupAdd Explorer, ahk_class ExploreWClass ;explorer
	
	; ahk_group AllExplorer : Represents all windows with Explorer-like features, such as rename, copy, etc...
	GroupAdd AllExplorer, ahk_class CabinetWClass ;my computer
	GroupAdd AllExplorer, ahk_class ExploreWClass ;explorer
	GroupAdd AllExplorer, ahk_class #32770 ;open dialogs
	GroupAdd AllExplorer, ahk_class Progman ;desktop
	GroupAdd AllExplorer, ahk_class WorkerW ;Win V/7 desktop


	; ahk_group AnyBrowser : Any browser window
	GroupAdd, AnyBrowser, - Google Chrome				  ; Google Chrome
	GroupAdd, AnyBrowser, ahk_class MozillaUIWindowClass ; Firefox 3
	GroupAdd, AnyBrowser, ahk_class MozillaWindowClass   ; Firefox 5
	GroupAdd, AnyBrowser, ahk_class IEFrame			  ; Internet Explorer
	
	; ahk_group Firefox
	GroupAdd, Firefox, ahk_class MozillaUIWindowClass ; Firefox 3
	GroupAdd, Firefox, ahk_class MozillaWindowClass   ; Firefox 5
	
	
	
	; ClipQueue ignore scripts:
	GroupAdd, ClipQueueIgnore, Remote Desktop Connection
	GroupAdd, ClipQueueIgnore, ahk_class XLMAIN
	GroupAdd, ClipQueueIgnore, Windows Virtual PC

Return


