public DrawingFullMainScreen
public UpdateMemoryPlayer1
public UpdateMemoryPlayer2
public UpdateRegsPlayer1
public UpdateRegsPlayer2


.model HUGE
.Stack 200
.data 
playerOnePoints db ?
playerTwoPoints db ?
char1 db ?
char2 db ?
char3 db ?
char4 db ?
initialPoints db ?
PlayersIndentifier db ?
levelIndicator db 1

Username1 db 'Mohameddddddddd','$'
Username2 db 'Ayman','$'

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

ShooterFirstX dw 68
ShooterFirstY dw 100

Shooter2FirstX dw 204
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
turn db 0

YourPoints db 0
.CODE
NormalPushingall MACRO
	PUSH AX
	PUSH bx
	PUSH cx
	PUSH dx
	PUSH si
	PUSH DI
	PUSHF
ENDM

NormalPopingall MACRO
	POPF
	POP DI
	POP si
	POP DX
	POP cx
	POP bx
	POP AX
ENDM	
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
;---------------------------------------------------------------------------------Coloring Char-------------------------------------------------------------------------------
ColoredChar MACRO Mychar,color 
                    mov ah,9
                    mov al,mychar
                    mov bh,0
                    mov cx,1
                    mov bl,color
                    int 10h
ENDM ColoredChar					
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
;-----------------------------------------------------------------------------------Changing Position-----------------------------------------------------------------------------------
ChangePosition MACRO X,Y 

                    MOV Ah,2H
                    MOV Dl,X
                    MOV Dh,Y
                    INT 10H  
ENDM ChangePosition
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
;-----------------------------------------------------------------------------------Reading From Player-----------------------------------------------------------------------------------
;----------------------------------------------------------------//////////////////////////////////////////////////////////---------------------------------------------------
;----------------------------------------------------------------//////////////////////////////////////////////////////////---------------------------------------------------
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
UpdatePlayer1ForbiddenChar proc
NormalPushingall
      ChangePosition 2,17
	  mov ah,9
                    mov al,char1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
					NormalPopingall
					ret
UpdatePlayer1ForbiddenChar	endp
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
UpdatePlayer2ForbiddenChar proc
NormalPushingall
      ChangePosition 37,17
	  mov ah,9
                    mov al,CHAR1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
					NormalPopingall
					ret
UpdatePlayer2ForbiddenChar endp
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
updateUsername1 proc 
NormalPushingall
      ChangePosition 3,20
	  mov ah,9
	  mov dx,offset Username1
	  int 21h
NormalPopingall
ret
updateUsername1 endp

updateUsername2 proc 
NormalPushingall
      ChangePosition 21,20
	  mov ah,9
	  mov dx,offset Username2
	  int 21h
NormalPopingall
ret
updateUsername2 endp

UpdateRegsPlayer1 proc
push ax
push bx
push cx
push dx
push si
push di
pushf
	;---------------------------------------------------------------------------
	                MOV Ah,2H
                    MOV Dl,3
                    MOV Dh,PlayersIndentifier
					inc dh
                    INT 10H
	  mov ah,9
                    mov al,char1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h

	    MOV Ah,2H
                    MOV Dl,4
                    MOV Dh,PlayersIndentifier
					inc dh
                    INT 10H
	  mov ah,9
                    mov al,char2
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h

	  MOV Ah,2H
                    MOV Dl,5
                    MOV Dh,PlayersIndentifier
					inc dh
                    INT 10H
	  mov ah,9
                    mov al,char3
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
	   MOV Ah,2H
                    MOV Dl,6
                    MOV Dh,PlayersIndentifier
					inc dh
                    INT 10H
	  mov ah,9
                    mov al,char4
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
			
ENDFUNC:
popf
pop di
pop si
pop dx
pop cx
pop bx
pop ax																		
ret	       				
UpdateRegsPlayer1 endp
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
UpdateRegsPlayer2 proc

push ax
push bx
push cx
push dx
push si
push di
pushf
	;---------------------------------------------------------------------------
	                MOV Ah,2H
                    MOV Dl,33
                    MOV Dh,PlayersIndentifier
					inc dh
                    INT 10H
	                mov ah,9
                    mov al,char1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h

	                MOV Ah,2H
                    MOV Dl,34
                    MOV Dh,PlayersIndentifier
					inc dh
                    INT 10H
	                mov ah,9
                    mov al,char2
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h

	                MOV Ah,2H
                    MOV Dl,35
                    MOV Dh,PlayersIndentifier
					inc dh
                    INT 10H
	                mov ah,9
                    mov al,char3
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h

	                MOV Ah,2H
                    MOV Dl,36
                    MOV Dh,PlayersIndentifier
					inc dh
                    INT 10H
	                mov ah,9
                    mov al,char4
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
			
popf
pop di
pop si
pop dx
pop cx
pop bx
pop ax																		
ret	             				
UpdateRegsPlayer2 endp

UpdateMemoryPlayer1 proc
push ax
push bx
push cx
push dx
push si
push di
pushf           
                    MOV Ah,2H
                    MOV Dl,16
                    MOV Dh,PlayersIndentifier
					sub dh,23
                    INT 10H
	                mov ah,9
                    mov al,char1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h

	                MOV Ah,2H
                    MOV Dl,17
                    MOV Dh,PlayersIndentifier
					sub dh,23
                    INT 10H
	                mov ah,9
                    mov al,char2
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
popf
pop di
pop si
pop dx
pop cx
pop bx
pop ax																		
ret	
UpdateMemoryPlayer1 endp

UpdateMemoryPlayer2 proc
push ax
push bx
push cx
push dx
push si
push di
pushf           
                    MOV Ah,2H
                    MOV Dl,21
                    MOV Dh,PlayersIndentifier
					sub dh,23
                    INT 10H
	                mov ah,9
                    mov al,char1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h

	                MOV Ah,2H
                    MOV Dl,22
                    MOV Dh,PlayersIndentifier
					sub dh,23
                    INT 10H
	                mov ah,9
                    mov al,char2
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
popf
pop di
pop si
pop dx
pop cx
pop bx
pop ax																		
ret	
UpdateMemoryPlayer2 endp

PushAll MACRO
	                push ax
                    push bx
                    push cx
                    push dx
                    push si
                    push di
                    push bP
                    push sp
                    pushf
ENDM PushAll
PopAll MACRO
	                popf
                    pop sp
                    pop bP
                    pop di
                    pop si
                    pop DX
                    pop cx
                    pop bx
                    pop ax
ENDM PopAll									

PrintingZeros PROC FAR
push ax
push bx
push cx
push dx
pushf

        mov cx,si
		mov dx,di
		mov bx,si
		add bx,4
		inc cx
		mov al,3
		mov ah,0ch
		        drawHZero:int 10h
				          inc cx
						  cmp cx,bx
						  jnz drawHZero
		mov cx,si
		mov dx,di
		add dx,6
		inc cx				  
				drawHZerotwo:int 10h
				             inc cx
							 cmp cx,bx
							 jnz drawHZerotwo
		mov cx,si
		mov dx,di
		mov bx,di
		add bx,6
		inc dx
		       drawVZero:int 10h
			             inc dx
						 cmp dx,bx
						 jnz drawVZero
		mov cx,si
		add cx,4
		mov dx,di
		inc dx
		       drawVZerotwo:int 10h
			                inc dx
							cmp dx,bx
							jnz drawVZerotwo
popf
pop dx
pop cx
pop bx
pop ax
ret
PrintingZeros ENDP


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

                    mov cx,initialSquare_X
	             	mov dx,initialSquare_Y
		        	mov al,0ch
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

                    mov cx,initialSquare_X2
	             	mov dx,initialSquare_Y2
		        	mov al,0ch
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
		   drawmainscreencolumnsForShooterTwo:
		                         drawhorizontallineInShooterTwo:int 10h
								                    inc cx
													cmp cx,258
													jnz drawhorizontallineInShooterTwo
                mov cx,190
								 inc dx
								 cmp dx,100
								 jnz drawmainscreencolumnsForShooterTwo
            mov cx,190
	        mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumnsForShooterTwo2:
		                         drawhorizontallineInShooterTwo2:int 10h
								                    inc cx
													cmp cx,258
													jnz drawhorizontallineInShooterTwo2
                                 mov cx,190
								 inc dx
								 cmp dx,20
								 jnz drawmainscreencolumnsForShooterTwo2

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

OurSmallGame proc far
       call DrawOurTarget
       call DrawSecondTarget



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
                                         cmp initialSquare_X2,260
                                         jz RestartAgain
                                         jmp JustDraw
                                         RestartAgain:mov ax,60
                                         mov initialSquare_X,ax
                                         mov initialSquare_X2,190
										 inc SmallGameCounter
										 cmp SmallGameCounter,7
										 jnz JustDraw
										 call ClearTargetArea
										 call ClearTargetArea2
										 mov SmallGameCounter,0
										 ret
                                         JustDraw:call ClearTargetArea
                                         call DrawOurTarget
                                           call ClearTargetArea2
                                         call DrawSecondTarget
                                        





                     Check: mov ah,1
                            int 16h
                            jz FullMovement


                        cmp ah,04DH
                        jne not_Right_Arrow
                         mov si,Shooter2FirstX
                              add si,ShooterWidth
                              cmp si,256
                              jae jmpBuffer2
                             add Shooter2FirstX,2
                             call ClearShooterArea2
                             call DrawOurSecondShooter
                             jmp clearbuffer
                        

                       not_Right_Arrow:cmp ah,04Bh
                       jne not_left_arrow
                        mov si,Shooter2FirstX
                       sub si,2
                       cmp si,190
                       je jmpBuffer2
                       sub Shooter2FirstX,2
                       call ClearShooterArea2
                       call DrawOurSecondShooter
                      jmpBuffer2: jmp clearbuffer2


 
                       not_left_arrow:
                       cmp ah,48h
                       jne notSecondShooterBuff
                                   mov ax,Shooter2FirstX
                                   add ax,4
                                   mov BallX2,ax
                                   mov ax,100
                                   mov BallY2,ax
                               CheckTime2:
                                          mov si,BallX2
                                          mov di,BallY2
                                          cmp si,initialSquare_X2
                                          jae checkOnFinalXShooter2
                                          jmp ContinShooting2
                                          notSecondShooterBuff:jmp notSecondShooter
                                          checkOnFinalXShooter2: cmp si,FinalSquare_X2
                                                         jbe checkOnInitialYShooter2
                                                         jmp ContinShooting2

                                           checkOnInitialYShooter2:cmp di,initialSquare_Y2
                                                        jae CheckOnFinalYShooter2 
                                                        jmp ContinShooting2

                                           CheckOnFinalYShooter2:cmp di,FinalSquare_Y2
                                                         jbe ItTochedit2   
                                                         jmp ContinShooting2                     

                                            ItTochedit2: inc YourPoints
                                                         call ClearFullGameArea
														 mov SmallGameCounter,0
                                                         ret

                                          ContinShooting2:call ClearGamingScreen2
                                          mov ah,02ch
                                          int 21h
                                          cmp dl,OurTimeAux;is the current time equal to the previous one(OurTimeAux)?
                                          je CheckTime2 ;if it's the same then check again
                                         ;if it's different,then draw,move,etc
                                         mov OurTimeAux,dl
                                         mov bx,Our_Ball_Velocity_In_Y
                                         sub BallY2,bx
                                         cmp BallY2,0
                                         jz clearbuffer2
                                         call DrawOurBall2
                                         jmp CheckTime2
                          clearbuffer2:mov ah,07
                                    int 21h           
                         con2:
                         jmp FullMovement





                      notSecondShooter:
                       cmp ah,01Eh
                       jne not_a
                        mov si,ShooterFirstX
                       sub si,2
                       cmp si,60
                       je jmpBuffer
                     
                       sub ShooterFirstX,2
                       call ClearShooterArea
                       call DrawOurShooter
                       jmp clearbuffer
                       not_a:
                             cmp ah,20h
                             jne not_d
                              mov si,ShooterFirstX
                              add si,ShooterWidth
                              cmp si,122
                              jae jmpBuffer
                             add ShooterFirstX,2
                             call ClearShooterArea
                             call DrawOurShooter
                             jmp clearbuffer
                             
                        not_d:
                        cmp ah,39h
                        je shoot
                        call ClearShooterArea
                        call DrawOurShooter
                        jmpBuffer:jmp clearbuffer 
                        shoot:
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

                                            ItTochedit: inc YourPoints
                                                        call ClearFullGameArea
                                                        jmp  WeDidIt
                                             mov si,BallX
                                             add si,OurBallSize
                                              cmp si,initialSquare_X
                                              jae checkOnFinalX2
                                              jmp ContinShooting

                                             checkOnFinalX2: cmp si,FinalSquare_X
                                                         jbe checkOnInitialY2
                                                         jmp ContinShooting
                                             checkOnInitialY2:cmp di,initialSquare_Y
                                                        jae CheckOnFinalY2
                                                        jmp ContinShooting

                                              CheckOnFinalY2:cmp di,FinalSquare_Y
                                                         jbe ItTochedit24  
                                                         jmp ContinShooting                      

                                            ItTochedit24: inc YourPoints
                                                        call ClearFullGameArea
                                                        jmp  WeDidIt              


                                         
                                                        

                                          ContinShooting:call ClearGamingScreen
                                          mov ah,02ch
                                          int 21h
                                          cmp dl,OurTimeAux;is the current time equal to the previous one(OurTimeAux)?
                                          je CheckTime ;if it's the same then check again
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
                                ret
                        clearbuffer:mov ah,07
                                    int 21h

                                    
                         con:
                         jmp FullMovement

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
			mov al,7
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
			mov cx,0
			mov dx,199
			          DrawSecondH:int 10h
					              inc cx
								  cmp cx,320
								  jnz DrawSecondH 
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
	        mov al,'1'
			mov char1,al
			mov al,'6'
			mov char2,al
            mov cx,0 
			mov al,24
           PrintingZerosInMemoryPlayer1: 
			                           mov PlayersIndentifier,al
			                           call UpdateMemoryPlayer1
									   inc al
									   inc cx
									   cmp cx,16
									   jnz PrintingZerosInMemoryPlayer1
			mov al,'5'
			mov char1,al
			mov al,'F'
			mov char2,al
            mov cx,0 
			mov al,24
           PrintingZerosInMemoryPlayer2: 
			                           mov PlayersIndentifier,al
			                           call UpdateMemoryPlayer2
									   inc al
									   inc cx
									   cmp cx,16
									   jnz PrintingZerosInMemoryPlayer2					   

			ChangePosition 9,18
			ColoredChar '6',55h

			ChangePosition 11,18
			ColoredChar '6',55h

		

			call updateUsername1

			call updateUsername2

			mov al,'0'
			mov char1,al
			mov al,'0'
			mov char2,al
			mov al,'0'
			mov char3,al
			mov al,'0'
			mov char4,al
			mov cx,0
			mov al,0
           PrintingZerosInRegsPlayer1: 
			                           mov PlayersIndentifier,al
			                           call UpdateRegsPlayer1
									   add al,2
									   inc cx
									   cmp cx,8
									   jnz PrintingZerosInRegsPlayer1
			mov cx,0
			mov al,0
           PrintingZerosInRegsPlayer2: 
			                           mov PlayersIndentifier,al
			                           call UpdateRegsPlayer2
									   add al,2
									   inc cx
									   cmp cx,8
									   jnz PrintingZerosInRegsPlayer2

									   call DrawTurnSquare	
									   call DrawPowerUpSquare
                                       call DrawErrorSquare



			 call DrawOurShooter
             call DrawOurSecondShooter
						   call OurSmallGame

		   					   

	hlt 
	DrawingFullMainScreen ENDP
    end DrawingFullMainScreen