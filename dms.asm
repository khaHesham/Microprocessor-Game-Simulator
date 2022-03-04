extrn STRING1:BYTE
extrn STRING2:BYTE
extrn STRING3:BYTE
extrn STRING4:BYTE
extrn Empty:BYTE
extrn temp:BYTE
extrn Notify2:BYTE
extrn Notify1:BYTE

public NotificationBar, DrawMainScreen, notification

.MODEL SMALL
.STACK 64


.CODE 
;---------------------------------------------MACROS--------------------------------------------------------------- 
; checkf1 macro  a   
; cmp a , 3bh
; jnz end11 
; mov varA , 1 
; end11:  
; endm checkf1
; checkf2 macro  a   
; cmp a , 3ch
; jnz end22 
; mov varA , 2 
; end22:  
; endm checkf2
; checkf3 macro  a   
; cmp a , 3dh
; jnz end33 
; mov varA , 3 
; end33:  
; endm checkf3
; checkf4 macro  a   
; cmp a , 3eh
; jnz end44 
; mov varA , 4 
; end44:  
; endm checkf4
; checkESC macro  a   
; cmp a , 01h
; jnz end55 
; mov varA , 0 
; end55:  
; endm checkESC
; checkETR macro  a   
; cmp a , 1ch
; jnz end66 
; mov varA , 9 
; end66:  
; endm checkETR


; getKeyPressed proc    
; ;calling inturupt
; mov ah , 0 
; int 16h    
; mov varA , ah 
; checkESC varA  
; cmp varA , 0
; jz end2
; checkF1 varA  
; cmp varA , 1
; jz end2
; checkF2 varA  
; cmp varA , 2
; jz end2
; checkF3 varA  
; cmp varA , 1
; jz end2
; checkF4 varA  
; cmp varA , 1
; jz end2
; checkETR varA  
; cmp varA , 1
; jz end2     

; end2:
; ret
; getKeyPressed endp  

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
ENDM

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
ENDM

ClrScreen MACRO
    push bx
    MOV AX,0600H
    MOV BH,7
    MOV CX,0
    MOV DX,184FH 
    INT 10H
    pop bx
ENDM

;------------------------------------- 
ShowMessage MACRO MyMessage  
    mov ah,9H 
    mov dx,offset MyMessage
    int 21h
ENDM
;-------------------------------------
ChangePosition MACRO X,Y 
    MOV Ah,2H
    MOV Dl,X
    MOV Dh,Y
    INT 10H     
ENDM
;-------------------------------------
ColoredChar MACRO Mychar,color 
    mov ah,9
    mov al,mychar
    mov bh,0
    mov cx,1
    mov bl,color
    int 10h
ENDM

NotificationBar proc far
    ChangePosition 0,15h 
    back: ColoredChar '-',4fh
    mov ah,3
    mov bh,0
    int 10h
    inc dl
    mov temp,dl 
    ChangePosition temp,15h
    cmp dl,50h
    jne back

    ChangePosition 0,16h
    ShowMessage Notify1

    ChangePosition 20h,17h
    ShowMessage Notify2
    ret   
NotificationBar ENDP

notification proc far ;input dx
    push dx
    ChangePosition 0,18h
    pop dx
    mov ah,9H 
    int 21h

    ret
notification endp
                    
                    
DrawMainScreen proc far
    ClrScreen

    MOV AH, 0
    MOV AL, 3
    INT 10H
    
    PushAll
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
  PopAll 

    ChangePosition 15h,4h
    ShowMessage STRING1
    ;------------------------------
    ColoredChar 'F',04h 
    mov ah,3          ;after coloring first char get its position
    mov bh,0
    int 10h
    inc dl            ;inc X by 1 to draw next char next to it
    mov temp,dl       ;move X pos to temp then pass it again to the function changepos
    ChangePosition temp,4h 
    ColoredChar '1',04h
    ;------------------------------
    ChangePosition 15h,6h
    ShowMessage STRING2
    ;------------------------------
    ColoredChar 'F',05h
    mov ah,3        ;after coloring first char get its position
    mov bh,0
    int 10h 

    inc dl          ;inc X by 1 to draw next char next to it
    mov temp,dl     ;move X pos to temp then pass it again to the function changepos  
    ChangePosition temp,6h
    ColoredChar '2',05h
    ;------------------------------
    ChangePosition 15h,8h
    ShowMessage STRING3
    ;------------------------------
    ColoredChar 'E',06h 
    mov ah,3        ;after coloring first char get its position
    mov bh,0
    int 10h
    inc dl          ;inc X by 1 to draw next char next to it
    mov temp,dl     ;move X pos to temp then pass it again to the function changepos
    ChangePosition temp,8h
    ColoredChar 'S',06h
    mov ah,3
    mov bh,0
    int 10h
    inc dl
    mov temp,dl
    ChangePosition temp,8h
    ColoredChar 'C',06h
    ;------------------------------
    ;Notification bar  
    ;------------------------------ 
    call NotificationBar
    ;------------------------------ 
    ret                 
DrawMainScreen endp
;----------------------------------------------END MACROS--------------------------------------------------------------                                               
MAIN  PROC FAR        

MAIN ENDP
END MAIN
