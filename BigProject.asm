.model huge
.386
.stack 200
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

cmd db 30,?,30 dup('$')
encode db ?,?,? ;cmd, destination, source
value dw '$$'
forbidden db ?


char1 db ?
char2 db ?
EnterName db 'Enter Your Name: $'
EnterInPoints db 'Initial Points: $'
edkhol db 'Press Enter To Continue$'
READName DB 16 , ? , 16 DUP('$')   
a dw ? 


STRING1  DB  'To start chatting press ','$' 
STRING2  DB  'To start the Game press ' ,'$'
STRING3  DB  'To end the program press ' ,'$'
STRING4  DB  'Notification Bar','$'
Empty    DB  ' ','$' 
temp     DB  ?    
Notify1  DB  'Notification Bar : ','$' 
Notify2  DB  'Welcome !!'


.code
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
ENDM

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
ENDM

ClrScreen MACRO
    push bx
    MOV AX,0600H
    MOV BH,7
    MOV CX,0
    MOV DX,184FH 
    INT 10H
    pop bx
ENDM

;------------------------------------- 
ShowMessage MACRO MyMessage  
    mov ah,9H 
    mov dx,offset MyMessage
    int 21h
ENDM
;-------------------------------------
ChangePosition MACRO X,Y 
    MOV Ah,2H
    MOV Dl,X
    MOV Dh,Y
    INT 10H     
ENDM
;-------------------------------------
ColoredChar MACRO Mychar,color 
    mov ah,9
    mov al,mychar
    mov bh,0
    mov cx,1
    mov bl,color
    int 10h
ENDM

NotificationBar proc
    ChangePosition 0,15h 
    back: ColoredChar '-',30h
    mov ah,3
    mov bh,0
    int 10h
    inc dl
    mov temp,dl 
    ChangePosition temp,15h
    cmp dl,50h
    jne back

    ChangePosition 0,16h
    ShowMessage Notify1

    ChangePosition 20h,17h
    ShowMessage Notify2
    ret   
NotificationBar ENDP


                    
                    
DrawMainScreen proc   
    ClrScreen
    
    PushAll
    MOV AH, 06h    ; Scroll up function
    XOR AL, AL     ; Clear entire screen
    XOR CX, CX     ; Upper left corner CH=row, CL=column
    MOV DX, 154FH  ; lower right corner DH=row, DL=column 
    MOV BH, 30h    ; blackOncyan
    INT 10H
    PopAll       

    PushAll
    MOV AH, 06h    ; Scroll up function
    XOR AL, AL     ; Clear entire screen
    mov cx,1500h     ;CH=row, CL=column
    MOV DX, 184FH  ; lower right corner DH=row, DL=column 
    MOV BH, 20h    ; BlackOnGreen
    INT 10H
    PopAll       

    ChangePosition 15h,4h
    ShowMessage STRING1
    ;------------------------------
    ColoredChar 'F',39h 
    mov ah,3          ;after coloring first char get its position
    mov bh,0
    int 10h
    inc dl            ;inc X by 1 to draw next char next to it
    mov temp,dl       ;move X pos to temp then pass it again to the function changepos
    ChangePosition temp,4h 
    ColoredChar '1',39h
    ;------------------------------
    ChangePosition 15h,6h
    ShowMessage STRING2
    ;------------------------------
    ColoredChar 'F',36h
    mov ah,3        ;after coloring first char get its position
    mov bh,0
    int 10h 

    inc dl          ;inc X by 1 to draw next char next to it
    mov temp,dl     ;move X pos to temp then pass it again to the function changepos  
    ChangePosition temp,6h
    ColoredChar '2',36h
    ;------------------------------
    ChangePosition 15h,8h
    ShowMessage STRING3
    ;------------------------------
    ColoredChar 'E',34h 
    mov ah,3        ;after coloring first char get its position
    mov bh,0
    int 10h
    inc dl          ;inc X by 1 to draw next char next to it
    mov temp,dl     ;move X pos to temp then pass it again to the function changepos
    ChangePosition temp,8h
    ColoredChar 'S',34h
    mov ah,3
    mov bh,0
    int 10h
    inc dl
    mov temp,dl
    ChangePosition temp,8h
    ColoredChar 'C',34h
    ;------------------------------
    ;Notification bar  
    ;------------------------------ 
    call NotificationBar
    ;------------------------------ 
    ret                 
DrawMainScreen endp

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
 getnum macro ; to read the number digit by digit
    mov ah , 1  ; read char 
    int 21h    
endm getnum  

readfirstdigit macro p1                 
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1000d ; awl rkm bdrbo f 1000 
    mul bx       ; multiply the first digit by 1000 
    mov p1 , ax ; put the result in a

endm readfirstdigit

readseconddigit macro p1                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 100d
    mul bx       ; multiply the first digit by 100 
    add p1 , ax ;add to a

endm readseconddigit

readThirddigit macro p1                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 10d
    mul bx       ; multiply the first digit by 10 
    add p1 , ax ; add to a

endm readThirddigit

read4thdigit macro p1                   
    mov ah , 0
    sub al , 30h ; convert the char to int 
    mov bx , 1d
    mul bx      
    add p1 , ax ;add to a

endm read4thdigit
 
Read4Digits macro p1
    ;reading the number digit by digit
    getnum
    readfirstdigit p1
    getnum
    readSeconddigit p1 
    getnum
    readThirddigit p1
    getnum
    read4thdigit p1      
  
 endm   Read4Digits  

Read4Dgs proc
    Read4Digits a
    ret
Read4Dgs endp

ReadString macro 
  ;READ FROM KEYBOARD 15 CHAR ONLY
    MOV AH , 0AH        
    LEA BX , READName    
    MOV DX , BX 
    INT 21H           
 endm ReadString

LoadMainScreen proc far  
    ;coloring the backGround
    NormalPusha
  NormalPusha
   MOV AH, 06h    ; Scroll up function
   XOR AL, AL     ; Clear entire screen
   XOR CX, CX     ; Upper left corner CH=row, CL=column
   MOV DX, 154FH  ; lower right corner DH=row, DL=column 
   MOV BH, 3fh    ; blackOncyan
   INT 10H
   NormalPopa       
   
    NormalPusha
   MOV AH, 06h    ; Scroll up function
   XOR AL, AL     ; Clear entire screen
   mov cx,1500h     ;CH=row, CL=column
   MOV DX, 184FH  ; lower right corner DH=row, DL=column 
   MOV BH, 2fh    ; BlackOnGreen
   INT 10H
   NormalPopa 
   
   ;move Cursor
  ChangePosition 5,5
   
   
    ;printing message
   mov ah , 9 
   mov dx , offset EnterName  
   int 21h
   ReadString
    
	ChangePosition 5,10
                   
   ;show Message
   mov ah , 9 
   mov dx , offset EnterInPoints
   int 21h 

    ChangePosition 5,7
    MOV AH , 0AH        
    LEA BX , READName    
    MOV DX , BX 
    INT 21H 
   
   ;move cursor
    MOV Ah,2H
    MOV Dl,5
    MOV Dh,12
    INT 10H   
           
           
   ;reading integer
    call Read4Dgs
    
   ;move cursor
   mov ah,  2
   mov dl , 5
   mov dh , 22
   int 10h 
   
   ;show message
   mov ah , 9 
   mov dx , offset edkhol
   int 21h    
                  
   ;get keypressed
   loop1:
   mov ah , 07
   int 21h 
   cmp al ,0Dh 
   jnz loop1
   NormalPopa

LoadMainScreen endp

UpdatePlayer1Points proc
NormalPusha
      ChangePosition 3,19
	  mov ah,9
                    mov al,char1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
	  ChangePosition 4,19
	  mov ah,9
                    mov al,char2
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
					NormalPopa
					ret
UpdatePlayer1Points	endp
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------
UpdatePlayer2Points proc
NormalPusha
      ChangePosition 35,19
	  mov ah,9
                    mov al,CHAR1
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
	  ChangePosition 36,19
	  mov ah,9
                    mov al,CHAR2
                    mov bh,0
                    mov cx,1
                    mov bl,55h
                    int 10h
					NormalPopa
					ret
UpdatePlayer2Points endp
;----------------------------------------------------------------/////////////////////////////////////////////////////////////------------------------------------------------

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

Update proc
	NormalPusha

	mov al, encode[1]
	MOV y, al
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

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------
DrawingFullMainScreen PROC FAR
		   mov ah,0h
		   mov al,13h
		   int 10h
            mov cx,0
	     	mov dx,0
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
								 cmp dx,170
								 jnz drawmainscreencolumns
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
			mov cx,60
			mov dx,155
					    DrawHorizontalUsername:int 10H
						                    inc cx
											cmp cx,148
											jnz DrawHorizontalUsername
			mov cx,60
			mov dx,155
			            DrawVerticalUserName:int 10H
						                    inc dx
											cmp dx,173
											jnz DrawVerticalUserName	
			;drawing username2 border horizontal
			mov cx,162
			mov dx,155
			            DrawHorizontalUsername2:int 10H
						                        inc cx
												cmp cx , 258
												jnz DrawHorizontalUsername2	
			mov cx,258
			mov dx,155
			            DrawVerticalUserName2:int 10H
						                    inc dx
											cmp dx,173
											jnz DrawVerticalUserName2																						

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
                mov cx,2
				mov dx,140
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne:int 10h
	    		             inc cx
							cmp cx,25
							jnz drawingOne
				mov cx,si
				add cx,38
				drawingtwo: int 10h
							inc cx
							cmp cx,60
							jnz drawingtwo
				mov cx,2
				mov dx,140
				drawing:int 10h
				        inc cx
				        inc dx
						cmp dx,170
						jnz drawing

				mov cx,60
				mov dx,140
				drawingtwooo:int 10h
				             dec cx
							 inc dx
							 cmp dx,170
							 jnz drawingtwooo	

                mov cx,25
				mov dx,140
				drawingThree:int 10h
				             inc cx
							 inc dx
							 cmp dx,145
							 jnz drawingThree
				mov cx,40
				mov dx,140
				drawingFour:int 10h
				             dec cx
							 inc dx
							 cmp dx,145
							 jnz drawingFour

				mov cx,30
				mov dx,145
				drawingH2:int 10h
				          inc cx
						  cmp cx,36
						  jnz drawingH2	
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

				mov cx,258
				mov dx,140
				mov al,9
				mov ah,0ch			
			    mov si,cx
				mov di,cx						          
				drawingOnePlayer2:int 10h
	    		             inc cx
							cmp cx,281
							jnz drawingOnePlayer2
				mov cx,si
				add cx,38
				drawingtwoPlayer2: int 10h
							inc cx
							cmp cx,316
							jnz drawingtwoPlayer2
				mov cx,258
				mov dx,140
				drawingPlayer2:int 10h
				        inc cx
				        inc dx
						cmp dx,170
						jnz drawingPlayer2

				mov cx,316
				mov dx,140
				drawingtwoooPlayer2:int 10h
				             dec cx
							 inc dx
							 cmp dx,170
							 jnz drawingtwoooPlayer2	

                mov cx,281
				mov dx,140
				drawingThreePlayer2:int 10h
				             inc cx
							 inc dx
							 cmp dx,145
							 jnz drawingThreePlayer2
				mov cx,296
				mov dx,140
				drawingFourPlayer2:int 10h
				             dec cx
							 inc dx
							 cmp dx,145
							 jnz drawingFourPlayer2

				mov cx,286
				mov dx,145
				drawingH2Player2:int 10h
				          inc cx
						  cmp cx,292
						  jnz drawingH2Player2
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

		mov al,'2'
		mov char1,al
		mov al,'F'
		mov char2,al
		call UpdatePlayer1Points
		mov al,'7'
		mov char2,al
		call UpdatePlayer2Points
		

			ChangePosition 8,20
			ColoredChar 'N',55h
			ChangePosition 9,20
			ColoredChar 'U',55h
			ChangePosition 10,20
			ColoredChar '3',55h

			ChangePosition 22,20
			ColoredChar 'Z',55h
			ChangePosition 23,20
			ColoredChar 'U',55h
			ChangePosition 24,20
			ColoredChar 'Z',55h

	ret
	DrawingFullMainScreen ENDP

   

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


check_numeric proc
    sub si, 1

    mov cx, 4
    mov bp, 0
    char:
        mov bh, cl

        dec cx
        mov al, 4
        mul cx
        mov bl, al

        lodsb
        mov di, offset ASC_TBL
        mov cx, 17
        repne scasb
        cmp cx, 0
        jz invnum
        mov al, 16
        sub al, cl
        
        mov ah, 0
        mov cl, bl
        shl ax, cl
        add bp, ax

        mov cl, bh
    loop char
    mov value, bp
    mov bl, -1
    mov dx, 1
    mov cl, 0
    ret

    invnum:
    mov cl, 1
    ret

check_numeric ENDP

CmpOperands proc
    lodsw
    mov di, offset Operands
    mov cx, 41
    repne scasw
    mov bl, 40
    sub bl, cl
    cmp cx, 0
    ret
CmpOperands ENDP

Get_Operand proc
    call CmpOperands
    jnz vld

    sub si, 2
    lodsb
    cmp al, '['
    
    jnz check_type

    call CmpOperands
    jz direct_addressing
    cmp bl, 24
    jge var

    cmp Execute_To, 0
    jnz p2
    mov di, offset Regs_player1
    jmp RIAM
    p2:
    mov di, offset Regs_player2
    RIAM:
    mov bh, 0
    add di, bx
    cmp bl, 16
    jb wrd
    sub di, 16
    mov cl, [di]
    mov ch, 0
    jmp vldAddr
    wrd:
    mov ch, [di]
    mov cl, [di+1]
    vldAddr:
    cmp cx, 15
    jg invld
    mov bl, cl
    add bl, 24

    var:
    inc si
    jmp vld

    direct_addressing:
    mov di, offset ASC_TBL
    mov cx, 17
    repne scasb
    mov bl, 40
    sub bl, cl
    cmp cx, 0
    jnz vld

    jmp invld

    check_type:
    cmp dx, 0
    jz invld
    call check_numeric
    ret

    vld:
    mov cl, 0
    ret
    invld:
    mov cl, 1
    ret
Get_Operand ENDP

ChangePosition MACRO X,Y 
    MOV Ah,2H
    MOV Dl,X
    MOV Dh,Y
    INT 10H  
ENDM ChangePosition

Parse_Cmd proc
    NormalPusha
    cmp Execute_To, 0
    jnz pos_p2
    ChangePosition 5,22
    jmp read
    pos_p2:
    ChangePosition 25,22
    read:
    ;reading the command
    mov ah, 0ah
    mov dx, offset cmd
    int 21H
    ;checking for forbidden character
    mov cx, 15
    mov al, forbidden
    mov di, offset cmd
    repne scasb
    jz invalid
    ;loading opcode into eax
    mov si, offset cmd+2

    lodsd
    ;comparing eax with the array of commands
    mov di, offset Cmds
    mov cx, 17
    repne scasd
    ;calculating the index of the command (if found) and storing it in code[0]
    mov bx, 16
    sub bx, cx
    cmp bx, 16
    jz invalid
    mov encode, bl
    cmp bl, 13
    jz exit
    ;Destination
    mov dx, 0
    call Get_Operand
    jmp v_iv

    ;Source
    Source:
    cmp encode, 14
    jge exit
    ;discard the dummy ", "
    lodsw

    mov dx, 1
    call Get_Operand

    v_iv:
    cmp cl, 0
    jnz invalid
    valid:
    cmp dx, 0
    jz ValidDest
    mov encode[2], bl
    jmp exit
    ValidDest:
    mov encode[1], bl
    jmp Source

    invalid: mov encode, -1

    exit:
    NormalPopa
    ret
Parse_Cmd endp



main proc far 
    mov ax , @DATA
    mov ds , ax 
    mov es , ax
    
    call LoadMainScreen
    ;call Parse_Cmd
    ;call DrawMainScreen

    hlt
main endp 
end main 