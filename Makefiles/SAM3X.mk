# FreeRTOS SAM3X Configuration Makefile

SAM3X_BUILD_DIR := SAM3X
SAM3X_TARGET := $(SAM3X_BUILD_DIR)/libFreeRTOS.a

SAM3X_SRC_DIR := src
SAM3X_PORT_DIR := src/portable/GCC/ARM_CM3

SAM3X_C_SRCS := \
	$(SAM3X_SRC_DIR)/tasks.c \
	$(SAM3X_SRC_DIR)/queue.c \
	$(SAM3X_SRC_DIR)/list.c \
	$(SAM3X_SRC_DIR)/timers.c \
	$(SAM3X_SRC_DIR)/event_groups.c \
	$(SAM3X_SRC_DIR)/stream_buffer.c \
	$(SAM3X_PORT_DIR)/port.c

SAM3X_INCLUDES := \
	-I$(SAM3X_SRC_DIR)/include \
	-I$(SAM3X_PORT_DIR)

SAM3X_DEFINES := \
	-D__SAM3X8E__ \
	-Dnoexcept=

SAM3X_CFLAGS := -c -std=gnu99 \
	-mcpu=cortex-m3 \
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
	$(SAM3X_INCLUDES) \
	$(SAM3X_DEFINES)

# Add debug flags if DEBUG=1
ifeq ($(DEBUG),1)
	SAM3X_CFLAGS += -O0 -g3
else
	SAM3X_CFLAGS += -O2
endif

SAM3X_OBJS := $(SAM3X_C_SRCS:%.c=$(SAM3X_BUILD_DIR)/%.o)
SAM3X_DEPS := $(SAM3X_OBJS:.o=.d)

.PHONY: SAM3X
SAM3X: $(SAM3X_TARGET)

$(SAM3X_TARGET): $(SAM3X_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(SAM3X_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(SAM3X_CFLAGS) -MMD -MP -o $@ $<

-include $(SAM3X_DEPS)

.PHONY: clean-SAM3X
clean-SAM3X:
	$(Q)echo "  RM      $(SAM3X_BUILD_DIR)"
	$(Q)rm -rf $(SAM3X_BUILD_DIR)
