
global total := 0
global hitrate := 135
global offset := 5
global padding := 20

Gui, +AlwaysOnTop
Gui, Add, Button, default x10 y5 w60 h30, Perfect
Gui, Add, Button, default x80 y5 w60 h30, Excellent
Gui, Add, Button, default x150 y5 w60 h30, Good
Gui, Add, Button, default x220 y5 w60 h30, Fair
Gui, Add, Button, default x290 y5 w60 h30, Bad
Gui, Add, Button, default x360 y5 w60 h30, Unsure
Gui, Add, Progress, x10 y40 w380 h30 -0x00000001 vMyProgress, 0
Gui, Add, Text, x390 y47 w30 h10 Center vProgressText, 100`%
Gui, Show, NoActivate, % total . " Ratings - " . Round(total / hitrate, 2) . " Hours"
Return

GuiClose:
	ExitApp
Return

ButtonPerfect: 
	ratePerfect()
Return

ButtonExcellent: 
	rateExcellent()
Return

ButtonGood: 
	rateGood()
Return

ButtonFair: 
	rateFair()
Return

ButtonBad: 
	rateBad()
Return

ButtonUnsure: 
	rateUnsure()
Return

^p:: ratePerfect()
^e:: rateExcellent()
^g:: rateGood()
^f:: rateFair()
^b:: rateBad()
^u:: rateUnsure()

ratePerfect() {
	Submit(0)
}

rateExcellent() {
	Submit(1)
}

rateGood() {
	Submit(2)
}

rateFair() {
	Submit(3)
}

rateBad() {
	Submit(4)
}

rateUnsure() {
	Submit(5)
}

Submit(index) {

	CoordMode, Mouse, Screen
	MouseGetPos, Oldx, Oldy 
	CoordMode, Mouse, Relative
	
	WinActivate ahk_class IEFrame
	Send ^{End}
	Sleep, 250
	PixelSearch, Px, Py, 0, 250, 1000, 1000, 0x707070, 0, Fast

	if (ErrorLevel) {
		MsgBox, That color was not found in the specified region.
	}
	else{
		MouseMove, Px, Py + offset + padding * index, 1
		Click
		MouseMove, Px, Py + 325, 1
		Click
		
		CoordMode, Mouse, Screen
		MouseMove, Oldx, Oldy, 1
		CoordMode, Mouse, Relative
		
		total++
		
		GuiControl,, MyProgress, % Floor(Mod(total, hitrate / 2) / (hitrate / 2) * 100)
		GuiControl,, ProgressText, % Round(Mod(total, hitrate / 2) / (hitrate / 2) * 100, 1) . `%
		Gui, Show, NoActivate, % total . " Ratings"
	}
}