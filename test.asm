
.model small
.stack 64
.data

encode db 'abc$' ;cmd, destination, source
CHAR_TO_SEND db ? ;input to send_char
RECEIVED_CHAR db ? ;output to receive_char

.code


INITIALIZE_PORT PROC FAR
    ;Setting d8 so i can write the lsb of the baud rate
    mov dx, 3fbh
    mov al, 10000000b
    out dx, al

    ;lsb of baud rate
    mov dx, 3f8h
    mov al, 0ch
    out dx, al

    ;msb of baud rate
    mov dx, 3f9h
    mov al, 00h
    out dx, al

    ;configuration
    mov dx, 3fbh
    mov al, 00011011b
    out dx, al

    ret
INITIALIZE_PORT ENDP

SEND_CHAR PROC FAR
    not_free:
        mov dx, 3fdh
        in al, dx
        and al, 00100000b
    jz not_free

    mov dx, 3f8h
    mov al, CHAR_TO_SEND
    out dx, al

    ret
SEND_CHAR ENDP

RECEIVE_CHAR PROC FAR
    mov dx, 3fdh
    chk: 
        in al, dx
        and al, 1   
    jz chk

    mov dx, 03f8h
    in al, dx
    mov RECEIVED_CHAR, al

    ret
RECEIVE_CHAR ENDP


SEND_ENCODE PROC FAR
    mov si, offset encode

    mov CHAR_TO_SEND, 's'
    call SEND_CHAR

    call RECEIVE_CHAR

    mov cx, 3
    send_ecd:
    lodsb
    mov CHAR_TO_SEND, al
    call SEND_CHAR
    loop send_ecd

    ret
SEND_ENCODE ENDP


RECIEVE_ENCODE PROC FAR
    mov di, offset encode
    call RECEIVE_CHAR

    mov CHAR_TO_SEND, 'r'
    call SEND_CHAR

    mov cx, 3
    rcv_ecd:
    call RECEIVE_CHAR
    mov al, RECEIVED_CHAR
    stosb
    loop rcv_ecd

    ret
RECIEVE_ENCODE ENDP

main proc far
    
    mov ax, @data
    mov ds, ax 
    mov es, ax

    call INITIALIZE_PORT

    mov ah,0
    int 16h

    cmp al, 's'
    jz sendooo
    call RECIEVE_ENCODE
    mov ah, 9
    mov dx, offset encode
    int 21h
    jmp exit

    sendooo:
    call SEND_ENCODE
   
   exit:
    hlt
main endp
end main