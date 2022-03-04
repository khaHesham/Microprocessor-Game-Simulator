extrn P1Name:BYTE
extrn P2Name:BYTE
extrn P1Points:WORD
extrn P2Points:WORD
extrn encode:BYTE
extrn value:WORD


extrn CHAR_TO_SEND:BYTE
extrn RECEIVED_CHAR:BYTE

public EXCHANGE_NAMES, INITIALIZE_PORT, SEND_CHAR, RECEIVE_CHAR, EXCHANGE_POINTS, SEND_ENCODE, RECIEVE_ENCODE


.model small
.stack 64
.data


; P1Name DB 16 , ? , 16 DUP('$')
; P2Name DB 16 , ? , 16 DUP('$')
name_ended db 0
rcv_name_ended db 0


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

EXCHANGE_POINTS proc far
    mov si, offset P1Points
    mov di, offset P2Points

    mov cx, 2
    send_points:
    lodsb
    mov CHAR_TO_SEND, al
    call SEND_CHAR

    call RECEIVE_CHAR
    mov al, RECEIVED_CHAR
    stosb
    loop send_points

    ret

EXCHANGE_POINTS ENDP

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


    mov si, offset value

    mov cx, 2
    send_vl:
    lodsb
    mov CHAR_TO_SEND, al
    call SEND_CHAR
    loop send_vl

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

    mov di, offset value

    mov cx, 2
    rcv_vl:
    call RECEIVE_CHAR
    mov al, RECEIVED_CHAR
    stosb
    loop rcv_vl

    ret
RECIEVE_ENCODE ENDP


EXCHANGE_NAMES PROC FAR
    mov si, offset P1Name
    mov di, offset P2Name

    snd_char:
        cmp name_ended, 1
        jz rcv_chr

        lodsb
        mov CHAR_TO_SEND, al
        call SEND_CHAR
        cmp al, '$'
        jz sent_name_ended
        jmp rcv_chr

        sent_name_ended:
        cmp rcv_name_ended, 1
        jz ext_name
        mov name_ended, 1
       
    rcv_chr:
        cmp rcv_name_ended, 1
        jz snd_char
        call RECEIVE_CHAR
        mov al, RECEIVED_CHAR
        stosb
        cmp al, '$'
        jz recieved_name_ended
        jmp snd_char

    recieved_name_ended:
    cmp name_ended, 1
    jz ext_name
    mov rcv_name_ended, 1
    jmp snd_char

    ext_name:
    ret
EXCHANGE_NAMES ENDP


end