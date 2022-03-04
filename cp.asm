public Control_Power_Up

extrn Regs_player1:BYTE
extrn Regs_player2:BYTE
extrn Execute_To:BYTE
extrn stuck:BYTE
extrn line:BYTE
extrn OneOrZero:BYTE
extrn P1Points:WORD
extrn P2Points:WORD
extrn levelIndicator:BYTE
extrn turn:BYTE
extrn Target_Value:WORD
extrn forbidden2:BYTE
extrn forbidden1:BYTE
extrn ASC_TBL:BYTE
extrn Changed1:BYTE
extrn Changed2:BYTE
extrn winning:BYTE
extrn SEND_CHAR:far
extrn CHAR_TO_SEND:BYTE
extrn RECEIVE_CHAR:far
extrn RECEIVED_CHAR:BYTE
extrn notification:far
extrn Update:far
extrn intitialization:far



getnum macro ; to read the number digit by digit
    mov ah , 7  ; read char 
    int 21h    
endm getnum  

readThirddigit macro lin                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 10d
    mul bx       ; multiply the first digit by 10 
    add lin , al ; add to a

endm readThirddigit

read4thdigit macro lin                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1d
    mul bx      
    add lin , al ;add to a

endm read4thdigit

NormalPusha MACRO
	PUSH AX
	PUSH bx
	PUSH cx
	PUSH dx
	PUSH si
	PUSH DI
	PUSHF
ENDM

NormalPopa MACRO
	POPF
	POP DI
	POP si
	POP DX
	POP cx
	POP bx
	POP AX
ENDM


.model large 
.stack 64

.data

	deduce_p1       db ?
	deduce_p2       db ?
	mess db '!!!$'
	;;;;;;;;;;;;;;;;;  Change Forbidden
	;Message         db 'Enter The New Char: $'
	NewTargetString db 5,?,5 dup('$')

.code
ClearingAllReg1 proc far
	NormalPusha   
	mov  cx,0
	mov  si,offset Regs_player1
	mov  di,offset Regs_player2
	ClearingRegs1Loop:
		mov al, 0
		mov  [si], al
		mov  [di], al
		inc  si
		inc  di
		inc  cx
		cmp  cx,24
		call Update
	jnz  ClearingRegs1Loop
	
	call intitialization
	NormalPopa
	ret
ClearingAllReg1 endp

ChangeForbidden1 proc far
	NormalPusha        
	cmp changed1 , 1
	jz hahah
	;reading the char without enter
	                    mov  ah , 7
	                    int  21h
	                    mov  forbidden2 , al
						mov CHAR_TO_SEND , al
						call SEND_CHAR
						mov changed1 , 1
	;We Should Push All here
	hahah:
	NormalPopa

	                    ret
ChangeForbidden1 endp

ChangeForbidden2 proc far
	NormalPusha          
	cmp changed2 , 1
	jz hxhxhx                        
	;reading the char without enter
	                    ; mov  ah , 7
	                    ; int  21h
						call RECEIVE_CHAR
						mov al , RECEIVED_CHAR
	                    mov  forbidden1 , al
						mov changed2 , 1
	;We Should Push All here
	hxhxhx:
	NormalPopa
	ret

ChangeForbidden2 endp
        
Execute_on_your_own proc
	NormalPusha
	                    mov  al,Execute_To
	                    cmp  al,0
	                    jz   l_1
	                    jmp  l_2
	l_1:                mov  al,1
	                    jmp  _exit_
	l_2:                mov  al,0
	_exit_:             
	                    mov  Execute_To,al
						NormalPopa
	                    ret
Execute_on_your_own endp

check_numeric proc ;si contains offset of the string
    mov cx, 4
    mov bp, 0
    char:
        mov bh, cl

        dec cx
        mov al, 4
        mul cx
        mov bl, al

        lodsb
        mov di, offset ASC_TBL
        mov cx, 17
        repne scasb
        cmp cx, 0
        jz invnum
        mov al, 16
        sub al, cl
        
        mov ah, 0
        mov cl, bl
        shl ax, cl
        add bp, ax

        mov cl, bh
    loop char
    mov Target_Value, bp
    ret

    invnum:
	mov bp, -1
    ret
check_numeric ENDP

Change_Target_ValueS proc
NormalPusha
	mov ah, 0AH
	mov dx, offset NewTargetString
	int 21H

	mov si, dx
	call check_numeric
	cmp bp, -1
	jz exists

	mov  bx,0
	mov  si,offset Regs_player2
	Mloop:              
	;add si,bx
		mov  ah,Regs_player2[bx]
		mov  al, Regs_player2[bx+1]
		cmp  ax, bp
		jz   exists
		add bx, 2
		cmp  bx,40
	jnz  Mloop
	mov  bx,0
	Lloop:              
		mov  ah,Regs_player1[bx]
		mov  al, Regs_player1[bx+1]
		cmp  ax,bp
		jz   exists
		add bx, 2
		cmp  bx,40
	jnz  Lloop

	mov Target_Value,bp
	exists:  
	NormalPopa
	ret
Change_Target_ValueS endp

; addItToDigit proc 
; check_numeric
; sub RECEIVED_CHAR, 30h
; mov RECEIVED_CHAR , al
; mov bl, 10
; mul bl
; add Target_Value, ax
; addItToDigit endp 


Change_Target_ValueR proc far

	mov dx, offset Target_Value
	mov si, dx
	call check_numeric
	cmp bp, -1
	jz existsS

	mov  bx,0
	mov  si,offset Regs_player2
	MloopP:              
		mov  ah,Regs_player2[bx]
		mov  al, Regs_player2[bx+1]
		cmp  ax, bp
		jz   exists
		add bx, 2
		cmp  bx,40
	jnz  MloopP
	mov  bx,0
	LloopP:              
		mov  ah,Regs_player1[bx]
		mov  al, Regs_player1[bx+1]
		cmp  ax,bp
		jz   exists
		add bx, 2
		cmp  bx,40
	jnz  LloopP

	mov Target_Value,bp
	existsS:  
	NormalPopa
	ret

Change_Target_ValueR endp
    
Control_Power_Up proc  far
	NormalPusha
	                    mov            ah , 7
	                    int            21h
	                    sub            al , 30h
	                    cmp            turn , 0              	; check that this is p1 turn
	                    jz             Play1
	                    jmp            Play2
 
	Play1:              
		mov CHAR_TO_SEND, al
		call SEND_CHAR
		mov dx , offset mess
		call notification
	                    cmp            al , 1
	                    jz             p1
	                    cmp            al , 2
	                    jz             p2
	                    cmp            al , 3
	                    jz             p3
	                    cmp            al , 4
	                    jnz            xx
	                    jmp            p4
	xx:                 
	                    cmp            al , 5
	                    jz             here
	                    jmp            exit
	                    
	                    
	here:                                                    	; lw das 5 lazm ashof howa lvl 1 wla lvl 2 lw lvl 2 hshtghl
	                    cmp            levelIndicator , 1
	                    jnz            here2
	                    jmp            exit
	here2:              
	                    jmp            p5
 
 
 
	p1:                 
	; check that the player has enough points
	; ;clear buffer
	; mov ah, 7
	; int 21h
	                    cmp            P1Points , 8d
	                    ja             here3
	                    jmp            lost                  	; if less than 9 dont allow
	here3:              
	                    call           changeForbidden1
	                    sub            P1Points , 8d
	                    jmp            exit
 
	p2:                 
	                    cmp            P1Points , 5d
	                    ja             here4
	                    jmp            lost                  	; if less than 6 dont allow
	here4:              
	                    call           Execute_on_your_own
	                    sub            P1Points , 5d
	                    jmp            exit
 
	p3:                 
	                    cmp            P1Points , 2d
	                    ja             con2
	                    jmp            lost
	
	con2:               
	;read line
	                    getnum
	                    readThirdDigit line
	                    getnum
	                    read4thDigit   line
	                    cmp            line , 16d            	;lw el rkm akbur mn 16 yeb2a el user 3bet
	                    jb             con3
	                    jmp            exit
	con3:               
	;read one or zero
	                    getnum
	                    read4thDigit   OneOrZero
	;check valid input
	                    cmp            OneOrZero ,02h        	; lw akbur ml 1 yeb2a el user byhzr
	                    jb             cont3
	                    jmp            lost
	cont3:              
						mov bl , turn 
						xor bl , 1
	                    mov            Stuck ,bl
	                    sub            P1Points , 2d
	                    jmp            exit
 
	p4:                 
	                    cmp            P1Points , 1eh
	                    ja             here5
	                    jmp            lost                  	; if less than 1f dont allow
	here5:              
	                    call           ClearingAllReg1
	                    sub            P1Points , 1eh
	                    jmp            exit
   
   
	p5:                 
	                    cmp            P1Points , 02d
	                    ja             here6
	                    jmp            lost                  	; if less than 9 dont allow
	here6:              
	                    call           Change_Target_ValueS
	                    sub            P1Points , 02d
	                    jmp            exit
 
        
	lost:               
	                    mov            winning	, 2
	                    jmp            exit
	;; applying powerUp to P2
	;determine the powerUp to be used
	Play2:              
		call RECEIVE_CHAR
		mov al, RECEIVED_CHAR 
		; cmp al , 4
		; jnz lkl
		; mov dx , offset mess
		; call notification
		; lkl:
	                    cmp            al , 1
	                    jz             p11
	                    cmp            al , 2
	                    jz             p22
	                    cmp            al , 3
	                    jz             p33
	                    cmp            al , 4
	                    jnz            xxx
	                    jmp            p44
	xxx:                
	                    cmp            al , 5
	                    jz             here7
	                    jmp            exit
	here7:                                                   	; lw das 5 lazm ashof howa lvl 1 wla lvl 2 lw lvl 2 hshtghl
	                    cmp            levelIndicator , 1
	                    jz             xxxx
	                    jmp            p55
	xxxx:               
	                    jmp            exit
 
 
	p11:                
	; check that the player has enough points
	;clear buffer
	; mov ah, 7
	; int 21h
	                    cmp            P2Points , 8d
	                    ja             here8
	                    jmp            lost2                 	; if less than 9 dont allow
	here8:              
	                    call           changeForbidden2
	                    sub            P2Points , 8d
	                    jmp            exit
 
	p22:                
	                    cmp            P2Points , 5d
	                    ja             xxxxx
	                    jmp            lost2
	xxxxx:              
	                    call           Execute_on_your_own
	                    sub            P2Points , 5d
	                    jmp            exit
 
 
	p33:                
	                    cmp            P2Points , 2d
	                    ja             con22
	                    jmp            lost2
	con22:              
	;read line
	                    getnum
	                    readThirdDigit line
	                    getnum
	                    read4thDigit   line
	                    cmp            line , 16d            	;lw el rkm akbur mn 16 yeb2a el user 3bet
	                    jb             con33
	                    jmp            exit
	con33:              
	;read one or zero
	                    getnum
	                    read4thDigit   OneOrZero
	;check valid input
	                    cmp            OneOrZero ,02h        	; lw akbur ml 1 yeb2a el user byhzr
	                    jb             cont44
	                    jmp            exit
	cont44:             
	                   	mov bl , turn 
						xor bl , 1
	                    mov            Stuck ,bl
	                    sub            P2Points , 2d
	                    jmp            exit
	p44:                
	                    cmp            P2Points , 1eh
	                    jb             lost2
	                    call           ClearingAllReg1
	                    sub            P2Points , 1eh
						jmp            exit
   
   
	p55:                
	                    cmp            P2Points , 02d
	                    jb             lost2                 	; if less than 31 dont allow
	                    call           Change_Target_ValueR
	                    sub            P2Points , 02d
	                    jmp            exit
   
	lost2:              
	                    mov            winning , 1
	exit:
	NormalPopa              
	ret
Control_Power_Up endp 

main proc far

main endp
end main