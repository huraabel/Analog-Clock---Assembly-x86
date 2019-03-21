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
window_title DB "CEAS ANALOG - HURA ABEL JONATHAN",0
area_width EQU  640 ;900
area_height EQU 480;600
area DD 0

x dd 450
y dd 300
r dd 280

x_1 dd 0 
y_1 dd 0

int_y dd 0
int_x dd 0

d_x dd 0
d_y dd 0
d_mare dd 0

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
deltax dd 0
deltay dd 0
deltaerr dd 0 
real_error dd 0.0


albv dd 1

counter DD 0 ; numara evenimentele de tip timer

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

draw_point_macro macro drawArea, x, y
	push eax
	push ebx
	push ecx
	push edx
	
	mov eax, 0
	mov eax, x
	mov ebx, 640
	mul ebx
	add eax, y
	shl eax, 2
	mov ebx, drawArea
	mov dword ptr [ebx+eax], 000000h
	mov dword ptr [ebx+eax+2560], 000000h
	mov dword ptr [ebx+eax+2560+2560], 000000h
	mov dword ptr [ebx+eax+2560+2560+2560], 000000h
	mov dword ptr [ebx+eax+4], 000000h
	mov dword ptr [ebx+eax+4+2560], 000000h
	mov dword ptr [ebx+eax+4+2560+2560], 000000h
	mov dword ptr [ebx+eax+4+2560+2560+2560], 000000h
	mov dword ptr [ebx+eax+8], 000000h
	mov dword ptr [ebx+eax+8+2560], 000000h
	mov dword ptr [ebx+eax+8+2560+2560], 0000ffh
	mov dword ptr [ebx+eax+8+2560+2560+2560], 000000h
	mov dword ptr [ebx+eax+12], 000000h
	mov dword ptr [ebx+eax+12+2560], 000000h
	mov dword ptr [ebx+eax+12+2560+2560], 0000ffh
	mov dword ptr [ebx+eax+12+2560+2560+2560], 000000h

	pop edx
	pop ecx
	pop ebx
	pop eax
endm


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

ABSDivide2NumbersAndAssign macro d ,a,b
	local negativ_a,pozitiv_a,,negativ_b,pozitiv_b,final
	
	mov eax,[a]
	mov ecx,[b]
	
	cmp eax,0
	jl negativ_a
	jmp pozitiv_a
	negativ_a:
	mov ebx,-1
	mul ebx
	pozitiv_a:
	
	cmp ecx,0
	jl negativ_b
	jmp pozitiv_b
	negativ_b:
	push eax
	mov eax,ecx
	mov ebx,-1
	mul ebx
	mov ecx,eax
	pop eax
	pozitiv_b:
	
	mov edx,0
	div ecx
	
	final:
	mov [d],eax
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

DrawPixel_alb macro x, y
    
   
	mov eax,[y]; pui y
	mov ebx,area_width	;pui latimea
	mul ebx	; eax= eax*ebx
	add eax,[x] ; eax pls x
	
	shl eax,2 ; pt ca dword == *4
	add eax,area
	
	mov dword ptr[eax],0fffffffh
	
endm

DrawPixel_rosu macro x, y
    
   
	mov eax,[y]; pui y
	mov ebx,area_width	;pui latimea
	mul ebx	; eax= eax*ebx
	add eax,[x] ; eax pls x
	
	shl eax,2 ; pt ca dword == *4
	add eax,area
	
	mov dword ptr[eax],0ff0000h
	
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

	
drawline macro x1,y1,x2,y2
local d_x_greater,d_y_greater,zero,not_zero,d_y_greater_than_d_x,dx_greater_dxer,dy_greater_dyer,for_loop1,for_loop2
;int_x,int_y =curentx/y
;d_x,d_y= Dx,Dy
;two_dx, two_dy
;xi,yi = increment
; dx_er, dy_er = errors

;begin
	
	
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


endm

hideline macro x1,y1,x2,y2
local d_x_greater,d_y_greater,zero,not_zero,d_y_greater_than_d_x,dx_greater_dxer,dy_greater_dyer,for_loop1,for_loop2
;int_x,int_y =curentx/y
;d_x,d_y= Dx,Dy
;two_dx, two_dy
;xi,yi = increment
; dx_er, dy_er = errors

;begin
	
	
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
	
	drawpixel_negru x1,y1
	

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
				
			drawpixel_negru int_x,int_y
		
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
			
			drawpixel_negru int_x,int_y
		
		compare2variables int_y,y2
		jne for_loop2
		
	
	zero:


endm

draw_layout macro 
	
	drawpixel_alb x,y ; centru
	drawcircle x,y,r
	
	;ore
	drawpixel_alb 415,75	;1 
	drawpixel_alb 485,145	;2
	drawpixel_alb 510,240	;3
	drawpixel_alb 485,335	;4
	drawpixel_alb 415,405	;5
	drawpixel_alb 320,430	;6
	drawpixel_alb 225,405	;7
	drawpixel_alb 155,335	;8
	drawpixel_alb 130,240	;9
	drawpixel_alb 155,145	;10
	drawpixel_alb 225,75	;11
	drawpixel_alb 320,50	;12
	
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
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	
	push eax							;ma intereseaza doar timer la clock
	push 0
	push area
	call memset			;ecran alb
	add esp, 12
	jmp final_draw
	
evt_click:	
	
	jmp final_draw
	
evt_timer:
	
	mov x,320
	mov y,240
	mov r,200
	draw_layout ; face cerc, ore, minute
	
	make_text_macro 'H',area,550,400
	make_text_macro 'U',area,560,400
	make_text_macro 'R',area,570,400
	make_text_macro 'A',area,580,400
	
	
	
	
	drawline x,y , 320+0,240-170	;0
	drawline x,y , 320+18,240-169	;1
	drawline x,y , 320+35,240-166	;2
	drawline x,y , 320+53,240-162
	drawline x,y , 320+69,240-155
	drawline x,y , 320+85,240-147
	drawline x,y , 320+100,240-138
	drawline x,y , 320+114,240-126
	drawline x,y , 320+126,240-114
	drawline x,y , 320+138,240-100
	drawline x,y , 320+147,240-85
	drawline x,y , 320+155,240-69
	drawline x,y , 320+162,240-53
	drawline x,y , 320+166,240-35
	drawline x,y , 320+169,240-18
	drawline x,y , 320+170,240-0
	drawline x,y , 320+169,240+18
	drawline x,y , 320+166,240+35
	drawline x,y , 320+162,240+53
	drawline x,y , 320+155,240+69
	drawline x,y , 320+147,240+85
	drawline x,y , 320+138,240+100
	drawline x,y , 320+126,240+114
	drawline x,y , 320+114,240+126
	drawline x,y , 320+100,240+138
	drawline x,y , 320+85,240+147
	drawline x,y , 320+69,240+155
	drawline x,y , 320+53,240+162
	drawline x,y , 320+35,240+166
	drawline x,y , 320+18,240+169
	drawline x,y , 320-0,240+170
	drawline x,y , 320-18,240+169
	drawline x,y , 320-35,240+166
	drawline x,y , 320-53,240+162
	drawline x,y , 320-69,240+155
	drawline x,y , 320-85,240+147
	drawline x,y , 320-100,240+138
	drawline x,y , 320-114,240+126
	drawline x,y , 320-126,240+114
	drawline x,y , 320-138,240+100
	drawline x,y , 320-147,240+85
	drawline x,y , 320-155,240+69
	drawline x,y , 320-162,240+53
	drawline x,y , 320-166,240+35
	drawline x,y , 320-169,240+18
	drawline x,y , 320-170,240-0
	drawline x,y , 320-169,240-18
	drawline x,y , 320-166,240-35
	drawline x,y , 320-162,240-53
	drawline x,y , 320-155,240-69
	drawline x,y , 320-147,240-85
	drawline x,y , 320-138,240-100
	drawline x,y , 320-126,240-114
	drawline x,y , 320-114,240-126
	drawline x,y , 320-100,240-138
	drawline x,y , 320-85,240-147
	drawline x,y , 320-69,240-155
	drawline x,y , 320-53,240-162
	drawline x,y , 320-35,240-166
	drawline x,y , 320-18,240-169	;59
	
	
	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

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




start:

	call get_time
	
	
	
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
