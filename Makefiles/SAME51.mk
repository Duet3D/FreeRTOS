# FreeRTOS SAME51 Configuration Makefile

SAME51_BUILD_DIR := SAME51
SAME51_TARGET := $(SAME51_BUILD_DIR)/libFreeRTOS.a

SAME51_SRC_DIR := src
SAME51_PORT_DIR := src/portable/GCC/ARM_CM4F

SAME51_C_SRCS := \
	$(SAME51_SRC_DIR)/tasks.c \
	$(SAME51_SRC_DIR)/queue.c \
	$(SAME51_SRC_DIR)/list.c \
	$(SAME51_SRC_DIR)/timers.c \
	$(SAME51_SRC_DIR)/event_groups.c \
	$(SAME51_SRC_DIR)/stream_buffer.c \
	$(SAME51_PORT_DIR)/port.c

SAME51_INCLUDES := \
	-I$(SAME51_SRC_DIR)/include \
	-I$(SAME51_PORT_DIR)

SAME51_DEFINES := \
	-D__SAME51N19A__ \
	-Dnoexcept=

SAME51_CFLAGS := -c -std=gnu99 \
	-mcpu=cortex-m4 \
	-mthumb \
	-fno-math-errno \
	-mfpu=fpv4-sp-d16 \
	-mfloat-abi=hard \
	-ffunction-sections \
	-fdata-sections \
	-nostdlib \
	-Wall \
	-Wundef \
	-Wdouble-promotion \
	-fsingle-precision-constant \
	-fstack-usage \
	-fdump-rtl-expand \
	-O2 \
	$(SAME51_INCLUDES) \
	$(SAME51_DEFINES)

SAME51_CFLAGS += $(DEBUG_FLAGS)

SAME51_OBJS := $(SAME51_C_SRCS:%.c=$(SAME51_BUILD_DIR)/%.o)
SAME51_DEPS := $(OBJS:.o=.d)

.PHONY: SAME51
SAME51: $(SAME51_TARGET)

$(SAME51_TARGET): $(SAME51_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(SAME51_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(SAME51_CFLAGS) -MMD -MP -o $@ $<

-include $(SAME51_DEPS)

.PHONY: clean-SAME51
clean-SAME51:
	$(Q)echo "Cleaning SAME51..."
	$(Q)rm -rf $(SAME51_BUILD_DIR)
