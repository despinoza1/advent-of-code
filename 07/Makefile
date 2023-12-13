default:
	nasm -f elf64 -g -o soln.o soln.asm
	ld -o soln soln.o -I/lib64/ld-linux-x86-64.so.2
	./soln > test.bin

clean:
	rm soln.o
