.MODEL SMALL
.STACK 64
.DATA
msg DB "What is your name?$"
InData DB 20,?,20 dup('$')
num DB 6,?,6 dup('$')
binary DB 9,?, 9 dup('$')
ASC_TBL DB   '0','1','2','3','4','5','6','7','8','9'
        DB   'A','B','C','D','E','F'

.CODE
DisplayString MACRO STR
    MOV DX, OFFSET STR
    MOV AH, 9
    INT 21H
ENDM

DisplayChar MACRO C
    MOV DL, C
    MOV AH, 2
    INT 21H
ENDM

ReadString MACRO STR
    MOV DX, OFFSET STR
    MOV AH, 0AH
    INT 21H	
ENDM

DisplayDigit MACRO D
    MOV DL, D
    ADD DL, 30H
    MOV AH, 2
    INT 21H
ENDM

Display_Number_16bit MACRO num; 
    ; MOV BX, 1000
    ; MOV DX,0
    ; DIV BX
    ; PUSH DX
    ; DisplayDigit AL
    ; POP AX
    ; MOV BL,100
    ; DIV BL
    ; PUSH AX
    ; DisplayDigit AL
    ; POP AX
    ; MOV AL,AH
    ; MOV AH,0
    ; MOV BL,10
    ; DIV BL
    ; PUSH AX
    ; DisplayDigit AL
    ; POP AX
    ; DisplayDigit AH
    MOV CX, num
    Display_Number_8bit_Dec CH
    Display_Number_8bit_Dec CL

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

Display_Number_8bit_Hex MACRO num
    MOV AL, num
    MOV AH, 0
    MOV BL, 16
    DIV BL
    PUSH AX
    Display_Hex AL
    POP AX
    Display_Hex AH
ENDM

Display_Number_16bit_Hex MACRO num
    MOV CX, num
    Display_Number_8bit_Hex CH
    Display_Number_8bit_Hex CL
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

MovCursor MACRO pos
    MOV AH, 2
    MOV DX, pos
    INT 10H
ENDM

Display_Hex MACRO hex_digit
MOV AL, hex_digit
MOV BX, OFFSET ASC_TBL
XLAT
DisplayChar AL
ENDM

Binary_Hex MACRO binary
    LOCAL Hex_digit
    MOV SI, offset binary
    MOV DL, 0
    MOV CL, 8
    Hex_digit:
    LODSB
    SUB AL, 30H
    MUL CL
    ADD DL, AL
    SHR CL, 1
    CMP CL, 0
    JNZ Hex_digit
    Display_Hex  DL
ENDM

ReadNumber MACRO STR; Read string from user, convert it to number and save it to AX
    ReadString STR
    MOV SI,offset STR+2
    MOV CL,[STR+1]
    MOV CH,0
    SUB CX,1
    MOV DI,0
    Expansion:
       PUSH CX
       MOV AX,1
       POW:
           MOV BX,10
           MUL BX
       LOOP POW
       POP CX
       MOV BL,[SI]
       SUB BL,30H
       MOV BH,0
       MUL BX
       ADD DI,AX
       INC SI
    LOOP Expansion
    MOV BL,[SI]
    SUB BL,30H
    MOV BH,0
    ADD DI,BX
    MOV AX,DI
ENDM


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

MAIN PROC FAR
MOV AX, @DATA
MOV DS, AX

ClrScreen
MovCursor 0H
; DisplayString msg
; MovCursor 0F14H
; ReadString InData
; MovCursor 1114H
; DisplayString InData+2


; ReadString binary
; Binary_Hex binary+2
; Binary_Hex binary+6

; MOV AH, 0
; MOV AL, 13H
; INT 10H
; Draw_Rectangle 70, 130, 130, 190

; mov ah, 2ch
; int 21H
; MovCursor 70, 0

; Display_Number_8bit_Dec CH
; DisplayChar ':'
; Display_Number_8bit_Dec CL

; mov ah, 2ah
; int 21H
; MovCursor 70, 2
; Display_Number_8bit_Dec DL
; DisplayChar '/'
; Display_Number_8bit_Dec DH
; DisplayChar '/'
; Display_Number_16bit_Dec CX

; MOV SI, 5
; CHECK:
;     Display_Number_16bit_Dec SI
;     INC SI
;     MOV AH, 1
;     INT 16H

;     MOV CX, 0FH
;     MOV DX, 4240H
;     MOV AH, 86H
;     INT 15H
; JZ CHECK

HLT    
MAIN ENDP
END MAIN
