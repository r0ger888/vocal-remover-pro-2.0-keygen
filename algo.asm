include md5.asm

Hex2ch 			PROTO		:DWORD,:DWORD,:DWORD
GenKey			PROTO		:DWORD

.const
MAXSiZE         equ 256

.data
MD5Mailhash1	db	MAXSiZE	dup(0)
MD5Mailhash2	db	MAXSiZE	dup(0)
MD5Mailhash3	db	MAXSiZE	dup(0)
MD5Mailhash4	db	MAXSiZE	dup(0)
MD5Srlhash	db	MAXSiZE	dup(0)
Hardpart1	db	"VOCALREMOVERPRO",0
Hardpart2   db  "ABBY",0
Hardpart3	db	"AUDI RS5",0
Hardpart4	db  "PORSCHE CAYMAN",0
Dashh		db	"-",0
NoMail		db  "Just type something.",0
TooLong		db	"Mail too long !",0

.data?
Mailbuff	db 	60h dup(?)
Part1len	dd	?
Part2len	dd	?
Part3len	dd	?
Part4len	dd	?
Keybuff		dd	?
part1		db 	60h dup(?)
part2		db 	60h dup(?)
part3		db 	60h dup(?)
part4		db 	60h dup(?)
Serialbuff	db	60h dup(?)
MD5Encr1	db  60h dup(?)
MD5Encr2	db  60h dup(?)
MD5Encr3	db  60h dup(?)
MD5Encr4	db  60h dup(?)

.code
Hex2ch proc HexValue:DWORD,CharValue:DWORD,HexLength:DWORD
    mov esi,[ebp+8]
    mov edi,[ebp+0Ch]
    mov ecx,[ebp+10h]
    @HexToChar:
      lodsb
      mov ah, al
      and ah, 0Fh
      shr al, 4
      add al, '0'
      add ah, '0'
       .if al > '9'
          add al, 'A'-'9'-1
       .endif
       .if ah > '9'
          add ah, 'A'-'9'-1
       .endif
      stosw
    loopd @HexToChar
    ret
Hex2ch endp

GenKey proc hWin:DWORD
	
		invoke GetDlgItemText,hWin,IDC_MAIL,addr Mailbuff,MAXSiZE
			.if eax == 0
				invoke SetDlgItemText,hWin,IDC_SERIAL,addr NoMail
			.elseif eax > 30
				invoke SetDlgItemText,hWin,IDC_SERIAL,addr TooLong
		.elseif
    
		invoke CharLower,addr Mailbuff ; <-- mail string should be lowercase in order to generate the key
    	
		; first part (our mail+ VOCALREMOVERPRO)
		invoke lstrcat,addr MD5Encr1,addr Mailbuff
		invoke lstrcat,addr MD5Encr1,addr Hardpart1
		; get the lenght of the first part of serial (md5 encryption)
		invoke lstrlen,addr MD5Encr1
		mov Part1len,eax
		invoke MD5Init
		invoke MD5Update,addr MD5Encr1,Part1len
		invoke MD5Final
		invoke Hex2ch,addr MD5Digest,addr MD5Mailhash1,16
		invoke lstrcpyn,addr part1,addr MD5Mailhash1,5
		invoke lstrcat,addr Serialbuff,addr part1
		invoke lstrcat,addr Serialbuff,addr Dashh
	    
	    ; second part (our mail + ABBY)
	    invoke lstrcat,addr MD5Encr2,addr Mailbuff
	    invoke lstrcat,addr MD5Encr2,addr Hardpart2
	    ; get the lenght of the second part of serial (md5 encryption)
	    invoke lstrlen,addr MD5Encr2
	    mov Part2len,eax
	    invoke MD5Init
	    invoke MD5Update,addr MD5Encr2,Part2len
	    invoke MD5Final
	    invoke Hex2ch,addr MD5Digest,addr MD5Mailhash2,16
	    invoke lstrcpyn,addr part2,addr MD5Mailhash2+28,5
	    invoke lstrcat,addr Serialbuff,addr part2
	    invoke lstrcat,addr Serialbuff,addr Dashh
	    
	    ; third part (AUDI RS5 + our mail)
	    invoke lstrcat,addr MD5Encr3,addr Mailbuff
	    invoke lstrcat,addr MD5Encr3,addr Hardpart3
	    ; get the lenght of the third part of serial (md5 encryption)
	    invoke lstrlen,addr MD5Encr3
	    mov Part3len,eax
	    invoke MD5Init
	    invoke MD5Update,addr MD5Encr3,Part3len
	    invoke MD5Final
	    invoke Hex2ch,addr MD5Digest,addr MD5Mailhash3,16
	    invoke lstrcpyn,addr part3,addr MD5Mailhash3,5
	    invoke lstrcat,addr Serialbuff,addr part3
	    invoke lstrcat,addr Serialbuff,addr Dashh
	    
	    ; last part (PORSCHE CAYMAN + our mail)
	    invoke lstrcat,addr MD5Encr4,addr Mailbuff
	    invoke lstrcat,addr MD5Encr4,addr Hardpart4
	    ; get the lenght of the third part of serial (md5 encryption)
	    invoke lstrlen,addr MD5Encr4
	    mov Part4len,eax
	    invoke MD5Init
	    invoke MD5Update,addr MD5Encr4,Part4len
	    invoke MD5Final
	    invoke Hex2ch,addr MD5Digest,addr MD5Mailhash4,16
	    invoke lstrcpyn,addr part4,addr MD5Mailhash4+28,5
	    invoke lstrcat,addr Serialbuff,addr part4
	   	invoke SetDlgItemText,hWin,IDC_SERIAL,addr Serialbuff
	   	call Clean
   	.endif
	Ret
GenKey endp

Clean proc
    invoke RtlZeroMemory,addr Mailbuff,sizeof Mailbuff
    invoke RtlZeroMemory,addr MD5Mailhash1,sizeof MD5Mailhash1
    invoke RtlZeroMemory,addr MD5Mailhash2,sizeof MD5Mailhash2
    invoke RtlZeroMemory,addr MD5Mailhash3,sizeof MD5Mailhash3
    invoke RtlZeroMemory,addr MD5Mailhash4,sizeof MD5Mailhash4
    invoke RtlZeroMemory,addr MD5Srlhash,sizeof MD5Srlhash
    invoke RtlZeroMemory,addr part1,sizeof part1
    invoke RtlZeroMemory,addr part2,sizeof part2
    invoke RtlZeroMemory,addr part3,sizeof part3
    invoke RtlZeroMemory,addr part4,sizeof part4
    invoke RtlZeroMemory,addr Serialbuff,sizeof Serialbuff
    invoke RtlZeroMemory,addr MD5Encr1,sizeof MD5Encr1
    invoke RtlZeroMemory,addr MD5Encr2,sizeof MD5Encr2
    invoke RtlZeroMemory,addr MD5Encr3,sizeof MD5Encr3
    invoke RtlZeroMemory,addr MD5Encr4,sizeof MD5Encr4
	Ret
Clean endp