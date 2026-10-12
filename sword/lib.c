#include <avr/io.h>
#include <stdint.h>

#include <util/delay.h>

/* Acess pins provided by avr-gcc avr/io.h */
void pin_up(uint8_t pin){
    DDRB |= (1 << pin);
    PORTB |= (1 << pin);
}

void pin_down(uint8_t pin){
    PORTB &= ~(1 << pin);
}

void delay(double __ms){
    _delay_ms(__ms);
}