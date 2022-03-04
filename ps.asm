extrn DrawingFullMainScreen:far
extrn Update:far
extrn DrawingPointsScreen:far
extrn Clear_Cmd_Area:far
extrn DrawTurnSquare:far
extrn DrawPowerUpSquare:far
extrn DrawErrorSquare:far
extrn UpdatePlayer1ForbiddenChar:far
extrn UpdatePlayer2ForbiddenChar:far
extrn RandomNumber5:far
extrn RandomNumber10:far
extrn OurSmallGame:far

extrn NotificationBar:far
extrn DrawMainScreen:far
extrn Parse_Cmd:far
extrn Defining_Usernames:far
extrn DetLvlAndForbidden:far

extrn ExecuteCommand:far
extrn check_Size_Memory_Mismatch:far
extrn Control_Power_Up:far

extrn IGC:far
extrn EXCHANGE_NAMES:far
extrn INITIALIZE_PORT:far
extrn Chatting:far
extrn SEND_CHAR:far
extrn RECEIVE_CHAR:far
extrn notification:far
extrn EXCHANGE_POINTS:far
extrn SEND_ENCODE:far
extrn RECIEVE_ENCODE:far
extrn RECIEVE_INGAME_MSG:far
extrn SEND_INGAME_MSG:far



public Regs_player1, Regs_player2, Hex_To_Display, encode, Execute_To, ASC_TBL, x, y, char1, char2
public EnterName1, EnterName2, P1Name, P2Name, EnterInPoints, P1Points, P2Points, edkhol
public value, forbidden1, forbidden2, Cmds, Operands, cmd
public STRING1, STRING2, STRING3, STRING4, Empty, temp, Notify2, Notify1
public levelIndicator, turn, Target_Value
public OneOrZero, line, source, carryplayer1, carryplayer2, stuck
public lvlMess, fMess, winning, changed2, changed1, WinningMsg1, WinningMsg2
public BallX,BallY,BallX2,BallY2,OurBallSize,OurBallSize2,OurTimeAux,ShooterFirstX,ShooterFirstY,Shooter2FirstX,Shooter2FirstY,Our_Ball_Velocity_In_Y
public initialSquare_X,initialSquare_Y,FinalSquare_X,FinalSquare_Y,initialSquare_Y2,initialSquare_X2,FinalSquare_X2,FinalSquare_Y2,ShooterHeight,ShooterWidth
public firstPlayerminRange,firstPlayerMaxRange,secondPlayerminRange,secondplayermaxRange,Squarevelocity,SmallGameCounter
public EnemyRandomNumber,ShootingGameRandomNumber
public CHAR_TO_SEND, RECEIVED_CHAR, INITIATOR, Nu3mnIndicator



.model huge
.386
.stack 64
.data

Cmds dd ' dda',' cda',' vom',' bus',' bbs', ' rox' , ' dna' , ' ror' , ' lor' ,' lcr',' rcr'  , ' lhs' , ' rhs' , 'clc' , ' cni',' ced'
Operands dw 'xa' ,'$$', 'xb' ,'$$', 'xc' ,'$$', 'xd' ,'$$', 'is','$$', 'id','$$', 'ps','$$', 'pb','$$',  'ha' , 'la' , 'hb' , 'lb' , 'hc' , 'lc' , 'hd' , 'ld'
         dw '0m', '1m' , '2m' , '3m' , '4m' , '5m' , '6m' , '7m' , '8m' , '9m' , 'am' , 'bm' , 'cm', 'dm', 'em', 'fm'
ASC_TBL db '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'
Hex_To_Display db ?,?,?,?
x db ?
y db ?

Regs_player1  db 40 dup(00)
Regs_player2  db 40 dup(00)
Execute_To  DB  0
levelIndicator db 1
turn db 0
Target_Value  DW 105eh

stuck  db 2
winning db 0
changed1 db ? 
changed2 db ?

carryplayer1  db  ?
carryplayer2  db  ?

cmd db 30,?,30 dup('$')
encode db ?,?,? ;cmd, destination, source
value dw '$$'
forbidden1 db 'K'
forbidden2 db 'N'


char1 db ?
char2 db ?

EnterName1 db 'Player Name: $'
EnterName2 db 'Player2 Name: $'
Initial_Points dw ?
P1Name DB 16 , ? , 16 DUP('$')
P2Name DB 16 , ? , 16 DUP('$')
P1Points dw ?  
P2Points dw ?
EnterInPoints db 'Initial Points: $'
edkhol db 'Press Enter To Continue$'

lvlMess db 'Level 1 or 2 ? $'
fMess db 'Enter Forbidden char in small Letters: $'

WinningMsg1 db 'Player 1 won','$'
WinningMsg2 db 'player 2 won','$'


STRING1  DB  'To start chatting press ','$' 
STRING2  DB  'To start the Game press ' ,'$'
STRING3  DB  'To end the program press ' ,'$'
STRING4  DB  'Notification Bar','$'
Empty    DB  ' ','$' 
temp     DB  ?    
Notify1  DB  'Notification Bar : ','$' 
Notify2  DB  'Welcome !!', '$'
chatting_invitation_sent db 'chatting invitation sent$'
chatting_invitation_recieved db 'chatting invitation recieved$'
gaming_invitation_sent db 'gaming invitation sent$'
gaming_invitation_recieved db 'gaming invitation recieved$'
msg db 'Rec P'
OneOrZero db ? 
line db ?
source dw ?

BallX dw ?
BallY dw 100
OurBallSize dw 01h
Our_Ball_Velocity_In_Y dw 5
OurTimeAux db 0  ; we use it to check if the time has passed


BallX2 dw ?
BallY2 dw 100
OurBallSize2 dw 01h

ShooterWidth dw 10
ShooterHeight dw 3

ShooterFirstX dw 60
ShooterFirstY dw 100

Shooter2FirstX dw 190
Shooter2FirstY dw 100

firstPlayerminRange dw 130
firstPlayerMaxRange dw 70

secondPlayerminRange dw 200
secondplayermaxRange dw 245

initialSquare_X  dw 70
FinalSquare_X dw ?
initialSquare_Y  dw 20
FinalSquare_Y dw ?

initialSquare_X2 dw 190
FinalSquare_X2 dw ?
initialSquare_Y2  dw 20
FinalSquare_Y2 dw ?

Squarevelocity dw 2
SqaureTimeAux db 0

SmallGameCounter db 0

EnemyRandomNumber db 1
ShootingGameRandomNumber db ?
Nu3mnIndicator db 0

CHAT_INVITATION db 0
GAME_INVITATION db 0
INITIATOR db 0

CHAR_TO_SEND db ? ;input to send_char
RECEIVED_CHAR db ? ;output to receive_char

.code

random_game proc far
    cmp INITIATOR, 1
    jnz __not_initiator
    call RandomNumber10
    ;call RandomNumber5
    cmp ShootingGameRandomNumber,6
    jne ThereIsNoShooting
    mov CHAR_TO_SEND, 1
    call SEND_CHAR
    call OurSmallGame
    jmp no_game

    ThereIsNoShooting:
    mov CHAR_TO_SEND, 0
    call SEND_CHAR
    ret

    __not_initiator:
    call RECEIVE_CHAR
    cmp RECEIVED_CHAR, 1
    jnz no_game
    call OurSmallGame

    no_game:
    ret
random_game endp

CONTROL_COMMANDS PROC FAR
    call DrawTurnSquare

    cmp turn, 0
    jnz cmd_not_my_turn

    cmp levelIndicator, 2
    jnz lvl1
    mov ah, 0
    int 16h
    
    cmp al, '0';0=default(on opponent processor)
    jz _dont_toggle
    xor execute_to, 1

    _dont_toggle:
    mov al, execute_to
    mov CHAR_TO_SEND, al
    call SEND_CHAR

    lvl1:
    call Parse_Cmd
    call check_Size_Memory_Mismatch
    call SEND_ENCODE
    jmp cnt_cmd

    cmd_not_my_turn:
    cmp levelIndicator, 2
    jnz _lvl1

    call RECEIVE_CHAR
    mov al, RECEIVED_CHAR
    xor al, 1
    mov execute_to, al

    _lvl1:
    call RECIEVE_ENCODE

    cnt_cmd:
    cmp encode[0], -1
    jnz cmd_is_valid
    call DrawErrorSquare
    jmp cmd_is_invalid

    cmd_is_valid:
    call ExecuteCommand
    call Update
    call Clear_Cmd_Area

    cmd_is_invalid:
    xor turn, 1 ;invert turn
    mov al, turn
    mov execute_to, al ;initial condition before any powerups

    call random_game

    ret
CONTROL_COMMANDS ENDP


Game proc far
    call DrawingFullMainScreen
    ;initial condition DONNOT TOUCH!!
    mov al, INITIATOR
    xor al, 1

    mov turn, al
    mov execute_to, al
    
    
    Game_loop:
        cmp turn, 0
        jnz not_my_turn
    ;my turn
        mov ah,1
        int 16h
        jz Game_loop

        cmp ah, 3eh
        jz send_game_over

        ; cmp ah, 19h
        cmp al, 112d
        jz Cntr_powerup

        cmp ah, 2eh
        jz commands

        cmp ah, 32h
        jz msgs

        jmp clr_buffer


        not_my_turn:
        call RECEIVE_CHAR
        mov al, RECEIVED_CHAR
        
        cmp al, 'c'
        jnz pwr
        call CONTROL_COMMANDS
        cmp winning, 0
        jnz game_over
        jmp Game_loop

        pwr:
        cmp al, 'p'
        jnz exitoo
        ;-------------
        call DrawPowerUpSquare
        ;------------
        call Control_Power_Up
        ; call Update
        call UpdatePlayer1ForbiddenChar
        call UpdatePlayer2ForbiddenChar
        jmp Game_loop

        exitoo:
        cmp al, 'e'
        jz game_over

        cmp al, 'm'
        jnz Game_loop
        call RECIEVE_INGAME_MSG
        jmp Game_loop

;============================================================================
        msgs:
        mov ah,07
        int 21h

        mov CHAR_TO_SEND, 'm'
        call SEND_CHAR
        call SEND_INGAME_MSG
        JMP Game_loop
       
       
       
        Cntr_powerup:
        mov ah,07
        int 21h
        call DrawPowerUpSquare
        mov CHAR_TO_SEND, 'p'
        call SEND_CHAR
        ;---------------------------
   
        call Control_Power_Up
        ; cmp levelIndicator, 2
        ; jz no_edit
        ; call Update
        call UpdatePlayer1ForbiddenChar
        call UpdatePlayer2ForbiddenChar
        ; no_edit:
        ;------------------------
        jmp Game_loop

        commands:
        mov ah,07
        int 21h
        mov CHAR_TO_SEND, 'c'
        call SEND_CHAR
        call CONTROL_COMMANDS

        cmp winning, 0
        jnz game_over
        jmp Game_loop

        send_game_over:
        mov CHAR_TO_SEND, 'e'
        call SEND_CHAR
        jmp game_over

        


        clr_buffer:
        mov ah,07
        int 21h
    jmp Game_loop


    game_over:
    call DrawingPointsScreen
    mov ah,07
    int 21h
    wait_for_key:
        mov ah,1
        int 16h
    jz wait_for_key
    ret
Game endp


Gaming_Mode proc far
    ;choose intital points
    call EXCHANGE_POINTS

    mov ax, P1Points
    cmp ax, P2Points
    jb set_p2_points
    mov ax, P2Points
    mov P1Points, ax
    jmp choose_level
    set_p2_points:
    mov P2Points, ax

    choose_level:
    mov Initial_Points, ax
    mov ah,07
    int 21h
    call DetLvlAndForbidden

    call Game
    mov ax, Initial_Points
    mov P1Points, ax
    mov P2Points, ax
    ret
Gaming_Mode endp

Manager proc far
   Main_loop:
        mov ah,1
        int 16h
        jz check_msgs

        cmp ah, 3ch
        jnz chk_cht

        cmp GAME_INVITATION, 1
        jz send_game_confirmation
        mov CHAR_TO_SEND, 'g'
        call SEND_CHAR
        mov dx, offset gaming_invitation_sent
        call notification
        jmp clr_bufferz_mgr

        send_game_confirmation:
        mov CHAR_TO_SEND, 'h'
        call SEND_CHAR
        call Gaming_Mode
        mov GAME_INVITATION , 0 
        call DrawMainScreen
        jmp Main_loop

    ;===================================================================================================================
        chk_cht:
        cmp ah, 3bh
        jnz cont_keys
        cmp CHAT_INVITATION, 1
        jz send_chat_confirmation
        mov CHAR_TO_SEND, 'c'
        call SEND_CHAR
        mov dx, offset chatting_invitation_sent
        call notification
        jmp clr_bufferz_mgr

        send_chat_confirmation:
        mov CHAR_TO_SEND, 'd'
        call SEND_CHAR
        call chatting
        mov CHAT_INVITATION , 0 
        jmp Main_loop
    ;===================================================================================================================
        cont_keys:
        cmp ah, 1h
        jz Escape

        jmp check_msgs



        ; Start_Game:
        ; call Gaming_Mode
        ; call DrawMainScreen
        ; jmp clr_bufferz_mgr


        check_msgs:
        ;check if there is a msg
        mov dx, 3fdh
        in al, dx
        and al, 1
        jz Main_loop
    ;============================================================================
        call RECEIVE_CHAR ;something is in the buffer (a msg!)

        ;if there is a chatting invitation
        cmp RECEIVED_CHAR, 'c'
        jnz cht_invitation_accepted
        mov dx, offset chatting_invitation_recieved
        call notification
        mov CHAT_INVITATION, 1
        jmp Main_loop

        cht_invitation_accepted:
        ;if invitation accepted
        cmp RECEIVED_CHAR, 'd'
        jnz chk_game
        call Chatting
        mov CHAT_INVITATION , 0 
        jmp Main_loop
    ;==============================================================================
        chk_game:
        ;if there is a gaming invitation
        cmp RECEIVED_CHAR, 'g'
        jnz gm_invitation_accepted
        mov dx, offset gaming_invitation_recieved
        call notification
        mov GAME_INVITATION, 1
        jmp Main_loop

        gm_invitation_accepted:
        ;if invitation accepted
        cmp RECEIVED_CHAR, 'h'
        jnz Main_loop
        mov INITIATOR, 1
        call Gaming_Mode
        mov GAME_INVITATION , 0
        mov INITIATOR, 0
        call DrawMainScreen
        jmp Main_loop

        
        clr_bufferz_mgr:
        mov ah,07
        int 21h

    jmp Main_loop

    Escape:
    ret 
Manager endp

main proc far 
    mov ax , @DATA
    mov ds , ax 
    mov es , ax

    call INITIALIZE_PORT
    call Defining_Usernames
    call EXCHANGE_NAMES
    call DrawMainScreen
    call Manager

    hlt
main endp 
end main 

