.model huge
.Stack 64
.data 
a dw ?
b dw ?
.CODE

ColoredChar MACRO Mychar,color 
                    mov ah,9
                    mov al,mychar
                    mov bh,0
                    mov cx,1
                    mov bl,color
                    int 10h
                    ENDM ColoredChar
ChangePosition MACRO X,Y 

                    MOV Ah,2H
                    MOV Dl,X
                    MOV Dh,Y
                    INT 10H    
                    ENDM ChangePosition	

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




;-----------------------------------------------------------------------------------


;-----------------------------------------------------------------------------------


;---------------------------------------------------------------------------------------------------------------------------------------------------------------------

MAIN PROC FAR
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
		   drawmainscreencolumns:
		                         drawhorizontalline:int 10h
								                    inc cx
													cmp cx,160
													jnz drawhorizontalline
                                 mov cx,0
								 inc dx
								 cmp dx,185
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
								 cmp dx,185
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
			mov cx,160
			mov dx,0
			mov al,9
			mov ah,0ch
			;drawing borders of the screen
			            ;draw most left border
					    DrawFirstVLine:int 10h
						               inc dx
									   cmp dx,185
									   jnz DrawFirstVLine

						;draw most right border			   
            mov cx,319
			mov dx,0
						DrawThirdVLine:int 10h
						               inc dx
									   cmp dx,200
									   jnz DrawThirdVLine
						;draw memory left border			   
			mov cx,130
			mov dx,0
			           DrawForthV:int 10h
					              inc dx
								  cmp dx,176
								  jnz DrawForthV
						;draw memory right border		  	
			mov cx,150
			mov dx,0	
			            DrawFifthV:int 10h
						           inc dx
								   cmp dx,186
								   jnz DrawFifthV 

			mov cx,290
			mov dx,0
			           DrawForthV2:int 10h
					              inc dx
								  cmp dx,176
								  jnz DrawForthV2
						;draw memory right border		  	
			mov cx,310
			mov dx,0	
			            DrawFifthV2:int 10h
						           inc dx
								   cmp dx,186
								   jnz DrawFifthV2
						;draw most top border		   				  					   
            mov cx,0
			mov dx,0
			           DrawFirstH:int 10h
					              inc cx
								  cmp cx,320
								  jnz DrawFirstH
			mov cx,160
			mov dx,175
			           DrawMan:int 10H 
					            inc cx	
								cmp cx,310
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
			mov dx,176
			         DrawThirdH:int 10h
					            inc cx
								cmp cx,131
								jnz DrawThirdH
						;draw chat  horizontal border		
			mov cx,0
			mov dx,185
			         DrawForthH:int 10h
					            inc cx
								cmp cx,320
								jnz DrawForthH
						;draw memory horizontal borders		
			mov dx,0
			mov cx,130
			DrawHorizontalMemory:
			                     drawHline:int 10h
								           inc cx
										   cmp cx,150
										   jnz drawHline
							mov cx,130
							add dx,9
							cmp dx,144
							jnz DrawHorizontalMemory
						;complate last horizontal border
			mov cx,130
			mov dx,185
			drawSimpleOne:int 10h
			            inc cx
						cmp cx,150
						jnz drawSimpleOne
						


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
	            mov cx,65
				mov dx,20
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne:int 10h
	    		             inc cx
							cmp cx,85
							jnz drawingOne
				mov cx,si
				add cx,40
				drawingtwo: int 10h
							inc cx
							cmp cx,125
							jnz drawingtwo
							
                mov cx,65
				mov dx,20
				drawing:int 10h
				        inc cx
				        inc dx
						cmp dx,51
						jnz drawing

				mov cx,125
				mov dx,20
				drawingtwooo:int 10h
				             dec cx
							 inc dx
							 cmp dx,50
							 jnz drawingtwooo	

                mov cx,85
				mov dx,20
				drawingThree:int 10h
				             inc cx
							 inc dx
							 cmp dx,25
							 jnz drawingThree
				mov cx,105
				mov dx,20
				drawingFour:int 10h
				             dec cx
							 inc dx
							 cmp dx,25
							 jnz drawingFour

				mov cx,90
				mov dx,25
				drawingH2:int 10h
				          inc cx
						  cmp cx,101
						  jnz drawingH2	

;-----------------------------------------------------------------------------------------------------
				mov cx,65
				mov dx,70
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOneOne:int 10h
	    		             inc cx
							cmp cx,85
							jnz drawingOneOne
				mov cx,si
				add cx,40
				drawingtwotwo: int 10h
							inc cx
							cmp cx,125
							jnz drawingtwotwo
							
                mov cx,65
				mov dx,70
				drawingg:int 10h
				        inc cx
				        inc dx
						cmp dx,101
						jnz drawingg

				mov cx,125
				mov dx,70
				drawingtwoootwooo:int 10h
				             dec cx
							 inc dx
							 cmp dx,100
							 jnz drawingtwoootwooo	

                mov cx,85
				mov dx,70
				drawingThreethree:int 10h
				             inc cx
							 inc dx
							 cmp dx,75
							 jnz drawingThreethree
				mov cx,105
				mov dx,70
				drawingFourFour:int 10h
				             dec cx
							 inc dx
							 cmp dx,75
							 jnz drawingFourFour

				mov cx,90
				mov dx,75
				drawingH2H2:int 10h
				          inc cx
						  cmp cx,101
						  jnz drawingH2H2	
                mov si,23
		        mov di,8
				PrintingReg:
				  printingrows2:
							  call PrintingZeros
							  add si,9
							  cmp si,59
							  jnz printingrows2
					mov si,23
					add di,16
					cmp di,136
					jnz PrintingReg
				            		  

		
;---------------------------------------------------------------------------------------------------------------------------
           mov si,134
		   mov di,2
	
		 		mov cx,220
				mov dx,20
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOne2:int 10h
	    		             inc cx
							cmp cx,240
							jnz drawingOne2
				mov cx,si
				add cx,40
				drawingtwo2: int 10h
							inc cx
							cmp cx,280
							jnz drawingtwo2
				
					mov cx,220
				mov dx,20
				drawing2:int 10h
				        inc cx
				        inc dx
						cmp dx,51
						jnz drawing2

				mov cx,280
				mov dx,20
				drawingtwooo2:int 10h
				             dec cx
							 inc dx
							 cmp dx,50
							 jnz drawingtwooo2	
				
                mov cx,240
				mov dx,20
				drawingThree2:int 10h
				             inc cx
							 inc dx
							 cmp dx,25
							 jnz drawingThree2
				mov cx,260
				mov dx,20
				drawingFour2:int 10h
				             dec cx
							 inc dx
							 cmp dx,25
							 jnz drawingFour2

			mov cx,174
			mov dx,5
			mov al,9
			mov ah,0ch	
			 			drawingSquares2:
			               mov si,cx
						   mov di,dx
						   mov bx,dx
						   add bx,17
						             
						            drawingfirstLine2:int 10h
									                 inc cx
													 cmp cx,211
													 jnz drawingfirstLine2
									mov cx,si
									mov dx,di
									add dx,16
									drawingSecondLine2:int 10h
									                  inc cx
													  cmp cx,211
													  jnz drawingSecondLine2
									mov cx,si
									mov dx,di	
									drawingThirdLine2:int 10h
									                  inc dx
													  cmp dx,bx
													  jnz drawingThirdLine2
									mov cx,211
									mov dx,di
									drawingForthLine2:int 10h
									                  inc dx
													  cmp dx,bx
													  jnz drawingForthLine2

							mov cx,si
							mov dx,di
							add dx,21
							cmp dx,173
							jnz drawingSquares2
														
					mov cx,245
				mov dx,25
				drawingH22:int 10h
				          inc cx
						  cmp cx,256
						  jnz drawingH22	

;-----------------------------------------------------------------------------------------------------
				mov cx,220
				mov dx,70
				mov al,9
				mov ah,0ch			

			    mov si,cx
				mov di,cx						          
				drawingOneOne2:int 10h
	    		            inc cx
							cmp cx,240
							jnz drawingOneOne2
							mov cx,si
				add cx,40
				drawingtwotwo2: int 10h
							inc cx
							cmp cx,280
							jnz drawingtwotwo2
														
                mov cx,220
				mov dx,70
				drawingg2:int 10h
				        inc cx
				        inc dx
						cmp dx,101
						jnz drawingg2

				mov cx,280
				mov dx,70
				drawingtwoootwooo2:int 10h
				             dec cx
							 inc dx
							 cmp dx,100
							 jnz drawingtwoootwooo2	
							 
                mov cx,240
				mov dx,70
				drawingThreethree2:int 10h
				             inc cx
							 inc dx
							 cmp dx,75
							 jnz drawingThreethree2
				mov cx,260
				mov dx,70
				drawingFourFour2:int 10h
				             dec cx
							 inc dx
							 cmp dx,75
							 jnz drawingFourFour2
							 
				mov cx,245
				mov dx,75
				drawingH2H22:int 10h
				          inc cx
						  cmp cx,256
						  jnz drawingH2H22	
                mov si,177
		        mov di,10
				PrintingReg2:
				  printingrows22:
							  call PrintingZeros
							  add si,9
							  cmp si,213
							  jnz printingrows22
					mov si,177
					add di,21
					cmp di,178
					jnz PrintingReg2
				            		  

		
;---------------------------------------------------------------------------------------------------------------------------
           mov si,294
		   mov di,2
		   printingZerooo2:
		            printingrows2222222:
							  call PrintingZeros
							  add si,7
							  cmp si,308
							  jnz printingrows2222222
					mov si,294
					add di,11
					cmp di,178
					jnz printingZerooo2


    ChangePosition 0,1
	ColoredChar "A",15h
	ChangePosition 1,1
	ColoredChar "X",15h


	ChangePosition 0,3
	ColoredChar "B",15h
	ChangePosition 1,3
	ColoredChar "X",15h

	ChangePosition 0,5
	ColoredChar "C",15h
	ChangePosition 1,5
	ColoredChar "X",15h

	ChangePosition 0,7
	ColoredChar "D",15h
	ChangePosition 1,7
	ColoredChar "X",15h

	ChangePosition 0,9
	ColoredChar "S",15h
	ChangePosition 1,9
	ColoredChar "I",15h

	ChangePosition 0,11
	ColoredChar "D",15h
	ChangePosition 1,11
	ColoredChar "I",15h

	ChangePosition 0,13
	ColoredChar "B",15h
	ChangePosition 1,13
	ColoredChar "P",15h

	ChangePosition 0,15
	ColoredChar "B",15h
	ChangePosition 1,15
	ColoredChar "P",15h



            ChangePosition 19,1
	        ColoredChar '0',15h

			ChangePosition 19,2
	        ColoredChar '1',15h

			ChangePosition 19,3
	        ColoredChar '2',15h

			ChangePosition 19,4
	        ColoredChar '3',15h

			ChangePosition 19,5
	        ColoredChar '4',15h

			ChangePosition 19,6
	        ColoredChar '5',15h

			ChangePosition 19,7
	        ColoredChar '6',15h

			ChangePosition 19,8
	        ColoredChar '7',15h

			ChangePosition 19,9
	        ColoredChar '8',15h

			ChangePosition 19,10
	        ColoredChar '9',15h

			ChangePosition 19,11
	        ColoredChar 'A',15h

			ChangePosition 19,12
	        ColoredChar 'B',15h

			ChangePosition 19,13
	        ColoredChar 'C',15h

			ChangePosition 19,14
	        ColoredChar 'D',15h























	



	




     




	


  
	
	hlt
	MAIN ENDP


    END MAIN
