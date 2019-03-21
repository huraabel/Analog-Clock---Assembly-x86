;arg1 = x1
;arg2= y1
;arg3=x2
;arg4=y2
drawline proc
push ebp
mov ebp, esp
pusha

;int_x,int_y =curentx/y
;d_x,d_y= Dx,Dy
;two_dx, two_dy
;xi,yi = increment
; dx_er, dy_er = errors

;begin
	mov eax,[ebp+arg1]
	mov ebx,[ebp+arg3]
	mov ecx,[ebp+arg2]
	mov edx,[ebp+arg4]
	
	mov x1,eax
	mov x2,ebx
	mov y1,ecx
	mov y2,edx
	
	subandassign d_x,x2,x1
	subandassign d_y,y2,y1
	addandassign two_dx, d_x,d_x
	addandassign two_dy, d_y,d_y
	assign int_x,x1
	assign int_y,y1
	mov xi,1
	mov yi,1
	
	CompareVariableAndNumber d_x,0
	jge d_x_greater
		mov xi,-1
		negate d_x
		negate two_dx
	d_x_greater:
	
	CompareVariableAndNumber d_y,0
	jge d_y_greater
		mov yi,-1
		negate d_y
		negate two_dy
	d_y_greater:
	
	drawpixel_alb x1,y1
	

	;iful mare
	CompareVariableAndNumber d_x,0
	jne not_zero
	CompareVariableAndNumber d_y,0
	jne not_zero
	jmp zero
	
	not_zero:
	
	
	compare2variables d_y,d_x
	jg d_y_greater_than_d_x
		
	
		mov dx_er,0
		;for loop
		for_loop1:
			addandassign int_x,int_x, xi
			addandassign dx_er,dx_er, two_dy
		
			compare2variables dx_er,d_x
			jle dx_greater_dxer
				addandassign int_y,int_y,yi
				subandassign dx_er,dx_er,two_dx
			dx_greater_dxer:
				
			drawpixel_alb int_x,int_y
		
		compare2variables int_x,x2
		jne for_loop1
		jmp	zero 
		
	d_y_greater_than_d_x:
		mov dy_er,0
		
		
		for_loop2:
			addandassign int_y,int_y,yi
			addandassign dy_er,dy_er,two_dx
			
			compare2variables dy_er,d_y
			jle dy_greater_dyer
				addandassign int_x,int_x,xi
				subandassign dy_er,dy_er,two_dy
			dy_greater_dyer:
			
			drawpixel_alb int_x,int_y
		
		compare2variables int_y,y2
		jne for_loop2
		
	
	zero:
	popa
	mov esp, ebp
	pop ebp
	ret 16

drawline endp

hideline proc 
push ebp
mov ebp, esp
pusha

mov eax,[ebp+arg1]
	mov ebx,[ebp+arg3]
	mov ecx,[ebp+arg2]
	mov edx,[ebp+arg4]
	
	mov x1,eax
	mov x2,ebx
	mov y1,ecx
	mov y2,edx

	
	
	subandassign d_x,x2,x1
	subandassign d_y,y2,y1
	addandassign two_dx, d_x,d_x
	addandassign two_dy, d_y,d_y
	assign int_x,x1
	assign int_y,y1
	mov xi,1
	mov yi,1
	
	CompareVariableAndNumber d_x,0
	jge d_x_greater1
		mov xi,-1
		negate d_x
		negate two_dx
	d_x_greater1:
	
	CompareVariableAndNumber d_y,0
	jge d_y_greater1
		mov yi,-1
		negate d_y
		negate two_dy
	d_y_greater1:
	
	drawpixel_negru x1,y1
	

	;iful mare
	CompareVariableAndNumber d_x,0
	jne not_zero1
	CompareVariableAndNumber d_y,0
	jne not_zero1
	jmp zero1
	
	not_zero1:
	
	
	compare2variables d_y,d_x
	jg d_y_greater_than_d_x1
		
	
		mov dx_er,0
		;for loop
		for_loop12:
			addandassign int_x,int_x, xi
			addandassign dx_er,dx_er, two_dy
		
			compare2variables dx_er,d_x
			jle dx_greater_dxer1
				addandassign int_y,int_y,yi
				subandassign dx_er,dx_er,two_dx
			dx_greater_dxer1:
				
			drawpixel_negru int_x,int_y
		
		compare2variables int_x,x2
		jne for_loop12
		jmp	zero1 
		
	d_y_greater_than_d_x1:
		mov dy_er,0
		
		
		for_loop22:
			addandassign int_y,int_y,yi
			addandassign dy_er,dy_er,two_dx
			
			compare2variables dy_er,d_y
			jle dy_greater_dyer1
				addandassign int_x,int_x,xi
				subandassign dy_er,dy_er,two_dy
			dy_greater_dyer1:
			
			drawpixel_negru int_x,int_y
		
		compare2variables int_y,y2
		jne for_loop22
		
	
	zero1:

	popa
	mov esp, ebp
	pop ebp
	ret 16

hideline endp