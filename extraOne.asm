.model huge
.stack 64
.data 
player_position_x db 0
player_position_y equ 12

enemy_max equ 50
enemy_x db 50 dup(0)
enemy_y db 50 dup(0)

cursor_x db 0
cursor_x db 0

bullet_max equ 50
bullet_x db 10 dup(0)
bullet_y db 10 dup(0)

score_0 db 0
score_1 db 0


.code


main proc far 

    mov ax,@data
    mov ds,ax
    mov ah,0h
	mov al,13h
    int 10h

    start:
          game_loop:
          check_key:
                     mov cx,01h
                     mov dx,0c680h
                     mov ah,86h
                     int 15h

                     mov ah,0bh
                     int 21h
                     cmp al,00h
                     je is_new_key_false

                     is_new_key_true:
                       mov ah,00h
                       int 16h    
 

                       cmp ah,1Eh
                       jne not_a
                       dec player_position_x
                       not_a:
                             cmp ah,20h
                             jne not_d
                             inc player_position_x
                        not_d: 
                        mov ah,0ch
                        int 21h    

                        is_new_key_false:
                                         mov si,0
                       loop_over_enemies:
                       cmp si,enemy_max
                       jge exit_loop_over_enemies
                                         mov dl,enemy_y[si]
                                         cmp dl,0
                                         je exit_loop_over_enemies
                                         inc Dl
                                         mov enemy_y[si],dl

                         exit_loop_over_enemies:
                                         mov si,0
                                         loop_over_bullet: 
                                                          cmp si,bullet_max
                                                          jge exit_loop_over_bullet

                                                          mov dl,bullet_y[si]
                                                          cmp dl,0
                                                          je exit_loop_over_bullet

                                                          dec Dl
                                                          mov bullet_y[si],di
                                                          push si


                                                          mov si,0
                                                          Inner_loop_over_enemies:
                                                                                 cmp si,enemy_max
                                                                                 jge exit_Inner_loop_over_enemies
                                                                                  jmp Inner_loop_over_enemies
                                                                                 exit_Inner_loop_over_enemies:

                                                         pop si
                                                          
                                         exit_loop_over_bullet:                                




main endp
end main
