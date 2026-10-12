lib:
	cd sword && avr-gcc -mmcu=atmega2560 lib.c -c -o ../bin/lib.o
stub:
	cd sword && gcc stub.c -c -o ../bin/stub.o
sword: lib
	cd sword && shield main.sword --link lib.o stub.o -o main && ./main

emit-llvm: lib
	shield ./sword/ --link lib.o --emit-llvm > ./bin/main.ll


verify:
	cd ./bin && opt -p=verify main.ll -S -o main.verified.ll

optimize:
	cd ./bin && opt -O2 main.verified.ll -S -o main.opt.ll

genO:
	# llc -mtriple=riscv32-unknown-none-elf -mcpu=generic-rv32 -mattr=+m,+c -filetype=obj main.opt.ll -o main.o
	cd ./bin && clang --target=avr -mmcu=atmega2560 -c main.opt.ll -o main.o


DEVICE = $(shell ls /dev/cu.usbserial-*)

all: emit-llvm verify optimize genO
	avr-gcc -mmcu=atmega2560 arduino.c bin/lib.o bin/main.o -o debug.elf
	avr-objcopy -O ihex -R .eeprom debug.elf debug.hex
	avrdude -p m2560 -c wiring -P $(DEVICE) -b 115200 -D -U flash:w:debug.hex:i
	#screen $(DEVICE) 9600

