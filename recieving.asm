.model small
.stack 64
.data
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





Recieving proc far
popf
mov dx , 3FDH
	CHK:	in al , dx 
  		test al , 1
  		JZ CHK                
  		mov dx , 03F8H
  		in al , dx 
popf
ret
Recieving endp



main proc far

call FirstProc
call Recieving

main endp
end main