public Read4Dgs
extrn a:BYTE

getnum macro ; to read the number digit by digit
    mov ah , 1  ; read char 
    int 21h    
endm getnum  

readfirstdigit macro p1                 
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1000d ; awl rkm bdrbo f 1000 
    mul bx       ; multiply the first digit by 1000 
    mov p1 , ax ; put the result in a
endm readfirstdigit

readseconddigit macro p1                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 100d
    mul bx       ; multiply the first digit by 100 
    add p1 , ax ;add to a

endm readseconddigit

readThirddigit macro p1                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 10d
    mul bx       ; multiply the first digit by 10 
    add p1 , ax ; add to a

endm readThirddigit

read4thdigit macro p1                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1d
    mul bx      
    add p1 , ax ;add to a

endm read4thdigit
 
Read4Digits macro p1
    ;reading the number digit by digit
    getnum
    readfirstdigit p1
    getnum
    readSeconddigit p1 
    getnum
    readThirddigit p1
    getnum
    read4thdigit p1      
endm Read4Digits  

.model small 
.code
Read4Dgs proc far
    Read4Digits a
    ret
Read4Dgs endp


main proc

main endp
end main