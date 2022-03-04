
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

readfirstdigit macro                    
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1000d ; awl rkm bdrbo f 1000 
    mul bx       ; multiply the first digit by 1000 
    mov a , ax ; put the result in a

endm readfirstdigit


readseconddigit macro                    
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 100d
    mul bx       ; multiply the first digit by 100 
    add a , ax ;add to a

endm readseconddigit

readThirddigit macro                    
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 10d
    mul bx       ; multiply the first digit by 10 
    add a , ax ; add to a

endm readThirddigit

read4thdigit macro                    
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1d
    mul bx      
    add a , ax ;add to a

endm read4thdigit
 
clr macro  ; a3ml beha clear ll screen lw 3auz
  mov ax , 0600h
  mov bh , 07
  mov cx , 0 
  mov dx , 184fh
  int 10h
endm clr  
 
 
Read4Digits macro 
    ;reading the number digit by digit
    getnum
    readfirstdigit
    getnum
    readSeconddigit  
    getnum
    readThirddigit
    getnum
    read4thdigit       
  
 endm   Read4Digits  
 
 

ReadString macro 
  ;READ FROM KEYBOARD 15 CHAR ONLY
    MOV AH , 0AH        
    LEA BX , READName    
    MOV DX , BX 
    INT 21H           
 endm ReadString
 
 
.model small 
.stack 64
.data 
EnterName db 'Enter Your Name: $'
EnterInPoints db 'Initial Points: $'
edkhol db 'Press Enter To Continue$'
READName DB 16 , ? , 16 DUP('$')   
a dw ?   
.code

LoadMainScreen proc far
   mov ax , @data 
   mov ds , ax   
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
   
   ;move Cursor
   mov ah,  2
   mov dl , 5
   mov dh , 5
   int 10h
   
   
    ;printing message
   mov ah , 9 
   mov dx , offset EnterName  
   int 21h

    
   mov ah,  2
   mov dl , 7
   mov dh , 7
   int 10h 
   ;reading the name
    ReadString 
                   
   
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
    Read4Digits
    
   ;move cursor
   mov ah,  2
   mov dl , 5
   mov dh , 22
   int 10h 
   
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


