# FreeRTOS STM32H5 Configuration Makefile

STM32H5_BUILD_DIR := STM32H5
STM32H5_TARGET := $(STM32H5_BUILD_DIR)/libFreeRTOS.a

STM32H5_SRC_DIR := src
STM32H5_PORT_DIR := src/portable/GCC/ARM_CM33_NTZ/non_secure

STM32H5_C_SRCS := \
	$(STM32H5_SRC_DIR)/tasks.c \
	$(STM32H5_SRC_DIR)/queue.c \
	$(STM32H5_SRC_DIR)/list.c \
	$(STM32H5_SRC_DIR)/timers.c \
	$(STM32H5_SRC_DIR)/event_groups.c \
	$(STM32H5_SRC_DIR)/stream_buffer.c \
	$(STM32H5_PORT_DIR)/port.c \
	$(STM32H5_PORT_DIR)/portasm.c \
	$(STM32H5_PORT_DIR)/mpu_wrappers_v2_asm.c

STM32H5_INCLUDES := \
	-I$(STM32H5_SRC_DIR)/include \
	-I$(STM32H5_PORT_DIR)

STM32H5_DEFINES := \
	-DSTM32H523xx \
	-Dnoexcept=

STM32H5_CFLAGS := -c -std=gnu99 \
	-mcpu=cortex-m33 \
	-mthumb \
	-fno-math-errno \
	-mfpu=fpv5-sp-d16 \
	-mfloat-abi=hard \
	-mno-unaligned-access \
	-ffunction-sections \
	-fdata-sections \
	-nostdlib \
	-Wundef \
	-Wdouble-promotion \
	-fsingle-precision-constant \
	-Wall \
	$(STM32H5_INCLUDES) \
	$(STM32H5_DEFINES)

# Add debug flags if DEBUG=1
ifeq ($(DEBUG),1)
STM32H5_CFLAGS += -O0 -g3
else
STM32H5_CFLAGS += -O2
endif

STM32H5_OBJS := $(STM32H5_C_SRCS:%.c=$(STM32H5_BUILD_DIR)/%.o)
STM32H5_DEPS := $(OBJS:.o=.d)

.PHONY: STM32H5
STM32H5: $(STM32H5_TARGET)

$(STM32H5_TARGET): $(STM32H5_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(STM32H5_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(STM32H5_CFLAGS) -MMD -MP -o $@ $<

-include $(STM32H5_DEPS)

.PHONY: clean-STM32H5
clean-STM32H5:
	$(Q)echo "Cleaning STM32H5..."
	$(Q)rm -rf $(STM32H5_BUILD_DIR)
