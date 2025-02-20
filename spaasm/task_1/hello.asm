	; ----------------------------------------------------------------------------------------
	; Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
	; To assemble and run:

	;   nasm -felf64 hello.asm && ld hello.o && ./a.out
	;   ----------------------------------------------------------------------------------------
	cmp rax, 42
	jl  yes
	mov rbx, 0
	jmp ex

yes:
	mov rbx, 1

ex:
