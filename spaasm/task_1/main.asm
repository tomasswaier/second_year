section  .data
filename db 'example.txt', 0; The name of the file to open

section .bss
buffer  resb 512; Reserve space for the buffer (512 bytes)

section .text
global  main; Entry point for the program

main:
	;       Open the file (sys_open)
	mov     rax, 2; sys_open system call number (2)
	mov     rdi, filename; Pointer to the file name (example.txt)
	mov     rsi, 0; Flags: O_RDONLY (read-only)
	mov     rdx, 0; Mode (not needed for read-only)
	syscall ; Make the system call
	mov     rdi, rax; Store the file descriptor in rdi

	; Read the entire file (sys_read)

read_file:
	mov     rax, 0; sys_read system call number (0)
	mov     rsi, buffer; Pointer to the buffer
	mov     rdx, 512; Number of bytes to read (buffer size)
	syscall ; Make the system call

	;   Store the number of bytes read in rcx
	mov rcx, rax; Store the number of bytes read in rcx

	;       Write the content to stdout (sys_write)
	mov     rax, 1; sys_write system call number (1)
	mov     rsi, buffer+7
	mov     rdi, 1; File descriptor 1 (stdout)
	mov     rdx, 8; Use the number of bytes read from the buffer (stored in rcx)
	syscall ; Make the system call

	;test rax, rax; Check if any bytes were read
	;jz   close_file; If no bytes were read (end of file), exit

close_file:
	;       Close the file (sys_close)
	mov     rax, 3; sys_close system call number (3)
	syscall ; Make the system call

exit:
	mov     rax, 60; system call for exit
	xor     rdi, rdi; exit code 0
	syscall ; invoke operating system to exit

	section .data
