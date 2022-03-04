public DrawingFullMainScreen, Update, DrawingPointsScreen, Clear_Cmd_Area, DrawTurnSquare, DrawPowerUpSquare, DrawErrorSquare, UpdatePlayer1ForbiddenChar, UpdatePlayer2ForbiddenChar, intitialization
public RandomNumber5,RandomNumber10,OurSmallGame

extrn CHAR_TO_SEND:BYTE
extrn RECEIVED_CHAR:BYTE

extrn Regs_player1:BYTE
extrn Regs_player2:BYTE
extrn Hex_To_Display:BYTE
extrn encode:BYTE
extrn Execute_To:BYTE
extrn ASC_TBL:BYTE
extrn x:BYTE
extrn y:BYTE
extrn char1:BYTE
extrn char2:BYTE
extrn P1Name:BYTE
extrn P2Name:BYTE
extrn forbidden1:BYTE
extrn forbidden2:BYTE
extrn levelIndicator:BYTE
extrn P1Points:WORD
extrn P2Points:WORD
extrn turn:BYTE
extrn winning:BYTE
extrn Target_Value:WORD
extrn WinningMsg1:BYTE
extrn WinningMsg2:BYTE
extrn BallX:WORD
extrn BallY:WORD
extrn OurBallSize:WORD
extrn Our_Ball_Velocity_In_Y:WORD
extrn OurTimeAux:BYTE  ; we use it to check if the time has passed


extrn BallX2:WORD
extrn BallY2:WORD
extrn OurBallSize2:WORD

extrn ShooterWidth:WORD
extrn ShooterHeight:WORD

extrn ShooterFirstX:WORD
extrn ShooterFirstY:WORD

extrn Shooter2FirstX:WORD
extrn Shooter2FirstY:WORD

extrn firstPlayerminRange:WORD
extrn firstPlayerMaxRange:WORD

extrn secondPlayerminRange:WORD
extrn secondplayermaxRange:WORD

extrn initialSquare_X:WORD
extrn FinalSquare_X:WORD
extrn initialSquare_Y:WORD
extrn FinalSquare_Y:WORD

extrn initialSquare_X2:WORD
extrn FinalSquare_X2:WORD
extrn initialSquare_Y2:WORD
extrn FinalSquare_Y2:WORD

extrn Squarevelocity:WORD


extrn SmallGameCounter:BYTE

extrn ShootingGameRandomNumber:BYTE
extrn EnemyRandomNumber:BYTE
extrn Nu3mnIndicator:BYTE


.model HUGE
.stack 64


.CODE
  


RandomNumber5 proc far
PUSH AX
	PUSH bx
	PUSH cx
	PUSH dx
	PUSH si
	PUSH DI
	PUSHF

mov cx,1
startDelay2:cmp cx,100
           je endDelay2
		   inc cx
           jmp startDelay2
endDelay2:	
mov ah,0
int 1ah
mov ax,dx
mov dx,0
mov bx,5
div bx
mov EnemyRandomNumber,dl
	POPF
	POP DI
	POP si
	POP DX
	POP cx
	POP bx
	POP AX
ret
RandomNumber5 endp

RandomNumber10 proc far
PUSH AX
	PUSH bx
	PUSH cx
	PUSH dx
	PUSH si
	PUSH DI
	PUSHF

mov cx,1
startDelay1:cmp cx,100
           je endDelay1
		   inc cx
           jmp startDelay1
endDelay1:		   
mov ah,0
int 1ah
mov ax,dx
mov dx,0
mov bx,10
div bx
mov ShootingGameRandomNumber,dl
	POPF
	POP DI
	POP si
	POP DX
	POP cx
	POP bx
	POP AX
ret
RandomNumber10 endp

;//////////////////////////////////////////////////////////////




NormalPusha MACRO
	PUSH AX
	PUSH bx
	PUSH cx
	PUSH dx
	PUSH si
	PUSH DI
	PUSHF
ENDM

NormalPopa MACRO
	POPF
	POP DI
	POP si
	POP DX
	POP cx
	POP bx
	POP AX
ENDM	
;---------------------------------------------------------------------------------Coloring Char-------------------------------------------------------------------------------
ColoredChar MACRO Mychar,color 
	mov ah,9
	mov al,mychar
	mov bh,0
	mov cx,1
	mov bl,color
	int 10h
ENDM 				

;-----------------------------------------------------------------------------------Changing Position-----------------------------------------------------------------------------------
ChangePosition MACRO X,Y 
	MOV Ah,2H
	MOV Dl,X
	MOV Dh,Y
	INT 10H  
ENDM

;-----------------------------------------------------------------------------------Reading From Player-----------------------------------------------------------------------------------


ChangePos proc
	MOV Ah,2H
	MOV Dl,X
	MOV Dh,Y
	INT 10H
	ret
ChangePos ENDP

ColorChar proc
	push cx
	mov ah,9
	mov bh,0
	mov cx,1
	mov bl,55h
	int 10h
	pop cx
	ret
ColorChar ENDP

Display_Hex proc
    MOV BX, OFFSET ASC_TBL
    XLAT
    stosb
    ret
Display_Hex ENDP


To_Hex_8bit proc ;input to al
    MOV AH, 0
    MOV BL, 16
    DIV BL
    call Display_Hex
    mov AL, AH
    call Display_Hex
    ret
To_Hex_8bit ENDP

To_Hex_16bit proc ;input to ax
    mov cl, al
    mov al, ah
    call To_Hex_8bit
    mov al, cl
    call To_Hex_8bit
    ret
To_Hex_16bit ENDP

Update proc far
	NormalPusha

	mov al, encode[1]
	MOV y, al

	and al, 1
	mov al, y
	jz not_l
	cmp al, 23
	ja not_l
	dec y
	dec al

	not_l:
	mov di, offset Hex_To_Display

	cmp Execute_To, 0
	jnz Dest_p2
	mov si, offset Regs_player1
	mov x, 3
	jmp Memory_reg
	Dest_p2:
	mov si, offset Regs_player2
	mov x, 33
	jmp Memory_reg


	Memory_reg:
	mov ah, 0
	add si, ax
	cmp encode[1], 16
	jb rg
	mov al, [si]
	call To_Hex_8bit
	sub y, 23
	mov di, 2
	cmp Execute_To, 0
	jnz Set_X_p2_m
	mov x, 16
	jmp Display_chars
	Set_X_p2_m:
	mov x, 21
	jmp Display_chars

	rg:
	inc y
	mov ah, [si]
	mov al, [si+1]
	;WINNING CONDITION
	cmp ax, Target_Value
	jnz not_game_over

	;determinig the winner
	;if(turn=execute_to) then the player is executing on the other player's processor, hence he won
	;else he is an idiot and made the other player won :)

	xor execute_to, 1;--------------------->

	mov bl, turn
	cmp execute_to, bl
	jnz plyr_is_idiot
	inc bl ;if turn=0->p1_won->winner=1,         turn=1->p2_won->winner=2
	mov winning, bl
	jmp not_game_over ;winning is being checked from outside

	plyr_is_idiot:
	mov bl, execute_to ;if it's my turn and i'm executing on my processor then the other player won
	inc bl
	mov winning, bl

	not_game_over:
	xor execute_to, 1;---------------->
	call To_Hex_16bit
	mov di, 4
	
	Display_chars:
	mov si, 0
	hex_char:
		call ChangePos
		mov al, Hex_To_Display[si]
		call ColorChar
		inc x
		inc si
		cmp si, di
	jnz hex_char

	NormalPopa																
	ret	       				
Update endp


intitialization proc
	mov cl, 0
	initial_values:
		mov Execute_To, cl
		mov ch,0
		mov dl, 24
		initial_regs:
			mov encode[1], ch
			call Update
			add ch, 2
			cmp ch, 16
		jnz initial_regs

		initial_mmry:
			mov encode[1], dl
			call Update
			inc dl
			cmp dl, 40
		jnz initial_mmry
		inc cl
		cmp cl, 2
	jnz initial_values
	ret
intitialization endp


UpdatePlayer1ForbiddenChar proc
	NormalPusha
	ChangePosition 2,17
	mov ah,9
	mov al,forbidden1
	mov bh,0
	mov cx,1
	mov bl,55h
	int 10h
	NormalPopa
	ret
UpdatePlayer1ForbiddenChar	endp
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
UpdatePlayer2ForbiddenChar proc
	NormalPusha
	ChangePosition 37,17
	mov ah,9
	mov al,forbidden2
	mov bh,0
	mov cx,1
	mov bl,55h
	int 10h
	NormalPopa
	ret
UpdatePlayer2ForbiddenChar endp

updateUsername1 proc 
	NormalPusha
	ChangePosition 3,20
	mov ah,9
	mov dx,offset P1Name+2
	int 21h
	NormalPopa
	ret
updateUsername1 endp

updateUsername2 proc 
	NormalPusha
	ChangePosition 21,20
	mov ah,9
	mov dx,offset P2Name+2
	int 21h
	NormalPopa
	ret
updateUsername2 endp
DrawOurBall proc near
push ax
push bx
push cx
push dx
pushf
   mov cx,BallX
   mov dx,BallY 
   DrawingHorizontalBall:  
                         mov ah,0ch
                         mov al,5h
                         mov bh,00h
                         int 10h


                         inc cx
                         mov ax,cx
                         sub ax,BallX
                         cmp ax,OurBallSize
                         jng DrawingHorizontalBall


                         mov cx,BallX
                         inc dx


                         mov ax,dx
                         sub ax,BallY
                         cmp ax,OurBallSize
                         jng DrawingHorizontalBall
popf
pop dx
pop cx
pop bx
pop ax                      
 ret
DrawOurBall endp


DrawOurBall2 proc near
push ax
push bx
push cx
push dx
pushf
   mov cx,BallX2
   mov dx,BallY2
   DrawingHorizontalBall2:  
                         mov ah,0ch
                         mov al,5h
                         mov bh,00h
                         int 10h


                         inc cx
                         mov ax,cx
                         sub ax,BallX2
                         cmp ax,OurBallSize2
                         jng DrawingHorizontalBall2


                         mov cx,BallX2
                         inc dx


                         mov ax,dx
                         sub ax,BallY2
                         cmp ax,OurBallSize2
                         jng DrawingHorizontalBall2
popf
pop dx
pop cx
pop bx
pop ax                      
 ret
DrawOurBall2 endp

DrawOurShooter proc far
push ax
push bx
push cx
push dx
pushf
   mov cx,ShooterFirstX
   mov dx,ShooterFirstY

   mov si,ShooterFirstX
   add si,ShooterWidth

   mov di,ShooterFirstY
   add di,ShooterHeight 
   DrawingHorizontalShooter:  
                         mov ah,0ch
                         mov al,3
                         mov bh,00h
                         int 10h


                         inc cx
                         mov ax,cx
                         cmp ax,si
                         jng DrawingHorizontalShooter
                    

                         mov cx,ShooterFirstX
                         inc dx


                         mov ax,dx
                         cmp ax,di
                         jng DrawingHorizontalShooter                                      
popf
pop dx
pop cx
pop bx
pop ax                      
ret
 DrawOurShooter endp

 DrawOurSecondShooter proc far
push ax
push bx
push cx
push dx
pushf
   mov cx,Shooter2FirstX
   mov dx,Shooter2FirstY

   mov si,Shooter2FirstX
   add si,ShooterWidth

   mov di,Shooter2FirstY
   add di,ShooterHeight 
   DrawingHorizontalShooter2:  
                         mov ah,0ch
                         mov al,3
                         mov bh,00h
                         int 10h


                         inc cx
                         mov ax,cx
                         cmp ax,si
                         jng DrawingHorizontalShooter2
                    

                         mov cx,Shooter2FirstX
                         inc dx


                         mov ax,dx
                         cmp ax,di
                         jng DrawingHorizontalShooter2                                    
popf
pop dx
pop cx
pop bx
pop ax                      
ret
 DrawOurSecondShooter endp

 DrawOurTarget proc far
push ax
push bx
push cx
push dx
pushf
mov al,EnemyRandomNumber
inc al
                    mov cx,initialSquare_X
	             	mov dx,initialSquare_Y
		        	mov ah,0ch 
                    mov bx,initialSquare_X
                    add bx,6  
                    mov FinalSquare_X,bx
                   ;DrawFullSquare
                                      DrawAboveHorizontalLine:int 10H
                                                              inc cx
                                                              cmp cx,bx
                                                              jnz DrawAboveHorizontalLine
                                         mov cx,initialSquare_X
                                         mov dx,initialSquare_Y
                                         add dx,2               
                                       DrawLowerHorizontalLine:int 10H
                                                               inc cx
                                                               cmp cx,bx
                                                               jnz DrawLowerHorizontalLine
                                         mov cx,bx
                                         mov dx,initialSquare_Y 
                                         mov bx,initialSquare_Y
                                         add bx,5
                                         mov FinalSquare_Y,bx
                                         DrawLeftVerticalLine:int 10H
                                                              inc DX
                                                              cmp dx,bx
                                                              jnz DrawLeftVerticalLine
                                          mov cx,initialSquare_X
                                          mov dx,initialSquare_Y
                                          DrawRightVerticalLine:int 10H
                                                                inc DX
                                                                cmp dx,bx
                                                                jnz DrawRightVerticalLine                                                            


popf
pop dx
pop cx
pop bx
pop ax                      
ret
 DrawOurTarget endp

  DrawSecondTarget proc far
push ax
push bx
push cx
push dx
pushf
mov al,EnemyRandomNumber
inc al
                    mov cx,initialSquare_X2
	             	mov dx,initialSquare_Y2
		        	mov ah,0ch 
                    mov bx,initialSquare_X2
                    add bx,6  
                    mov FinalSquare_X2,bx
                   ;DrawFullSquare
                                      DrawAboveHorizontalLine2:int 10H
                                                              inc cx
                                                              cmp cx,bx
                                                              jnz DrawAboveHorizontalLine2
                                         mov cx,initialSquare_X2
                                         mov dx,initialSquare_Y2
                                         add dx,2               
                                       DrawLowerHorizontalLine2:int 10H
                                                               inc cx
                                                               cmp cx,bx
                                                               jnz DrawLowerHorizontalLine2
                                         mov cx,bx
                                         mov dx,initialSquare_Y2 
                                         mov bx,initialSquare_Y2
                                         add bx,5
                                         mov FinalSquare_Y2,bx
                                         DrawLeftVerticalLine2:int 10H
                                                              inc DX
                                                              cmp dx,bx
                                                              jnz DrawLeftVerticalLine2
                                          mov cx,initialSquare_X2
                                          mov dx,initialSquare_Y2
                                          DrawRightVerticalLine2:int 10H
                                                                inc DX
                                                                cmp dx,bx
                                                                jnz DrawRightVerticalLine2                                                            


popf
pop dx
pop cx
pop bx
pop ax                      
ret
 DrawSecondTarget endp

ClearGamingScreen proc near
push ax
push bx
push cx
push dx
push si
push di
pushf
            mov cx,60
	     	mov dx,25
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns:
		                         drawhorizontalline:int 10h
								                    inc cx
													cmp cx,124
													jnz drawhorizontalline
                                 mov cx,60
								 inc dx
								 cmp dx,99
								 jnz drawmainscreencolumns
            mov cx,60
	     	mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns3:
		                         drawhorizontalline3:int 10h
								                    inc cx
													cmp cx,124
													jnz drawhorizontalline3
                                 mov cx,60
								 inc dx
								 cmp dx,20
								 jnz drawmainscreencolumns3

popf
pop di
pop si
pop dx
pop cx
pop bx
pop ax                      
 ret
ClearGamingScreen endp

ClearGamingScreen2 proc near
push ax
push bx
push cx
push dx
pushf
      mov cx,190
	    mov dx,25
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolum:
		                         drawhorizontallineInShooterTwo:int 10h
								                    inc cx
													cmp cx,258
													jnz drawhorizontallineInShooterTwo
                mov cx,190
								 inc dx
								 cmp dx,100
								 jnz drawmainscreencolum
            mov cx,190
	        mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumnsForShooterTwo99992:
		                         drawhorizontallineInShooterTwo2:int 10h
								                    inc cx
													cmp cx,258
													jnz drawhorizontallineInShooterTwo2
                                 mov cx,190
								 inc dx
								 cmp dx,20
								 jnz drawmainscreencolumnsForShooterTwo99992

popf
pop dx
pop cx
pop bx
pop ax                      
 ret
ClearGamingScreen2 endp

ClearShooterArea proc near
push ax
push bx
push cx
push dx
pushf
            mov cx,60
	     	mov dx,100
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns2:
		                         drawhorizontalline2:int 10h
								                    inc cx
													cmp cx,124
													jnz drawhorizontalline2
                                 mov cx,60
								 inc dx
								 cmp dx,110
								 jnz drawmainscreencolumns2

popf
pop dx
pop cx
pop bx
pop ax                      
 ret
ClearShooterArea endp

ClearShooterArea2 proc near
push ax
push bx
push cx
push dx
pushf
            mov cx,189
	     	mov dx,100
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns22:
		                         drawhorizontalline22:int 10h
								                    inc cx
													cmp cx,259
													jnz drawhorizontalline22
                                 mov cx,189
								 inc dx
								 cmp dx,110
								 jnz drawmainscreencolumns22

popf
pop dx
pop cx
pop bx
pop ax                      
 ret
ClearShooterArea2 endp

ClearFullGameArea proc near
push ax
push bx
push cx
push dx
pushf
      mov cx,189
	    mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns222:
		                         drawhorizontalline222:int 10h
								                    inc cx
													cmp cx,258
													jnz drawhorizontalline222
                                 mov cx,189
								 inc dx
								 cmp dx,100
								 jnz drawmainscreencolumns222

	mov cx,60
	mov dx,0
	mov al,0
	mov ah,0ch
	        D:
			        De:int 10H
					   inc cx
					   cmp cx,124
					   jnz De
				mov cx,60
				inc DX
				cmp dx,100
				jnz D	   							 

popf
pop dx
pop cx
pop bx
pop ax                      
 ret
ClearFullGameArea endp

ClearTargetArea proc near
push ax
push bx
push cx
push dx
pushf
            mov cx,60
	     	mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns223:
		                         drawhorizontalline223:int 10h
								                    inc cx
													cmp cx,124
													jnz drawhorizontalline223
                                 mov cx,60
								 inc dx
								 cmp dx,29
								 jnz drawmainscreencolumns223

popf
pop dx
pop cx
pop bx
pop ax                      
 ret
ClearTargetArea endp

ClearTargetArea2 proc near
push ax
push bx
push cx
push dx
pushf
      mov cx,189
	    mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns2233:
		                         drawhorizontalline2233:int 10h
								                    inc cx
													cmp cx,258
													jnz drawhorizontalline2233
                  mov cx,189
								 inc dx
								 cmp dx,29
								 jnz drawmainscreencolumns2233

popf
pop dx
pop cx
pop bx
pop ax                      
 ret
ClearTargetArea2 endp

clearPlayer1Area proc far
push ax
push bx
push cx
push dx
pushf
 CleaingWholeArea:
            mov cx,0
			mov dx,174
			mov al,0
			mov ah,0ch 
			ClearingRows:int 10H 
			             inc cx
						 cmp cx,155
						 jnz ClearingRows
					mov cx,0
					inc DX
					cmp dx ,183
					jnz CleaingWholeArea	 
popf
pop dx
pop cx
pop bx
pop ax                      
ret
clearPlayer1Area endp

clearPlayer2Area proc far
push ax
push bx
push cx
push dx
pushf
 CleaingWholeArea2:
            mov cx,160
			mov dx,174
			mov al,0
			mov ah,0ch 
			ClearingRows2:int 10H 
			             inc cx
						 cmp cx,320
						 jnz ClearingRows2
					mov cx,160
					inc DX
					cmp dx ,183
					jnz CleaingWholeArea2	 
popf
pop dx
pop cx
pop bx
pop ax                      
ret
clearPlayer2Area endp

recieve proc
mov dx , 3FDH ; Line Status Register
in al , dx 
AND al , 1

JZ temp_it_wont_move
mov dx , 03F8H
in al , dx 
mov RECEIVED_CHAR , al
;DisplayChar VALUE
    cmp RECEIVED_CHAR,04DH
	jne we_didnt_recieve_right_arrow
	mov si,Shooter2FirstX
    add si,ShooterWidth
    cmp si,256
	jae temp_it_wont_move
	add Shooter2FirstX,2
    call ClearShooterArea2
    call DrawOurSecondShooter
	jmp temp_it_wont_move

    we_didnt_recieve_right_arrow:
	cmp RECEIVED_CHAR,04Bh
	jne we_didnt_recieve_left_arrow
	mov si,Shooter2FirstX
    sub si,2
    cmp si,190
    jbe temp_it_wont_move
	sub Shooter2FirstX,2
    call ClearShooterArea2
    call DrawOurSecondShooter
	temp_it_wont_move:jmp MyEND

	we_didnt_recieve_left_arrow:
	cmp RECEIVED_CHAR,48h
	jne MyEND
	mov ax,Shooter2FirstX
    add ax,4
    mov BallX2,ax
    mov ax,100
    mov BallY2,ax
			    Check_On_Recieved_Actions:
                            mov si,BallX2
                            mov di,BallY2
                            cmp si,initialSquare_X2
                            jae checkOnFinalXShooter2
                            jmp ContinShooting2
                            


                            checkOnFinalXShooter2:
						            cmp si,FinalSquare_X2
                                    jbe checkOnInitialYShooter2
                                    jmp ContinShooting2

                            checkOnInitialYShooter2:
							        cmp di,initialSquare_Y2
                                    jae CheckOnFinalYShooter2 
                                    jmp ContinShooting2

                            CheckOnFinalYShooter2:
							        cmp di,FinalSquare_Y2
                                    jbe ItTochedit2   
                                    jmp ContinShooting2                     

                            ItTochedit2: 
							        inc P2Points
									mov al,EnemyRandomNumber
									mov ah,0
									add P1Points,ax
                                    call ClearFullGameArea
									mov SmallGameCounter,0
									mov Nu3mnIndicator,1
                                    ret

                            ContinShooting2:
							        call ClearGamingScreen2
                                    mov ah,02ch
                                    int 21h
                                    cmp dl,OurTimeAux;is the current time equal to the previous one(OurTimeAux)?
                                    je Check_On_Recieved_Actions ;if it's the same then check again
                                         ;if it's different,then draw,move,etc
                                    mov OurTimeAux,dl
                                    mov bx,Our_Ball_Velocity_In_Y
                                    sub BallY2,bx
                                    cmp BallY2,0
                                    jz MyEND
                                    call DrawOurBall2
                                    jmp Check_On_Recieved_Actions


MyEND:
ret
recieve endp

send proc
mov dx , 3FDH ; Line Status Register
In al , dx ;Read Line Status
AND al , 00100000b
JZ AGAIN
mov dx , 3F8H ; Transmit data register
mov al,CHAR_TO_SEND
out dx , al
AGAIN:
ret 
send endp  

OurSmallGame proc far
       call DrawOurTarget
       call DrawSecondTarget
	   ;call RandomNumber5



       FullMovement: 
                                          ContinuePlaying:mov ah,02ch
                                          int 21h
                                          cmp dl,OurTimeAux;is the current time equal to the previous one(OurTimeAux)?
                                          je FullMovement ;if it's the same then check again
                                         ;if it's different,then draw,move,etc
                                         mov OurTimeAux,dl
                                         mov bx,Squarevelocity
                                         add initialSquare_X,bx
                                         cmp initialSquare_X,118
                                         jz RestartAgain
                                         add initialSquare_X2,bx
                                         cmp initialSquare_X2,248
                                         jz RestartAgain
                                         jmp JustDraw
                                         RestartAgain:mov ax,60
                                         mov initialSquare_X,ax
                                         mov initialSquare_X2,190
										 inc SmallGameCounter
										 cmp SmallGameCounter,8
										 jnz JustDraw
										 call ClearTargetArea
										 call ClearTargetArea2
										 mov SmallGameCounter,0
										 ret
                                         JustDraw:call ClearTargetArea
                                         call DrawOurTarget
                                         call ClearTargetArea2
                                         call DrawSecondTarget
  Check: ;mov ah,1
                         ;int 16h
                            ;jz FullMovement
                        mov ah,1
                        int 16h
						jz CheckRecieving1

                       cmp ah,04BH
                       jne not_a
					   mov CHAR_TO_SEND,04BH
					   call send
                       mov si,ShooterFirstX
                       sub si,2
                       cmp si,60
                       je jmpBuffer
                       sub ShooterFirstX,2
                       call ClearShooterArea
                       call DrawOurShooter
                       jmp clearbuffer

                       not_a:
                             cmp ah,04Dh
                             jne not_d
							 mov CHAR_TO_SEND,04DH
					         call send
                             mov si,ShooterFirstX
                              add si,ShooterWidth
                              cmp si,122
                              jae jmpBuffer
                             add ShooterFirstX,2
                             call ClearShooterArea
                             call DrawOurShooter
                             jmp clearbuffer
							 CheckRecieving1:jmp rerere
                             
                        not_d:
                        cmp ah,48h
                        je shoot
						
                        call ClearShooterArea
                        call DrawOurShooter
                        jmpBuffer:jmp clearbuffer 
                        shoot:
						            mov ah,48h
						            mov CHAR_TO_SEND,ah
					                call send
                                   mov ax,ShooterFirstX
                                   add ax,4
                                   mov BallX,ax
                                   mov ax,100
                                   mov BallY,ax
                               CheckTime:
                                          ;check if x is in range
                                          mov si,BallX
                                          mov di,BallY
                                          cmp si,initialSquare_X
                                          jae checkOnFinalX
                                          jmp ContinShooting

                                          checkOnFinalX: cmp si,FinalSquare_X
                                                         jbe checkOnInitialY
                                                         jmp ContinShooting

                                           checkOnInitialY:cmp di,initialSquare_Y
                                                        jae CheckOnFinalY  
                                                        jmp ContinShooting

                                           CheckOnFinalY:cmp di,FinalSquare_Y
                                                         jbe ItTochedit   
                                                         jmp ContinShooting                      

                                            ItTochedit: inc P1Points
											             mov al,EnemyRandomNumber
														 mov ah,0
														 add P1Points,ax
                                                        call ClearFullGameArea
                                                        jmp  WeDidIt
                                              ;mov si,BallX
                                              ;add si,OurBallSize
                                              ;cmp si,initialSquare_X
                                              ;jae checkOnFinalX2
                                              ;jmp ContinShooting

                                             ;checkOnFinalX2: cmp si,FinalSquare_X
                                              ;           jbe checkOnInitialY2
                                              ;           jmp ContinShooting
                                       ;      checkOnInitialY2:cmp di,initialSquare_Y
                                        ;                jae CheckOnFinalY2
                                         ;               jmp ContinShooting
;
 ;                                             CheckOnFinalY2:cmp di,FinalSquare_Y
  ;                                                       jbe ItTochedit24  
   ;                                                      jmp ContinShooting                      
;
 ;                                             ItTochedit24: inc P1Points
  ;                                                        call ClearFullGameArea
   ;                                                       jmp  WeDidIt              
                                          ContinShooting:call ClearGamingScreen
                                          mov ah,02ch
                                          int 21h
                                          cmp dl,OurTimeAux;is the current time equal to the previous one(OurTimeAux)?
                                          je ContinShooting ;if it's the same then check again
                                         ;if it's different,then draw,move,etc
                                         mov OurTimeAux,dl
                                         mov bx,Our_Ball_Velocity_In_Y
                                         sub BallY,bx
                                         cmp BallY,0
                                         jz clearbuffer
                                         call DrawOurBall
                                         jmp CheckTime
                        WeDidIt:mov ah,07
                                int 21h
								mov SmallGameCounter,0
								call ClearFullGameArea
                                jmp khallasss
 
                         clearbuffer:mov ah,07
                                    int 21h

                        rerere:call recieve
						cmp Nu3mnIndicator,1
						jnz tata
						mov Nu3mnIndicator,0
						ret
                        tata: jmp FullMovement

	khallasss:
	call ClearFullGameArea
	ret					

OurSmallGame endp

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------
DrawingFullMainScreen PROC FAR
		   mov ax, @data
		   mov DS, ax
		   mov ah,0h
		   mov al,13h
		   int 10h
            mov cx,0
	     	mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns12:
		                         drawhorizontalline12:int 10h
								                    inc cx
													cmp cx,160
													jnz drawhorizontalline12
                                 mov cx,0
								 inc dx
								 cmp dx,170
								 jnz drawmainscreencolumns12
			mov cx,160
	     	mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing second player screen background
		   drawmainscreencolumnss:
		                         drawhorizontallinee:int 10h
								                    inc cx
													cmp cx,320
													jnz drawhorizontallinee
                                 mov cx,160
								 inc dx
								 cmp dx,170
								 jnz drawmainscreencolumnss	
			mov cx,0
			mov dx,186
			mov al,0
			mov ah,0ch
			drawChattingAre:
			                DrawHH:int 10h
							       inc cx 
								   cmp cx,320
								   jnz DrawHH
							mov cx,0
							inc dx
							cmp dx,200
							jnz drawChattingAre	   					 				 
			mov cx,162
			mov dx,0
			mov al,9
			mov ah,0ch
			;drawing borders of the screen
			            ;draw most left border
					    DrawFirstVLine:int 10h
						               inc dx
									   cmp dx,137
									   jnz DrawFirstVLine
						;draw memory left border			   
			mov cx,124
			mov dx,0
			           DrawForthV:int 10h
					              inc dx
								  cmp dx,136
								  jnz DrawForthV
						;draw memory right border		  	
		    mov cx,148
			mov dx,137
			           DrawMemoryPlayer1Border:int 10H
					                            inc dx
												cmp dx,173
												jnz DrawMemoryPlayer1Border
			mov cx,162
			mov dx,137
			           DrawMemoryPlayer2Border2:int 10H
					                            inc dx
												cmp dx,173
												jnz DrawMemoryPlayer2Border2							   				  					   
            mov cx,0
			mov dx,0
			           DrawFirstH:int 10h
					              inc cx
								  cmp cx,320
								  jnz DrawFirstH
			mov cx,124
			mov dx,136
			           DrawFirstH22:int 10h
					              inc cx
								  cmp cx,149
								  jnz DrawFirstH22
			;drawing username1 border horizontal
			mov cx,20
			mov dx,155
					    DrawHorizontalUsername:int 10H
						                    inc cx
											cmp cx,148
											jnz DrawHorizontalUsername
			mov cx,20
			mov dx,155
			            DrawVerticalUsername:int 10H
						                     inc DX
											 cmp dx,173
											 jnz DrawVerticalUsername								
	
			;drawing username2 border horizontal
			mov cx,162
			mov dx,155
			            DrawHorizontalUsername2:int 10H
						                        inc cx
												cmp cx , 300
												jnz DrawHorizontalUsername2	
			mov cx,300
			mov dx,155
			            DrawVertical2Username:int 10H 
						                      inc DX
											  cmp dx,173
											  jnz DrawVertical2Username

																					

			mov cx,162
			mov dx,137
			           DrawFirstH223:int 10h
					              inc cx
								  cmp cx,188
								  jnz DrawFirstH223				  	

			mov cx,188
			mov dx,0
			           DrawMemoryPlayer2Border:int 10H
					                           inc dx
											   cmp dx,138
											   jnz DrawMemoryPlayer2Border

			mov cx,150
			mov dx,172
			           DrawMan:int 10H 
					            inc cx	
								cmp cx,320
								jnz DrawMan				  
				;draw most bottom border		  
                        ;draw current command border
			mov cx,0
			mov dx,172
			         DrawThirdH:int 10h
					            inc cx
								cmp cx,155
								jnz DrawThirdH
						;draw chat  horizontal border		
			mov cx,0
			mov dx,185
			         DrawForthH:int 10h
					            inc cx
								cmp cx,320
								jnz DrawForthH
						;draw memory horizontal borders		
						;complate last horizontal border
			mov al,9			
			mov cx,124
			mov dx,185
			drawSimpleOne:int 10h
			            inc cx
						cmp cx,144
						jnz drawSimpleOne

			mov cx,148
			mov dx,0	
			            DrawFifthV:int 10h
						           inc dx
								   cmp dx,140
								   jnz DrawFifthV 			
            mov cx,18
			mov dx,6
                       ;drawing the rectangels
			drawingSquares:mov si,cx
						   mov di,dx
						   mov bx,dx
						   add bx,11
						             
						            drawingfirstLine:int 10h
									                 inc cx
													 cmp cx,59
													 jnz drawingfirstLine
									mov cx,si
									mov dx,di
									add dx,10
									drawingSecondLine:int 10h
									                  inc cx
													  cmp cx,59
													  jnz drawingSecondLine
									mov cx,si
									mov dx,di	
									drawingThirdLine:int 10h
									                  inc dx
													  cmp dx,bx
													  jnz drawingThirdLine
									mov cx,59
									mov dx,di
									drawingForthLine:int 10h
									                  inc dx
													  cmp dx,bx
													  jnz drawingForthLine
							mov cx,si
							mov dx,di
							add dx,16
							cmp dx,134
							jnz drawingSquares

				  mov cx,68
				  mov dx,141			
	            drawingUser1Powerups:mov si,cx
				                     mov di,dx
									 mov bx,cx
									 add bx,13
									DrawingFirstHoriz:int 10h
									                 inc cx
													 cmp cx,bx
													 jnz DrawingFirstHoriz
									mov cx,si
									mov dx,di
									add dx,11
									DrawingSecondHoriz:int 10h
									                 inc cx
													 cmp cx,bx
													 jnz DrawingSecondHoriz
									mov cx,si
									mov dx,di
									DrawingFirstVert:int 10H
									                 inc dx
													 cmp dx,152
													 jnz DrawingFirstVert
									mov cx,si
									mov dx,di
									add cx,12
									DrawingSecondVert:int 10H
									                 inc dx
													 cmp dx,152
													 jnz DrawingSecondVert
									mov cx,si
									mov dx,di
									add cx,16
									cmp cx,132
									jnz drawingUser1Powerups

                cmp levelIndicator,1
				jnz DontDrawOne
                mov cx,3
				mov dx,131
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne2:int 10h
	    		             inc cx
							cmp cx,16
							jnz drawingOne2
				mov cx,si
				add cx,19
				drawingtwo2: int 10h
							inc cx
							cmp cx,36
							jnz drawingtwo2
				mov cx,3
				mov dx,131
				drawing2:int 10h
				        inc cx
				        inc dx
						cmp dx,147
						jnz drawing2

				mov cx,35
				mov dx,131
				drawingtwooo2:int 10h
				             dec cx
							 inc dx
							 cmp dx,148
							 jnz drawingtwooo2	

                mov cx,16
				mov dx,131
				drawingThree2:int 10h
				             inc cx
							 inc dx
							 cmp dx,134
							 jnz drawingThree2
				mov cx,22
				mov dx,131
				drawingFour2:int 10h
				             dec cx
							 inc dx
							 cmp dx,134
							 jnz drawingFour2

				mov cx,18
				mov dx,133
				drawingH22:int 10h
				          inc cx
						  cmp cx,21
						  jnz drawingH22	

						  mov char1,'C'
						  call UpdatePlayer1ForbiddenChar
				DontDrawOne:		  
                mov cx,259
			    mov dx,6
				

						  drawingSquares2:mov si,cx
						   mov di,dx
						   mov bx,dx
						   add bx,11
						             
						            drawingfirstLine2:int 10h
									                 inc cx
													 cmp cx,298
													 jnz drawingfirstLine2
									mov cx,si
									mov dx,di
									add dx,10
									drawingSecondLine2:int 10h
									                  inc cx
													  cmp cx,298
													  jnz drawingSecondLine2
									mov cx,si
									mov dx,di	
									drawingThirdLine2:int 10h
									                  inc dx
													  cmp dx,bx
													  jnz drawingThirdLine2
									mov cx,298
									mov dx,di
									drawingForthLine2:int 10h
									                  inc dx
													  cmp dx,bx
													  jnz drawingForthLine2

							mov cx,si
							mov dx,di
							add dx,16
							cmp dx,134
							jnz drawingSquares2



                cmp levelIndicator,1
				jnz DontDrawTwo
				mov cx,283
				mov dx,131
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne:int 10h
	    		             inc cx
							cmp cx,296
							jnz drawingOne
				mov cx,si
				add cx,19
				drawingtwo: int 10h
							inc cx
							cmp cx,315
							jnz drawingtwo
				mov cx,283
				mov dx,131
				drawing:int 10h
				        inc cx
				        inc dx
						cmp dx,147
						jnz drawing

				mov cx,315
				mov dx,131
				drawingtwooo:int 10h
				             dec cx
							 inc dx
							 cmp dx,148
							 jnz drawingtwooo	

                mov cx,296
				mov dx,131
				drawingThree:int 10h
				             inc cx
							 inc dx
							 cmp dx,134
							 jnz drawingThree
				mov cx,302
				mov dx,131
				drawingFour:int 10h
				             dec cx
							 inc dx
							 cmp dx,134
							 jnz drawingFour

				mov cx,299
				mov dx,133
				drawingH2:int 10h
				          inc cx
						  cmp cx,301
						  jnz drawingH2
				mov char1,'M'
				call UpdatePlayer2ForbiddenChar	
	  
	DontDrawTwo:		  
    ChangePosition 0,1
	ColoredChar "A",55h
	ChangePosition 1,1
	ColoredChar "X",55h

	ChangePosition 0,3
	ColoredChar "B",55h
	ChangePosition 1,3
	ColoredChar "X",55h

	ChangePosition 0,5
	ColoredChar "C",55h
	ChangePosition 1,5
	ColoredChar "X",55h

	ChangePosition 0,7
	ColoredChar "D",55h
	ChangePosition 1,7
	ColoredChar "X",55h

	ChangePosition 0,9
	ColoredChar "S",55h
	ChangePosition 1,9
	ColoredChar "I",55h

	ChangePosition 0,11
	ColoredChar "D",55h
	ChangePosition 1,11
	ColoredChar "I",55h

	ChangePosition 0,13
	ColoredChar "S",55h
	ChangePosition 1,13
	ColoredChar "P",55h

	ChangePosition 0,15
	ColoredChar "B",55h
	ChangePosition 1,15
	ColoredChar "P",55h

	 ChangePosition 38,1
	ColoredChar "A",55h
	ChangePosition 39,1
	ColoredChar "X",55h

	ChangePosition 38,3
	ColoredChar "B",55h
	ChangePosition 39,3
	ColoredChar "X",55h

	ChangePosition 38,5
	ColoredChar "C",55h
	ChangePosition 39,5
	ColoredChar "X",55h

	ChangePosition 38,7
	ColoredChar "D",55h
	ChangePosition 39,7
	ColoredChar "X",55h

	ChangePosition 38,9
	ColoredChar "S",55h
	ChangePosition 39,9
	ColoredChar "I",55h

	ChangePosition 38,11
	ColoredChar "D",55h
	ChangePosition 39,11
	ColoredChar "I",55h

	ChangePosition 38,13
	ColoredChar "S",55h
	ChangePosition 39,13
	ColoredChar "P",55h

	ChangePosition 38,15
	ColoredChar "B",55h
	ChangePosition 39,15
	ColoredChar "P",55h
         
            ChangePosition 19,1
	        ColoredChar '0',55h

			ChangePosition 19,2
	        ColoredChar '1',55h

			ChangePosition 19,3
	        ColoredChar '2',55h

			ChangePosition 19,4
	        ColoredChar '3',55h

			ChangePosition 19,5
	        ColoredChar '4',55h

			ChangePosition 19,6
	        ColoredChar '5',55h

			ChangePosition 19,7
	        ColoredChar '6',55h

			ChangePosition 19,8
	        ColoredChar '7',55h

			ChangePosition 19,9
	        ColoredChar '8',55h

			ChangePosition 19,10
	        ColoredChar '9',55h

			ChangePosition 19,11
	        ColoredChar 'A',55h

			ChangePosition 19,12
	        ColoredChar 'B',55h

			ChangePosition 19,13
	        ColoredChar 'C',55h

			ChangePosition 19,14
	        ColoredChar 'D',55h

			ChangePosition 19,15
			ColoredChar 'E',55h

			ChangePosition 19,16
			ColoredChar 'F',55h


			call intitialization

		; mov al,'2'
		; mov char1,al
		; mov al,'F'
		; mov char2,al
		; call UpdatePlayer1Points
		; mov al,'7'
		; mov char2,al
		; call UpdatePlayer2Points
		

			; ChangePosition 8,20
			; ColoredChar 'N',55h
			; ChangePosition 9,20
			; ColoredChar 'U',55h
			; ChangePosition 10,20
			; ColoredChar '3',55h

			; ChangePosition 22,20
			; ColoredChar 'Z',55h
			; ChangePosition 23,20
			; ColoredChar 'U',55h
			; ChangePosition 24,20
			; ColoredChar 'Z',55h
			call updateUsername1
			call updateUsername2
			
			 call DrawOurShooter
             call DrawOurSecondShooter

	ret
	DrawingFullMainScreen ENDP

loop_on_4_chars proc
	mov si, 0
	hex_char_points:
		call ChangePos
		mov al, Hex_To_Display[si]
		call ColorChar
		inc x
		inc si
		cmp si, 4
	jnz hex_char_points
	ret
loop_on_4_chars endp


Update_Points proc
    mov di, offset Hex_To_Display
	mov Y, 12
	mov X, 10
	mov ax, P1Points
	call To_Hex_16bit
	call loop_on_4_chars
    mov di, offset Hex_To_Display
	mov ax, P2Points
	mov X, 26
	call To_Hex_16bit
	call loop_on_4_chars
	ret
Update_Points endp

Clear_Cmd_Area proc far
	push ax
	push bx
	push cx
	push dx
	pushf
	CleaingWholeAreazzz:
				mov cx,0
				mov dx,174
				mov al,0
				mov ah,0ch 
				ClearingRows3:int 10H 
							inc cx
							cmp cx,320
							jnz ClearingRows3
						mov cx,0
						inc DX
						cmp dx ,185
						jnz ClearingRows3	 
	popf
	pop dx
	pop cx
	pop bx
	pop ax                      
	ret
Clear_Cmd_Area endp
DrawTurnSquare proc far
	push ax
	push bx
	push cx
	push dx
	pushf
           cmp turn,1
		   jz drawTurnSquareForPlayer2

		   mov cx,4
		   mov dx,150
		   mov ah,0ch
		   mov al,2h
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare: mov ah,0ch
                                                 mov al,5h
												 mov bh,00h
												 int 10h
		                                         inc cx
												 cmp cx,8
												 jnz DrawHorizontalTurnSquare
						mov cx,4
						inc DX
						cmp dx,154
						jnz DrawHorizontalTurnSquare
           mov cx,312
		   mov dx,150
		   mov ah,0ch
		   mov al,00h
		   mov bh,00h
		   int 10h
		                DrawHorizontalTurnSquare4:
												 int 10h
		                                         inc cx
												 cmp cx,316
												 jnz DrawHorizontalTurnSquare4
						mov cx,312
						inc DX
						cmp dx,154
						jnz DrawHorizontalTurnSquare4


						jmp Drawend						 

		   drawTurnSquareForPlayer2:
		   mov cx,312
		   mov dx,150
		   mov ah,0ch
		   mov al,2h
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare2: mov ah,0ch
                                                 mov al,5h
												 mov bh,00h
												 int 10h
		                                         inc cx
												 cmp cx,316
												 jnz DrawHorizontalTurnSquare2
						mov cx,312
						inc DX
						cmp dx,154
						jnz DrawHorizontalTurnSquare2

		   mov cx,4
		   mov dx,150
		   mov ah,0ch
		   mov al,00h
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare5:
												 int 10h
		                                         inc cx
												 cmp cx,8
												 jnz DrawHorizontalTurnSquare5
						mov cx,4
						inc DX
						cmp dx,154
						jnz DrawHorizontalTurnSquare5			
	Drawend:							
	popf
	pop dx
	pop cx
	pop bx
	pop ax                      
	ret


DrawTurnSquare endp

DrawErrorSquare proc far
	push ax
	push bx
	push cx
	push dx
	pushf

           cmp turn,1
		   jz drawTurnSquareForPlayer223

		   mov cx,4
		   mov dx,166
		   mov ah,0ch
		   mov al,0ch
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare223:
												 int 10h
		                                         inc cx
												 cmp cx,8
												 jnz DrawHorizontalTurnSquare223
						mov cx,4
						inc DX
						cmp dx,170
						jnz DrawHorizontalTurnSquare223

		   mov cx,312
		   mov dx,166
		   mov ah,0ch
		   mov al,00h
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare22238:
												 int 10h
		                                         inc cx
												 cmp cx,316
												 jnz DrawHorizontalTurnSquare22238
						mov cx,312
						inc DX
						cmp dx,170
						jnz DrawHorizontalTurnSquare22238
						jmp Drawend23						 

		   drawTurnSquareForPlayer223:
		   mov cx,312
		   mov dx,166
		   mov ah,0ch
		   mov al,0ch
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare2223:
												 int 10h
		                                         inc cx
												 cmp cx,316
												 jnz DrawHorizontalTurnSquare2223
						mov cx,312
						inc DX
						cmp dx,170
						jnz DrawHorizontalTurnSquare2223

			mov cx,4
		   mov dx,166
		   mov ah,0ch
		   mov al,00h
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare2239:
												 int 10h
		                                         inc cx
												 cmp cx,8
												 jnz DrawHorizontalTurnSquare2239
						mov cx,4
						inc DX
						cmp dx,170
						jnz DrawHorizontalTurnSquare2239		
	Drawend23:							
	popf
	pop dx
	pop cx
	pop bx
	pop ax                      
	ret
DrawErrorSquare endp

DrawPowerUpSquare proc far
push ax
push bx
push cx
push dx
pushf
           cmp turn,1
		   jz drawTurnSquareForPlayer22

		   mov cx,4
		   mov dx,158
		   mov ah,0ch
		   mov al,0Bh
		   mov bh,00h
		               DrawHorizontalTurnSquare22:
												 int 10h
		                                         inc cx
												 cmp cx,8
												 jnz DrawHorizontalTurnSquare22
						mov cx,4
						inc DX
						cmp dx,162
						jnz DrawHorizontalTurnSquare22

		   mov cx,312
		   mov dx,158
		   mov ah,0ch
		   mov al,00h
		   mov bh,00h
		               DrawHorizontalTurnSquare2224:
												 int 10h
		                                         inc cx
												 cmp cx,316
												 jnz DrawHorizontalTurnSquare2224
						mov cx,312
						inc Dx
						cmp dx,162
						jnz DrawHorizontalTurnSquare2224
							jmp Drawend2				 

		   drawTurnSquareForPlayer22:
		   mov cx,312
		   mov dx,158
		   mov ah,0ch
		   mov al,0Bh
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare222:
												 int 10h
		                                         inc cx
												 cmp cx,316
												 jnz DrawHorizontalTurnSquare222
						mov cx,312
						inc DX
						cmp dx,162
						jnz DrawHorizontalTurnSquare222
							

			mov cx,4
		   mov dx,158
		   mov ah,0ch
		   mov al,00h
		   mov bh,00h
		   int 10h
		               DrawHorizontalTurnSquare227:
												 int 10h
		                                         inc cx
												 cmp cx,8
												 jnz DrawHorizontalTurnSquare227
						mov cx,4
						inc DX
						cmp dx,162
						jnz DrawHorizontalTurnSquare227			
Drawend2:							
popf
pop dx
pop cx
pop bx
pop ax                      
ret
DrawPowerUpSquare endp
DrawingPointsScreen PROC FAR
	NormalPusha
		   mov ah,0h
		   mov al,13h
		   int 10h

                mov cx,40
				mov dx,70
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne_pts:int 10h
	    		             inc cx
							cmp cx,80
							jnz drawingOne_pts
				mov cx,si
				add cx,70
				drawingtwo_pts: int 10h
							inc cx
							cmp cx,150
							jnz drawingtwo_pts
				mov cx,40
				mov dx,70
				drawing_pts:int 10h
				        inc cx
				        inc dx
						cmp dx,126
						jnz drawing_pts

				mov cx,150
				mov dx,70
				drawingtwooo_pts:int 10h
				             dec cx
							 inc dx
							 cmp dx,126
							 jnz drawingtwooo_pts	

                mov cx,80
				mov dx,70
				drawingThree_pts:int 10h
				             inc cx
							 inc dx
							 cmp dx,80
							 jnz drawingThree_pts
				mov cx,110
				mov dx,70
				drawingFour_pts:int 10h
				             dec cx
							 inc dx
							 cmp dx,80
							 jnz drawingFour_pts

				mov cx,90
				mov dx,80
				drawingH2_pts:int 10h
				          inc cx
						  cmp cx,101
						  jnz drawingH2_pts	

                mov cx,160
			    mov dx,0	
			            DrawFifthV_pts:int 10h
						           inc dx
								   cmp dx,200
								   jnz DrawFifthV_pts

                mov cx,170
				mov dx,70
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne2_pts:int 10h
	    		             inc cx
							cmp cx,210
							jnz drawingOne2_pts
				mov cx,si
				add cx,70
				drawingtwo2_pts: int 10h
							inc cx
							cmp cx,280
							jnz drawingtwo2_pts
				mov cx,170
				mov dx,70
				drawing2_pts:int 10h
				        inc cx
				        inc dx
						cmp dx,126
						jnz drawing2_pts

				mov cx,280
				mov dx,70
				drawingtwooo2_pts:int 10h
				             dec cx
							 inc dx
							 cmp dx,126
							 jnz drawingtwooo2_pts	

                mov cx,210
				mov dx,70
				drawingThree2_pts:int 10h
				             inc cx
							 inc dx
							 cmp dx,80
							 jnz drawingThree2_pts
				mov cx,240
				mov dx,70
				drawingFour2_pts:int 10h
				             dec cx
							 inc dx
							 cmp dx,80
							 jnz drawingFour2_pts

				mov cx,220
				mov dx,80
				drawingH22_pts:int 10h
				          inc cx
						  cmp cx,231
						  jnz drawingH22_pts  

						  call Update_Points

	mov ah,2
    mov dh,160
    mov dl,40
    mov bh,0
    int 10H

	cmp winning, 0
	jz no_winner
	cmp winning, 1
	jz ply_1_won
	mov dx,offset WinningMsg2
	jmp print_winner
	ply_1_won:
	mov dx,offset WinningMsg1

	print_winner:
    mov ah,9
    int 21H

	no_winner:

	NormalPopa
	ret
DrawingPointsScreen endp
;-----------------------------------------------------------------------


main proc far

main endp
end main