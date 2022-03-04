.model small
.stack 64   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.data       
CmdArr db 'add','adc','mov','sub','sbb', 'xor' , 'and' , 'ror' , 'rol' ,'rcl','rcr'  , 'shl' , 'shr' , 'div' , 'mul', 'clc' , 'inc','dec' , 'nop', '$$$$' ;kolohom small letters
RegArr db 'ax' , 'bx' , 'cx' , 'dx' , 'al' , 'bl' , 'cl' , 'dl' , 'ah' , 'bh' , 'ch' , 'dh' , '$$$$'
MemArr db 'm01' , 'm02' , 'm03' , 'm04' , 'm05' , 'm06' , 'm07' , 'm08' , 'm09' , 'm10' , 'm11' , 'm12' , '$$$$'

InputCommand db 30 dup('$')
str1 DB 20 , ? , 20 dup('$')  ; source
operation db 4 dup('$') ;operation
Dest db  3 dup('$'); destination 
sorce db 3 dup('$'); source -> reg or value or memory loc all of them wont exceed 4 letters 
inv db 'C' ; invalid format for operation

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

.code                                

main proc far 
 mov ax , @data 
 mov ds , ax 
 mov es , ax ; to use string operations
 mov si , offset str1 + 2 ; 
 mov di , offset operation
 

;read the whole command 
 mov ah , 0ah
 mov dx , offset str1
 int 21h 
 
 ;reading first 3 chars which are the operation 
 mov cx , 3 
 rep movSB
   

  ;;  add  a-> x
  ;;  xlt 
 ;loop and check wethere this string exits in the cmdarr or not  
 mov di, offset CmdArr 
 checkloop:
 mov si , offset operation 
    cmpsb 
    jnz NF1 ; not the correct command
    cmpsw
    jnz checkloop
    jz Found ; if found exit
 
 NF1:; lw awl 7rf 8lt yeb2a me7tag azwd el di mrten 
 inc di
 inc di     
 push ax
 mov al , '$'
 cmp [di] , al
 pop ax 
 jz cant     
 jmp checkloop
 
 cant:
  mov inv , 'X'
  ; halt program
  mov ax , 4ch 
  int 21h  
 
 Found:      
 mov si ,offset str1 + 5 ; start from the 5th loc
 ;Neglect all spaces
  
 push ax 
 loop1: ;to  neglect all spaces in the input    
 mov al , [si]
 cmp al , 20h ; if they are equal  end loop
 jnz  end1 ; not space so end 
 inc si
 jmp loop1
 end1:
 pop ax
 ;the destination will be reg so it wont be > 2 chars    
 mov di , offset Dest ; now we should write in the destination
 mov cx , 3
 rep movSB
 
 
 ;check for valid destination    
 ;search in regARR first
 mov di, offset RegArr 
 checkRegArr:
 mov si , offset Dest 
 cmpsw 
 jnz NF2 ; not the correct command
 jz Found2 ; if found exit
 
 NF2:; lw awl 7rf 8lt yeb2a me7tag azwd el di mrten    
 push ax
 mov al , '$'
 cmp [di] , al
 pop ax 
 jz checkMemArr     
 jmp checkRegArr
 
 
 ;CheckMemArr 
 checkMemArr:
 mov di , offset MemArr
 checkMemArr2:
 mov si , offset Dest
 cmpsb 
 jnz NF3 ; not the correct command
 cmpsw
 jnz checkMemArr2
 jz Found3 ; if found exit
 
 NF3:; lw awl 7rf 8lt yeb2a me7tag azwd el di mrten 
 inc di
 inc di     
 push ax
 mov al , '$'
 cmp [di] , al
 pop ax 
 jz cant2     
 jmp checkMemArr2

  cant2:
  mov inv , 'X'
  ; halt program
  mov ax , 4ch 
  int 21h  

 Found2:
 mov si ,offset str1 + 8 ; 34an l2eto b3d el operation w el destination 7rfen bs
 jmp cont
 
 Found3:
 mov si ,offset str1 + 9 ; 34an l2eto w el dest 3 7rof 
 cont:
 
 ;;neglect all spaces again 
 push ax 
 loop2: ;to  neglect all spaces in the input    
 mov al , [si]
 cmp al , 20h ; if they are equal  end loop
 jnz  end2 ; not space so end 
 inc si
 jmp loop2
 end2:
 pop ax
 
 ;neglect comma
 inc si 
 
 ;neglect all spaces again
 push ax 
 loop3: ;to  neglect all spaces in the input    
 mov al , [si]
 cmp al , 20h ; if they are equal  end loop
 jnz  end3 ; not space so end 
 inc si
 jmp loop3
 end3:
 pop ax 
  
 ;put the values in the sorce now 
 mov di , offset sorce
 mov cx ,4
 rep  movSB 
 
 ;; check for valid sorce and des
  mov di, offset RegArr 
 checkRegArr2:
 mov si , offset sorce 
 cmpsw 
 jnz NF4 ; not the correct command
 jz Found5 ; if found exit
 
 NF4:; lw awl 7rf 8lt yeb2a me7tag azwd el di mrten    
 push ax
 mov al , '$'
 cmp [di] , al
 pop ax 
 jz checkMemArr2     
 jmp checkRegArr2
 
 
 ;CheckMemArr 
 checkMemArr3:
 mov di , offset MemArr
 checkMemArr4:
 mov si , offset Dest
 cmpsb 
 jnz NF5 ; not the correct command
 cmpsw
 jnz checkMemArr4 
 jz Found5 ; if found exit
 
 NF5:; lw awl 7rf 8lt yeb2a me7tag azwd el di mrten 
 inc di
 inc di     
 push ax
 mov al , '$'
 cmp [di] , al
 pop ax 
 jz cant4     
 jmp checkMemArr4
   
 Found5:
    
 ;halt the program 
 mov ax , 4ch 
 int 21h   
 
  cant4:
  mov inv , 'X'
  ; halt program
  mov ax , 4ch 
  int 21h   
    
main endp 

end main 