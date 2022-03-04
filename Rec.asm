.model small 
.data
                              
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

                   
   
recieve proc
    
    ;mov ah,3
    ;mov dx,1
    ;int 14h
    
    ;AND ah,1
    ;cmp ah,1
    
    ;jne again
    ;mov ah,2
    ;mov dx,1
    ;int 14h
        
    ;mov dl,al 
    ;mov ah,2
    ;int 21h
    ;jmp again
 m:    
    mov dx,3fdh
    chk: in al,dx
    test al,1
    jz chk
    
    mov dx,03f8h
    in al,dx
    
    mov dl,al        
             
   mov  ah,02h
   int 21h
jmp m
recieve endp   
              
Ex proc
    mov ah,4ch
    int 21h
    
Ex endp                  
              
  
  
  
main proc far
   
   mov ax,@DATA
   mov ds,ax


         

   
   
   call initial 
   call recieve
  
          
   
   
   
        
main endp
end main