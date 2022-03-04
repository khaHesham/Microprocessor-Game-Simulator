extrn Regs_player1:BYTE
extrn Regs_player2:BYTE
extrn encode:BYTE
extrn Execute_To:BYTE
extrn carryplayer1:BYTE
extrn carryplayer2:BYTE
extrn value:WORD
extrn stuck:BYTE
extrn source:WORD
extrn line:BYTE
extrn OneOrZero:BYTE
extrn turn:BYTE

public ExecuteCommand

getnum macro ; to read the number digit by digit
    mov ah , 1  ; read char 
    int 21h    
endm getnum  

readThirddigit macro lin                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 10d
    mul bx       ; multiply the first digit by 10 
    add lin , al ; add to a

endm readThirddigit

read4thdigit macro lin                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1d
    mul bx      
    add lin , al ;add to a

endm read4thdigit

 PushExcept_DX MACRO
    push ax
    push bx
    push cx
    push si
    push di
    push bP
    push sp
    pushf
 ENDM PushExcept_DX


PopExcept_DX MACRO
    popf
    pop sp
    pop bP
    pop di
    pop si
    pop cx
    pop bx
    pop ax
ENDM PopExcept_DX    


.model huge
.stack 64
.data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
And8  db   7fh,   0bfh,  0dfh
And81 db 0efh, 0f7h,0fbh  , 0fdh, 0feh  
;;;;;;;;;;;;;;;;;
And16 dw   7fffh, 0bfffh, 0dfffh, 0efffh
And162 dw 0f7ffh, 0fbffh, 0fdffh, 0feffh
And163 dw 0ff7h, 0ffbfh, 0ffdfh, 0ffefh
And164 dw 0fff7h, 0fffbh, 0fffdh, 0fffeh 
;;;;;;;;;;;;;;;;;
Or8   db   80h, 40h, 20h, 10h
or81 db  08h, 04h, 02h,   01h
;;;;;;;;;;;;;;;;
Or16  dw   8000h   ,4000h,   2000h,   1000h,   0800h
or161 dw  0400h,   0200h,   0100h,   0080h
or163 dw   0040h,   0020h,   0010h,   0008h
or164 dw   0004h,   0002h,   0001h

.code
;----;;-----;;-----;;-----;;-----;;------;;-----;;-----;;------;;-------;;-----;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
StuckDataLine proc 
 cmp source , 255d ; lw a2l mn 16 yeb2a word 16 
 ja WorkWord
 jmp  WorkByte

 WorkWord: ;read from user the index of the line
 cmp OneOrZero , 0 
 jne One
 jmp  Zeros     
 
 One:
 mov si , offset Or16 + 30d    
 mov al , line
 mov ah , 2
 mul ah 
 cmp al , 0  ; lw awl element 5las mtdkholsh el loop
 je cont  
 loop1:
   dec si
   dec al
   cmp al , 0
   jne  loop1  ; b5leh yo2f 3nd el line el mfrod ystuck 3ndo
   
 cont:
 mov dx , [si] 
 mov bx , source
 or dx, bx 
 jmp  finish ;; keda ana 5lst el or
 
 Zeros:
 mov si , offset And16 + 30d  ; b5leh yo2f 3nd el line el mfrod ystuck 3ndo   
 mov al , line
 mov ah , 2
 mul ah 
 cmp al , 0 
 je  cont2 
 loop2:
   dec si
   dec al
   cmp al , 0
   jne  loop2
 
 cont2:
 mov dx , [si] 
 mov bx , source
 and dx, bx 
 jmp  finish ;; keda ana 5lst el or
 
 WorkByte:  
 cmp OneOrZero , 0
 je  Zeros2
 ; ones
 mov si , offset Or8 + 7  ; b5leh yo2f 3nd el line el mfrod ystuck 3ndo   
 mov al , line
 cmp al , 0
 je  cont3  
 loop11:
   dec si
   dec al
   cmp al , 0
   jne  loop11
 cont3:
 mov dl , [si] 
 mov bx , source
 or dl, bl
 mov dh , 0 
 jmp finish ;; keda ana 5lst el or
 
 Zeros2:
 mov si , offset and8 + 7 ; b5leh yo2f 3nd el line el mfrod ystuck 3ndo   
 mov al , line
 cmp al , 0 
 je  cont44 
 loop22:
   dec si
   dec al
   cmp al , 0
 jne  loop22
 
 cont44:
 mov dl , [si] 
 mov bx , source 
 and dl, bl
 mov dh , 0 

    finish:
    ret 
StuckDataLine endp 

Set_Carry_Flag proc    
    cmp  execute_to,1   ;player 1 turn ---> player 2 registers
    jz player11_1
    jmp player22_2
    player11_1: 
    cmp carryplayer2,1
    jz setcarry22 
    jmp clearcarry22
                setcarry22: stc
                jmp continue11              
    clearcarry22:clc
    jmp continue11 
    player22_2:
    cmp carryplayer1,1
        jz setcarry11 
        jmp clearcarry11
                setcarry11: stc
                jmp continue11
    clearcarry11:clc 
    continue11:ret        
Set_Carry_Flag endp    

flagsEditor  proc    
                    pushf
                    cmp  execute_to,1   ;player 1 turn ---> player 2 registers
                    jz player1
                    jmp player2         ;player 2 turn ---> player 1 registers
                    
                    player1:
                    popf       ;
                    jc setcarryplayer2
                    jmp clearcarryplayer2
                    setcarryplayer2:mov cl,1
                                    mov carryplayer2,cl
                                    jmp exit1
                             clearcarryplayer2:mov cl,0
                                               mov carryplayer2,cl
                                               jmp exit1                           
                    player2:
                    popf
                    jc setcarryplayer1
                    jmp clearcarryplayer1
                    setcarryplayer1:mov cl,1
                                    mov carryplayer1,cl
                                    jmp exit1
                             clearcarryplayer1:mov cl,0
                                               mov carryplayer1,cl
                                              jmp exit1
         exit1: ret                                                       
flagsEditor endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Which_Instruction proc     ;code= (encode[1] || encode[2])    check which player
                    cmp encode[0],0   ;ADD
                    jz l0
                    cmp encode[0],1   ;ADC
                    jz l1
                    cmp encode[0],2   ;MOV
                    jz l2
                    cmp encode[0],3   ;SUB
                    jz l3
                    cmp encode[0],4   ;SBB
                    jz l4
                    cmp encode[0],5   ;XOR
                    jz l5
                    cmp encode[0],6   ;AND
                    jz l6
                    cmp encode[0],7   ;ROR
                    jz l7
                    cmp encode[0],8   ;ROL
                    jz l8
                    cmp encode[0],9   ;RCL
                    jz l9
                    cmp encode[0],10   ;RCR
                    jz l10
                    cmp encode[0],11   ;SHL
                    jz l11
                    cmp encode[0],12   ;SHR
                    jz l12
                    cmp encode[0],14   ;INC
                    jz l13
                    cmp encode[0],15   ;DEC
                    jz l14
                    cmp encode[0],13   ;CLC
                    jz l15                    
                    ret
                    l0:
                    add ax,dx
                    call flagsEditor       
                    ret
                    l1:
                    adc ax,dx 
                    call flagsEditor                                 
                    ret
                    l2:
                    mov ax,dx
                    ret
                    l3:
                    sub ax,dx
                    call flagsEditor                     
                    ret
                    l4:
                    sbb ax,dx
                    call flagsEditor 
                    ret
                    l5:
                    xor ax,dx
                    call flagsEditor 
                    ret
                    l6:
                    and ax,dx
                    call flagsEditor
                    ret
                    l7:
                    mov cl,dl
                    ror ax,cl
                    call flagsEditor
                    ret
                    l8: 
                    mov cl,dl
                    rol ax,cl
                    call flagsEditor
                    ret
                    l9: 
                    mov cl,dl
                    rcl ax,cl
                    call flagsEditor
                    ret
                    l10:
                    mov cl,dl
                    rcr ax,cl
                    call flagsEditor
                    ret
                    l11:
                    mov cl,dl
                    shl ax,cl
                    call flagsEditor
                    ret
                    l12:
                    mov cl,dl
                    shr ax,cl
                    call flagsEditor
                    ret
                    l13:
                    inc ax 
                    call flagsEditor
                    ret
                    l14:
                    dec ax 
                    call flagsEditor
                    ret
                    l15:  ;i will change this to mul instead of working with flags
                    clc
                    call flagsEditor  
                    ret                        
Which_Instruction endp     

execute_word proc     ;code = (encode[1] || encode[2])
 cmp Execute_To,0   
 jz player1_turn1
 jmp player2_turn1
 player1_turn1:
    mov si,offset Regs_player2
    mov di,offset Regs_player2 
    mov al,1          
    mov Execute_To,al
    jmp next3   
 player2_turn1:
     mov si,offset Regs_player1
     mov di,offset Regs_player1 
     mov al,0                   
     mov Execute_To,al
     jmp next3
    next3:
    mov bl,encode[1]     ;destination
    mov bh,0
    add si,bx  
    mov ah, [si]
    mov al, [si+1]
    mov cl,encode[2]     ;source
    mov ch,0
    add di,cx  
    mov dh, [di]
    mov dl, [di+1]

    ;;SET CARRY FLAG
    call Set_Carry_Flag
    call Which_Instruction
    mov [si],ah
    mov [si+1], al
    ret
 execute_word endp
 
    execute_byte proc     ;code= (encode[1] || encode[2])    check which player
 cmp Execute_To,0   
    jz player1_turn2
    jmp player2_turn2
 player1_turn2:
     mov si,offset Regs_player2
     mov di,offset Regs_player2 
     mov al,1          
     mov Execute_To,al
     jmp next1   
 player2_turn2:
     mov si,offset Regs_player1
     mov di,offset Regs_player1 
     mov al,0                   
     mov Execute_To,al
     jmp next1
    next1:
    mov bl,encode[1]  ;destination
    mov bh,0
    add si,bx
    mov al,encode[2]  ;source
    mov ah,0
    add di,ax
    mov ah,0
    mov al,[si]
    mov dl,[di]
    mov dh,0
    ;add ax,dx;;; 
    ;;SET CARRY FLAG
    call Set_Carry_Flag
    call Which_Instruction
    mov [si],al  
    ret
execute_byte endp
                                                                                 
execute_word_value proc     ;code= (encode[1] || encode[2])    check which player
 cmp Execute_To,0   
    jz player1_turn3
    jmp player2_turn3
 player1_turn3:
    mov si,offset Regs_player2 
    mov al,1          
     mov Execute_To,al
    jmp next2   
 player2_turn3:
    mov si,offset Regs_player1
    mov al,0                   
    mov Execute_To,al
    jmp next2
    next2:
    mov bl,encode[1]  ;destination
    mov bh,0
    add si,bx   
    mov dx,value  ;source 
    mov ah, [si]
    mov al, [si+1] 
    ;::::::STUCK POWERUP::::::: 
    push Bx
    mov bl , stuck
    cmp bl , turn
    pop BX
    jz stuck__
    jmp __nxt__
    stuck__:mov source,dx
        PushExcept_DX
        call StuckDataLine
        PopExcept_DX
        mov stuck,2
    __nxt__:
    ;;SET CARRY FLAGS
    call Set_Carry_Flag
    call Which_Instruction
    mov [si],ah
    mov [si+1], al
    ret  
execute_word_value endp 
;;------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
execute_byte_value proc     ;code= (encode[1] || encode[2])    check which player
 cmp Execute_To,0   
    jz player1_turn33
    jmp player2_turn33
 player1_turn33:
    mov si,offset Regs_player2 
    mov al,1          
     mov Execute_To,al
    jmp next2__   
 player2_turn33:
    mov si,offset Regs_player1
    mov al,0                   
    mov Execute_To,al
    jmp next2__
    next2__:
    mov bl,encode[1]  ;destination
    mov bh,0
    add si,bx   
    mov dx,value  ;source 
    mov ax,[si]
    ;:  :::::::STUCK POWERUP:::::::
    push BX
    mov bl , stuck
    cmp bl , turn
    pop BX
    jz stuck_M_
    jmp __nxt_M_
    stuck_M_:mov source,dx
        PushExcept_DX
        call StuckDataLine
        PopExcept_DX
        mov stuck,2
    __nxt_M_:         
    ;;SET CARRY FLAGS
    call Set_Carry_Flag
    call Which_Instruction
    mov [si],al
    ret  
execute_byte_value endp 

execute_one_operand proc     ;code= (encode[1] || encode[2])    check which player
 cmp Execute_To,0   
    jz player1_turn4
    jmp player2_turn4
 player1_turn4:
    mov si,offset Regs_player2 
    mov al,1          
    mov Execute_To,al
    jmp nnext2   
 player2_turn4:
     mov si,offset Regs_player1
     mov al,0                   
     mov Execute_To,al
     jmp nnext2
    nnext2:
    mov bl,encode[1]  ;destination
    mov bh,0
    add si,bx 
    
    mov ax,[si] 
    ;;SET CARRY FLAG
    call Set_Carry_Flag 
    call Which_Instruction
    mov [si],ax
    ret  
execute_one_operand endp


ExecuteCommand  proc far
    cmp encode[0],-1    ;check for validity of command
    jnz _cont_normally
    ;not Execute_to;------------------------------------------->
    ret     
    _cont_normally:     
     cmp encode[2],-1
        jz Value__
        jmp Next     ;not value
    Value__:cmp value,0
    jz zero_vl
    jmp nxtt
    zero_vl:cmp encode[1],15
    jbe Zero_Word
    jmp Zero_Byte
    Zero_Word:call execute_word_value
              ret
    Zero_Byte:call execute_byte_value
              ret    
    nxtt:
    cmp value,255
    ja word_val
    jmp nxt
    word_val:call execute_word_value    ;need to check inside byte or word
             ret

     nxt:cmp encode[1],15
     jbe ex_nor
    jmp nxtt___
    ex_nor:call execute_word_value
           ret
    nxtt___:
     
     mov ah,0             ;;byte value no need to check for memory-memory already done :)))))))))
         ;mov al,encode[1]
         cmp encode[1], 23
         ja is_memory
         sub encode[1],16

         is_memory:
         ;mov encode[1],al
         mov ah,0 
         call execute_byte_value  ;i have already checked for destination in error no need to check again
         ret                      
     Next:
    cmp encode[0],13    ;one operand operation
        jae one_operand
        jmp Neext2
    one_operand:call execute_one_operand
        ret     
    Neext2:         ;normal operations
        cmp encode[1],15 ;destination is register
        jbe word_D
        jmp Nextt
    word_D:call execute_word
        ret
    Nextt:cmp encode[1],24
        jb half_reg
        jmp Neext
    half_reg:    ;i guess if one is byte the other would be byte too or an error occour and that isny my job here
        ; mov ah,0
        ; mov al,encode[1]
        ; sub al,16
        ; mov encode[1],al
        ; mov ah,0
        ; mov al,encode[2]
        ; sub al,16
        ; mov encode[2],al


        mov ah,0
        sub encode[1],16
    Neext:
        cmp encode[2], 23
        ja is_memory_2
        sub encode[2],16
        is_memory_2:
        call execute_byte  ;if memory    
        ret    
ExecuteCommand endp

;;;;;;;;;;;WHICH PROCESSOR  LV2;;;;;;;;;;;;;;;;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;MAIN;;;;;;;;;;;;;;;;;;; 
main proc far

main endp
end main