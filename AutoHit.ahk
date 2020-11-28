; Variables used for tracking time.
global CurrentTime := 0 ; In seconds
global PassedTime := 0 ; In seconds
global MaxTime := 300 ; In seconds

; Counts the number of judged hits.
global Hits := 0

; Default goal values.
global DefaultTimeGoal := 30 ; In minutes
global DefaultHitsGoal := 65

; Offset and padding between the radio buttons.
global Offset := 5
global Padding := 20

; Whether this application is paused or not.
global Paused := False

Gui, +AlwaysOnTop

; Build to top row of the GUI (pause/unpause button and goal setting)
Gui, Add, Button, x10 y4 w60 h22 vPauseButton, Pause
Gui, Add, Button, default x80 y4 w60 h22, Set
Gui, Add, Text, x145 y7 w40 h20 Left, Goal = 
Gui, Add, Edit, x180 y5 w50 h20 vHitsGoal, %DefaultHitsGoal%
Gui, Add, Text, x232 y7 w40 h20 Left, Hits in
Gui, Add, Edit, x263 y5 w50 h20 vTimeGoal, %DefaultTimeGoal%
Gui, Add, Text, x315 y7 w60 h20 Left, minutes.

; Build the middle row of the GUI (rating buttons)
Gui, Add, Button, default x10 y30 w60 h30, Perfect
Gui, Add, Button, default x80 y30 w60 h30, Excellent
Gui, Add, Button, default x150 y30 w60 h30, Good
Gui, Add, Button, default x220 y30 w60 h30, Fair
Gui, Add, Button, default x290 y30 w60 h30, Bad
Gui, Add, Button, default x360 y30 w60 h30, Unsure

; Build the last three rows of the GUI (progress bars)
Gui, Add, Progress, x10 y67 w350 h30 BackgroundE1E1E1 cGreen vTimerProgress
Gui, Add, Text, x365 y74 w80 h20 Left vTimerProgressText
Gui, Add, Progress, x10 y104 w350 h30 BackgroundE1E1E1 cGreen vTimeProgress
Gui, Add, Text, x365 y111 w80 h20 Left vTimeProgressText
Gui, Add, Progress, x10 y141 w350 h30 BackgroundE1E1E1 cGreen vHitsProgress
Gui, Add, Text, x365 y148 w80 h20 Left vHitsProgressText

; Set the initial values.
Set()
Return

; Called when the GUI is closed.
GuiClose:
	ExitApp
Return

; Called when the pause button is pressed.
ButtonPause:
	Pause()
return

; Called when the set button is pressed.
ButtonSet:
	Set()
Return

; Called when the perfect rating button is pressed.
ButtonPerfect: 
	RatePerfect()
Return

; Called when the excellent rating button is pressed.
ButtonExcellent: 
	RateExcellent()
Return

; Called when the good rating button is pressed.
ButtonGood: 
	RateGood()
Return

; Called when the fair rating button is pressed.
ButtonFair: 
	RateFair()
Return

; Called when the bad rating button is pressed.
ButtonBad: 
	RateBad()
Return

; Called when the unsure rating button is pressed.
ButtonUnsure: 
	RateUnsure()
Return

; Shortcut definitions for the ratings.
^p:: RatePerfect()
^e:: RateExcellent()
^g:: RateGood()
^f:: RateFair()
^b:: RateBad()
^u:: RateUnsure()

; Rating methods.
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

; Handles pause logic.
Pause(){
	Paused := !Paused
	if (Paused){
		GuiControl,, PauseButton, Unpause
	}
	else{
		GuiControl,, PauseButton, Pause
	}
}

; Sets the goal and starts the timer.
Set(){
	CurrentTime := 0
	PassedTime := 0
	Hits := 0
	
	UpdateGUI()
	
	start := A_TickCount
	SetTimer, Count, 1000
}

; The method that is called in the timer.
Count:
	if (!Paused){
		CurrentTime++
		UpdateGUI()
	}
return

; Submits a rating with the given index.
Submit(index) {
	; Record the mouse position.
	CoordMode, Mouse, Screen
	MouseGetPos, Oldx, Oldy 
	CoordMode, Mouse, Relative
	
	; Activate internet explorer.
	WinActivate ahk_class IEFrame
	Send ^{End}
	Sleep, 250

	; Search for the rating radio buttons.
	PixelSearch, Px, Py, 0, 250, 1000, 1000, 0x707070, 0, Fast

	if (ErrorLevel) {
		MsgBox, That color was not found in the specified region.
	}
	else{
		; Click the rating radio button based on the given index.
		MouseMove, Px, Py + Offset + Padding * index, 1
		Click

		; Click the submit button.
		MouseMove, Px, Py + 325, 1
		Click
		
		; Move the mouse back to the original position.
		CoordMode, Mouse, Screen
		MouseMove, Oldx, Oldy, 1
		CoordMode, Mouse, Relative
		
		; Update the time variables and increment the number of hits.
		PassedTime := PassedTime + CurrentTime
		CurrentTime := 0
		Hits++
		
		; Update the GUI.
		UpdateGUI()
	}
}

; Updates the GUI.
UpdateGUI(){
	; Get the hits goal and time goal.
	GuiControlGet, HitsGoal
	GuiControlGet, TimeGoal
	
	; Calculate the allowed amount of time per hit.
	allowedTime := Round(min(TimeGoal * 60 / (HitsGoal - Hits), MaxTime))

	; If the judge has passed the allowed amount of time, the timer progress
	; bar will turn red to indicate the judge has entered overtime.
	if (CurrentTime < allowedTime){
		timerProgressColor := "cGreen"
	}
	else{
		timerProgressColor := "cRed"
	}

	; Update the timer progress bar.
	GuiControl, +%timerProgressColor%, TimerProgress
	GuiControl,, TimerProgress, % Round(CurrentTime / MaxTime * 100)
	GuiControl,, TimerProgressText, %CurrentTime%/%allowedTime%~%MaxTime% s
	
	; Update the time goal progress bar.
	passedTimeMinutes := Round(PassedTime / 60)
	GuiControl,, TimeProgress, % Round(passedTimeMinutes / TimeGoal * 100)
	GuiControl,, TimeProgressText, %passedTimeMinutes%/%TimeGoal% Mins

	; Update the hits goal progress bar.
	GuiControl,, HitsProgress, % Round(Hits / HitsGoal * 100)
	GuiControl,, HitsProgressText, %Hits%/%HitsGoal% Hits
	
	; Show the GUI.
	Gui, Show, NoActivate, AutoHit
}