# FreeRTOS STM32H7 Configuration Makefile

STM32H7_BUILD_DIR := STM32H7
STM32H7_TARGET := $(STM32H7_BUILD_DIR)/libFreeRTOS.a

STM32H7_SRC_DIR := src
STM32H7_PORT_DIR := src/portable/GCC/ARM_CM7/r0p1

STM32H7_C_SRCS := \
	$(STM32H7_SRC_DIR)/tasks.c \
	$(STM32H7_SRC_DIR)/queue.c \
	$(STM32H7_SRC_DIR)/list.c \
	$(STM32H7_SRC_DIR)/timers.c \
	$(STM32H7_SRC_DIR)/event_groups.c \
	$(STM32H7_SRC_DIR)/stream_buffer.c \
	$(STM32H7_PORT_DIR)/port.c

STM32H7_INCLUDES := \
	-I$(STM32H7_SRC_DIR)/include \
	-I$(STM32H7_PORT_DIR)

STM32H7_DEFINES := \
	-DSTM32H743xx \
	-Dnoexcept=

STM32H7_CFLAGS := -c -std=gnu99 \
	-mcpu=cortex-m7 \
	-mthumb \
	-fno-math-errno \
	-mfpu=fpv5-d16 \
	-mfloat-abi=hard \
	-mno-unaligned-access \
	-ffunction-sections \
	-fdata-sections \
	-nostdlib \
	-Wundef \
	-Wdouble-promotion \
	-fsingle-precision-constant \
	-Wall \
	$(STM32H7_INCLUDES) \
	$(STM32H7_DEFINES)

# Add debug flags if DEBUG=1
ifeq ($(DEBUG),1)
STM32H7_CFLAGS += -O0 -g3
else
STM32H7_CFLAGS += -O2
endif

STM32H7_OBJS := $(STM32H7_C_SRCS:%.c=$(STM32H7_BUILD_DIR)/%.o)
STM32H7_DEPS := $(OBJS:.o=.d)

.PHONY: STM32H7
STM32H7: $(STM32H7_TARGET)

$(STM32H7_TARGET): $(STM32H7_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(STM32H7_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(STM32H7_CFLAGS) -MMD -MP -o $@ $<

-include $(STM32H7_DEPS)

.PHONY: clean-STM32H7
clean-STM32H7:
	$(Q)echo "Cleaning STM32H7..."
	$(Q)rm -rf $(STM32H7_BUILD_DIR)
