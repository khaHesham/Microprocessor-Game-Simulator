public IGC, SEND_INGAME_MSG, RECIEVE_INGAME_MSG

extrn SEND_CHAR:far
extrn RECEIVE_CHAR:far
extrn CHAR_TO_SEND:BYTE
extrn RECEIVED_CHAR:BYTE

.model small 
.stack 64
.data 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SendChar db  0
RecChar db 0
You db 'You: $'
YourOpp db 'opnt: $'
sep db '|$'
charposX2 db 5
charposY2 db 14
charposX db 25
charposY db 2

MSG_TO_SEND db 16, ?, 16 dup('$')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.code 
SetCursor macro x ,y 
  PushAll
  mov bx , 0
  mov ah , 2 
  mov dl , x
  mov dh , y
  int 10h
  PopAll
Endm SetCursor

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

clr macro
  PushAll
  push bx
  mov ax, 0600h
  mov bh , 07
  mov cx , 0
  mov dl , 80
  mov dh , 26
  int 10h
  pop bx
  PopAll
endm clr

clrLower1 macro  ; a3ml beha clear ll screen lw 3auz
  PushAll 
    push bx
    mov ax , 0600h ;; for scrolling
    mov bh , 00
    mov cl , 5 ;p1 x
    mov ch , 24d ; p1 y
    mov dl, 17d ; p2 x
    mov dh, 24d ; p2 y
    int 10h
    pop bx
  PopAll
endm clrLower1

clrLower2 macro  ; a3ml beha clear ll screen lw 3auz 
  PushAll
  push bx
  mov ax , 0600h
  mov bh , 00
  mov cl , 24 ;p1 x
  mov ch , 24 ; p1 y
  mov dl, 40 ; p2 x
  mov dh, 24 ; p2 y
  int 10h
  pop bx
  POPALL
endm clrLower2

DespMess macro Mes
  PushAll
  mov ah , 9 
  mov dx, offset Mes
  int 21h
  PopAll
endm DespMess

InitialPos macro  
  push bx
  SetCursor 1 , 24
  pop bx
  DespMess You
  push bx
  SetCursor 20, 24
  pop bx
  DespMess sep
  push bx
  SetCursor 21, 24
  pop bx
  DespMess YourOpp
endm InitialPos

chgToGPHX macro

  mov ah , 0
  mov al , 13h
  int 10h

endm chgToGPHX

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
  jnz okok
  jmp Chk    
  okok:
  mov dx , 03f8h
  in al , dx
  mov RecChar, al
  cmp al , 13d ; lw das enter ems7
  jnz herexx
  clrLower2
  mov charposX , 24
  herexx:
  SetCursor charposX , 24
  inc charposX
  ;; print that char
  mov  ah ,2 
  mov dl , RecChar
  int 21h
  Chk: ;; lw mfesh data y5rog
  ret
Receiving endp 

IGC proc far

  ;chgToGPHX
  InitialPos

  Loop1:
  call Receiving
  ;;get cursor position
  mov ah , 3h
  mov bh , 00h
  int 10h
  cmp dl , 39
  jnz cxxx
  clrLower2
  mov charposX , 24
  cxxx:
  ;check for key pressed
  mov ah , 1
  int 16h 
  jz loop1 ; lw mfesh haga edast recieve
  cmp al , 13d ; lw das enter ems7
  jnz cont
  clrLower1
  mov charposX2 , 4

  ;;lw ktb haga t3ala nb3tha
  cont:
  SetCursor charposX2 , 24
  inc charposX2
  mov SendChar, al
  mov ah, 2
  mov dl, SendChar
  int 21h 

  ;;get cursor position
  mov ah , 3h
  mov bh , 00h
  int 10h

  ;compare x position m3 el pos bta3 el sep lw ablo b 1 ems7
  cmp dl , 18
  jnz here
  clrLower1
  mov charposX2 , 5
  here:
  mov ah,0ch
  mov al,0
  int 21h
  CALL Sending
  jmp loop1
  ret
IGC endp   


SEND_INGAME_MSG proc far
  InitialPos

  push bx
  SetCursor 5, 24
  pop bx

  
  mov dx, offset MSG_TO_SEND
  mov si, dx
  mov ah, 0ah
  int 21h

  call RECEIVE_CHAR

  mov cx, 16
  send_inmsg:
    lodsb
    mov CHAR_TO_SEND, al
    call SEND_CHAR
  loop send_inmsg

  ret
SEND_INGAME_MSG endp

RECIEVE_INGAME_MSG proc far
  InitialPos

  mov CHAR_TO_SEND, 'r'
  call SEND_CHAR
  mov di, offset MSG_TO_SEND

  mov cx, 16
    rcv_inmsg:
    call RECEIVE_CHAR
    mov al, RECEIVED_CHAR
    stosb
  loop rcv_inmsg

  push bx
  SetCursor 26, 24
  pop bx

  mov ah , 9
  mov dx, offset MSG_TO_SEND+2
  int 21h

ret
RECIEVE_INGAME_MSG endp

end