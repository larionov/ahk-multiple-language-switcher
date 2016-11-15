ru := DllCall("LoadKeyboardLayout", "Str", "00000419", "Int", 1)
en := DllCall("LoadKeyboardLayout", "Str", "00000409", "Int", 1)
cn := DllCall("LoadKeyboardLayout", "Str", "00000804", "Int", 1)
jp := DllCall("LoadKeyboardLayout", "Str", "00000411", "Int", 1)
pp := A_PriorKey

defaultLn := en
SetLayout(language)
{
  ControlGetFocus, control, A
  ;SplashTextOn,,, % "" . language
  PostMessage 0x50, 0, %language%, %control%, A ; WM_INPUTLANGCHANGEREQUEST
}

; Break/Pause button, wait for release
Break Up::
	w := DllCall("GetForegroundWindow")
	pid := DllCall("GetWindowThreadProcessId", "UInt", w, "Ptr", 0)
	l := DllCall("GetKeyboardLayout", "UInt", pid)

	if (l = cn) {
		SetLayout(defaultLn)
	} else {
		SetLayout(cn)
	}
	Return

; LAlt+LShift in any order, wait for release and also pass event back to system
~+LAlt Up::
~!LShift Up::
	p := A_PriorKey
	t := A_TimeSincePriorHotkey

	; If any other keys were pressed don't change language
	if ((p = "LShift" || p = "LAlt") && t > 140) {
		w := DllCall("GetForegroundWindow")
		pid := DllCall("GetWindowThreadProcessId", "UInt", w, "Ptr", 0)
		l := DllCall("GetKeyboardLayout", "UInt", pid)

		if (l = jp) {
			SetLayout(defaultLn)
		} else {
			SetLayout(jp)
		}
	}
	pp := p
	Return

; LControl+LShift in any order, wait for release and also pass event back to system
~^LShift Up::
~+LControl Up::
	p := A_PriorKey
	t := A_TimeSincePriorHotkey

	; If any other keys were pressed don't change language (like ctrl+shift+tab)
	 
	if (( p = "LShift" || p = "LControl") && t > 140) {
		w := DllCall("GetForegroundWindow")
		pid := DllCall("GetWindowThreadProcessId", "UInt", w, "Ptr", 0)
		l := DllCall("GetKeyboardLayout", "UInt", pid)
		if (l = en) {
			SetLayout(ru)
		} else {
			SetLayout(en)
		}
	} 
	pp := p
	Return