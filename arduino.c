#define F_CPU 16000000UL
#include <avr/io.h>
#include <stdio.h>
#include <stdint.h>

#define BAUD 9600
#define UBRR_VAL ((F_CPU / (16UL * BAUD)) - 1)

// Declare external LLVM IR function
extern uint8_t res_one(void) __asm__("main.ResOne");

// Stub for panic required by LLVM IR
void sword_panic(const char *msg, uint64_t len) {
    while (1);
}

// Low-level character output for printf
static int uart_putchar(char c, FILE *stream) {
    if (c == '\n') {
        uart_putchar('\r', stream); // Auto-append carriage return for terminal
    }
    while (!(UCSR0A & (1 << UDRE0)));
    UDR0 = c;
    return 0;
}

// Global stream bound to uart_putchar
static FILE uart_stdout = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);

void serial_begin(void) {
    UBRR0H = (unsigned char)(UBRR_VAL >> 8);
    UBRR0L = (unsigned char)(UBRR_VAL);
    UCSR0B = (1 << TXEN0);                  // Enable Tx
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // 8-bit mode
    
    stdout = &uart_stdout;                  // Redirect stdout to UART
}

int main(void) {
    serial_begin(); // Call once at setup

    // Now you can use printf() anywhere like Serial.print()!
    DDRB |= (1 << PB0);
    PORTB |= (1 << PB0);

    

    while (1)
        printf("The result was %d\n", res_one());
    return 0;
}