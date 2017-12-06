#include <ucos_ii.h>
#include <misc.h>
#include <stm32f10x_gpio.h>
#include <stm32f10x_rcc.h>
#include <rtc.h>
#include <logger.h>


#define START_TASK_PRIO         10 
#define START_STK_SIZE          64 
OS_STK START_TASK_STK[START_STK_SIZE];
void start_task(void *pdata);  

#define LED0_TASK_PRIO          7  
#define LED0_STK_SIZE          64 
OS_STK LED0_TASK_STK[LED0_STK_SIZE];
void led0_task(void *pdata); 

#define LED1_TASK_PRIO          6  
#define LED1_STK_SIZE          64 
OS_STK LED1_TASK_STK[LED1_STK_SIZE];
void led1_task(void *pdata); 

void led_init();
#define LED0_OFF  GPIO_SetBits(GPIOB,GPIO_Pin_5)
#define LED1_OFF  GPIO_SetBits(GPIOB,GPIO_Pin_1)
#define LED0_ON GPIO_ResetBits(GPIOB,GPIO_Pin_5)
#define LED1_ON GPIO_ResetBits(GPIOB,GPIO_Pin_1)

int main()
{
  rtc_init();
  logger_init();
  led_init();
  //NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); 
  OS_CPU_SysTickInit(10000);
  OSInit();
  put_with_unix_time_ln("system initialized");
  OSTaskCreate(start_task,(void*)0,(OS_STK*)&START_TASK_STK[START_STK_SIZE-1],START_TASK_PRIO);
  OSStart();
}

void start_task(void *pdata) {
  OS_CPU_SR cpu_sr=0;
  pdata = pdata;
  OS_ENTER_CRITICAL();
  OSTaskCreate(led0_task,(void *)0,(OS_STK*)&LED0_TASK_STK[LED0_STK_SIZE-1],LED0_TASK_PRIO);
  OSTaskCreate(led1_task,(void *)0,(OS_STK*)&LED1_TASK_STK[LED1_STK_SIZE-1],LED1_TASK_PRIO); 
  OSTaskSuspend(START_TASK_PRIO); 
  OS_EXIT_CRITICAL(); 
}

const unsigned int blink = 40;

void led0_task(void *pdata) {
  put_with_unix_time_ln("led0");
  while(1) {
    LED0_ON;
    OSTimeDly(blink*2);
    LED0_OFF;
    OSTimeDly(blink);
    LED0_ON;
    OSTimeDly(blink*2);
    LED0_OFF;
    OSTimeDly(blink*6);
  };
}

void led1_task(void *pdata) {
  put_with_unix_time_ln("led1");
  OSTimeDly(blink*6);
  while(1) {
    LED1_ON;
    OSTimeDly(blink*2);
    LED1_OFF;
    OSTimeDly(blink);
    LED1_ON;
    OSTimeDly(blink*2);
    LED1_OFF;
    OSTimeDly(blink*6);
  };
}

void led_init(void) {
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
  GPIO_InitTypeDef LED0_GPIO = {
    .GPIO_Pin = GPIO_Pin_5,
    .GPIO_Mode = GPIO_Mode_Out_PP,
    .GPIO_Speed = GPIO_Speed_50MHz
  };
  GPIO_InitTypeDef LED1_GPIO = {
    .GPIO_Pin = GPIO_Pin_1,
    .GPIO_Mode = GPIO_Mode_Out_PP,
    .GPIO_Speed = GPIO_Speed_50MHz
  };
  GPIO_Init(GPIOB,&LED0_GPIO);
  GPIO_Init(GPIOB,&LED1_GPIO);
  GPIO_SetBits(GPIOB,GPIO_Pin_5);
  GPIO_SetBits(GPIOB,GPIO_Pin_1);
}