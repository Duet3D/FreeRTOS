# FreeRTOS SAMC21 Configuration Makefile

SAMC21_BUILD_DIR := SAMC21
SAMC21_TARGET := $(SAMC21_BUILD_DIR)/libFreeRTOS.a

SAMC21_SRC_DIR := src
SAMC21_PORT_DIR := src/portable/GCC/ARM_CM0

SAMC21_C_SRCS := \
	$(SAMC21_SRC_DIR)/tasks.c \
	$(SAMC21_SRC_DIR)/queue.c \
	$(SAMC21_SRC_DIR)/list.c \
	$(SAMC21_SRC_DIR)/timers.c \
	$(SAMC21_SRC_DIR)/event_groups.c \
	$(SAMC21_SRC_DIR)/stream_buffer.c \
	$(SAMC21_PORT_DIR)/port.c

SAMC21_INCLUDES := \
	-I$(SAMC21_SRC_DIR)/include \
	-I$(SAMC21_PORT_DIR)

SAMC21_DEFINES := \
	-D__SAMC21G18A__ \
	-Dnoexcept=

SAMC21_CFLAGS := -c -std=gnu99 \
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
	$(SAMC21_INCLUDES) \
	$(SAMC21_DEFINES)

# Add debug flags if DEBUG=1
ifeq ($(DEBUG),1)
SAMC21_CFLAGS += -O0 -g3
else
SAMC21_CFLAGS += -O2
endif

SAMC21_OBJS := $(SAMC21_C_SRCS:%.c=$(SAMC21_BUILD_DIR)/%.o)
SAMC21_DEPS := $(OBJS:.o=.d)

.PHONY: SAMC21
SAMC21: $(SAMC21_TARGET)

$(SAMC21_TARGET): $(SAMC21_OBJS)
	$(Q)echo "  AR      $@"
	$(Q)mkdir -p $(@D)
	$(Q)$(AR) rcs $@ $^

$(SAMC21_BUILD_DIR)/%.o: %.c
	$(Q)echo "  CC      $<"
	$(Q)mkdir -p $(@D)
	$(Q)$(CC) $(SAMC21_CFLAGS) -MMD -MP -o $@ $<

-include $(SAMC21_DEPS)

.PHONY: clean-SAMC21
clean-SAMC21:
	$(Q)echo "Cleaning SAMC21..."
	$(Q)rm -rf $(SAMC21_BUILD_DIR)
