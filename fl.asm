public DetLvlAndForbidden

extrn levelIndicator:BYTE 
extrn forbidden1:BYTE
extrn forbidden2:BYTE
extrn edkhol:BYTE
extrn lvlMess:BYTE 
extrn fMess: BYTE
extrn INITIATOR:BYTE
extrn CHAR_TO_SEND:BYTE
extrn RECEIVED_CHAR:BYTE

extrn SEND_CHAR:far
extrn RECEIVE_CHAR:far

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

getnum macro ; to read the number digit by digit
    mov ah , 1  ; read char 
    int 21h  
endm getnum  


read4thdigit macro                 
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1d
    mul bx      
    mov levelIndicator , al ;add to a
endm read4thdigit
 
clr macro  ; a3ml beha clear ll screen lw 3auz 
  push bx
  mov ax , 0600h
  mov bh , 07
  mov cx , 0 
  mov dx , 184fh
  int 10h
  pop bx
endm clr  
  
.model small 
.stack 64
.data  
.code

DetLevAndForbidChar proc far
  NormalPusha
  ;coloring the backGround
  MOV AH, 06h    ; Scroll up function
  XOR AL, AL     ; Clear entire screen
  XOR CX, CX     ; Upper left corner CH=row, CL=column
  MOV DX, 154FH  ; lower right corner DH=row, DL=column 
  MOV BH, 0fh    ; blackOncyan
  INT 10H

  MOV AH, 06h    ; Scroll up function
  XOR AL, AL     ; Clear entire screen
  mov cx,1500h     ;CH=row, CL=column
  MOV DX, 184FH  ; lower right corner DH=row, DL=column 
  MOV BH, 4fh    ; BlackOnGreen
  INT 10H 
   
   ;move Cursor
   mov ah,  2
   mov bh , 0
   mov dl , 5
   mov dh , 5
   int 10h
   
   cmp INITIATOR, 1
   jnz frbdn
    ;printing message
   mov ah , 9 
   mov dx , offset lvlMess  
   int 21h

    ;move cursor 
   mov ah,  2
   mov bh , 0
   mov dl , 7
   mov dh , 7
   int 10h    
   
   ;reading the level
    loopx:
        getnum
        read4thdigit 
        ; check eno 1  aw  2
        cmp levelIndicator , 02
        ja loopx                
        cmp levelIndicator , 00
        je loopx
    
    mov al, levelIndicator
    mov CHAR_TO_SEND, al
    call SEND_CHAR

  frbdn:

   cmp INITIATOR, 1
   jz init
   call RECEIVE_CHAR
   mov al, RECEIVED_CHAR
   mov levelIndicator, al

  init:
   ;move cursor                
   mov ah,  2
   mov bh , 0
   mov dl , 5
   mov dh , 9
   int 10h 
    
                   
   ;show Message
   mov ah , 9 
   mov dx , offset fMess
   int 21h 
   
   ;move cursor
   mov ah,  2
   mov bh , 0
   mov dl , 5
   mov dh , 12
   int 10h 
           
           
   ;reading FChar
    mov ah,0
    int 16h

    mov ah,2
    mov dl,al
    int 21h
    mov forbidden1 , al

    mov CHAR_TO_SEND, al
    call SEND_CHAR

    call RECEIVE_CHAR
    mov al, RECEIVED_CHAR
    mov forbidden2, al


   NormalPopa  
   ret
DetLevAndForbidChar endp
     
     
   
; DetForbidCharP2 proc far
; NormalPusha
;     ;coloring the backGround
;   MOV AH, 06h    ; Scroll up function
;   XOR AL, AL     ; Clear entire screen
;   XOR CX, CX     ; Upper left corner CH=row, CL=column
;   MOV DX, 154FH  ; lower right corner DH=row, DL=column 
;   MOV BH, 0fh    ; blackOncyan
;   INT 10H

;   MOV AH, 06h    ; Scroll up function
;   XOR AL, AL     ; Clear entire screen
;   mov cx,1500h     ;CH=row, CL=column
;   MOV DX, 184FH  ; lower right corner DH=row, DL=column 
;   MOV BH, 4fh    ; BlackOnGreen
;   INT 10H 
   
;    ;move Cursor
;    mov ah,  2
;    mov bh , 0
;    mov dl , 5
;    mov dh , 5
;    int 10h
    
;    ;show Message
;    mov ah , 9 
;    mov dx , offset fMess
;    int 21h 
   
;    ;move cursor
;    mov ah,  2
;    mov bh , 0
;    mov dl , 7
;    mov dh , 7
;    int 10h

   
;    ;reading FChar
;     mov ah,0
;     int 16h

;     mov ah,2
;     mov dl,al
;     int 21h
;     mov forbidden2 , al 

;    ;move cursor
;    mov ah,  2
;    mov bh ,0
;    mov dl , 5
;    mov dh , 22
;    int 10h


;    ;show message
;    mov ah , 9 
;    mov dx , offset edkhol
;    int 21h
                  
;    ;get keypressed
;    loop1:
;    mov ah , 07
;    int 21h 
;    cmp al ,0Dh 
;    jnz loop1
; NormalPopa
;    ret
; DetForbidCharP2 endp
    
     
DetLvlAndForbidden proc far

    clr
    NormalPusha
    call DetLevAndForbidChar   
    NormalPopa
    ret
DetLvlAndForbidden endp

main proc far

main endp
end main