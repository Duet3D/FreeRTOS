# FreeRTOS STM32H743 Configuration Makefile

STM32H743_BUILD_DIR := STM32H743
STM32H743_TARGET := $(STM32H743_BUILD_DIR)/libFreeRTOS.a

STM32H743_SRC_DIR := src
STM32H743_PORT_DIR := src/portable/GCC/ARM_CM7/r0p1

STM32H743_C_SRCS := \
	$(STM32H743_SRC_DIR)/tasks.c \
	$(STM32H743_SRC_DIR)/queue.c \
	$(STM32H743_SRC_DIR)/list.c \
	$(STM32H743_SRC_DIR)/timers.c \
	$(STM32H743_SRC_DIR)/event_groups.c \
	$(STM32H743_SRC_DIR)/stream_buffer.c \
	$(STM32H743_PORT_DIR)/port.c

STM32H743_INCLUDES := \
	-I$(STM32H743_SRC_DIR)/include \
	-I$(STM32H743_PORT_DIR)

STM32H743_DEFINES := \
	-DSTM32H743xx \
	-Dnoexcept=

STM32H743_CFLAGS := -c -std=gnu99 \
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
	$(STM32H743_INCLUDES) \
	$(STM32H743_DEFINES)

# Add debug flags if DEBUG=1
ifeq ($(DEBUG),1)
STM32H743_CFLAGS += -O0 -g3
else
STM32H743_CFLAGS += -O2
endif

STM32H743_OBJS := $(STM32H743_C_SRCS:%.c=$(STM32H743_BUILD_DIR)/%.o)
STM32H743_DEPS := $(OBJS:.o=.d)

.PHONY: STM32H743
STM32H743: $(STM32H743_TARGET)

$(STM32H743_TARGET): $(STM32H743_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(STM32H743_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(STM32H743_CFLAGS) -MMD -MP -o $@ $<

-include $(STM32H743_DEPS)

.PHONY: clean-STM32H743
clean-STM32H743:
	$(Q)echo "Cleaning STM32H743..."
	$(Q)rm -rf $(STM32H743_BUILD_DIR)
