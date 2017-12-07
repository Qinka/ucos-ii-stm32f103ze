/**
 * USART for logger
 * 
 * 
 */


#define _LOGGER_C_

#include <logger.h>

void logger_init(void)
{
  GPIO_InitTypeDef dps_t_gpio_i_s = {.GPIO_Pin = _DPS_PIN_TX_,
                                     .GPIO_Mode = GPIO_Mode_AF_PP,
                                     .GPIO_Speed = GPIO_Speed_50MHz};
  USART_InitTypeDef dps_uart_i_s = {.USART_BaudRate = _DPS_BAUDRATE_,
                                    .USART_WordLength = USART_WordLength_8b,
                                    .USART_StopBits = USART_StopBits_1,
                                    .USART_Parity = USART_Parity_No,
                                    .USART_Mode = USART_Mode_Tx,
                                    .USART_HardwareFlowControl =
                                        USART_HardwareFlowControl_None};
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
  _DPS_PORT_CLK_F_(_DPS_PORT_CLK_, ENABLE);
  _DPS_CLK_F_(_DPS_CLK_, ENABLE);
  GPIO_Init(_DPS_PORT_TX_, &dps_t_gpio_i_s);
  USART_Init(_DPS_UART_, &dps_uart_i_s);
  USART_Cmd(_DPS_UART_, ENABLE);
}

/**
 * put_char
 * [wait]
 */
void put_char(char c)
{
  while (USART_GetFlagStatus(_DPS_UART_, USART_FLAG_TC) == RESET)
    ;
  USART_SendData(_DPS_UART_, c);
}

/**
 * put_hex_uint8_t
 */
static void put_hex_u8(uint8_t i)
{
  char high = 0xF & (i >> 4);
  char low = 0xF & i;
  _DIGIT_HEX(high);
  _DIGIT_HEX(low);
  put_char(high);
  put_char(low);
}


/**
 * put a unix time
 * wait
 */
void put_unix_time()
{
  uint32_t time_stamp = RTC->CNTH;
  time_stamp <<= 16;
  time_stamp |= RTC->CNTL;
  int i = 0;
  while (i < 8)
  {
    put_hex_u8(time_stamp & 0xFF);
    time_stamp >>= 8;
    ++i;
  }
}
