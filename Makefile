# FreeRTOS Library Makefile
# Builds FreeRTOS library for various MCU configurations

# Cross-compiler toolchain
#CROSS_COMPILE ?= ../arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-
CROSS_COMPILE ?= ../arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-
export CROSS_COMPILE

# Toolchain programs
CC  := $(CROSS_COMPILE)gcc
CXX := $(CROSS_COMPILE)g++
AS  := $(CROSS_COMPILE)gcc
AR  := $(CROSS_COMPILE)ar
export CC CXX AS AR

# Quiet build support (Linux kernel style)
ifeq ($(V),1)
	Q :=
	VERBOSE :=
else
	Q := @
	VERBOSE := -s
endif
export Q VERBOSE

# Available build configurations
CONFIGS := SAM4E SAME51 SAME70 SAMC21 RP2040 STM32H523 STM32H743

# Default target
.DEFAULT_GOAL := help

# Print available targets
.PHONY: help
help:
	$(Q)echo "FreeRTOS Library Build System"
	$(Q)echo "=============================="
	$(Q)echo ""
	$(Q)echo "Build targets:"
	$(Q)for config in $(CONFIGS); do echo "  $$config"; done
	$(Q)echo ""
	$(Q)echo "Other targets:"
	$(Q)echo "  all             - Build all configurations"
	$(Q)echo "  clean           - Clean all build outputs"
	$(Q)echo "  clean-<config>  - Clean specific configuration"
	$(Q)echo ""
	$(Q)echo "Options:"
	$(Q)echo "  V=1             - Verbose build output"
	$(Q)echo "  DEBUG=1         - Build with debug symbols and no optimization"
	$(Q)echo "  CROSS_COMPILE   - Toolchain prefix (default: $(CROSS_COMPILE))"
	$(Q)echo ""

# Build all configurations
.PHONY: all
all: $(CONFIGS)

# Include configuration-specific makefiles
-include Makefiles/SAM4E.mk
-include Makefiles/SAME51.mk
-include Makefiles/SAME70.mk
-include Makefiles/SAMC21.mk
-include Makefiles/RP2040.mk
-include Makefiles/STM32H523.mk
-include Makefiles/STM32H743.mk

# Generic clean target
.PHONY: clean
clean:
	$(Q)echo "Cleaning all FreeRTOS build outputs..."
	$(Q)for config in $(CONFIGS); do \
		if [ -d "$$config" ]; then \
			echo "  RM      $$config"; \
			rm -rf "$$config"; \
		fi; \
	done

# Configuration-specific clean targets are defined in each config makefile
