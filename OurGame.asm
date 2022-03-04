.model huge
.stack 64
.data
Window_Width dw 320
Window_Height dw 200
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

Shooter2FirstX dw 220
Shooter2FirstY dw 100

firstPlayerminRange dw 130
firstPlayerMaxRange dw 40 

secondPlayerminRange dw 160
secondplayermaxRange dw 250

initialSquare_X  dw 20
FinalSquare_X dw ?
initialSquare_Y  dw 40
FinalSquare_Y dw ?

initialSquare_X2 dw 160
FinalSquare_X2 dw ?
initialSquare_Y2  dw 40
FinalSquare_Y2 dw ?

Squarevelocity dw 2
SqaureTimeAux db 0

YourPoints db 0


.code

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
	     	mov dx,45
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns:
		                         drawhorizontalline:int 10h
								                    inc cx
													cmp cx,160
													jnz drawhorizontalline
                                 mov cx,0
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
													cmp cx,160
													jnz drawhorizontalline3
                                 mov cx,0
								 inc dx
								 cmp dx,40
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
      mov cx,161
	    mov dx,45
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumnsForShooterTwo:
		                         drawhorizontallineInShooterTwo:int 10h
								                    inc cx
													cmp cx,320
													jnz drawhorizontallineInShooterTwo
                mov cx,161
								 inc dx
								 cmp dx,99
								 jnz drawmainscreencolumnsForShooterTwo
      mov cx,161
	    mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumnsForShooterTwo2:
		                         drawhorizontallineInShooterTwo2:int 10h
								                    inc cx
													cmp cx,320
													jnz drawhorizontallineInShooterTwo2
                                 mov cx,160
								 inc dx
								 cmp dx,40
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
            mov cx,0
	     	mov dx,100
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns2:
		                         drawhorizontalline2:int 10h
								                    inc cx
													cmp cx,150
													jnz drawhorizontalline2
                                 mov cx,0
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
            mov cx,160
	     	mov dx,90
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns22:
		                         drawhorizontalline22:int 10h
								                    inc cx
													cmp cx,320
													jnz drawhorizontalline22
                                 mov cx,160
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
      mov cx,0
	    mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns222:
		                         drawhorizontalline222:int 10h
								                    inc cx
													cmp cx,320
													jnz drawhorizontalline222
                 mov cx,0
								 inc dx
								 cmp dx,100
								 jnz drawmainscreencolumns222

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
            mov cx,0
	     	mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns223:
		                         drawhorizontalline223:int 10h
								                    inc cx
													cmp cx,150
													jnz drawhorizontalline223
                                 mov cx,0
								 inc dx
								 cmp dx,55
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
      mov cx,160
	    mov dx,0
			mov al,0
			mov ah,0ch
        ;drawing first player screen background
		   drawmainscreencolumns2233:
		                         drawhorizontalline2233:int 10h
								                    inc cx
													cmp cx,300
													jnz drawhorizontalline2233
                  mov cx,160
								 inc dx
								 cmp dx,45
								 jnz drawmainscreencolumns2233

popf
pop dx
pop cx
pop bx
pop ax                      
 ret
ClearTargetArea2 endp


main proc far
       mov ax,@data
       mov ds,ax
       mov ah,0  ;making video mode
       mov al,13h
       int 10h

       mov ah,0bh ;making background black
       mov bh,00h
       mov bl,00h
       int 10h
       call DrawOurShooter
       call DrawOurSecondShooter
       call DrawOurTarget
       call DrawSecondTarget



       FullMovement: 
                                          mov ah,02ch
                                          int 21h
                                          cmp dl,OurTimeAux;is the current time equal to the previous one(OurTimeAux)?
                                          je FullMovement ;if it's the same then check again
                                         ;if it's different,then draw,move,etc
                                         mov OurTimeAux,dl
                                         mov bx,Squarevelocity
                                         add initialSquare_X,bx
                                         cmp initialSquare_X,120
                                         jz RestartAgain
                                         add initialSquare_X2,bx
                                         cmp initialSquare_X2,260
                                         jz RestartAgain
                                         jmp JustDraw
                                         RestartAgain:mov ax,20
                                         mov initialSquare_X,ax
                                         mov initialSquare_X2,160
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
                              cmp si,260
                              jae jmpBuffer2
                             add Shooter2FirstX,3
                             call ClearShooterArea2
                             call DrawOurSecondShooter
                             jmp clearbuffer
                        

                       not_Right_Arrow:cmp ah,04Bh
                       jne not_left_arrow
                        mov si,Shooter2FirstX
                       sub si,3
                       cmp si,157
                       je jmpBuffer2
                       sub Shooter2FirstX,3
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
                       cmp si,40
                       je jmpBuffer
                     
                       sub ShooterFirstX,3
                       call ClearShooterArea
                       call DrawOurShooter
                       jmp clearbuffer
                       not_a:
                             cmp ah,20h
                             jne not_d
                              mov si,ShooterFirstX
                              add si,ShooterWidth
                              cmp si,130
                              jae jmpBuffer
                             add ShooterFirstX,3
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
                                ret
                        clearbuffer:mov ah,07
                                    int 21h

                                    
                         con:
                         jmp FullMovement            

                        



          
main endp
end main