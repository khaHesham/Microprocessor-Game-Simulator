.model large
.data
p db ?,?

.code

drawSquare MACRO c
    mov ah, 06h
    xor al, al
    mov cl, p[1]
    mov ch, p[0]
    
    add p[1], 2
    add p[0], 1
    
    mov dl, p[1]
    mov dh, p[0]
    mov bh, c
    int 10h
    
    sub p[1], 2
    sub p[0], 1   
endm

down proc
  drawSquare 00h
  add p[0], 1
  add p[1], 3
  drawSquare 40h
    
down endp

up proc
  drawSquare 00h
  sub p[0], 1
  add p[1], 3
  drawSquare 40h
    
up endp


main proc far
    mov ax, @data
    mov ds, ax
    
    mov p[0], 0ch
    mov p[1], 4dh
     
    drawSquare 20h
     
    mov p[0], 0ch
    mov p[1], 00h
    drawSquare 40h
    
    
        dowwn:call down
        mov ah, 1
        int 16h
        jnz upp
        jmp dowwn
        
        upp:mov ah, 7
        int 21h
        call up

         cmp p[1], 4ah
         jae green
         
         
         here:
        mov ah, 1
        int 16h
        jnz upp
        
        jz dowwn
    
         
         green:
         cmp p[0], 14h
         jae red
         
    mov ah, 06    
    xor al, al
    mov cl, 0
    mov ch, 0
   
    
    mov dl, 4fh
    mov dh, 15h
    mov bh, 20h
    int 10h
    jmp exxxit 
    
    red:
        mov ah, 06    
    xor al, al
    mov cl, 0
    mov ch, 0
   
    
    mov dl, 4fh
    mov dh, 15h
    mov bh, 40h
    int 10h
    
    exxxit:
    
main endp
end main