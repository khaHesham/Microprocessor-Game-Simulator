extrn DrawMainScreen:far
public Chatting
; extrn P1Name:BYTE
; extrn P2Name:BYTE

.model small 
.stack 64 
.data 
SendChar db  0
RecChar db 0
You db 'You$'
YourOpp db 'Your Opponent$'
charposX2 db 0
charposY2 db 14
charposX db 0
charposY db 2

exit_chat db 0

.code 
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

clrUpper macro  ; a3ml beha clear ll screen lw 3auz 
  push bx
  mov ax , 0601h
  mov bh , 07
  mov cl , 0 ;p1 x
  mov ch , 2d ; p1 y
  mov dl, 80d ; p2 x
  mov dh, 11d ; p2 y
  int 10h
  pop bx
endm clrUpper  

clrLower macro  ; a3ml beha clear ll screen lw 3auz 
  push bx
  mov ax , 0601h
  mov bh , 07
  mov cl , 0 ;p1 x
  mov ch , 14d ; p1 y
  mov dl, 80d ; p2 x
  mov dh, 23d ; p2 y
  int 10h
  pop bx
endm clrLower

DespMess macro Mes
    mov ah , 9 
    mov dx, offset Mes
    int 21h
endm DespMess

DrawLine macro 
mov ah , 9 
mov bh , 0
mov al , '-'
mov cx , 80
mov bl , 0ffh 
int 10h
endm DrawLine

; intialization proc 
; mov dx , 3fbh ;line control reg
; mov al , 10000000b ; set div Latch
; out dx , al ;out it

; mov dx , 3f8h
; mov al , 0ch
; out dx , al 

; mov dx , 3f9h
; mov al , 00h
; out dx , al

; mov dx , 3fbh
; mov al , 00011011b
; out dx , al

;    ret         
; intialization endp 

Sending proc far
   ; ;Check that Transmitter Holding Register is Empty
    mov dx , 3fdh 
    in al , dx 
    and al , 00100000b
    JZ Again

   ;; If empty put the VALUE in Transmit data register
    mov dx ,  3f8h
    mov al, SendChar
    out dx, al
    Again: ; lw msh empty ykhrog 
    ret
Sending endp 

Receiving proc far
    mov dx , 3fdh
    in al , dx 
    and al , 1
    jz Chk
    
    mov dx , 03f8h
    in al , dx
    mov RecChar, al

    cmp al, '&'
    jnz rcv
    mov exit_chat, 1
    jmp Chk
    
    rcv:
    ;;;;;;;
    cmp al , 13d ; if enter is clicked get new line
    jnz here2x
    ;check 34an lw 3auz ams7 el shasha
    cmp charposY2 , 23
    jnz contx
    clrLower
    mov charposX2 , 0
    mov charposY2 , 23
    jmp here2x
    contx:
    mov charposX2 , 0
    inc charposY2
    here2x:
    ;btb3ha 3la el shasha
    inc charposX2
    SetCursor charposX2, charposY2  
    cmp charposX2 , 70 
    jnz herex
    ;if 0 increment y and return x to 0
    mov charposX2 , 0
    inc charposY2
    herex:
    ;;;;;;;
   ;; print that char
    mov  ah ,2 
    mov dl , RecChar
    int 21h
    Chk: ;; lw mfesh data y5rog
    ret
Receiving endp 

Chatting proc far
    mov ah,07
    int 21h

    mov cx , 0
    mov dx , 0
    clr
    SetCursor 0 , 0
    DrawLine 

    SetCursor 1, 1
    DespMess You 

    SetCursor 0 , 12
    DrawLine 

    SetCursor 1 , 13
    DespMess YourOpp

    SetCursor 0 , 24
    DrawLine 

    ;call intialization
    Loop1:
    call Receiving
    cmp exit_chat, 1
    jnz heelll
    jmp  end_chat
    
    heelll:
    ;check for key pressed
    mov ah , 1
    int 16h 
    jz loop1 ; lw mfesh haga edast recieve
    
    ;;lw ktb haga t3ala nb3tha
    cmp ah, 3dh
    jnz cnt_snding
    mov SendChar, '&'
    mov ah,0ch
    mov al,0
    int 21h
    CALL Sending
    jmp end_chat

    cnt_snding:
    mov SendChar, al
    cmp al , 13d ; if enter is clicked get new line
    jnz here2
    ;;check 34an lw 3auz ams7 el shasha
    cmp charposY , 11
    jnz cont
    clrUpper
    mov charposX , 0
    mov charposY , 11
    jmp here2
    cont:
    mov charposX , 0
    inc charposY
    here2:
    ;btb3ha 3la el shasha
    inc charposX
    SetCursor charposX, charposY  
    cmp charposX , 70 
    jnz here
    ;if 0 increment y and return x to 0
    mov charposX , 0
    inc charposY
    here:
    mov ah, 2
    mov dl, SendChar
    int 21h 

    mov ah,0ch
    mov al,0
    int 21h
    CALL Sending
    jmp loop1

    end_chat:
    ; mov ah,07
    ; int 21h
    call DrawMainScreen
    ret

Chatting endp 

end