.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf:proc
extern GetLocalTime@4: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "CEAS ANALOG ",0
area_width EQU  640 
area_height EQU 480
area DD 0

x dd 450
y dd 300
r dd 280

x1 dd 0
x2 dd 0
y1 dd 0
y2 dd 0

int_y dd 0
int_x dd 0

d_x dd 0
d_y dd 0


two_dx dd 0
two_dy dd 0

xi dd 0 
yi dd 0

dx_er dd 0
dy_er dd 0


balance dd 0
xoff dd 0
yoff dd 0 
    
xplusx dd 0
xminusx dd 0
yplusy dd 0
yminusy dd 0
    
xplusy dd 0
xminusy dd 0
yplusx dd 0
yminusx dd 0


format db "%d",0ah,0
 
counter DD 0 ; numara evenimentele de tip timer
counter_ora dd 0;
counter_sec dd 0

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
include digits.inc
include letters.inc
includelib kernel32.lib

mytimeStruct STRUCT
  wYear word ?
  wMonth word ?
  wDayOfWeek word ?
  wDay word ?
  wHour word ?
  wMinute word ?
  wSecond word ?
  wMilliseconds word ?
mytimeStruct ends

mytime mytimeStruct <>

h DD 0
m DD 0
s DD 0

.code



Assign macro a, b
    mov eax, [b]
    mov [a], eax    
	endm
	
	Negate macro a
    mov eax, [a]
    neg eax
    mov [a], eax    
endm

;a = a+1 
IncVar macro a
    mov eax, [a]
    inc eax
    mov [a], eax    
endm

;a = a-1 
DecVar macro a
    mov eax, [a]
    dec eax
    mov [a], eax    
endm

Compare2Variables macro a, b
    mov ecx, [a]
    cmp ecx, [b]
endm

CompareVariableAndNumber macro a, b
    mov ecx, [a]
    cmp ecx, b
endm

abs_minus macro cc,a,b
	local eax_mai_mare
	mov eax,[a]
	mov ebx,[b]
	sub eax,ebx
	
	cmp eax,0
	jg eax_mai_mare
	mov ebx,-1
	mul ebx
	
	eax_mai_mare:
	mov [cc],eax
	
endm

;c = a+b
AddAndAssign macro cc, a, b
    mov eax, [a]
    add eax, [b]
    mov [cc], eax
endm 

;c = a-b
SubAndAssign macro cc, a, b
    mov eax, [a]
    sub eax, [b]
    mov [cc], eax
endm

;d = a+b+c
Add3NumbersAndAssign macro d, a, b, cc
    mov eax, [a]
    add eax, [b]
    add eax, [cc]
    mov [d], eax
endm 

;d = a-b-c
Sub3NumbersAndAssign macro d, a, b, cc
    mov eax, [a]
    sub eax, [b]
    sub eax, [cc]
    mov [d], eax
endm


DrawPixel_negru macro x, y
    
   
	mov eax,y; pui y
	mov ebx,area_width	;pui latimea
	mul ebx	; eax= eax*ebx
	add eax,x ; eax pls x
	
	shl eax,2 ; pt ca dword == *4
	add eax,area
	
	mov dword ptr[eax],0
	
endm

DRAWPIXEL_VERDE macro x, y
    
   
	mov eax,[y]; pui y
	mov ebx,area_width	;pui latimea
	mul ebx	; eax= eax*ebx
	add eax,[x] ; eax pls x
	
	shl eax,2 ; pt ca dword == *4
	add eax,area
	
	mov dword ptr[eax],0008Ff00h
	
endm

DrawPixel_rosu macro x, y
    
   
	mov eax,[y]; pui y
	mov ebx,area_width	;pui latimea
	mul ebx	; eax= eax*ebx
	add eax,[x] ; eax pls x
	
	shl eax,2 ; pt ca dword == *4
	add eax,area
	
	mov dword ptr[eax],990033H;0ff0000h
	
endm

DrawCircle macro circleCenterX, circleCenterY, radius
	local draw_circle_loop, balance_negative, end_drawing
    ;C# Code
;         int balance;
;         int xoff;
;         int yoff;
    mov balance , 0
	mov xoff    , 0
	mov yoff    , 0 
    
	mov xplusx  , 0
    mov xminusx , 0
    mov yplusy  , 0
    mov yminusy , 0
    
    mov xplusy  , 0
    mov xminusy , 0
    mov yplusx  , 0
    mov yminusx , 0
    
    
    ;C# Code
    ;         xoff = 0;
    ;         yoff = radius;
    ;         balance = -radius;
    
    Assign yoff, radius
    
    Assign balance, radius
    Negate balance
    
    
    ;C# Code
    ;         while (xoff <= yoff)
    ;         {
    draw_circle_loop:
     
     AddAndAssign xplusx, circleCenterX, xoff
     SubAndAssign xminusx, circleCenterX, xoff
     AddAndAssign yplusy, circleCenterY, yoff
     SubAndAssign yminusy, circleCenterY, yoff
     
     AddAndAssign xplusy, circleCenterX, yoff
     SubAndAssign xminusy, circleCenterX, yoff
     AddAndAssign yplusx, circleCenterY, xoff
     SubAndAssign yminusx, circleCenterY, xoff
     
    ;C# Code
    ;        DrawPixel(circleCenterX + yoff, circleCenterY - xoff);
    ; part 1 from angle 0 to 45 counterclockwise
    DrawPixel_rosu xplusy, yminusx
    
    ;C# Code
    ;       DrawPixel(circleCenterX + xoff, circleCenterY - yoff);
    ; part 2 from angle 90 to 45 clockwise
    DrawPixel_rosu xplusx, yminusy
    
    ;C# Code
    ;       DrawPixel(circleCenterX - xoff, circleCenterY - yoff); 
    ; part 3 from angle 90 to 135 counterclockwise
    DrawPixel_rosu xminusx, yminusy
    
    ;C# Code
    ;        DrawPixel(circleCenterX - yoff, circleCenterY - xoff); 
    ; part 4 from angle 180 to 135 clockwise
    DrawPixel_rosu xminusy, yminusx
    
    ;C# Code
    ;       DrawPixel(circleCenterX - yoff, circleCenterY + xoff); 
    ; part 5 from angle 180 to 225 counterclockwise
    DrawPixel_rosu xminusy, yplusx
    
        ;C# Code
    ;       DrawPixel(circleCenterX - xoff, circleCenterY + yoff); 
    ; part 6 from angle 270 to 225 clockwise
    DrawPixel_rosu xminusx, yplusy
        
    ;C# Code
    ;       DrawPixel(circleCenterX + xoff, circleCenterY + yoff); 
    ; part 7 from angle 270 to 315 counterclockwise
    DrawPixel_rosu xplusx, yplusy
    
    
    ;C# Code
    ;       DrawPixel(circleCenterX + yoff, circleCenterY + xoff); 
    ; part 8 from angle 360 to 315 clockwise
    DrawPixel_rosu xplusy, yplusx

    
    ;C# Code
    ;        balance = balance + xoff + xoff;
    Add3NumbersAndAssign balance, balance, xoff, xoff
    
    ;C# Code
    ;            if (balance >= 0)
    ;            {
    ; 
    ;               yoff = yoff - 1;
    ;               balance = balance - yoff - yoff;
    ;               
    ;            }
    ; 
    ;            xoff = xoff + 1;
    CompareVariableAndNumber balance, 0
    jl balance_negative
    ;balance_positive:
    DecVar yoff
    
    Sub3NumbersAndAssign balance, balance, yoff, yoff
    
    balance_negative:
    IncVar xoff
    
    ;C# Code
    ;         while (xoff <= yoff)
    Compare2Variables xoff, yoff
    jg end_drawing
    jmp draw_circle_loop
    
    
    end_drawing:
    ; pause the screen for dos compatibility:    
endm	


; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	
	cmp eax,' '
	jg make_point
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	jmp draw_text

make_point:
	mov eax, 10
	lea esi, digits
		
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_negru
	mov dword ptr [edi], 0ffff00h ;galben
	jmp simbol_pixel_next
simbol_pixel_negru:
	mov dword ptr [edi], 0h
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm



draw_layout macro 
	
	DRAWPIXEL_VERDE x,y ; centru
	drawcircle x,y,r
	
	make_text_macro 'H',area,540,400
	make_text_macro 'U',area,550,400
	make_text_macro 'R',area,560,400
	make_text_macro 'A',area,570,400
	
	make_text_macro 'A',area,590,400
	make_text_macro 'B',area,600,400
	make_text_macro 'E',area,610,400
	make_text_macro 'L',area,620,400
	
	
	
	make_text_macro '1' ,area,310,45
	make_text_macro '2' ,area,320,45
	make_text_macro '3' ,area,500,230
	make_text_macro '6' ,area,315,415
	make_text_macro '9' ,area,130,230
	
	
	;ore
	DRAWPIXEL_VERDE 415,75	;1 
	DRAWPIXEL_VERDE 485,145	;2
	;DRAWPIXEL_VERDE 510,240	;3
	DRAWPIXEL_VERDE 485,335	;4
	DRAWPIXEL_VERDE 415,405	;5
	DRAWPIXEL_VERDE 320,430	;6
	DRAWPIXEL_VERDE 225,405	;7
	DRAWPIXEL_VERDE 155,335	;8
	DRAWPIXEL_VERDE 130,240	;9
	DRAWPIXEL_VERDE 155,145	;10
	DRAWPIXEL_VERDE 225,75	;11
	DRAWPIXEL_VERDE 320,50	;12
	
	;minute
	drawpixel_rosu  320+0,240-170
	drawpixel_rosu  320+18,240-169
	drawpixel_rosu  320+35,240-166
	drawpixel_rosu  320+53,240-162
	drawpixel_rosu  320+69,240-155
	drawpixel_rosu  320+85,240-147
	drawpixel_rosu  320+100,240-138
	drawpixel_rosu  320+114,240-126
	drawpixel_rosu  320+126,240-114
	drawpixel_rosu  320+138,240-100
	drawpixel_rosu  320+147,240-85
	drawpixel_rosu  320+155,240-69
	drawpixel_rosu  320+162,240-53
	drawpixel_rosu  320+166,240-35
	drawpixel_rosu  320+169,240-18
	drawpixel_rosu  320+170,240-0
	drawpixel_rosu  320+169,240+18
	drawpixel_rosu  320+166,240+35
	drawpixel_rosu  320+162,240+53
	drawpixel_rosu  320+155,240+69
	drawpixel_rosu  320+147,240+85
	drawpixel_rosu  320+138,240+100
	drawpixel_rosu  320+126,240+114
	drawpixel_rosu  320+114,240+126
	drawpixel_rosu  320+100,240+138
	drawpixel_rosu  320+85,240+147
	drawpixel_rosu  320+69,240+155
	drawpixel_rosu  320+53,240+162
	drawpixel_rosu  320+35,240+166
	drawpixel_rosu  320+18,240+169
	drawpixel_rosu  320-0,240+170
	drawpixel_rosu  320-18,240+169
	drawpixel_rosu  320-35,240+166
	drawpixel_rosu  320-53,240+162
	drawpixel_rosu  320-69,240+155
	drawpixel_rosu  320-85,240+147
	drawpixel_rosu  320-100,240+138
	drawpixel_rosu  320-114,240+126
	drawpixel_rosu  320-126,240+114
	drawpixel_rosu  320-138,240+100
	drawpixel_rosu  320-147,240+85
	drawpixel_rosu  320-155,240+69
	drawpixel_rosu  320-162,240+53
	drawpixel_rosu  320-166,240+35
	drawpixel_rosu  320-169,240+18
	drawpixel_rosu  320-170,240-0
	drawpixel_rosu  320-169,240-18
	drawpixel_rosu  320-166,240-35
	drawpixel_rosu  320-162,240-53
	drawpixel_rosu  320-155,240-69
	drawpixel_rosu  320-147,240-85
	drawpixel_rosu  320-138,240-100
	drawpixel_rosu  320-126,240-114
	drawpixel_rosu  320-114,240-126
	drawpixel_rosu  320-100,240-138
	drawpixel_rosu  320-85,240-147
	drawpixel_rosu  320-69,240-155
	drawpixel_rosu  320-53,240-162
	drawpixel_rosu  320-35,240-166
	drawpixel_rosu  320-18,240-169

endm

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
	
	DRAWPIXEL_VERDE x1,y1
	

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
				
			DRAWPIXEL_VERDE int_x,int_y
		
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
			
			DRAWPIXEL_VERDE int_x,int_y
		
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

push_stack macro x1,y1,x2,y2
	push y2
	push x2
	push y1
	push x1
endm

get_time proc
	push offset mytime
	call GetLocalTime@4
	
	mov ebx, 0
	mov bx, mytime.wHour
	mov h, ebx
	mov ebx, 0
	mov bx, mytime.wMinute
	mov m, ebx
	mov ebx, 0
	mov bx, mytime.wSecond
	mov s, ebx
	ret
get_time endp


minutes proc
push ebp
mov ebp, esp
pusha
	
	mov eax,[ebp+arg1]
	
	cmp eax,5
	jg next1
	push_stack x,y,320-18,240-169
	call hideline
	drawpixel_rosu 320-18,240-169
	push_stack x,y,320,240-170
	call drawline
	jmp end1
	
	next1:
	cmp eax,10
	jg next2
	push_stack x,y,320,240-170
	call hideline
	drawpixel_rosu 320,240-170
	push_stack x,y,320+18,240-169
	call drawline
	jmp end1
	
	next2:
	cmp eax,15
	jg next3
	push_stack x,y,320+18,240-169
	call hideline
	drawpixel_rosu 320+18,240-169
	push_stack x,y,320+35,240-166
	call drawline
	jmp end1
	
	next3:
	cmp eax,20
	jg next4
	push_stack x,y,320+35,240-166
	call hideline
	drawpixel_rosu  320+35,240-166
	push_stack x,y , 320+53,240-162
	call drawline
	jmp end1
	
	next4:
	cmp eax,25
	jg next5
	push_stack x,y,320+53,240-162
	call hideline
	drawpixel_rosu  320+53,240-162
	push_stack x,y,320+69,240-155
	call drawline
	jmp end1
	
	next5:
	cmp eax,30
	jg next6
	push_stack x,y,320+69,240-155
	call hideline
	drawpixel_rosu  320+69,240-155
	push_stack x,y,320+85,240-147
	call drawline
	jmp end1
	
	next6:
	cmp eax,35
	jg next7
	push_stack x,y,320+85,240-147
	call hideline
	drawpixel_rosu  320+85,240-147
	push_stack x,y,320+100,240-138
	call drawline
	jmp end1
	
	next7:
	cmp eax,40
	jg next8
	push_stack x,y,320+100,240-138
	call hideline
	drawpixel_rosu  320+100,240-138
	push_stack x,y,320+114,240-126
	call drawline
	jmp end1
	
	next8:
	cmp eax,45
	jg next9
	push_stack x,y,320+114,240-126
	call hideline
	drawpixel_rosu  320+114,240-126
	push_stack x,y,320+126,240-114
	call drawline
	jmp end1
	
	next9:
	cmp eax,50
	jg next10
	push_stack x,y,320+126,240-114
	call hideline
	drawpixel_rosu  320+126,240-114
	push_stack x,y,320+138,240-100
	call drawline
	jmp end1
	
	next10:
	cmp eax,55
	jg next11
	push_stack x,y,320+138,240-100
	call hideline
	drawpixel_rosu  320+138,240-100
	push_stack x,y,320+147,240-85
	call drawline
	jmp end1
	
	next11:
	cmp eax,60
	jg next12
	push_stack x,y,320+147,240-85
	call hideline
	drawpixel_rosu  320+147,240-85
	push_stack x,y,320+155,240-69
	call drawline
	jmp end1
	
	next12:
	cmp eax,65
	jg next13
	push_stack x,y,320+155,240-69
	call hideline
	drawpixel_rosu  320+155,240-69
	push_stack x,y,320+162,240-53
	call drawline
	jmp end1
	
	next13:
	cmp eax,70
	jg next14
	push_stack x,y,320+162,240-53
	call hideline
	drawpixel_rosu  320+162,240-53
	push_stack x,y,320+166,240-35
	call drawline
	jmp end1
	
	next14:
	cmp eax,75
	jg next15
	push_stack x,y,320+166,240-35
	call hideline
	drawpixel_rosu  320+166,240-35
	push_stack x,y,320+169,240-18
	call drawline
	jmp end1
	
	next15:
	cmp eax,80
	jg next16
	push_stack x,y,320+169,240-18
	call hideline
	drawpixel_rosu  320+169,240-18
	push_stack x,y,320+170,240-0
	call drawline
	jmp end1
	
	next16:
	cmp eax,85
	jg next17
	push_stack x,y,320+170,240-0
	call hideline
	drawpixel_rosu  320+170,240-0
	push_stack x,y,320+169,240+18
	call drawline
	jmp end1
	
	next17:
	cmp eax,90
	jg next18
	push_stack x,y,320+169,240+18
	call hideline
	drawpixel_rosu  320+169,240+18
	push_stack x,y,320+166,240+35
	call drawline
	jmp end1
	
	next18:
	cmp eax,95
	jg next19
	push_stack x,y,320+166,240+35
	call hideline
	drawpixel_rosu  320+166,240+35
	push_stack x,y,320+162,240+53
	call drawline
	jmp end1
	
	next19:
	cmp eax,100
	jg next20
	push_stack x,y,320+162,240+53
	call hideline
	drawpixel_rosu  320+162,240+53
	push_stack x,y,320+155,240+69
	call drawline
	jmp end1
	
	next20:
	cmp eax,105
	jg next21
	push_stack x,y,320+155,240+69
	call hideline
	drawpixel_rosu  320+155,240+69
	push_stack x,y,320+147,240+85
	call drawline
	jmp end1
	
	next21:
	cmp eax,110
	jg next22
	push_stack x,y,320+147,240+85
	call hideline
	drawpixel_rosu  320+147,240+85
	push_stack x,y,320+138,240+100
	call drawline
	jmp end1
	
	next22:
	cmp eax,115
	jg next23
	push_stack x,y,320+138,240+100
	call hideline
	drawpixel_rosu  320+138,240+100
	push_stack x,y,320+126,240+114
	call drawline
	jmp end1
	
	next23:
	cmp eax,120
	jg next24
	push_stack x,y,320+126,240+114
	call hideline
	drawpixel_rosu  320+126,240+114
	push_stack x,y,320+114,240+126
	call drawline
	jmp end1
	
	next24:
	cmp eax,125
	jg next25
	push_stack x,y,320+114,240+126
	call hideline
	drawpixel_rosu  320+114,240+126
	push_stack x,y,320+100,240+138
	call drawline
	jmp end1
	
	next25:
	cmp eax,130
	jg next26
	push_stack x,y,320+100,240+138
	call hideline
	drawpixel_rosu  320+100,240+138
	push_stack x,y,320+85,240+147
	call drawline
	jmp end1
	
	next26:
	cmp eax,135
	jg next27
	push_stack x,y,320+85,240+147
	call hideline
	drawpixel_rosu  320+85,240+147
	push_stack x,y,320+69,240+155
	call drawline
	jmp end1
	
	next27:
	cmp eax,140
	jg next28
	push_stack x,y,320+69,240+155
	call hideline
	drawpixel_rosu  320+69,240+155
	push_stack x,y,320+53,240+162
	call drawline
	jmp end1
	
	next28:
	cmp eax,145
	jg next29
	push_stack x,y,320+53,240+162
	call hideline
	drawpixel_rosu  320+53,240+162
	push_stack x,y,320+35,240+166
	call drawline
	jmp end1
	
	next29:
	cmp eax,150
	jg next30
	push_stack x,y,320+35,240+166
	call hideline
	drawpixel_rosu  320+35,240+166
	push_stack x,y,320+18,240+169
	call drawline
	jmp end1
	
	next30:
	cmp eax,155
	jg next31
	push_stack x,y,320+18,240+169
	call hideline
	drawpixel_rosu  320+18,240+169
	push_stack x,y, 320-0,240+170
	call drawline
	jmp end1
	
	next31:
	cmp eax,160
	jg next32
	push_stack x,y,320-0,240+170
	call hideline
	drawpixel_rosu  320-0,240+170
	push_stack x,y, 320-18,240+169
	call drawline
	jmp end1
	
	next32:
	cmp eax,165
	jg next33
	push_stack x,y,320-18,240+169
	call hideline
	drawpixel_rosu  320-18,240+169
	push_stack x,y,320-35,240+166
	call drawline
	jmp end1
	
	next33:
	cmp eax,170
	jg next34
	push_stack x,y,320-35,240+166
	call hideline
	drawpixel_rosu  320-35,240+166
	push_stack x,y,320-53,240+162
	call drawline
	jmp end1
	
	next34:
	cmp eax,175
	jg next35
	push_stack x,y,320-53,240+162
	call hideline
	drawpixel_rosu  320-53,240+162
	push_stack x,y,320-69,240+155
	call drawline
	jmp end1
	
	next35:
	cmp eax,180
	jg next36
	push_stack x,y,320-69,240+155
	call hideline
	drawpixel_rosu  320-69,240+155
	push_stack x,y,320-85,240+147
	call drawline
	jmp end1
	
	next36:
	cmp eax,185
	jg next37
	push_stack x,y,320-85,240+147
	call hideline
	drawpixel_rosu  320-85,240+147
	push_stack x,y,320-100,240+138
	call drawline
	jmp end1
	
	next37:
	cmp eax,190
	jg next38
	push_stack x,y,320-100,240+138
	call hideline
	drawpixel_rosu  320-100,240+138
	push_stack x,y,320-114,240+126
	call drawline
	jmp end1
	
	next38:
	cmp eax,195
	jg next39
	push_stack x,y,320-114,240+126
	call hideline
	drawpixel_rosu  320-114,240+126
	push_stack x,y,320-126,240+114
	call drawline
	jmp end1
	
	next39:
	cmp eax,200
	jg next40
	push_stack x,y,320-126,240+114
	call hideline
	drawpixel_rosu  320-126,240+114
	push_stack x,y,320-138,240+100
	call drawline
	jmp end1
	
	next40:
	cmp eax,205
	jg next41
	push_stack x,y,320-138,240+100
	call hideline
	drawpixel_rosu  320-138,240+100
	push_stack x,y, 320-147,240+85
	call drawline
	jmp end1
	
	next41:
	cmp eax,210
	jg next42
	push_stack x,y,320-147,240+85
	call hideline
	drawpixel_rosu  320-147,240+85
	push_stack x,y,320-155,240+69
	call drawline
	jmp end1
	
	next42:
	cmp eax,215
	jg next43
	push_stack x,y,320-155,240+69
	call hideline
	drawpixel_rosu  320-155,240+69
	push_stack x,y,320-162,240+53
	call drawline
	jmp end1
	
	next43:
	cmp eax,220
	jg next44
	push_stack x,y,320-162,240+53
	call hideline
	drawpixel_rosu  320-162,240+53
	push_stack x,y,320-166,240+35
	call drawline
	jmp end1
	
	next44:
	cmp eax,225
	jg next45
	push_stack x,y,320-166,240+35
	call hideline
	drawpixel_rosu  320-166,240+35
	push_stack x,y,320-169,240+18
	call drawline
	jmp end1
	
	next45:
	cmp eax,230
	jg next46
	push_stack x,y,320-169,240+18
	call hideline
	drawpixel_rosu  320-169,240+18
	push_stack x,y,320-170,240+0
	call drawline
	jmp end1
	
	next46:
	cmp eax,235
	jg next47
	push_stack x,y,320-170,240+0
	call hideline
	drawpixel_rosu  320-170,240-0
	push_stack x,y,320-169,240-18
	call drawline
	jmp end1
	
	next47:
	cmp eax,240
	jg next48
	push_stack x,y,320-169,240-18
	call hideline
	drawpixel_rosu  320-169,240-18
	push_stack x,y,320-166,240-35
	call drawline
	jmp end1
	
	next48:
	cmp eax,245
	jg next49
	push_stack x,y,320-166,240-35
	call hideline
	drawpixel_rosu  320-166,240-35
	push_stack x,y,320-162,240-53
	call drawline
	jmp end1
	
	next49:
	cmp eax,250
	jg next50
	push_stack x,y,320-162,240-53
	call hideline
	drawpixel_rosu  320-162,240-53
	push_stack x,y,320-155,240-69
	call drawline
	jmp end1
	
	next50:
	cmp eax,255
	jg next51
	push_stack x,y,320-155,240-69
	call hideline
	drawpixel_rosu  320-155,240-69
	push_stack x,y,320-147,240-85
	call drawline
	jmp end1
	
	next51:
	cmp eax,260
	jg next52
	push_stack x,y,320-147,240-85
	call hideline
	drawpixel_rosu  320-147,240-85
	push_stack x,y,320-138,240-100
	call drawline
	jmp end1
	
	next52:
	cmp eax,265
	jg next53
	push_stack x,y,320-138,240-100
	call hideline
	drawpixel_rosu  320-138,240-100
	push_stack x,y,320-126,240-114
	call drawline
	jmp end1
	
	next53:
	cmp eax,270
	jg next54
	push_stack x,y,320-126,240-114
	call hideline
	drawpixel_rosu  320-126,240-114
	push_stack x,y,320-114,240-126
	call drawline
	jmp end1
	
	next54:
	cmp eax,275
	jg next55
	push_stack x,y,320-114,240-126
	call hideline
	drawpixel_rosu  320-114,240-126
	push_stack x,y,320-100,240-138
	call drawline
	jmp end1
	
	next55:
	cmp eax,280
	jg next56
	push_stack x,y,320-100,240-138
	call hideline
	drawpixel_rosu  320-100,240-138
	push_stack x,y,320-85,240-147
	call drawline
	jmp end1
	
	next56:
	cmp eax,285
	jg next57
	push_stack x,y,320-85,240-147
	call hideline
	drawpixel_rosu  320-85,240-147
	push_stack x,y,320-69,240-155
	call drawline
	jmp end1
	
	next57:
	cmp eax,290
	jg next58
	push_stack x,y,320-69,240-155
	call hideline
	drawpixel_rosu  320-69,240-155
	push_stack x,y,320-53,240-162
	call drawline
	jmp end1
	
	next58:
	cmp eax,295
	jg next59
	push_stack x,y,320-53,240-162
	call hideline
	drawpixel_rosu  320-53,240-162
	push_stack x,y,320-35,240-166
	call drawline
	jmp end1
	
	next59:
	cmp eax,300
	jg end1
	push_stack x,y,320-35,240-166
	call hideline
	drawpixel_rosu  320-35,240-166
	push_stack x,y,320-18,240-169
	call drawline
	jmp end1
	
	
	end1:
	
	popa
	mov esp, ebp
	pop ebp
	ret 4
	
	
minutes endp

go_back proc

push ebp
mov ebp, esp
pusha
	
	mov eax,[ebp+arg1]
	
	cmp eax,5
	jg next_1
	push_stack x,y,320+18,240-169
	call hideline
	drawpixel_rosu 320-18,240-169
	push_stack x,y,320,240-170
	call drawline
	jmp end1
	
	next_1:
	cmp eax,10
	jg next_2
	push_stack x,y,320,240-170
	call hideline
	drawpixel_rosu 320,240-170
	push_stack x,y,320-18,240-169
	call drawline
	jmp end1
	
	next_2:
	cmp eax,15
	jg next_3
	push_stack x,y,320-18,240-169
	call hideline
	drawpixel_rosu 320-18,240-169
	push_stack x,y,320-35,240-166
	call drawline
	jmp end1
	
	next_3:
	cmp eax,20
	jg next_4
	push_stack x,y,320-35,240-166
	call hideline
	drawpixel_rosu  320-35,240-166
	push_stack x,y , 320-53,240-162
	call drawline
	jmp end1
	
	next_4:
	cmp eax,25
	jg next_5
	push_stack x,y,320-53,240-162
	call hideline
	drawpixel_rosu  320-53,240-162
	push_stack x,y,320-69,240-155
	call drawline
	jmp end1
	
	next_5:
	cmp eax,30
	jg next_6
	push_stack x,y,320-69,240-155
	call hideline
	drawpixel_rosu  320-69,240-155
	push_stack x,y,320-85,240-147
	call drawline
	jmp end1
	
	next_6:
	cmp eax,35
	jg next_7
	push_stack x,y,320-85,240-147
	call hideline
	drawpixel_rosu  32085,240-147
	push_stack x,y,320-100,240-138
	call drawline
	jmp end1
	
	next_7:
	cmp eax,40
	jg next_8
	push_stack x,y,320-100,240-138
	call hideline
	drawpixel_rosu  320-100,240-138
	push_stack x,y,320-114,240-126
	call drawline
	jmp end1
	
	next_8:
	cmp eax,45
	jg next_9
	push_stack x,y,320-114,240-126
	call hideline
	drawpixel_rosu  320-114,240-126
	push_stack x,y,320-126,240-114
	call drawline
	jmp end1
	
	next_9:
	cmp eax,50
	jg next_10
	push_stack x,y,320-126,240-114
	call hideline
	drawpixel_rosu  320-126,240-114
	push_stack x,y,320-138,240-100
	call drawline
	jmp end1
	
	next_10:
	cmp eax,55
	jg next_11
	push_stack x,y,320-138,240-100
	call hideline
	drawpixel_rosu  320-138,240-100
	push_stack x,y,320-147,240-85
	call drawline
	jmp end1
	
	next_11:
	cmp eax,60
	jg next_12
	push_stack x,y,320-147,240-85
	call hideline
	drawpixel_rosu  320-147,240-85
	push_stack x,y,320-155,240-69
	call drawline
	jmp end1
	
	next_12:
	cmp eax,65
	jg next_13
	push_stack x,y,320-155,240-69
	call hideline
	drawpixel_rosu  320-155,240-69
	push_stack x,y,320-162,240-53
	call drawline
	jmp end1
	
	next_13:
	cmp eax,70
	jg next_14
	push_stack x,y,320-162,240-53
	call hideline
	drawpixel_rosu  320-162,240-53
	push_stack x,y,320-166,240-35
	call drawline
	jmp end1
	
	next_14:
	cmp eax,75
	jg next_15
	push_stack x,y,320-166,240-35
	call hideline
	drawpixel_rosu  320-166,240-35
	push_stack x,y,320-169,240-18
	call drawline
	jmp end1
	
	next_15:
	cmp eax,80
	jg next_16
	push_stack x,y,320-169,240-18
	call hideline
	drawpixel_rosu  320-169,240-18
	push_stack x,y,320-170,240-0
	call drawline
	jmp end1
	
	next_16:
	cmp eax,85
	jg next_17
	push_stack x,y,320-170,240-0
	call hideline
	drawpixel_rosu  320-170,240-0
	push_stack x,y,320-169,240+18
	call drawline
	jmp end1
	
	next_17:
	cmp eax,90
	jg next_18
	push_stack x,y,320-169,240+18
	call hideline
	drawpixel_rosu  320-169,240+18
	push_stack x,y,320-166,240+35
	call drawline
	jmp end1
	
	next_18:
	cmp eax,95
	jg next_19
	push_stack x,y,320-166,240+35
	call hideline
	drawpixel_rosu  320-166,240+35
	push_stack x,y,320-162,240+53
	call drawline
	jmp end1
	
	next_19:
	cmp eax,100
	jg next_20
	push_stack x,y,320-162,240+53
	call hideline
	drawpixel_rosu  320-162,240+53
	push_stack x,y,320-155,240+69
	call drawline
	jmp end1
	
	next_20:
	cmp eax,105
	jg next_21
	push_stack x,y,320-155,240+69
	call hideline
	drawpixel_rosu  320-155,240+69
	push_stack x,y,320-147,240+85
	call drawline
	jmp end1
	
	next_21:
	cmp eax,110
	jg next_22
	push_stack x,y,320-147,240+85
	call hideline
	drawpixel_rosu  320-147,240+85
	push_stack x,y,320-138,240+100
	call drawline
	jmp end1
	
	next_22:
	cmp eax,115
	jg next_23
	push_stack x,y,320-138,240+100
	call hideline
	drawpixel_rosu  320-138,240+100
	push_stack x,y,320-126,240+114
	call drawline
	jmp end1
	
	next_23:
	cmp eax,120
	jg next_24
	push_stack x,y,320-126,240+114
	call hideline
	drawpixel_rosu  320-126,240+114
	push_stack x,y,320-114,240+126
	call drawline
	jmp end1
	
	next_24:
	cmp eax,125
	jg next_25
	push_stack x,y,320-114,240+126
	call hideline
	drawpixel_rosu  320-114,240+126
	push_stack x,y,320-100,240+138
	call drawline
	jmp end1
	
	next_25:
	cmp eax,130
	jg next_26
	push_stack x,y,320-100,240+138
	call hideline
	drawpixel_rosu  320-100,240+138
	push_stack x,y,320-85,240+147
	call drawline
	jmp end1
	
	next_26:
	cmp eax,135
	jg next_27
	push_stack x,y,320-85,240+147
	call hideline
	drawpixel_rosu  320-85,240+147
	push_stack x,y,320-69,240+155
	call drawline
	jmp end1
	
	next_27:
	cmp eax,140
	jg next_28
	push_stack x,y,320-69,240+155
	call hideline
	drawpixel_rosu  320-69,240+155
	push_stack x,y,320-53,240+162
	call drawline
	jmp end1
	
	next_28:
	cmp eax,145
	jg next_29
	push_stack x,y,320-53,240+162
	call hideline
	drawpixel_rosu  320-53,240+162
	push_stack x,y,320-35,240+166
	call drawline
	jmp end1
	
	next_29:
	cmp eax,150
	jg next_30
	push_stack x,y,320-35,240+166
	call hideline
	drawpixel_rosu  320-35,240+166
	push_stack x,y,320-18,240+169
	call drawline
	jmp end1
	
	next_30:
	cmp eax,155
	jg next_31
	push_stack x,y,320-18,240+169
	call hideline
	drawpixel_rosu  320-18,240+169
	push_stack x,y, 320-0,240+170
	call drawline
	jmp end1
	
	next_31:
	cmp eax,160
	jg next_32
	push_stack x,y,320+0,240+170
	call hideline
	drawpixel_rosu  320+0,240+170
	push_stack x,y, 320+18,240+169
	call drawline
	jmp end1
	
	next_32:
	cmp eax,165
	jg next_33
	push_stack x,y,320+18,240+169
	call hideline
	drawpixel_rosu  320+18,240+169
	push_stack x,y,320+35,240+166
	call drawline
	jmp end1
	
	next_33:
	cmp eax,170
	jg next_34
	push_stack x,y,320+35,240+166
	call hideline
	drawpixel_rosu  320+35,240+166
	push_stack x,y,320+53,240+162
	call drawline
	jmp end1
	
	next_34:
	cmp eax,175
	jg next_35
	push_stack x,y,320+53,240+162
	call hideline
	drawpixel_rosu  320+53,240+162
	push_stack x,y,320+69,240+155
	call drawline
	jmp end1
	
	next_35:
	cmp eax,180
	jg next_36
	push_stack x,y,320+69,240+155
	call hideline
	drawpixel_rosu  320+69,240+155
	push_stack x,y,320+85,240+147
	call drawline
	jmp end1
	
	next_36:
	cmp eax,185
	jg next_37
	push_stack x,y,320+85,240+147
	call hideline
	drawpixel_rosu  320+85,240+147
	push_stack x,y,320+100,240+138
	call drawline
	jmp end1
	
	next_37:
	cmp eax,190
	jg next_38
	push_stack x,y,320+100,240+138
	call hideline
	drawpixel_rosu  320+100,240+138
	push_stack x,y,320+114,240+126
	call drawline
	jmp end1
	
	next_38:
	cmp eax,195
	jg next_39
	push_stack x,y,320+114,240+126
	call hideline
	drawpixel_rosu  320+114,240+126
	push_stack x,y,320+126,240+114
	call drawline
	jmp end1
	
	next_39:
	cmp eax,200
	jg next_40
	push_stack x,y,320+126,240+114
	call hideline
	drawpixel_rosu  320+126,240+114
	push_stack x,y,320+138,240+100
	call drawline
	jmp end1
	
	next_40:
	cmp eax,205
	jg next_41
	push_stack x,y,320+138,240+100
	call hideline
	drawpixel_rosu  320+138,240+100
	push_stack x,y, 320+147,240+85
	call drawline
	jmp end1
	
	next_41:
	cmp eax,210
	jg next_42
	push_stack x,y,320+147,240+85
	call hideline
	drawpixel_rosu  320+147,240+85
	push_stack x,y,320+155,240+69
	call drawline
	jmp end1
	
	next_42:
	cmp eax,215
	jg next_43
	push_stack x,y,320+155,240+69
	call hideline
	drawpixel_rosu  320+155,240+69
	push_stack x,y,320+162,240+53
	call drawline
	jmp end1
	
	next_43:
	cmp eax,220
	jg next_44
	push_stack x,y,320+162,240+53
	call hideline
	drawpixel_rosu  320+162,240+53
	push_stack x,y,320+166,240+35
	call drawline
	jmp end1
	
	next_44:
	cmp eax,225
	jg next_45
	push_stack x,y,320+166,240+35
	call hideline
	drawpixel_rosu  320+166,240+35
	push_stack x,y,320+169,240+18
	call drawline
	jmp end1
	
	next_45:
	cmp eax,230
	jg next_46
	push_stack x,y,320+169,240+18
	call hideline
	drawpixel_rosu  320+169,240+18
	push_stack x,y,320+170,240+0
	call drawline
	jmp end1
	
	next_46:
	cmp eax,235
	jg next_47
	push_stack x,y,320+170,240+0
	call hideline
	drawpixel_rosu  320+170,240-0
	push_stack x,y,320+169,240-18
	call drawline
	jmp end1
	
	next_47:
	cmp eax,240
	jg next_48
	push_stack x,y,320+169,240-18
	call hideline
	drawpixel_rosu  320+169,240-18
	push_stack x,y,320+166,240-35
	call drawline
	jmp end1
	
	next_48:
	cmp eax,245
	jg next_49
	push_stack x,y,320+166,240-35
	call hideline
	drawpixel_rosu  320+166,240-35
	push_stack x,y,320+162,240-53
	call drawline
	jmp end1
	
	next_49:
	cmp eax,250
	jg next_50
	push_stack x,y,320+162,240-53
	call hideline
	drawpixel_rosu  320+162,240-53
	push_stack x,y,320+155,240-69
	call drawline
	jmp end1
	
	next_50:
	cmp eax,255
	jg next_51
	push_stack x,y,320+155,240-69
	call hideline
	drawpixel_rosu  320+155,240-69
	push_stack x,y,320+147,240-85
	call drawline
	jmp end1
	
	next_51:
	cmp eax,260
	jg next_52
	push_stack x,y,320+147,240-85
	call hideline
	drawpixel_rosu  320+147,240-85
	push_stack x,y,320+138,240-100
	call drawline
	jmp end1
	
	next_52:
	cmp eax,265
	jg next_53
	push_stack x,y,320+138,240-100
	call hideline
	drawpixel_rosu  320+138,240-100
	push_stack x,y,320+126,240-114
	call drawline
	jmp end1
	
	next_53:
	cmp eax,270
	jg next_54
	push_stack x,y,320+126,240-114
	call hideline
	drawpixel_rosu  320+126,240-114
	push_stack x,y,320+114,240-126
	call drawline
	jmp end1
	
	next_54:
	cmp eax,275
	jg next_55
	push_stack x,y,320+114,240-126
	call hideline
	drawpixel_rosu  320+114,240-126
	push_stack x,y,320+100,240-138
	call drawline
	jmp end1
	
	next_55:
	cmp eax,280
	jg next_56
	push_stack x,y,320+100,240-138
	call hideline
	drawpixel_rosu  320+100,240-138
	push_stack x,y,320+85,240-147
	call drawline
	jmp end1
	
	next_56:
	cmp eax,285
	jg next_57
	push_stack x,y,320+85,240-147
	call hideline
	drawpixel_rosu  320+85,240-147
	push_stack x,y,320+69,240-155
	call drawline
	jmp end1
	
	next_57:
	cmp eax,290
	jg next_58
	push_stack x,y,320+69,240-155
	call hideline
	drawpixel_rosu  320+69,240-155
	push_stack x,y,320+53,240-162
	call drawline
	jmp end1
	
	next_58:
	cmp eax,295
	jg next_59
	push_stack x,y,320+53,240-162
	call hideline
	drawpixel_rosu  320+53,240-162
	push_stack x,y,320+35,240-166
	call drawline
	jmp end1
	
	next_59:
	cmp eax,300
	jg end1
	push_stack x,y,320+35,240-166
	call hideline
	drawpixel_rosu  320+35,240-166
	push_stack x,y,320+18,240-169
	call drawline
	jmp end1
	
	
	end1:
	
	popa
	mov esp, ebp
	pop ebp
	ret 4
	
	
go_back endp



; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	;jz evt_click
	jz evt_timer
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	
	push eax							
	push 0
	push area
	call memset			;ecran alb
	add esp, 12
	jmp final_draw
	
;evt_click:	;NU AM NEVOIE
	
	;jmp final_draw
	
evt_timer:
	
	mov x,320
	mov y,240
	mov r,200
	draw_layout ; face cerc, ore, minute, NUMELE
	
	
	
	call get_time ; ia timpul de la PC
	
	mov eax,25
	mov ebx,h
	mul ebx
	inc eax
	mov counter_ora,eax
	
	mov eax,m
	mov ebx,12
	mov edx,0
	div ebx
	mov ebx,5
	mul ebx
	add counter_ora,eax   ;rezolva orele
	
	cmp counter_ora,300
	jl no_init_ora
	sub counter_ora,300
	
	no_init_ora:
	
	
	
	mov eax,5
	mov ebx,s
	mul ebx
	inc eax
	mov counter_sec,eax	;rezolva secundele
	
	mov eax,5
	mov ebx,m
	mul ebx
	inc eax
	mov counter,eax	;rezolva minutele
	
	
	push counter
	call minutes
	
	push counter_sec
	call minutes
	
	push counter_ora
	call minutes
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp




start:


	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	
	
	stop:
	;terminarea programului
	push 0
	call exit
end start
