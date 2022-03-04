.MODEL SMALL
.STACK 64
.DATA
ASC_TBL DB '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

Hex_TO_Dislay db 'f','f','f','f'
num_16bit dw ?,?
num_8bit db ?

.CODE

;---------------------------------------------------DISPLAY CHARACTERS-------------------------------------------------

DisplayChar MACRO C
    MOV DL, C
    MOV AH, 2
    INT 21H
ENDM

ChangePosition MACRO X,Y 
    MOV Ah,2H
    MOV Dl,X
    MOV Dh,Y
    INT 10H  
ENDM

DisplayChar1 MACRO C
    mov ah,9
    mov al,C
    mov bh,0
    mov cx,1
    mov bl,55h
    int 10h
ENDM


DisplayString MACRO STR
    MOV DX, OFFSET STR
    MOV AH, 9
    INT 21H
ENDM

;---------------------------------------------DISPLAY NUMBERS----------------------------------------------------------
;<INTEGER>
DisplayDigit MACRO D
    MOV DL, D
    ADD DL, 30H
    MOV AH, 2
    INT 21H
ENDM

Display_Number_8bit_Dec MACRO num
    MOV AL, num
    MOV AH, 0
    MOV BL, 100
    DIV BL
    PUSH AX
    DisplayDigit AL
    POP AX
    MOV AL,AH
    MOV AH,0
    MOV BL, 10
    DIV BL
    PUSH AX
    DisplayDigit AL
    POP AX
    DisplayDigit AH
ENDM

Display_Number_16bit_Dec MACRO num;
    MOV AX, num
    MOV BX, 10000
    MOV DX,0
    DIV BX
    PUSH DX
    DisplayDigit AL
    POP AX
    MOV BX, 1000
    MOV DX,0
    DIV BX
    PUSH DX
    DisplayDigit AL
    POP AX
    MOV BL,100
    DIV BL
    PUSH AX
    DisplayDigit AL
    POP AX
    MOV AL,AH
    MOV AH,0
    MOV BL,10
    DIV BL
    PUSH AX
    DisplayDigit AL
    POP AX
    DisplayDigit AH
ENDM

;<HEXADECIMAL>
; Display_Hex proc
;     MOV AL, hex_digit
;     MOV BX, OFFSET ASC_TBL
;     XLAT
;     DisplayChar1 AL
;     ret
; Display_Hex ENDP



; Display_Number_8bit_Hex proc
;     MOV AL, num_8bit
;     MOV AH, 0
;     MOV BL, 16
;     DIV BL
;     PUSH AX
;     mov hex_digit, AL
;     call Display_Hex
;     POP AX
;     mov hex_digit, AH
;     call Display_Hex
;     ret
; Display_Number_8bit_Hex ENDP

; Display_Number_16bit_Hex proc
;     MOV CX, num_16bit
;     mov num_8bit, CH
;     call Display_Number_8bit_Hex
;     mov num_8bit, CL
;     call Display_Number_8bit_Hex
;     ret
; Display_Number_16bit_Hex ENDP

Display_Hex proc
    MOV AL, hex_digit
    MOV BX, OFFSET ASC_TBL
    XLAT
    stosb
    ret
Display_Hex ENDP


To_Hex_8bit proc ;input to al
    MOV AH, 0
    MOV BL, 16
    DIV BL
    call Display_Hex
    mov AL, AH
    call Display_Hex
    ret
To_Hex_8bit ENDP

To_Hex_16bit proc
    mov di, offset Hex_TO_Dislay
    MOV ax, num_16bit
    mov cl, al
    mov al, ah
    call To_Hex_8bit
    mov al, cl
    call To_Hex_8bit
    ret
To_Hex_16bit ENDP

;---------------------------------------------------DRAWING------------------------------------------------------------

Draw_Horizontal_Line MACRO start, end, row
    LOCAL next
    MOV CX, start
    MOV DX, row
    MOV AL, 5
    MOV AH, 0ch
    next:
        INT 10H
        INC CX
        CMP CX, end
    JNZ next
ENDM

Draw_Vertical_Line MACRO start, end, col
    LOCAL next
    MOV DX, start
    MOV CX, col
    MOV AL, 5
    MOV AH, 0ch
    next:
        INT 10H
        INC DX
        CMP DX, end
    JNZ next
ENDM

Draw_Rectangle MACRO sr, er, sc, ec
    Draw_Horizontal_Line sc, ec, sr
    Draw_Vertical_Line sr, er, sc
    Draw_Horizontal_Line sc, ec, er
    Draw_Vertical_Line sr, er, ec
ENDM

;---------------------------------------------------OTHERS------------------------------------------------------------

ClrScreen MACRO
	push bx
    MOV AX,0600H
    MOV BH,7
    MOV CX,0
    MOV DX,184FH 
    INT 10H
	pop bx
ENDM

NewLine MACRO
    DisplayChar 10
    DisplayChar 13
ENDM

MovCursor MACRO x, y
    MOV AH, 2
    MOV DL, x
    MOV DH, y
    INT 10H
ENDM

VideoMode MACRO
    MOV AH, 0
    MOV AL, 13H
    INT 10H
ENDM

TextMode MACRO
    MOV AH, 0
    MOV AL, 3
    INT 10H
ENDM

;-----------------------------------------------------------------------------------------------------------------------

MAIN PROC FAR
MOV AX, @DATA
MOV DS, AX

ClrScreen
VideoMode
mov num_16bit, 0ffffh
call Display_Number_16bit_Hex


HLT    
MAIN ENDP
END MAIN
