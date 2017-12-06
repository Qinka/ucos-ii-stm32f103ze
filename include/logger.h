/**
 * Usart header file for logger
 * 
 */

#ifndef _LOGGER_H_
#define _LOGGER_H_ 

#include <stm32f10x_usart.h>
#include <stm32f10x_rcc.h>
#include <stm32f10x_gpio.h>
#include <misc.h>

#define _DIGIT_HEX(x) (x += x > 9 ? '7' : '0')

/**
 * logger init
 */
void logger_init(void);
/**
 * put a char
 */
void put_char(char);
/**
 * put a string
 */
void put_str(const char *);
/**
 * put a byte in hex
 */
void put_hex_u8(uint8_t);
/**
 * put a unix time stamp
 */
void put_unix_time();
/**
 * put a string with new line
 */
void put_str_ln(const char *);

void put_with_unix_time(const char* p);

void put_with_unix_time_ln(const char* p);

/// register for UART
#define _DPS_UART_ UART5
/// baud rate for UART
#define _DPS_BAUDRATE_ (9600)
/// The send pin for UART
#define _DPS_PIN_TX_ GPIO_Pin_12
/// The send pin's port for UART
#define _DPS_PORT_TX_ GPIOC
/// The receive pin for UART
#define _DPS_PIN_RX_ GPIO_Pin_2
/// The receive pin's port for UART
#define _DPS_PORT_RX_ GPIOD
/// The port's clocks
#define _DPS_PORT_CLK_ (RCC_APB2Periph_GPIOC | RCC_APB2Periph_GPIOD)
/// The function for initializing the clocks
#define _DPS_PORT_CLK_F_ RCC_APB2PeriphClockCmd
/// The clock for UART
#define _DPS_CLK_ RCC_APB1Periph_UART5
/// The clock for initializing the clock of UART
#define _DPS_CLK_F_ RCC_APB1PeriphClockCmd
/// The IRQ of UART
#define _DPS_IRQ_ UART5_IRQn
/// The fucntion name of handler of interrupt
#define _DPS_IRQHandler UART5_IRQHandler


#endif // !_LOGGER_H_