.model small 
.data
        
b db "dont shoot my bbb$"        
val db ?        
.stack 64
.code

initial proc 
    
      ;mov ah,0
      ;mov dx,1
      ;mov al,0c3h
      ;int 14h
      
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
      mov al,00010011b
      out dx,al
      
initial endp

             
send proc
    
    check:
    mov ah,01
    int 16h
    jz check
     
    mov ah,0
    int 16h
    mov bl,al
              
    mov dl,al
    
    mov ah,02h
    int 21h
    ;cmp al,1bh
    ;je exit
    
    ;mov al,'k'    
    ;mov ah,1   
    ;mov dx,01
    ;int 14h
    
;next: call recieve
;exit: call Ex

   mov dx,3fdh
   AGAIN:in al,dx
   test al,00100000b
   jz AGAIN
   
   
   mov dx,3f8h
   mov al,bl
   out dx,al
           
send endp             
     
                            
              
  
  
  
main proc far
   
   
  ; call initial
   mylop:
   call send 
   jmp mylop
        
main endp
end main