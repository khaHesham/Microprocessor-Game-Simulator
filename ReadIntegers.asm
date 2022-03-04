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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.model small 
.stack 64
.data
a dw ?
.code
main proc
	     MOV         AX , @DATA
	     MOV         DS , AX
	     Read4Digits
	;hlt program
	     mov         ah , 4ch
	     int         21h
main endp
end main   

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

