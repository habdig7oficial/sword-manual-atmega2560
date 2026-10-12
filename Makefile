lib:
	cd sword && avr-gcc -mmcu=atmega2560 lib.c -c -o ../bin/lib.o
stub:
	cd sword && gcc stub.c -c -o ../bin/stub.o
sword: lib
	cd sword && shield main.sword --link lib.o stub.o -o main && ./main


# Generates manual llvm ir 
emit-llvm: lib
	shield ./sword/ --link lib.o --emit-llvm > ./bin/main.ll

# Verifies the manual llvm ir
verify:
	cd ./bin && opt -p=verify main.ll -S -o main.verified.ll

# Manually optimizes the llvm ir
optimize:
	cd ./bin && opt -O2 main.verified.ll -S -o main.opt.ll

# Generates the object file based on the optimized llvm
# sugestion to add flags directly to clang as --target and --mmcu
genO:
	# llc -mtriple=riscv32-unknown-none-elf -mcpu=generic-rv32 -mattr=+m,+c -filetype=obj main.opt.ll -o main.o
	cd ./bin && clang --target=avr -mmcu=atmega2560 -c main.opt.ll -o main.o


DEVICE = $(shell ls /dev/cu.usbserial-*)

all: emit-llvm verify optimize genO
	# Link sword with C entrypoint
	avr-gcc -mmcu=atmega2560 arduino.c bin/lib.o bin/main.o -o debug.elf 

	# Generates arduino .hex format
	avr-objcopy -O ihex -R .eeprom debug.elf debug.hex

 	# Flashes to the arduino
	avrdude -p m2560 -c wiring -P $(DEVICE) -b 115200 -D -U flash:w:debug.hex:i

	# Open Serial Monitor for debug
	screen $(DEVICE) 9600 

