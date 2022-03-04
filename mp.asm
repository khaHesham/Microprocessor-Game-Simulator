public Defining_Usernames

extrn EnterName1:BYTE
extrn EnterName2:BYTE
extrn EnterInPoints:BYTE
extrn edkhol:BYTE
extrn P1Name:BYTE
extrn P2Name:BYTE
extrn P1Points:WORD
extrn P2Points:WORD


getnum macro ; to read the number digit by digit
  mov ah , 1  ; read char 
  int 21h    
endm getnum  

readfirstdigit macro p1                   
  mov ah , 0
  sub al , 30h ; convert the char to int 
  mov bx , 1000d ; awl rkm bdrbo f 1000 
  mul bx       ; multiply the first digit by 1000 
  mov p1 , ax ; put the result in a
endm readfirstdigit


readseconddigit macro p1                    
  mov ah , 0
  sub al , 30h ; convert the char to int 
  mov bx , 100d
  mul bx       ; multiply the first digit by 100 
  add p1 , ax ;add to a
endm readseconddigit

readThirddigit macro p1                  
  mov ah , 0
  sub al , 30h ; convert the char to int 
  mov bx , 10d
  mul bx       ; multiply the first digit by 10 
  add p1 , ax ; add to a
endm readThirddigit

read4thdigit macro p1                   
  mov ah , 0
  sub al , 30h ; convert the char to int 
  mov bx , 1d
  mul bx      
  add p1 , ax ;add to a
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
 
 
Read4Digits macro p1
  ;reading the number digit by digit
  getnum
  readfirstdigit p1
  getnum
  readSeconddigit p1 
  getnum
  readThirddigit  p1
  getnum
  read4thdigit  p1     
  
endm   Read4Digits  
 
 
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


ReadString macro  name
  NormalPusha
 ;READ FROM KEYBOARD 15 CHAR ONLY
  MOV AH , 0AH        
  LEA BX , name    
  MOV DX , BX 
  INT 21H
  NormalPopa
endm ReadString



.model small 
.stack 64

; .data
; EnterName1 db 'Player1 Name: $'
; EnterName2 db 'Player2 Name: $'
; P1Name DB 16 , ? , 16 DUP('$')
; P2Name DB 16 , ? , 16 DUP('$') 
; P1Points dw ?  
; P2Points dw ?
; EnterInPoints db 'Initial Points: $'
; edkhol db 'Press Enter To Continue$'
 
.code

LoadMainScreen1 proc far  
  clr
  ;coloring the backGround
  NormalPusha
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
  NormalPopa 
  
  ;move Cursor
  mov ah,  2
  mov dl , 5
  mov dh , 5
  int 10h
  
  
  ;printing message
  mov ah , 9 
  mov dx , offset EnterName1
  int 21h
  
  mov ah,  2
  mov dl , 7
  mov dh , 7
  int 10h 
  ;reading the name
  ReadString P1name
                  
  ;move cursor                
  mov ah,  2
  mov dl , 5
  mov dh , 10
  int 10h 
               
  ;show Message
  mov ah , 9 
  mov dx , offset EnterInPoints
  int 21h 

  
  ;move cursor
  mov ah,  2
  mov dl , 7
  mov dh , 12
  int 10h 
          
          
  ;reading integer
  Read4Digits P1Points
  
  ;move cursor
  mov ah,  2
  mov dl , 5
  mov dh , 22
  int 10h 
  
  ;show message
  mov ah , 9 
  mov dx , offset edkhol
  int 21h    
                
  loop1:
    mov ah , 07
    int 21h 
    cmp al ,0Dh 
  jnz loop1
  ret
LoadMainScreen1 endp

LoadMainScreen2 proc far  
  clr
  ;coloring the backGround
  NormalPusha
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
  NormalPopa 
  
  ;move Cursor
  mov ah,  2
  mov dl , 5
  mov dh , 5
  int 10h
  
  
  ;printing message
  mov ah , 9 
  mov dx , offset EnterName2
  int 21h
  
  mov ah,  2
  mov dl , 7
  mov dh , 7
  int 10h 
  ;reading the name
  ReadString P2name
                  
  
  ;move cursor                
  mov ah,  2
  mov dl , 5
  mov dh , 10
  int 10h 
  
                  
  ;show Message
  mov ah , 9 
  mov dx , offset EnterInPoints
  int 21h 
  
  ;move cursor
  mov ah,  2
  mov dl , 7
  mov dh , 12
  int 10h 
          
          
  ;reading integer
  Read4Digits P2Points
  
  ;move cursor
  mov ah,  2
  mov dl , 5
  mov dh , 22
  int 10h 
  
  ;show message
  mov ah , 9 
  mov dx , offset edkhol
  int 21h    
                
  loop2:
    mov ah , 07
    int 21h 
    cmp al ,0Dh 
  jnz loop2
  ret
LoadMainScreen2 endp


Defining_Usernames proc far
  MOV AH, 0
  MOV AL, 3
  INT 10H
  
  call LoadMainScreen1
  ret
Defining_Usernames endp

main proc far

main endp
end main