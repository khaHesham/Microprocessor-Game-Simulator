.model small 
.stack 64
.data 
AXX db 'Mov ax: $'
BXX db 'Mov bx: $'
CXX db 'Mov cx: $'
DXX db 'Mov dx: $'
SII db 'Mov si: $'
DII db 'Mov di: $'
BPP db 'Mov bp: $'
SPP db 'Mov sp: $'
edkhol db 'Press Enter To Continue$'
REGS DW , 8 DUP(?)
P1Name DB 16 , ? , 16 DUP('$')   
P1Points dw ?   
.code


PushAll MACRO
push ax
push bx
push cx
push dx
push si
push di
push bP
push sp
pushf
ENDM PushAll

PopAll MACRO
popf
pop sp
pop bP
pop di
pop si
pop DX
pop cx
pop bx
pop ax
ENDM PopAll  

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

DespMess macro Mes
    mov ah , 9 
    mov dx, offset Mes
    int 21h
endm DespMess


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
 
 SetCursor macro x ,y 
push ax 
push dx
mov ah , 2 
mov dl , x
mov dh , y
int 10h
pop dx
pop ax
Endm SetCursor

clr macro
push bx
mov ax, 0600h
mov bh , 07
mov cx , 0
mov dl , 80
mov dh , 26
int 10h
pop bx
endm clr
 

LoadMainScreen proc far
   mov ax , @data 
   mov ds , ax  
   clr
   
      ;coloring the backGround
   PushAll
   MOV AH, 06h    ; Scroll up function
   XOR AL, AL     ; Clear entire screen
   XOR CX, CX     ; Upper left corner CH=row, CL=column
   MOV DX, 154FH  ; lower right corner DH=row, DL=column 
   MOV BH, 0fh    ; blackOncyan
   INT 10H
   PopAll       
   
   PushAll
   MOV AH, 06h    ; Scroll up function
   XOR AL, AL     ; Clear entire screen
   mov cx,1500h     ;CH=row, CL=column
   MOV DX, 184FH  ; lower right corner DH=row, DL=column 
   MOV BH, 4fh    ; BlackOnGreen
   INT 10H
   PopAll 
    
    MOV SI , offset REGS
    ;intializing ax
    SetCursor 5 , 3
    DespMess AXX
    Read4Digits [SI]
    ADD SI , 2
    ;intializing ax
    SetCursor 5 , 8
    DespMess BXX
    Read4Digits [SI]
    ADD SI , 2
    ;intializing ax
    SetCursor 5 , 13
    DespMess CXX
    Read4Digits [SI]
    ADD SI , 2

    ;intializing ax
    SetCursor 5 , 18
    DespMess DXX
    Read4Digits [SI]
    ADD SI , 2

    ;intializing ax
    SetCursor 40 , 3
    DespMess SII
    Read4Digits [SI]
    ADD SI , 2

    ;intializing ax
    SetCursor 40 , 8
    DespMess DII
    Read4Digits [SI]
    ADD SI , 2

    ;intializing ax
    SetCursor 40 , 13
    DespMess SPP
    Read4Digits [SI]
    ADD SI , 2

    ;intializing ax
    SetCursor 40 ,18
    DespMess BPP
    Read4Digits [SI]
    ADD SI , 2

   
   SetCursor 2,22  
   ;show message
   mov ah , 9 
   mov dx , offset edkhol
   int 21h    
                  
   ;get keypressed
   loop1:
   mov ah , 07
   int 21h 
   cmp al ,0Dh 
   jnz loop1

    LoadMainScreen endp
  
 end LoadMainScreen


