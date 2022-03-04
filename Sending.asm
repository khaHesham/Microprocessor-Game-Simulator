.model small
.stack 64
.data
Value db 'd'
.code
FirstProc proc far
mov dx,3fbh 		
mov al,10000000b		
out dx,al

mov dx,3f8h			
mov al,0ch			
out dx,al

mov dx,3f9h
mov al,00h
out dx,al

mov dx,3fbh
mov al,00011011b
out dx,al
ret
FirstProc endp





Sending proc far
popf
mov dx , 3FDH		
AGAIN:  In al , dx 			
test al , 00100000b
JZ AGAIN             
mov dx , 3F8H		
mov  al,Value
out dx , al
popf
ret
Sending endp
 


main proc far
		   mov ax, @data
		   mov DS, ax

call FirstProc
call Sending

main endp
end main