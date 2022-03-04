.model HUGE
.Stack 200
.data 
char1 db ?
char2 db ?
char3 db ?
char4 db ?



.code

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
UpdatePlayer1Points proc
NormalPushingall
      ChangePosition 10,12
	  mov ah,9
                    mov al,char1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
	  ChangePosition 11,12
	  mov ah,9
                    mov al,char2
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
     ChangePosition 12,12
	  mov ah,9
                    mov al,char3
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h         

    ChangePosition 13,12
	 mov ah,9
                    mov al,char4
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h            
					NormalPopingall
					ret
UpdatePlayer1Points	endp
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
UpdatePlayer2Points proc
NormalPushingall
     ChangePosition 26,12
	  mov ah,9
                    mov al,char1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
	  ChangePosition 27,12
	  mov ah,9
                    mov al,char2
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
     ChangePosition 28,12
	  mov ah,9
                    mov al,char3
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h         

    ChangePosition 29,12
	 mov ah,9
                    mov al,char4
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h            
					NormalPopingall
					ret
UpdatePlayer2Points endp


DrawingPointsScreen PROC FAR
 mov ax, @data
		   mov DS, ax
		   mov ah,0h
		   mov al,13h
		   int 10h

                mov cx,40
				mov dx,70
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne:int 10h
	    		             inc cx
							cmp cx,80
							jnz drawingOne
				mov cx,si
				add cx,70
				drawingtwo: int 10h
							inc cx
							cmp cx,150
							jnz drawingtwo
				mov cx,40
				mov dx,70
				drawing:int 10h
				        inc cx
				        inc dx
						cmp dx,126
						jnz drawing

				mov cx,150
				mov dx,70
				drawingtwooo:int 10h
				             dec cx
							 inc dx
							 cmp dx,126
							 jnz drawingtwooo	

                mov cx,80
				mov dx,70
				drawingThree:int 10h
				             inc cx
							 inc dx
							 cmp dx,80
							 jnz drawingThree
				mov cx,110
				mov dx,70
				drawingFour:int 10h
				             dec cx
							 inc dx
							 cmp dx,80
							 jnz drawingFour

				mov cx,90
				mov dx,80
				drawingH2:int 10h
				          inc cx
						  cmp cx,101
						  jnz drawingH2	

                mov cx,160
			    mov dx,0	
			            DrawFifthV:int 10h
						           inc dx
								   cmp dx,200
								   jnz DrawFifthV

                mov cx,170
				mov dx,70
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne2:int 10h
	    		             inc cx
							cmp cx,210
							jnz drawingOne2
				mov cx,si
				add cx,70
				drawingtwo2: int 10h
							inc cx
							cmp cx,280
							jnz drawingtwo2
				mov cx,170
				mov dx,70
				drawing2:int 10h
				        inc cx
				        inc dx
						cmp dx,126
						jnz drawing2

				mov cx,280
				mov dx,70
				drawingtwooo2:int 10h
				             dec cx
							 inc dx
							 cmp dx,126
							 jnz drawingtwooo2	

                mov cx,210
				mov dx,70
				drawingThree2:int 10h
				             inc cx
							 inc dx
							 cmp dx,80
							 jnz drawingThree2
				mov cx,240
				mov dx,70
				drawingFour2:int 10h
				             dec cx
							 inc dx
							 cmp dx,80
							 jnz drawingFour2

				mov cx,220
				mov dx,80
				drawingH22:int 10h
				          inc cx
						  cmp cx,231
						  jnz drawingH22   

						  mov char1,'0'
						  mov char2,'6'
						  mov char3,'3'
						  mov char4,'1'
						  call UpdatePlayer1Points
						  call UpdatePlayer2Points

                          hlt                         
                
DrawingPointsScreen endp
end DrawingPointsScreen           