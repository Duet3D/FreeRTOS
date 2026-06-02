# FreeRTOS RP2040 Configuration Makefile

RP2040_BUILD_DIR := RP2040
RP2040_TARGET := $(RP2040_BUILD_DIR)/libFreeRTOS.a

RP2040_SRC_DIR := src
RP2040_PORT_DIR := src/portable/GCC/ARM_CM0

RP2040_C_SRCS := \
	$(RP2040_SRC_DIR)/tasks.c \
	$(RP2040_SRC_DIR)/queue.c \
	$(RP2040_SRC_DIR)/list.c \
	$(RP2040_SRC_DIR)/timers.c \
	$(RP2040_SRC_DIR)/event_groups.c \
	$(RP2040_SRC_DIR)/stream_buffer.c \
	$(RP2040_PORT_DIR)/port.c

RP2040_INCLUDES := \
	-I$(RP2040_SRC_DIR)/include \
	-I$(RP2040_PORT_DIR)

RP2040_DEFINES := \
	-D__RP2040__ \
	-Dnoexcept=

RP2040_CFLAGS := -c -std=gnu99 \
	-mcpu=cortex-m0plus \
	-mthumb \
	-fno-math-errno \
	-ffunction-sections \
	-fdata-sections \
	-nostdlib \
	-Wall \
	-Werror \
	-Wundef \
	-Wwrite-strings \
	-Wdouble-promotion \
	-Werror=return-type \
	-fsingle-precision-constant \
	-O2 \
	$(RP2040_INCLUDES) \
	$(RP2040_DEFINES)

RP2040_CFLAGS += $(DEBUG_FLAGS)

RP2040_OBJS := $(RP2040_C_SRCS:%.c=$(RP2040_BUILD_DIR)/%.o)
RP2040_DEPS := $(RP2040_OBJS:.o=.d)

.PHONY: RP2040
RP2040: $(RP2040_TARGET)

$(RP2040_TARGET): $(RP2040_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(RP2040_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(RP2040_CFLAGS) -MMD -MP -o $@ $<

-include $(RP2040_DEPS)

.PHONY: clean-RP2040
clean-RP2040:
	$(Q)echo "  RM      $(RP2040_BUILD_DIR)"
	$(Q)rm -rf $(RP2040_BUILD_DIR)
