for3:
		pusha
		push [esi+ebx]
		push offset format_int_no_endl
		call printf
		add esp,8
		popa
		
		pusha
		
		push [esi+ebx]
		call nr_div_prim
		
		
		pusha
		push eax
		push offset format_int
		call printf
		add esp,8
		popa
		
		popa
		
		add ebx,4
	
	loop for3