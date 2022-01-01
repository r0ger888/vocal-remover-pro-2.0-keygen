include		windows.inc 
include		kernel32.inc 
include		user32.inc 
include     gdi32.inc  
include 	shell32.inc
include		winmm.inc
include		masm32.inc
include		msvcrt.inc
include		comctl32.inc
include		oleaut32.inc
include		ole32.inc
include		advapi32.inc
include		comdlg32.inc
include     /masm32/macros/macros.asm

includelib	kernel32.lib
includelib	user32.lib 
includelib 	gdi32.lib
includelib 	shell32.lib
includelib	winmm.lib
includelib 	masm32.lib
includelib	msvcrt.lib
includelib	comctl32.lib
includelib  oleaut32.lib
includelib  ole32.lib
includelib	advapi32.lib
includelib	comdlg32.lib

include btnt.inc

include MagicV2mEngine.inc
includelib MagicV2mEngine.lib

DlgProc		PROTO	:DWORD,:DWORD,:DWORD,:DWORD
StaticLineInit	PROTO	:DWORD
FreeStatic		PROTO	:DWORD
Drawz    		PROTO
DrawLine		PROTO	:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GraphShake		PROTO	:DWORD
FadeOut			PROTO	:DWORD
MakeDialogTransparent	PROTO	:DWORD,:DWORD
TypewritingAnim	PROTO	:DWORD
Copytxt			PROTO	:DWORD,:DWORD,:DWORD
StrLen			PROTO	:DWORD

.const
IDD_MAIN	equ	1000
IDD_ABOUT	equ	2000
IDB_EXIT	equ	1001
IDB_COPY	equ	1002
IDB_ABOUT	equ	1003
IDC_MAIL	equ	1004
IDC_SERIAL	equ	1005
IDC_SOUND	equ	1006
IDC_STATIC2001	equ	2001

.data
include picnic.inc
WindowTitle	db	"Vocal Remover Pro 2.0 KeyGen",0
DefaultMail	db	"peryferiah@hush.com",0
Msg1		db	"copied 2 clipboard.",0
r3kt			RECT	<>
TxtFont		LOGFONT <12,0,0,0,FW_DONTCARE,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,0,'tahoma'>
DELAY_VALUE			equ		6
Transparency		dd		?
TRANSPARENT_VALUE	equ 254

.data?
hInstance	dd	?
xWnd		dd	?
wParam2 		dd ?
nHeight    		dd ?
nWidth			dd ?
BmpDC    		dd ?
dword_404044    dd ?
BoxDC			dd ?
dword_404030    dd ?
dword_404034    dd ?
dword_404038    dd ?
ho				dd ?
rc 				RECT <?>
hDC 			dd ?
hThread			dd ?
hBrush			dd ?
hFont			dd	?
hMail			dd	?
hSerial			dd	?
hIMG			dd  ?
WndRect		RECT	<>
XndRect		RECT	<>
YndRect		RECT	<>
MailRect	RECT	<>
SerialRect	RECT	<>
StaticRect	RECT	<>