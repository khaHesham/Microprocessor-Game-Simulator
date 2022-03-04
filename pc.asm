public Parse_Cmd

extrn Regs_player1:BYTE
extrn Regs_player2:BYTE
extrn encode:BYTE
extrn Execute_To:BYTE
extrn ASC_TBL:BYTE

extrn value:WORD
extrn forbidden1:BYTE
extrn forbidden2:BYTE
extrn Cmds:DWORD
extrn Operands:WORD
extrn cmd:BYTE
extrn turn:BYTE

.model huge
.386  

.code

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


check_numeric proc
    sub si, 1

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
    mov value, bp
    mov bl, -1
    mov dx, 1
    mov cl, 0
    ret

    invnum:
    mov cl, 1
    ret

check_numeric ENDP

CmpOperands proc
    lodsw
    mov di, offset Operands
    mov cx, 41
    repne scasw
    mov bl, 40
    sub bl, cl
    cmp cx, 0
    ret
CmpOperands ENDP

Get_Operand proc
    call CmpOperands
    jnz vld

    sub si, 2
    lodsb
    cmp al, '['
    
    jnz check_type

    call CmpOperands
    jz direct_addressing
    cmp bl, 24
    jge var

    cmp bl, 2
    jz register_indirect
    cmp bl, 8
    jz register_indirect
    cmp bl, 10
    jz register_indirect
    jmp invld
    
    register_indirect:
    cmp Execute_To, 1;according to khaled logic------------------->
    jnz p2
    mov di, offset Regs_player1
    jmp RIAM
    p2:
    mov di, offset Regs_player2
    RIAM:
    mov bh, 0
    add di, bx
    cmp bl, 16
    jb wrd
    sub di, 16
    mov cl, [di]
    mov ch, 0
    jmp vldAddr
    wrd:
    mov ch, [di]
    mov cl, [di+1]
    vldAddr:
    cmp cx, 15
    jg invld
    mov bl, cl
    add bl, 24

    var:
    inc si
    jmp vld

    direct_addressing:
    mov di, offset ASC_TBL
    mov cx, 17
    repne scasb
    mov bl, 40
    sub bl, cl
    cmp cx, 0
    jnz vld

    jmp invld

    check_type:
    cmp dx, 0
    jz invld
    call check_numeric
    ret

    vld:
    mov cl, 0
    ret
    invld:
    mov cl, 1
    ret
Get_Operand ENDP

ChangePosition MACRO X,Y 
    MOV Ah,2H
    MOV Dl,X
    MOV Dh,Y
    INT 10H  
ENDM ChangePosition

Parse_Cmd proc far
    NormalPusha

    cmp turn, 0
    jnz pos_p2
    mov al, forbidden1
    ChangePosition 2,22
    jmp read
    pos_p2:
    mov al, forbidden2
    ChangePosition 25,22
    read:
    ;reading the command
    mov ah, 0ah
    mov dx, offset cmd
    int 21H
    ;checking for forbidden character
    mov cx, 15
    ; mov al, forbidden
    mov di, offset cmd
    repne scasb
    jz invalid
    ;loading opcode into eax
    mov si, offset cmd+2

    lodsd
    ;comparing eax with the array of commands
    mov di, offset Cmds
    mov cx, 17
    repne scasd
    ;calculating the index of the command (if found) and storing it in code[0]
    mov bx, 16
    sub bx, cx
    cmp bx, 16
    jz invalid
    mov encode, bl
    cmp bl, 13
    jz exit
    ;Destination
    mov dx, 0
    call Get_Operand
    jmp v_iv

    ;Source
    Source:
    cmp encode, 14
    jge exit
    ;discard the dummy ", "
    lodsw

    mov dx, 1
    call Get_Operand

    v_iv:
    cmp cl, 0
    jnz invalid
    valid:
    cmp dx, 0
    jz ValidDest
    mov encode[2], bl
    jmp exit
    ValidDest:
    mov encode[1], bl
    jmp Source

    invalid: mov encode, -1

    exit:
    NormalPopa
    ret
Parse_Cmd endp


main proc far 


main endp 
end main 

