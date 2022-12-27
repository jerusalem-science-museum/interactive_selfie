; Disable Alt+Tab
!Tab::Return

; Disable Windows Key + Tab
#Tab::Return

; Disable Left Windows Key
LWin::Return

; Disable Right Windows Key
RWin::Return

; Disable Alt+F4
!F4::Return

; Disable Alt + Esc
!Esc::Return

; Disable Ctrl + Alt + Del
^!Delete::Return

; Disable Ctrl + Shift + Esc
$^+Esc::Return

; Close window with Alt + q
!q::WinClose, A

; Open Task Manager with Alt + t
$!t::^+Esc

; Open/Close OnScreenKeyboard with Alt + k
!k::Send #^o