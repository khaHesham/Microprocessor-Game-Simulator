extrn P1Points:WORD
extrn P2Points:WORD
extrn encode:BYTE
extrn Execute_To:BYTE
extrn value:WORD
extrn turn:BYTE


public check_Size_Memory_Mismatch

.model small
.stack 64

.code
check_Size_Memory_Mismatch proc far
    cmp encode[0],-1   ;already there is error [!!DONT CONTINUE!!]
    jnz cont_0_
    jmp not_equal
  
  cont_0_:   
  cmp encode[2],-1
  jz Val
  jmp _continue_
  Val:cmp encode[1],15
  jbe val_check     ;;maybe zeroo!!
  jmp _next_
  val_check:cmp value,0
  jz equal
;   cmp value,255   
;   ja equal ; D:word- S: (word value) 
;   jmp not_equal ; D:word -S:byte value  [error] 
       jmp equal
  _next_:cmp encode[1],24  
  jb __next__
  jmp equal  ;;memort to memory
  __next__:cmp value,0
  jz equal
  cmp value,255d
         jbe equal    ;D:byte  S:Byte
         jmp not_equal ;D:byte  S:word
  _continue_:
  cmp encode[1],15
  jbe source_check
  jmp _next_0
  source_check:cmp encode[2],15   
  jbe equal ; D:word-S:word 
  jmp not_equal ; D:Byte-S:word  [error] 
  _next_0:cmp encode[1],24
  jb  source_check2
  jmp _next2_0
  source_check2:cmp encode[2],16 
  jae  equal    ;D:byte - S:byte (or) memory
  jmp not_equal ;D:byte -S:word   [error]
  _next2_0:cmp encode[2],24
        jae not_equal  ; D:memory -S:memory   [error]
        jmp check2      ;D:memory -S:byte or word        
        check2:cmp encode[2],16
               jbe not_equal  ;D:memory -S:word  [error] 
               jmp equal       ;D:memory - S:byte 
  not_equal:
  cmp turn, 0
  jnz red_p2
  dec P1Points
  jmp validate
  red_p2:
  dec P2Points

  validate:
  mov encode[0], -1
  ret
  equal:ret                    
check_Size_Memory_Mismatch  endp

main proc far

main endp
end main