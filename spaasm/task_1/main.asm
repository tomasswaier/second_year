section   .data
filename  db 'double.txt', 0; The name of the file to open
;filename db 'single.txt', 0; The name of the file to open
message   db 'closing', 10
fmt       db "%d", 10, 0; Format string "%d\n" (newline included)
newline   db 10

section .bss
buffer  resb 512; Reserve space for the buffer (512 bytes)
current_buffer resb 512;for storing a string
prev_buffer resb 512;for storing prev string
num_buffer resb 20

section .text
global  main; Entry point for the program
extern  printf

main:
	;       Open the file (sys_open)
	mov     rax, 2; sys_open system call number (2)
	mov     rdi, filename; Pointer to the file name
	mov     rsi, 0; Flags: O_RDONLY (read-only)
	mov     rdx, 0; Mode (not needed for read-only)
	syscall ; Make the system call

	test rax, rax; Check if file opened successfully
	js   exit; If error (rax < 0), exit program

	mov rdi, rax; Store file descriptor in rdi
	mov r12, 0; Initialize buffer index
	mov r14, 0; pointer in current_buffer
	mov r15, 0; pointer in prev_buffer

	jmp load_file; Jump to read the file

load_file:
	;       Read from the file (sys_read)
	mov     rax, 0; sys_read system call number (0)
	mov     rsi, buffer; Pointer to the buffer
	mov     rdx, 512; Number of bytes to read (buffer size)
	syscall ; Make the system call

	test rax, rax; Check if EOF (0 bytes read) or error (-1)
	jle  close_file; If 0 or negative, close and exit

	mov r13, rax; Store number of bytes read
	jmp read_file_by_char

read_file_by_char:
	cmp byte [buffer +r12], 10
	je  cmp_strings

	cmp r12, r13; Compare index with bytes read
	jge close_file; If index >= bytes read, close the file

	;lea     rsi, [buffer + r12]; Load address of buffer[r12]
	;mov     rax, 1; sys_write syscall
	;mov     rdi, 1; File descriptor (stdout)
	;mov     rdx, 1; Print 1 byte
	;syscall ; Make the system call

	;     Append the current character to the output buffer
	lea   rdi, [current_buffer + r14]; Address of current_buffer[r13]
	mov   al, [buffer + r12]; Load the character from the input buffer
	mov   [rdi], al; Store the character in the output buffer
	inc   r12; Move to the next character
	inc   r14; Increment the output buffer index
	mov   rax, r12; debug thing for printing the position of pointer
	;call print_number; meow
	jmp   read_file_by_char

cmp_strings:
	cmp r14, r15
	jne prepare_copy

prepare_copy:
	mov rdi, prev_buffer; Destination buffer (prev_buffer)
	mov rsi, current_buffer; Source buffer (current_buffer)
	mov rcx, r14
	mov r15, r14
	jmp copy_buffer

copy_buffer:
	mov al, [rsi]; Load byte from current_buffer
	mov [rdi], al; Store byte in prev_buffer
	inc rsi; Move to next byte in current_buffer
	inc rdi; Move to next byte in prev_buffer
	dec rcx
	jnz copy_buffer; Repeat until all bytes are copied

	; After copy, reset current_buffer

	;   Append the newline to current_buffer
	mov rdi, current_buffer; Destination (current_buffer)
	mov rcx, 512; Size of buffer
	xor rax, rax; Set AL to 0
	rep stosb; Fill buffer with 0s

	mov r14, 0; Reset index in current_buffer

	;   Print the current_buffer
	jmp print_message

print_message:
	inc  r15
	;mov byte [prev_buffer+r15], 10
	inc  r15
	mov  rax, 1; system call for write
	mov  rdi, 1; file handle 1 is stdout
	mov  rsi, prev_buffer; address of string to output
	mov  rdx, r15; number of bytes
	syscall
	mov  rax, 1; system call for write
	mov  rdi, 1; file handle 1 is stdout
	mov  rsi, newline; address of string to output
	mov  rdx, 1; number of bytes
	syscall
	mov  r14, 0
	inc  r14
	inc  r12
	jmp  read_file_by_char

close_file:
	mov     rax, 1; system call for write
	mov     rdi, 1; file handle 1 is stdout
	mov     rsi, message; address of string to output
	mov     rdx, 8; number of bytes
	syscall
	;       Close the file (sys_close)
	mov     rax, 3; sys_close system call number (3)
	mov     rdi, rdi; File descriptor (stored in rdi)
	syscall ; Make the system call

exit:
	mov     rax, 60; System call for exit
	xor     rdi, rdi; Exit code 0
	syscall ; Invoke operating system to exit

	; debug functions

print_number:
	sub rsp, 8; Align stack (System V ABI requires 16-byte alignment)

	mov  rdi, fmt; 1st argument: format string
	mov  rsi, rax; 2nd argument: integer to print
	xor  rax, rax; Clear rax (printf uses it for float handling)
	call printf; Call printf

	add rsp, 8; Restore stack alignment
	ret

;test rax, rax; Check if any bytes were read
;jz   close_file; If no bytes were read (end of file), exit
