	; ----------------------------------------------------------------------------------------
	; Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
	; To assemble and run:

	; nasm -felf64 hello.asm && ld hello.o && ./a.out
	; ----------------------------------------------------------------------------------------

	global _start; define that I start at _start

	section .data

message:
	db 'hello, world!', 10; define my message

	section .text

_start:
	mov rax, 1; set sys call num to rax
	mov rdi, 1; set the destination to be output
	mov rsi, message; set readin gindex to be input
	mov rdx, 14; read 14 characters
	syscall
	mov rax, 60; sysexit
	xor rdi, rdi; code 0
	syscall
