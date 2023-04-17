/*
 * LCD.h
 *
 *  Created on: Apr 16, 2023
 *      Author: phang
 */

#ifndef INC_LCD_H_
#define INC_LCD_H_

#include "main.h"

typedef enum {
    LCD_1602,
    LCD_2004
} LCD_SizeTypeDef;

typedef struct {
    uint16_t LCD_RS_PIN;
    uint16_t LCD_RW_PIN;
    uint16_t LCD_EN_PIN;
    uint16_t LCD_D4_PIN;
    uint16_t LCD_D5_PIN;
    uint16_t LCD_D6_PIN;
    uint16_t LCD_D7_PIN;
} LCD_GPIOTypeDef;

typedef struct {
    GPIO_TypeDef *GPIOx;
    LCD_GPIOTypeDef LCD_Pin;
    LCD_SizeTypeDef LCD_Size;
} LCD_HandleTypeDef;


// #define LCD_PORT	GPIOC
// #define LCD_RS_PIN  GPIO_PIN_9
// #define LCD_RW_PIN  GPIO_PIN_8
// #define LCD_EN_PIN  GPIO_PIN_7
// #define LCD_D4_PIN  GPIO_PIN_6
// #define LCD_D5_PIN  GPIO_PIN_5
// #define LCD_D6_PIN  GPIO_PIN_4
// #define LCD_D7_PIN  GPIO_PIN_3

void LCD_Init(LCD_HandleTypeDef *LCD, GPIO_TypeDef *GPIOx, 
                LCD_GPIOTypeDef LCD_Pin, LCD_SizeTypeDef LCD_Size);
void LCD_SendCommand(LCD_HandleTypeDef *LCD, uint8_t command);
void LCD_SetCursor(LCD_HandleTypeDef *LCD, 
                    uint8_t LCD_column_pos, uint8_t LCD_row_pos);
void LCD_SendChar(LCD_HandleTypeDef *LCD, uint8_t LCD_data);
void LCD_SendString(LCD_HandleTypeDef *LCD, char *LCD_string);


#endif /* INC_LCD_H_ */
