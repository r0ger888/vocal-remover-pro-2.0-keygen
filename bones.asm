.686
.model	flat, stdcall
option	casemap :none

include	resID.inc
include algo.asm
include meatballs_bY_newborn.asm
include textscr_mod.asm

AllowSingleInstance MACRO lpTitle
        invoke FindWindow,NULL,lpTitle
        cmp eax, 0
        je @F
          push eax
          invoke ShowWindow,eax,SW_RESTORE
          pop eax
          invoke SetForegroundWindow,eax
          mov eax, 0
          ret
        @@:
ENDM

.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	InitCommonControls
	invoke LoadBitmap,hInstance,400
	mov hIMG,eax
	invoke CreatePatternBrush,eax
	mov hBrush,eax
	AllowSingleInstance addr WindowTitle
	invoke	DialogBoxParam, hInstance, IDD_MAIN, 0, offset DlgProc, 0
	invoke	ExitProcess, eax

DlgProc proc hDlg:HWND,uMessg:UINT,wParams:WPARAM,lParam:LPARAM
LOCAL ThreadId:DWORD
LOCAL pv:byte
LOCAL X:DWORD
LOCAL Y:DWORD
LOCAL ps:PAINTSTRUCT
LOCAL TypeThread:DWORD

	.if [uMessg] == WM_INITDIALOG
 
 		push hDlg
 		pop xWnd
		mov eax, 384
		mov nHeight, eax
		mov eax, 290 
		mov nWidth, eax                
		invoke GetSystemMetrics,0                
		sub eax, nHeight
		shr eax, 1
		mov [X], eax
		invoke GetSystemMetrics,1               
		sub eax, nWidth
		shr eax, 1
		mov [Y], eax
		invoke SetWindowPos,xWnd,0,X,Y,nHeight,nWidth,40h
            	
		invoke	LoadIcon,hInstance,200
		invoke	SendMessage, xWnd, WM_SETICON, 1, eax
		invoke  SetWindowText,xWnd,addr WindowTitle
		invoke 	MakeDialogTransparent,xWnd,TRANSPARENT_VALUE
		invoke  SetDlgItemText,xWnd,IDC_MAIL,addr DefaultMail
		invoke 	SendDlgItemMessage, xWnd, IDC_MAIL, EM_SETLIMITTEXT, 31, 0
		invoke  StaticLineInit,xWnd
		invoke  ScrollerInit,hDlg
		invoke CreateFontIndirect,addr TxtFont
		mov hFont,eax
		invoke GetDlgItem,xWnd,IDC_MAIL
		mov hMail,eax
		invoke SendMessage,eax,WM_SETFONT,hFont,1
		invoke GetDlgItem,xWnd,IDC_SERIAL
		mov hSerial,eax
		invoke SendMessage,eax,WM_SETFONT,hFont,1
		
		invoke ImageButton,xWnd,28,209,500,502,501,IDB_COPY
		mov hCopy,eax
		invoke ImageButton,xWnd,147,209,600,602,601,IDB_ABOUT
		mov hAbout,eax
		invoke ImageButton,xWnd,266,209,700,702,701,IDB_EXIT
		mov hExit,eax

		invoke  MAGICV2MENGINE_DllMain,hInstance,DLL_PROCESS_ATTACH,0
		invoke 	V2mPlayStream, addr v2m_Data,TRUE
		invoke  V2mSetAutoRepeat,1
		
		invoke GenKey,xWnd
		
	.elseif [uMessg] == WM_LBUTTONDOWN

		invoke SendMessage, xWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0

	.elseif [uMessg] == WM_CTLCOLORDLG

		return hBrush

	.elseif [uMessg] == WM_PAINT
                
		invoke BeginPaint,xWnd,addr ps
		mov edi,eax
		lea ebx,r3kt
		assume ebx:ptr RECT
                
		invoke GetClientRect,xWnd,ebx
		invoke CreateSolidBrush,0
		invoke FrameRect,edi,ebx,eax
		invoke EndPaint,xWnd,addr ps                   
     
    .elseif [uMessg] == WM_CTLCOLOREDIT
    
		invoke SetBkMode,wParams,TRANSPARENT
		invoke SetTextColor,wParams,White
		invoke GetWindowRect,xWnd,addr WndRect
		invoke GetDlgItem,xWnd,IDC_MAIL
		invoke GetWindowRect,eax,addr MailRect
		mov edi,WndRect.left
		mov esi,MailRect.left
		sub edi,esi
		mov ebx,WndRect.top
		mov edx,MailRect.top
		sub ebx,edx
		invoke SetBrushOrgEx,wParams,edi,ebx,0
		mov eax,hBrush
		ret        
	
	.elseif [uMessg] == WM_CTLCOLORSTATIC
	
		invoke GetDlgCtrlID,lParam
		.if eax == IDC_SERIAL
			invoke SetBkMode,wParams,TRANSPARENT
			invoke SetTextColor,wParams,White
			invoke GetWindowRect,xWnd,addr XndRect
			invoke GetDlgItem,xWnd,IDC_SERIAL
			invoke GetWindowRect,eax,addr SerialRect
			mov edi,XndRect.left
			mov esi,SerialRect.left
			sub edi,esi
			mov ebx,XndRect.top
			mov edx,SerialRect.top
			sub ebx,edx
			invoke SetBrushOrgEx,wParams,edi,ebx,0
			mov eax,hBrush
			ret
		.elseif eax == IDC_STATIC2001
			invoke SetBkMode,wParams,TRANSPARENT
			invoke SetTextColor,wParams,White
			invoke GetWindowRect,xWnd,addr YndRect
			invoke GetDlgItem,xWnd,IDC_STATIC2001
			invoke GetWindowRect,eax,addr StaticRect
			mov edi,YndRect.left
			mov esi,StaticRect.left
			sub edi,esi
			mov ebx,YndRect.top
			mov edx,StaticRect.top
			sub ebx,edx
			invoke SetBrushOrgEx,wParams,edi,ebx,0
			mov eax,hBrush
			ret
		.endif
	.elseif [uMessg] == WM_COMMAND
        
		mov eax,wParams
		mov edx,eax
		shr edx,16
		and eax,0ffffh      
		.if edx == EN_CHANGE
			.if eax == IDC_MAIL
				invoke GenKey,xWnd
			.endif
		.endif  
		.if	eax==IDB_COPY
			invoke SendDlgItemMessage,xWnd,IDC_SERIAL,EM_SETSEL,0,-1
			invoke SendDlgItemMessage,xWnd,IDC_SERIAL,WM_COPY,0,0
			invoke PlaySound,IDC_SOUND,hInstance,SND_RESOURCE or SND_ASYNC
			invoke CreateThread,NULL,0,addr TypewritingAnim,xWnd,0,addr TypeThread
			invoke CloseHandle,eax
			invoke SetTimer,xWnd,2,1500,0
		.elseif eax == IDB_ABOUT
			invoke PlaySound,IDC_SOUND,hInstance,SND_RESOURCE or SND_ASYNC
			invoke ShowWindow,xWnd,0
			invoke DialogBoxParam,0,IDD_ABOUT,xWnd,offset AboutProc,0
		.elseif eax == IDB_EXIT
			invoke PlaySound,IDC_SOUND,hInstance,SND_RESOURCE or SND_ASYNC
			invoke FadeOut,xWnd
			invoke SendMessage,xWnd,WM_CLOSE,0,0
		.endif 
   
    .elseif [uMessg] == WM_TIMER
    	
		invoke SetDlgItemText,xWnd,IDC_STATIC2001,chr$(" ")
		invoke KillTimer,xWnd,2
             
	.elseif [uMessg] == WM_CLOSE	
		invoke V2mStop
  		invoke MAGICV2MENGINE_DllMain,hInstance,DLL_PROCESS_DETACH,0          
		invoke FreeStatic,xWnd
		invoke EndDialog,xWnd,0     
	.endif
         xor eax,eax
         ret
DlgProc endp

StaticLineInit proc hWnd:DWORD
LOCAL ThreadId:DWORD

	mov edx, nWidth
	add edx, 0Ch
           	
	invoke CreateBitmap,nHeight,edx,1,20h,0
	mov BmpDC, eax           
	invoke CreateCompatibleDC,0
	mov BoxDC, eax
	invoke SelectObject,BoxDC,BmpDC
	invoke DeleteDC,dword_404034
	invoke CreatePatternBrush,dword_404030                
	mov dword_404038, eax
	invoke CreateSolidBrush,Black; background color                               
	mov ho, eax

	call Randomize     
	invoke GetDC,hWnd               
	mov hDC, eax             
	mov rc.left, 0
	mov rc.top, 0
	mov eax, nHeight
	mov rc.right, eax
	mov eax, nWidth
	mov rc.bottom, eax                            
	lea eax, [ThreadId]
	invoke CreateThread,0,0,offset Drawz,0,0,eax               
	mov hThread, eax
	
	xor eax,eax
	ret
StaticLineInit endp
FreeStatic proc hWnd:DWORD
	invoke TerminateThread,hThread,0
	invoke ReleaseDC,hWnd,hDC
	xor eax,eax
	ret
FreeStatic endp
Drawz    proc near 
LOCAL x:DWORD
LOCAL cc:DWORD
LOCAL var_45:DWORD
LOCAL rect:RECT
	


loc_40289C:    

                invoke FillRect,BoxDC,offset rc,ho
                invoke DrawLine,BoxDC,-5,0,376,0,5,0FFFFFFh,0,0 ; <-- top wall   
      
                push    8                  
                xor     eax, eax                
                invoke BitBlt,BoxDC,10h,nWidth,0D2h,0Ch,BoxDC,10h,0BAh,0CC0020h
                invoke GraphShake,2
             
loc_402CCB:                       
                cmp     edi, 0C6h
                ja      loc_402D70
                mov     esi, 10h ; <-- left fade X axis value

loc_402CDC:                         
                cmp     esi, 2Eh
                ja      short loc_402D1E
                invoke GetPixel,BoxDC,esi,edi
                cmp     eax, 0FFFFFFh
                jnz     short loc_402D1B
                mov     eax, esi
                sub     eax, 10h
                push    1               ; int
                push    eax             ; nNumber
                push    1Eh             ; nDenominator
                push    0               ; int
                push    0FFFFFFh        ; int
                call    sub_402E31
                invoke SetPixel,BoxDC,esi,edi,eax
                
                
                
loc_402D1B:                      
                inc     esi
                jmp     short loc_402CDC
loc_402D1E:                         
                mov     esi, 0C4h ; <-- right fade X axis value
loc_402D23:                          
                cmp     esi, 0E2h
                ja      short loc_402D6A
                invoke GetPixel,BoxDC,esi,edi
                cmp     eax, 0FFFFFFh
                jnz     short loc_402D67
                mov     eax, esi
                sub     eax, 0C4h ;<-- right fade size
                push    0               ; int
                push    eax             ; nNumber
                push    1Eh             ; nDenominator
                push    0               ; int
                push    0FFFFFFh        ; int
                call    sub_402E31
                invoke SetPixel,BoxDC,esi,edi,eax
loc_402D67:       
                inc     esi
                jmp     short loc_402D23
loc_402D6A:              
                inc     edi
                jmp     loc_402CCB
                
loc_402D70:     
           
                mov     ecx, 28h ; <-- text line up width
                mov     esi, 79h ; <-- text line up X axis
                mov     edi, 0B8h ; <-- text line up Y axis
                
loc_402D7F:                     
                push    ecx
                invoke GraphShake,14h
                add     esi, eax
                invoke GraphShake,14h
                sub     esi, eax
              ;  invoke SetPixel,BoxDC,esi,edi,0FFFFFFh ;0000FF00h  <-- text line up color 
                pop     ecx
                loop    loc_402D7F
                mov     ecx, 0Ah
                mov     esi, 79h
                mov     edi, 0C8h
                
loc_402DB7:           
                push    ecx
                invoke GraphShake,14h
                add     esi, eax
                invoke GraphShake,14h ;<-- text line down X axis
                sub     esi, eax
            ;    invoke SetPixel,BoxDC,esi,edi,0FFFFFFh ; 0000FFFFh <-- text line down color
                pop     ecx
                loop    loc_402DB7
                invoke BitBlt,hDC,110,138,253,4,BoxDC,0,0,0CC0020h
                invoke Sleep,10 ; <-- scroller speed
                dec     [x]
                mov     eax, [x]
                neg     eax
                cmp     eax, [var_45]
                jle     loc_402E27
                mov     [x], 0E2h ; <-- scroller start position (when it ends)

loc_402E27:                       
                jmp     loc_40289C
                ret
Drawz    endp

sub_402E31      proc arg_011:DWORD,arg_41:DWORD,nDenominator:DWORD,nNumber:DWORD,arg_10:DWORD 
LOCAL var_8:BYTE
LOCAL var_7:BYTE
LOCAL var_6:BYTE
LOCAL var_5:BYTE
LOCAL var_4z:BYTE
LOCAL var_3:BYTE
                cmp     [arg_10], 0
                jz      short loc_402EA8
                mov     eax, [arg_41]
                mov     edx, [arg_011]
                mov     [var_8], al
                mov     [var_5], dl
                sub     [var_5], al
                shr     eax, 8
                shr     edx, 8
                mov     [var_7], al
                mov     [var_4z], dl
                sub     [var_4z], al
                shr     eax, 8
                shr     edx, 8
                mov     [var_6], al
                mov     [var_3], dl
                sub     [var_3], al
                movzx   eax, [var_5]
                push    [nDenominator] ; nDenominator
                push    eax             ; nNumerator
                push    [nNumber]   ; nNumber
                call    MulDiv
                add     [var_8], al
                movzx   eax, [var_4z]
                push    [nDenominator] ; nDenominator
                push    eax             ; nNumerator
                push    [nNumber]   ; nNumber
                call    MulDiv
                add     [var_7], al
                movzx   eax, [var_3]
                push    [nDenominator] ; nDenominator
                push    eax             ; nNumerator
                push    [nNumber]   ; nNumber
                call    MulDiv
                add     [var_6], al
                jmp     short loc_402F11
loc_402EA8:                            
                mov     eax, [arg_011]
                mov     edx, [arg_41]
                mov     [var_8], al
                mov     [var_5], al
                sub     [var_5], dl
                shr     eax, 8
                shr     edx, 8
                mov     [var_7], al
                mov     [var_4z], al
                sub     [var_4z], dl
                shr     eax, 8
                shr     edx, 8
                mov     [var_6], al
                mov     [var_3], al
                sub     [var_3], dl
                movzx   eax, [var_5]
                push    [nDenominator] ; nDenominator
                push    eax             ; nNumerator
                push    [nNumber]   ; nNumber
                call    MulDiv
                sub     [var_8], al
                movzx   eax, [var_4z]
                push    [nDenominator] ; nDenominator
                push    eax             ; nNumerator
                push    [nNumber]   ; nNumber
                call    MulDiv
                sub     [var_7], al
                movzx   eax, [var_3]
                push    [nDenominator] ; nDenominator
                push    eax             ; nNumerator
                push    [nNumber]   ; nNumber
                call    MulDiv
                sub     [var_6], al

loc_402F11:                           
                mov     al, [var_6]
                shl     eax, 8 ; <-- right fade color 
                mov     al, [var_7]
                shl     eax, 8
                mov     al, [var_8]
                ret
sub_402E31      endp


DrawLine      proc hdca:DWORD,arg_48:DWORD,arg_888:DWORD,arg_E:DWORD,arg_169:DWORD,arg_141:DWORD,colorz:DWORD,arg_AMOGUS:DWORD,arg_222:DWORD
LOCAL var_2:BYTE
LOCAL var_1:BYTE
                push    ecx
                push    ebx
                push    esi
                push    edi
                mov     edi, [arg_141]
                mov     esi, [arg_888]
                mov     ebx, [arg_48]
                mov     [var_1], 0
                mov     [var_2], 0
                cmp     ebx, [arg_E]
                jge     short loc_402F45
                mov     [var_1], 1
loc_402F45:                         
                cmp     esi, [arg_169]
                jge     short loc_402F4E
                mov     [var_2], 1
loc_402F4E:                            
                cmp     ebx, [arg_E]
                jle     short loc_402F57
                mov     [var_1], 0FFh
loc_402F57:                           
                cmp     esi, [arg_169]
                jle     short loc_402F94
                mov     [var_2], 0FFh
                jmp     short loc_402F94
loc_402F62:                                                          
                mov     eax, [colorz]
                push    eax          
                push    edi
                call    GraphShake
                add     eax, esi
                add     eax, [arg_222]
                push    eax             
                push    edi
                call    GraphShake
                add     eax, ebx
                add     eax, [arg_AMOGUS]
                push    eax       
                mov     eax, [hdca]
                push    eax            
                call    SetPixel
                movsx   eax, [var_2]
                add     esi, eax
                movsx   eax, [var_1]
                add     ebx, eax
loc_402F94: 
                cmp     ebx, [arg_E]
                jnz     short loc_402F62
                cmp     esi, [arg_169]
                jnz     short loc_402F62
                pop     edi
                pop     esi
                pop     ebx
                pop     ecx
                ret
DrawLine      endp

Randomize      proc near
LOCAL SystemTime:SYSTEMTIME
                lea     edx, [SystemTime]
                push    edx          
                call    GetSystemTime
                movzx   eax, [SystemTime.wHour]
                imul    eax, 3Ch
                add     ax, [SystemTime.wMinute]
                imul    eax, 3Ch
                xor     edx, edx
                mov     dx, [SystemTime.wSecond]
                add     eax, edx
                imul    eax, 3E8h
                mov     dx, [SystemTime.wMilliseconds]
                add     eax, edx
                mov     dword_404044, eax
                ret
Randomize      endp

GraphShake      proc arg_w:DWORD
                mov     eax, [arg_w]
                imul    edx, dword_404044, 8088405h
                inc     edx
                mov     dword_404044, edx
                mul     edx
                mov     eax, edx
                ret
GraphShake      endp

FadeOut proc hWnd:HWND
	mov Transparency,250
@@:
	invoke SetLayeredWindowAttributes,hWnd,0,Transparency,LWA_ALPHA
	invoke Sleep,DELAY_VALUE
	sub Transparency,5
	cmp Transparency,0
	jne @b
	ret
FadeOut endp

MakeDialogTransparent proc _handle:dword,_transvalue:dword
	
	pushad
	invoke GetModuleHandle,chr$("user32.dll")
	invoke GetProcAddress,eax,chr$("SetLayeredWindowAttributes")
	.if eax!=0
		invoke GetWindowLong,_handle,GWL_EXSTYLE	;get EXSTYLE
		
		.if _transvalue==255
			xor eax,WS_EX_LAYERED	;remove WS_EX_LAYERED
		.else
			or eax,WS_EX_LAYERED	;eax = oldstlye + new style(WS_EX_LAYERED)
		.endif
		
		invoke SetWindowLong,_handle,GWL_EXSTYLE,eax
		
		.if _transvalue<255
			invoke SetLayeredWindowAttributes,_handle,0,_transvalue,LWA_ALPHA
		.endif	
	.endif
	popad
	ret
MakeDialogTransparent endp

TypewritingAnim proc hWnd:DWORD ; <-- this effect is taken from Crisanar's keygen template so thx to him for that.
	LOCAL Charbuff[255]:TCHAR	
	LOCAL Newlen:DWORD
	 
	mov Newlen,FUNC(StrLen,addr Msg1)
	inc Newlen
	shr Newlen,1							
	
	mov ecx,1	
	;  initialize text animation
	.while(ecx <= Newlen)
		invoke Copytxt,addr Charbuff,addr Msg1,ecx
		invoke Copytxt,ADDR Charbuff[ecx],ADDR Msg1[ecx],ecx
		mov Charbuff[ecx*2],0	  
		inc ecx
		push ecx
		invoke SetDlgItemText,xWnd,IDC_STATIC2001,addr Charbuff
		invoke Sleep,15 ;<-- typewriting speed
		pop ecx
	.endw
	invoke ExitThread,NULL	
TypewritingAnim endp

Copytxt proc uses ecx esi edi aDest:DWORD,aSrc:DWORD,aLen:DWORD
   mov ecx,aLen
   mov esi,aSrc
   mov edi,aDest
   rep movsb
   ret
Copytxt endp

StrLen proc uses ecx edi aString:DWORD
   mov edi,aString
   xor eax,eax
   mov ecx,-1
   repne scasb
   not ecx
   dec ecx
   mov eax,ecx
   ret
StrLen endp

end start