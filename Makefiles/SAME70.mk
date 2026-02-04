# FreeRTOS SAME70 Configuration Makefile

SAME70_BUILD_DIR := SAME70
SAME70_TARGET := $(SAME70_BUILD_DIR)/libFreeRTOS.a

SAME70_SRC_DIR := src
SAME70_PORT_DIR := src/portable/GCC/ARM_CM7/r0p1

SAME70_C_SRCS := \
	$(SAME70_SRC_DIR)/tasks.c \
	$(SAME70_SRC_DIR)/queue.c \
	$(SAME70_SRC_DIR)/list.c \
	$(SAME70_SRC_DIR)/timers.c \
	$(SAME70_SRC_DIR)/event_groups.c \
	$(SAME70_SRC_DIR)/stream_buffer.c \
	$(SAME70_PORT_DIR)/port.c

SAME70_INCLUDES := \
	-I$(SAME70_SRC_DIR)/include \
	-I$(SAME70_PORT_DIR)

SAME70_DEFINES := \
	-D__SAME70Q21__ \
	-Dnoexcept=

SAME70_CFLAGS := -c -std=gnu99 \
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
	-Werror=return-type \
	-Werror=implicit \
	-fsingle-precision-constant \
	-O2 \
	-Wall \
	-Werror \
	-Wwrite-strings \
	$(SAME70_INCLUDES) \
	$(SAME70_DEFINES)

# Add debug flags if DEBUG=1
ifeq ($(DEBUG),1)
SAME70_CFLAGS += -O0 -g3
else
SAME70_CFLAGS += -O2
endif

SAME70_OBJS := $(SAME70_C_SRCS:%.c=$(SAME70_BUILD_DIR)/%.o)
SAME70_DEPS := $(OBJS:.o=.d)

.PHONY: SAME70
SAME70: $(SAME70_TARGET)

$(SAME70_TARGET): $(SAME70_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(SAME70_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(SAME70_CFLAGS) -MMD -MP -o $@ $<

-include $(SAME70_DEPS)

.PHONY: clean-SAME70
clean-SAME70:
	$(Q)echo "Cleaning SAME70..."
	$(Q)rm -rf $(SAME70_BUILD_DIR)
