# FreeRTOS SAM4S Configuration Makefile

SAM4S_BUILD_DIR := SAM4S
SAM4S_TARGET := $(SAM4S_BUILD_DIR)/libFreeRTOS.a

SAM4S_SRC_DIR := src
SAM4S_PORT_DIR := src/portable/GCC/ARM_CM3

SAM4S_C_SRCS := \
	$(SAM4S_SRC_DIR)/tasks.c \
	$(SAM4S_SRC_DIR)/queue.c \
	$(SAM4S_SRC_DIR)/list.c \
	$(SAM4S_SRC_DIR)/timers.c \
	$(SAM4S_SRC_DIR)/event_groups.c \
	$(SAM4S_SRC_DIR)/stream_buffer.c \
	$(SAM4S_PORT_DIR)/port.c

SAM4S_INCLUDES := \
	-I$(SAM4S_SRC_DIR)/include \
	-I$(SAM4S_PORT_DIR)

SAM4S_DEFINES := \
	-D__SAM4S8C__ \
	-Dnoexcept=

SAM4S_CFLAGS := -c -std=gnu99 \
	-mcpu=cortex-m4 \
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
	$(SAM4S_INCLUDES) \
	$(SAM4S_DEFINES)

SAM4S_CFLAGS += $(DEBUG_FLAGS)

SAM4S_OBJS := $(SAM4S_C_SRCS:%.c=$(SAM4S_BUILD_DIR)/%.o)
SAM4S_DEPS := $(OBJS:.o=.d)

.PHONY: SAM4S
SAM4S: $(SAM4S_TARGET)

$(SAM4S_TARGET): $(SAM4S_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(SAM4S_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(SAM4S_CFLAGS) -MMD -MP -o $@ $<

-include $(SAM4S_DEPS)

.PHONY: clean-SAM4S
clean-SAM4S:
	$(Q)echo "Cleaning SAM4S..."
	$(Q)rm -rf $(SAM4S_BUILD_DIR)
