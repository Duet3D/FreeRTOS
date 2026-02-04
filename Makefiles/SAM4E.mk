# FreeRTOS SAM4E Configuration Makefile

# Build directory
SAM4E_BUILD_DIR := SAM4E

# Output library
SAM4E_TARGET := $(SAM4E_BUILD_DIR)/libFreeRTOS.a

# Source directories
SAM4E_SRC_DIR := src
SAM4E_PORT_DIR := src/portable/GCC/ARM_CM4F

# Source files
SAM4E_C_SRCS := \
	$(SAM4E_SRC_DIR)/tasks.c \
	$(SAM4E_SRC_DIR)/queue.c \
	$(SAM4E_SRC_DIR)/list.c \
	$(SAM4E_SRC_DIR)/timers.c \
	$(SAM4E_SRC_DIR)/event_groups.c \
	$(SAM4E_SRC_DIR)/stream_buffer.c \
	$(SAM4E_PORT_DIR)/port.c

# Include paths
SAM4E_INCLUDES := \
	-I$(SAM4E_SRC_DIR)/include \
	-I$(SAM4E_PORT_DIR)

# Add FreeRTOSConfig.h path if provided by parent makefile
ifdef FREERTOS_CONFIG_DIR
SAM4E_INCLUDES += -I$(FREERTOS_CONFIG_DIR)
endif

# Defines
SAM4E_DEFINES := \
	-D__SAM4E8E__ \
	-Dnoexcept=

# Compiler flags
SAM4E_CFLAGS := -c -std=gnu99 \
	-mcpu=cortex-m4 \
	-mthumb \
	-fno-math-errno \
	-mfpu=fpv4-sp-d16 \
	-mfloat-abi=hard \
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
	-Wall \
	$(SAM4E_INCLUDES) \
	$(SAM4E_DEFINES)

# Add debug flags if DEBUG=1
ifeq ($(DEBUG),1)
	SAM4E_CFLAGS += -O0 -g3
else
	SAM4E_CFLAGS += -O2
endif

# Object files
SAM4E_OBJS := $(SAM4E_C_SRCS:%.c=$(SAM4E_BUILD_DIR)/%.o)

# Dependency files
SAM4E_DEPS := $(SAM4E_OBJS:.o=.d)

# Target rule
.PHONY: SAM4E
SAM4E: $(SAM4E_TARGET)

$(SAM4E_TARGET): $(SAM4E_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

# Compile C files
$(SAM4E_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(SAM4E_CFLAGS) -MMD -MP -o $@ $<

# Include dependencies
-include $(SAM4E_DEPS)

# Clean target
.PHONY: clean-SAM4E
clean-SAM4E:
	$(Q)echo "  RM      $(SAM4E_BUILD_DIR)"
	$(Q)rm -rf $(SAM4E_BUILD_DIR)
