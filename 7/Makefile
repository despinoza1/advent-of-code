default:
	nasm -f elf64 -o soln.o soln.asm
	ld -o soln soln.o -I/lib64/ld-linux-x86-64.so.2
	rm soln.o
	./soln

