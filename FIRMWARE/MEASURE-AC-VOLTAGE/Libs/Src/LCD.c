/*
 * LCD.c
 *
 *  Created on: Apr 16, 2023
 *      Author: phang
 */
#include "LCD.h"

void LCD_Init(LCD_HandleTypeDef *LCD, GPIO_TypeDef *GPIOx, 
                LCD_GPIOTypeDef LCD_Pin, LCD_SizeTypeDef LCD_Size)
{
    LCD->GPIOx = GPIOx;
    LCD->LCD_Pin.LCD_RS_PIN = LCD_Pin.LCD_RS_PIN;
    LCD->LCD_Pin.LCD_RW_PIN = LCD_Pin.LCD_RW_PIN;
    LCD->LCD_Pin.LCD_EN_PIN = LCD_Pin.LCD_EN_PIN;
    LCD->LCD_Pin.LCD_D7_PIN = LCD_Pin.LCD_D7_PIN;
    LCD->LCD_Pin.LCD_D6_PIN = LCD_Pin.LCD_D6_PIN;
    LCD->LCD_Pin.LCD_D5_PIN = LCD_Pin.LCD_D5_PIN;
    LCD->LCD_Pin.LCD_D4_PIN = LCD_Pin.LCD_D4_PIN;
    LCD->LCD_Size = LCD_Size;

    HAL_Delay(50);
    

}

void LCD_SendCommand(LCD_HandleTypeDef *LCD, uint8_t command)
{
	/* RS = 0: Write Command */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RS_PIN, 0);
	/* Transmit high nibble */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D4_PIN, (command >> 4) & 0x01);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D5_PIN, (command >> 4) & 0x02);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D6_PIN, (command >> 4) & 0x04);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D7_PIN, (command >> 4) & 0x08);
    
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 1);
    HAL_Delay(1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 0);
    /* Transmit low nibble */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D4_PIN, command & 0x01);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D5_PIN, command & 0x02);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D6_PIN, command & 0x04);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D7_PIN, command & 0x08);
    
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 1);
    HAL_Delay(1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 0);
}
