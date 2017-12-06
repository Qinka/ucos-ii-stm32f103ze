
#ifndef _RTC_H_
#define _RTC_H_

#include <stm32f10x_rcc.h>
#include <stm32f10x_rtc.h>
#include <stm32f10x_bkp.h>

/// Initialize the RTC
void rtc_init(void);

#endif // !_RTC_H_