.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.global  g_pfnVectors
.global  Crash_Handler

/* start address for the initialization values of the .data section. 
defined in linker script */
.word  _sidata
/* start address for the .data section. defined in linker script */  
.word  _sdata
/* end address for the .data section. defined in linker script */
.word  _edata
/* start address for the .bss section. defined in linker script */
.word  _sbss
/* end address for the .bss section. defined in linker script */
.word  _ebss
/* stack used for SystemInit_ExtMemCtl; always internal RAM used */

.equ  BootRAM,        0xF1E0F85F
/**
	* @brief  This is the code that gets called when the processor first
	*          starts execution following a reset event. Only the absolutely
	*          necessary set is performed, after which the application
	*          supplied main() routine is called. 
	* @param  None
	* @retval : None
*/

/**
	* @function Reset_System function
	* @snapshot The function frist to run when processor launched.
	*            Then the aiko_initialzation(function) will be call.
	*/
.section .text.Reset_System
.weak Reset_System
.type Reset_System, %function
Reset_System:

/* Copy the data segment initializers from flash to SRAM */  
  movs  r1, #0
  b  LoopCopyDataInit

CopyDataInit:
  ldr  r3, =_sidata
  ldr  r3, [r3, r1]
  str  r3, [r0, r1]
  adds  r1, r1, #4
    
LoopCopyDataInit:
  ldr  r0, =_sdata
  ldr  r3, =_edata
  adds  r2, r0, r1
  cmp  r2, r3
  bcc  CopyDataInit
  ldr  r2, =_sbss
  b  LoopFillZerobss
/* Zero fill the bss segment. */  
FillZerobss:
  movs  r3, #0
  str  r3, [r2], #4
    
LoopFillZerobss:
  ldr  r3, = _ebss
  cmp  r2, r3
  bcc  FillZerobss
/* Call the application's entry point.*/
  bl  main
  bx  lr    
.size Reset_System, .-Reset_System

/**
	* @function Crash_Handler
	* @snapshot This handler is the "default" for handler which should be have.
	*            When got into this handler, means the system down. 
	* @param  None     
	* @retval None       
	*/
.section  .text.Crash_Handler,"ax",%progbits
Crash_Handler: 
	bkpt
	b Infinite_Loop
Infinite_Loop:
	b  Infinite_Loop
	.size  Crash_Handler, .-Crash_Handler


/**
	* @section  for interrupt
	* The vector table for a Cortex M3. Note that the proper constructs
	* must be placed on this to ensure that it ends up at physical address
	* 0x0000.0000.
	*/
.section  .isr_vector,"a",%progbits
.type  g_pfnVectors, %object
.size  g_pfnVectors, .-g_pfnVectors
g_pfnVectors:
	/* 0x0000_0000 */
	.word  _estack                  /* reserved */
	.word  Reset_System             /* reset */
	.word  NMI_Handler              /* non maskable interrupt */
	.word  HardFault_Handler        /* all class of fault */
	.word  MemManage_Handler        /* Memory management */
	.word  BusFault_Handler         /* undefined instruction or illegal state */
	.word  UsageFault_Handler       /* prefetch fault, memory access fault */
	/* 0x0000_0018 ~ 0x0000_2B reserved */
	.word  0
	.word  0
	.word  0
	.word  0
	/* 0x0000_002C SVC call */
	.word  SVC_Handler              /* system service call via SWI instruction */
	.word  DebugMon_Handler         /* debug monitor */
	.word  0                        /* reserved */
	.word  OS_CPU_PendSVHandler     /* pendable request for system service */
	.word  OS_CPU_SysTickHandler    /* system tick */
	.word  WWDG_IRQHandler          /* window watch-dog IRQ Handler */
	.word  PVD_IRQHandler           /* PVD through EXTI Line detection interrupt */
	.word  TAMPER_IRQHandler        /* Tamper interrupt */
	.word  RTC_IRQHandler          	/* RTC global interrupt */
	.word  FLASH_IRQHandler         /* Flash global interrupt */
	.word  RCC_IRQHandler           /* 	RCC global interrupt */
	.word  EXTI0_IRQHandler        	/* 	EXTI Line interrupt */
	.word  EXTI1_IRQHandler       	/*	EXTI Line interrupt  */
	.word  EXTI2_IRQHandler       	/*	EXTI Line interrupt  */
	.word  EXTI3_IRQHandler       	/*	EXTI Line interrupt  */
	.word  EXTI4_IRQHandler        	/*	EXTI Line interrupt  */
	.word  DMA1_Channel1_IRQHandler	/* 	DMA1 Channel global interrupt */
	.word  DMA1_Channel2_IRQHandler	/* 	DMA1 Channel global interrupt */
	.word  DMA1_Channel3_IRQHandler	/* 	DMA1 Channel global interrupt */
	.word  DMA1_Channel4_IRQHandler	/* 	DMA1 Channel global interrupt */
	.word  DMA1_Channel5_IRQHandler	/* 	DMA1 Channel global interrupt */
	.word  DMA1_Channel6_IRQHandler	/* 	DMA1 Channel global interrupt */
	.word  DMA1_Channel7_IRQHandler	/* 	DMA1 Channel global interrupt */
	.word  ADC1_2_IRQHandler        	/* 	ADC1 and ADC2 global interrupt */
	.word  USB_HP_CAN1_TX_IRQHandler 	/* 	CAN1 TX interrupts */
	.word  USB_LP_CAN1_RX0_IRQHandler	/*	CAN1 RX0 interrupts  */
	.word  CAN1_RX1_IRQHandler      /* 	CAN1 RX1 interrupt */
	.word  CAN1_SCE_IRQHandler    	/* 	CAN1 SCE interrupt */
	.word  EXTI9_5_IRQHandler     	/* 	EXTI Line interrupts */
	.word  TIM1_BRK_TIM9_IRQHandler	/* 	TIM1 Break interrupt */
	.word  TIM1_UP_TIM10_IRQHandler	/* 	TIM1 Update interrupt */
	.word  TIM1_TRG_COM_TIM11_IRQHandler 	/* 	TIM1 Trigger and Commutation interrupts */
	.word  TIM1_CC_IRQHandler       /* 	TIM1 Capture Compare interrupt */
	.word  TIM2_IRQHandler        	/* 	TIM2 global interrupt */
	.word  TIM3_IRQHandler         	/*	TIM3 global interrupt  */
	.word  TIM4_IRQHandler         	/* 	TIM4 global interrupt */
	.word  I2C1_EV_IRQHandler      	/* 	I2C1 event interrupt */
	.word  I2C1_ER_IRQHandler      	/* 	I2C1 error interrupt */
	.word  I2C2_EV_IRQHandler      	/* 	I2C2 event interrupt */
	.word  I2C2_ER_IRQHandler      	/* 	I2C2 error interrupt */
	.word  SPI1_IRQHandler         	/* 	SPI1 global interrupt */
	.word  SPI2_IRQHandler          /* 	SPI2 global interrupt */
	.word  USART1_IRQHandler       	/*	USART1 global interrupt  */
	.word  USART2_IRQHandler       	/* 	USART2 global interrupt */
	.word  USART3_IRQHandler       	/*	USART3 global interrupt  */
	.word  EXTI15_10_IRQHandler    	/*	EXTI Line[15:10] interrupts */
	.word  RTCAlarm_IRQHandler     	/*	RTC alarm through EXTI line interrupt  */
	.word  USBWakeUp_IRQHandler    	/*	USB On-The-Go FS Wakeup through EXTI line interrupt  */	
	/* 0x0000_00EC for more on XL devices */
	.word  TIM8_BRK_TIM12_IRQHandler 	    /*	TIM8 Break interrupt and TIM12 global interrupt  */
	.word  TIM8_UP_TIM13_IRQHandler	      /* 	TIM8 Break interrupt and TIM12 global interrupt */
	.word  TIM8_TRG_COM_TIM14_IRQHandler 	/* 	TIM8 Trigger and Commutation interrupts and TIM14 global interrupt */
	.word  TIM8_CC_IRQHandler       /* 	TIM8 Trigger and Commutation interrupts and TIM14 global interrupt */
	.word  ADC3_IRQHandler        	/* 	ADC3 global interrupt */
	.word  FSMC_IRQHandler          /* 	FSMC global interrupt */
	.word  SDIO_IRQHandler        	/* 	SDIO global interrupt */
	.word  TIM5_IRQHandler         	/* 	TIM5 global interrupt */
	.word  SPI3_IRQHandler        	/*	SPI3 global interrupt  */
	.word  UART4_IRQHandler        	/* 	UART4 global interrupt */
	.word  UART5_IRQHandler       	/* 	UART5 global interrupt */
	.word  TIM6_IRQHandler         	/* 	TIM6 global interrupt */
	.word  TIM7_IRQHandler         	/*	TIM7 global interrupt  */
	.word  DMA2_Channel1_IRQHandler    	/* 	DMA2 Channel1 global interrupt */
	.word  DMA2_Channel2_IRQHandler    	/* 	DMA2 Channel2 global interrupt */
	.word  DMA2_Channel3_IRQHandler    	/* 	DMA2 Channel3 global interrupt */
.word  DMA2_Channel4_5_IRQHandler  	/* 	DMA2 Channel4 and DMA2 Channel5 global interrupts */
	/* nothing 0x0000_012D */
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	.word  0
	/* 0x0000_01E0 boot in RAM mode */
	.word  BootRAM
/**
  * Setting up Handler
  */
	
.weak  NMI_Handler
.thumb_set NMI_Handler,Crash_Handler

.weak  HardFault_Handler
.thumb_set HardFault_Handler,Crash_Handler

.weak  MemManage_Handler
.thumb_set MemManage_Handler,Crash_Handler

.weak  BusFault_Handler
.thumb_set BusFault_Handler,Crash_Handler

.weak  UsageFault_Handler
.thumb_set UsageFault_Handler,Crash_Handler

.weak  SVC_Handler
.thumb_set SVC_Handler,Crash_Handler

.weak  DebugMon_Handler
.thumb_set DebugMon_Handler,Crash_Handler

.weak  OS_CPU_PendSVHandler
.thumb_set OS_CPU_PendSVHandler,Crash_Handler

.weak  OS_CPU_SysTickHandler
.thumb_set OS_CPU_SysTickHandler,Crash_Handler

.weak  WWDG_IRQHandler
.thumb_set WWDG_IRQHandler,Crash_Handler

.weak  PVD_IRQHandler
.thumb_set PVD_IRQHandler,Crash_Handler

.weak  TAMPER_IRQHandler
.thumb_set TAMPER_IRQHandler,Crash_Handler

.weak  RTC_IRQHandler
.thumb_set RTC_IRQHandler,Crash_Handler

.weak  FLASH_IRQHandler
.thumb_set FLASH_IRQHandler,Crash_Handler

.weak  RCC_IRQHandler
.thumb_set RCC_IRQHandler,Crash_Handler

.weak  EXTI0_IRQHandler
.thumb_set EXTI0_IRQHandler,Crash_Handler

.weak  EXTI1_IRQHandler
.thumb_set EXTI1_IRQHandler,Crash_Handler

.weak  EXTI2_IRQHandler
.thumb_set EXTI2_IRQHandler,Crash_Handler

.weak  EXTI3_IRQHandler
.thumb_set EXTI3_IRQHandler,Crash_Handler

.weak  EXTI4_IRQHandler
.thumb_set EXTI4_IRQHandler,Crash_Handler

.weak  DMA1_Channel1_IRQHandler
.thumb_set DMA1_Channel1_IRQHandler,Crash_Handler

.weak  DMA1_Channel2_IRQHandler
.thumb_set DMA1_Channel2_IRQHandler,Crash_Handler

.weak  DMA1_Channel3_IRQHandler
.thumb_set DMA1_Channel3_IRQHandler,Crash_Handler

.weak  DMA1_Channel4_IRQHandler
.thumb_set DMA1_Channel4_IRQHandler,Crash_Handler

.weak  DMA1_Channel5_IRQHandler
.thumb_set DMA1_Channel5_IRQHandler,Crash_Handler

.weak  DMA1_Channel6_IRQHandler
.thumb_set DMA1_Channel6_IRQHandler,Crash_Handler

.weak  DMA1_Channel7_IRQHandler
.thumb_set DMA1_Channel7_IRQHandler,Crash_Handler

.weak  ADC1_2_IRQHandler
.thumb_set ADC1_2_IRQHandler,Crash_Handler

.weak  USB_HP_CAN1_TX_IRQHandler
.thumb_set USB_HP_CAN1_TX_IRQHandler,Crash_Handler

.weak  USB_LP_CAN1_RX0_IRQHandler
.thumb_set USB_LP_CAN1_RX0_IRQHandler,Crash_Handler

.weak  CAN1_RX1_IRQHandler
.thumb_set CAN1_RX1_IRQHandler,Crash_Handler

.weak  CAN1_SCE_IRQHandler
.thumb_set CAN1_SCE_IRQHandler,Crash_Handler

.weak  EXTI9_5_IRQHandler
.thumb_set EXTI9_5_IRQHandler,Crash_Handler

.weak  TIM1_BRK_TIM9_IRQHandler
.thumb_set TIM1_BRK_TIM9_IRQHandler,Crash_Handler

.weak  TIM1_UP_TIM10_IRQHandler
.thumb_set TIM1_UP_TIM10_IRQHandler,Crash_Handler

.weak  TIM1_TRG_COM_TIM11_IRQHandler
.thumb_set TIM1_TRG_COM_TIM11_IRQHandler,Crash_Handler

.weak  TIM1_CC_IRQHandler
.thumb_set TIM1_CC_IRQHandler,Crash_Handler

.weak  TIM2_IRQHandler
.thumb_set TIM2_IRQHandler,Crash_Handler

.weak  TIM3_IRQHandler
.thumb_set TIM3_IRQHandler,Crash_Handler

.weak  TIM4_IRQHandler
.thumb_set TIM4_IRQHandler,Crash_Handler

.weak  I2C1_EV_IRQHandler
.thumb_set I2C1_EV_IRQHandler,Crash_Handler

.weak  I2C1_ER_IRQHandler
.thumb_set I2C1_ER_IRQHandler,Crash_Handler

.weak  I2C2_EV_IRQHandler
.thumb_set I2C2_EV_IRQHandler,Crash_Handler

.weak  I2C2_ER_IRQHandler
.thumb_set I2C2_ER_IRQHandler,Crash_Handler

.weak  SPI1_IRQHandler
.thumb_set SPI1_IRQHandler,Crash_Handler

.weak  SPI2_IRQHandler
.thumb_set SPI2_IRQHandler,Crash_Handler

.weak  USART1_IRQHandler
.thumb_set USART1_IRQHandler,Crash_Handler

.weak  USART2_IRQHandler
.thumb_set USART2_IRQHandler,Crash_Handler

.weak  USART3_IRQHandler
.thumb_set USART3_IRQHandler,Crash_Handler

.weak  EXTI15_10_IRQHandler
.thumb_set EXTI15_10_IRQHandler,Crash_Handler

.weak  RTCAlarm_IRQHandler
.thumb_set RTCAlarm_IRQHandler,Crash_Handler

.weak  USBWakeUp_IRQHandler
.thumb_set USBWakeUp_IRQHandler,Crash_Handler

.weak  TIM8_BRK_TIM12_IRQHandler
.thumb_set TIM8_BRK_TIM12_IRQHandler,Crash_Handler

.weak  TIM8_UP_TIM13_IRQHandler
.thumb_set TIM8_UP_TIM13_IRQHandler,Crash_Handler

.weak  TIM8_TRG_COM_TIM14_IRQHandler
.thumb_set TIM8_TRG_COM_TIM14_IRQHandler,Crash_Handler

.weak  TIM8_CC_IRQHandler
.thumb_set TIM8_CC_IRQHandler,Crash_Handler

.weak  ADC3_IRQHandler
.thumb_set ADC3_IRQHandler,Crash_Handler

.weak  FSMC_IRQHandler
.thumb_set FSMC_IRQHandler,Crash_Handler

.weak  SDIO_IRQHandler
.thumb_set SDIO_IRQHandler,Crash_Handler

.weak  TIM5_IRQHandler
.thumb_set TIM5_IRQHandler,Crash_Handler

.weak  SPI3_IRQHandler
.thumb_set SPI3_IRQHandler,Crash_Handler

.weak  UART4_IRQHandler
.thumb_set UART4_IRQHandler,Crash_Handler

.weak  UART5_IRQHandler
.thumb_set UART5_IRQHandler,Crash_Handler

.weak  TIM6_IRQHandler
.thumb_set TIM6_IRQHandler,Crash_Handler

.weak  TIM7_IRQHandler
.thumb_set TIM7_IRQHandler,Crash_Handler

.weak  DMA2_Channel1_IRQHandler
.thumb_set DMA2_Channel1_IRQHandler,Crash_Handler

.weak  DMA2_Channel2_IRQHandler
.thumb_set DMA2_Channel2_IRQHandler,Crash_Handler

.weak  DMA2_Channel3_IRQHandler
.thumb_set DMA2_Channel3_IRQHandler,Crash_Handler

.weak  DMA2_Channel4_5_IRQHandler
.thumb_set DMA2_Channel4_5_IRQHandler,Crash_Handler