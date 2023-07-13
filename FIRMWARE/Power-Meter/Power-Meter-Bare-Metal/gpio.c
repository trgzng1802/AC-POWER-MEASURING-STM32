#include "stm32f10x.h"
#include "gpio.h"

void GPIO_Init(void)
{
	RCC->APB2ENR  |= RCC_APB2ENR_IOPBEN | RCC_APB2ENR_IOPAEN | RCC_APB2ENR_IOPDEN;
	
	GPIOB->CRL |= GPIO_CRL_MODE
}
