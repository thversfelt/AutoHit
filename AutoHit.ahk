
global ElapsedTime := 0
global HitTime := 0
global Hits := 0

global Offset := 5
global Padding := 20

Gui, +AlwaysOnTop

Gui, Add, Button, default x10 y4 w60 h22, Set
Gui, Add, Text, x75 y7 w40 h20 Left, Goal = 
Gui, Add, Edit, x110 y5 w50 h20 vHitsGoal, 68
Gui, Add, Text, x162 y7 w40 h20 Left, Hits in
Gui, Add, Edit, x193 y5 w50 h20 vTimerGoal, 30
Gui, Add, Text, x245 y7 w60 h20 Left, minutes.

Gui, Add, Button, default x10 y30 w60 h30, Perfect
Gui, Add, Button, default x80 y30 w60 h30, Excellent
Gui, Add, Button, default x150 y30 w60 h30, Good
Gui, Add, Button, default x220 y30 w60 h30, Fair
Gui, Add, Button, default x290 y30 w60 h30, Bad
Gui, Add, Button, default x360 y30 w60 h30, Unsure

Gui, Add, Progress, x10 y67 w350 h30 -0x00000001 vTimerProgress, 0
Gui, Add, Text, x365 y74 w60 h20 Left vTimerProgressText, 0/0 s

Gui, Add, Progress, x10 y104 w350 h30 -0x00000001 vHitsProgress, 0
Gui, Add, Text, x365 y111 w60 h20 Left vHitsProgressText, 0/0 Hits

Set()
Return

GuiClose:
	ExitApp
Return

ButtonSet:
	Set()
Return

ButtonPerfect: 
	RatePerfect()
Return

ButtonExcellent: 
	RateExcellent()
Return

ButtonGood: 
	RateGood()
Return

ButtonFair: 
	RateFair()
Return

ButtonBad: 
	RateBad()
Return

ButtonUnsure: 
	RateUnsure()
Return

^p:: RatePerfect()
^e:: RateExcellent()
^g:: RateGood()
^f:: RateFair()
^b:: RateBad()
^u:: RateUnsure()

RatePerfect() {
	Submit(0)
}

RateExcellent() {
	Submit(1)
}

RateGood() {
	Submit(2)
}

RateFair() {
	Submit(3)
}

RateBad() {
	Submit(4)
}

RateUnsure() {
	Submit(5)
}

Set(){
	ElapsedTime := 0
	HitTime := 0
	Hits := 0
	
	UpdateGUI()
	
	start := A_TickCount
	SetTimer, Count, 1000
}

Count:
	ElapsedTime++
	HitTime++
	UpdateGUI()
return

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
		MouseMove, Px, Py + Offset + Padding * index, 1
		Click
		MouseMove, Px, Py + 325, 1
		Click
		
		CoordMode, Mouse, Screen
		MouseMove, Oldx, Oldy, 1
		CoordMode, Mouse, Relative
		
		HitTime := 0
		Hits++
		
		UpdateGUI()
	}
}

UpdateGUI(){
	GuiControlGet, HitsGoal
	GuiControlGet, TimerGoal
	
	availableTime := TimerGoal * 60 - ElapsedTime
	availableHits := HitsGoal - Hits
	allowedTime := Round(min(availableTime / availableHits, 300))
	
	GuiControl,, TimerProgress, % Round(HitTime / allowedTime * 100)
	GuiControl,, TimerProgressText, %HitTime%/%allowedTime% s
	
	GuiControl,, HitsProgress, % Round(Hits / HitsGoal * 100)
	GuiControl,, HitsProgressText, %Hits%/%HitsGoal% Hits
	
	Gui, Show, NoActivate, AutoHit
}