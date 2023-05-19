/*
 * LCD.c
 *
 *  Created on: Apr 16, 2023
 *      Author: phang
 */
#include "LCD.h"
#include "string.h"
#include "stdarg.h"
#include "stdio.h"

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
    LCD->LCD_Size.LCD_column = LCD_Size.LCD_column;
    LCD->LCD_Size.LCD_row = LCD_Size.LCD_row;

    HAL_Delay(50);
    /* Function set: 4-bit interface*/
    LCD_SendCommand(LCD, 0x03);
    HAL_Delay(5);
    LCD_SendCommand(LCD, 0x03);
    HAL_Delay(1);
    LCD_SendCommand(LCD, 0x03);
    HAL_Delay(1);
    LCD_SendCommand(LCD, 0x02);
        HAL_Delay(1);
    /*Display OFF, cursor ON*/
    LCD_SendCommand(LCD, 0x28);
    HAL_Delay(1);
    LCD_SendCommand(LCD, 0x08);
        HAL_Delay(1);
    /*Clear display*/
    LCD_SendCommand(LCD, 0x01);
    HAL_Delay(3);
    LCD_SendCommand(LCD, 0x06);
    HAL_Delay(1);
    /* Function set: 5x7 mode for chars*/
    LCD_SendCommand(LCD, 0x0c);
    HAL_Delay(1);
    LCD_SendCommand(LCD, 0x02);
    HAL_Delay(1);

}

void LCD_SendCommand(LCD_HandleTypeDef *LCD, uint8_t command)
{
	/* RS = 0: Write Command */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RS_PIN, 0);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RW_PIN, 0);
	/* Transmit high nibble */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D4_PIN, (command & 0x10) >> 4);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D5_PIN, (command & 0x20) >> 5);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D6_PIN, (command & 0x40) >> 6);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D7_PIN, (command & 0x80) >> 7);
    
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 1);
    HAL_Delay(1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 0);
    HAL_Delay(1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RS_PIN, 0);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RW_PIN, 0);
    /* Transmit low nibble */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D4_PIN, command & 0x01);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D5_PIN, (command & 0x02) >> 1);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D6_PIN, (command & 0x04) >> 2);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D7_PIN, (command & 0x08) >> 3);
    
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 1);
    HAL_Delay(1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 0);
}

void LCD_SendChar(LCD_HandleTypeDef *LCD, uint8_t LCD_data)
{
    /* RS = 1: Write data */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RS_PIN, 1);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RW_PIN, 0);
    /* Transmit high nibble */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D4_PIN, (LCD_data & 0x10) >> 4);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D5_PIN, (LCD_data & 0x20) >> 5);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D6_PIN, (LCD_data & 0x40) >> 6);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D7_PIN, (LCD_data & 0x80) >> 7);
    
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 1);
    HAL_Delay(1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 0);
    HAL_Delay(1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RS_PIN, 1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_RW_PIN, 0);
    /* Transmit low nibble */
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D4_PIN, LCD_data & 0x01);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D5_PIN, (LCD_data & 0x02) >> 1);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D6_PIN, (LCD_data & 0x04) >> 2);
	HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_D7_PIN, (LCD_data & 0x08) >> 3);
    
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 1);
    HAL_Delay(1);
    HAL_GPIO_WritePin(LCD->GPIOx, LCD->LCD_Pin.LCD_EN_PIN, 0);
}

void LCD_SetCursor(LCD_HandleTypeDef *LCD, 
                    uint8_t LCD_column_pos, uint8_t LCD_row_pos)
{
    uint8_t cursor_command;
    if ((LCD_column_pos < LCD->LCD_Size.LCD_column) && (LCD_row_pos < LCD->LCD_Size.LCD_row))
    {
        switch (LCD_row_pos)
        {
        case 0:
            cursor_command = 0x80 + LCD_column_pos;
            break;

        case 1:
            cursor_command = 0xc0 + LCD_column_pos;
            break;

        case 2:
            cursor_command = 0x80 + LCD->LCD_Size.LCD_column + LCD_column_pos;
            break;

        case 3:
            cursor_command = 0xc0 + LCD->LCD_Size.LCD_column + LCD_column_pos;
            break;
        default:
            break;
        }
    }
    LCD_SendCommand(LCD, cursor_command);
}

void LCD_SendString(LCD_HandleTypeDef *LCD, char *LCD_string)
{
    for (uint8_t i = 0; i < LCD->LCD_Size.LCD_column; i++)
    {
        LCD_SendChar(LCD, LCD_string[i]);
    }
}

void LCD_Printf(LCD_HandleTypeDef *LCD, const char *String, ...)
{
	char StringArray[16];
	va_list args;
	va_start(args, String);
	vsprintf(StringArray, String, args);
	va_end(args);

	for(uint8_t i=0; i<strlen(StringArray) && i < LCD->LCD_Size.LCD_column; i++)
	{
		LCD_SendChar(LCD, (uint8_t)StringArray[i]);
	}
}
