################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (10.3-2021.10)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Libs/Src/LCD.c 

OBJS += \
./Libs/Src/LCD.o 

C_DEPS += \
./Libs/Src/LCD.d 


# Each subdirectory must supply rules for building sources it contributes
Libs/Src/%.o Libs/Src/%.su Libs/Src/%.cyclo: ../Libs/Src/%.c Libs/Src/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -I"C:/Users/phang/OneDrive - hcmut.edu.vn/Data/Projects/AC-POWER-MEASURING-STM32/FIRMWARE/MEASURE-AC-VOLTAGE/Libs/Src" -I"C:/Users/phang/OneDrive - hcmut.edu.vn/Data/Projects/AC-POWER-MEASURING-STM32/FIRMWARE/MEASURE-AC-VOLTAGE/Libs/Inc" -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"

clean: clean-Libs-2f-Src

clean-Libs-2f-Src:
	-$(RM) ./Libs/Src/LCD.cyclo ./Libs/Src/LCD.d ./Libs/Src/LCD.o ./Libs/Src/LCD.su

.PHONY: clean-Libs-2f-Src

