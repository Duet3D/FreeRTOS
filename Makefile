# FreeRTOS Library Makefile
# Builds FreeRTOS library for various MCU configurations

# Cross-compiler toolchain.
# RepRapFirmware exports CROSS_COMPILE when building this as a submodule.
# When building FreeRTOS standalone, fall back to a toolchain on PATH.
ARM_GNU_TOOLCHAIN_VERSION ?= 15.2.rel1
ifeq ($(OS),Windows_NT)
HOST_ARCH_RAW := $(subst AMD64,x86_64,$(subst ARM64,aarch64,$(PROCESSOR_ARCHITECTURE)))
else
HOST_ARCH_RAW := $(shell uname -m)
HOST_OS_RAW := $(shell uname -s)
endif

ifeq ($(HOST_ARCH_RAW),aarch64)
ARM_GNU_TOOLCHAIN_HOST_ARCH := aarch64
else ifeq ($(HOST_ARCH_RAW),arm64)
ARM_GNU_TOOLCHAIN_HOST_ARCH := aarch64
else ifeq ($(HOST_ARCH_RAW),x86_64)
ARM_GNU_TOOLCHAIN_HOST_ARCH := x86_64
else ifeq ($(HOST_ARCH_RAW),amd64)
ARM_GNU_TOOLCHAIN_HOST_ARCH := x86_64
else
ARM_GNU_TOOLCHAIN_HOST_ARCH := $(HOST_ARCH_RAW)
endif

ifeq ($(OS),Windows_NT)
ARM_GNU_TOOLCHAIN_HOST := mingw-w64-$(ARM_GNU_TOOLCHAIN_HOST_ARCH)
else ifeq ($(HOST_OS_RAW),Darwin)
ARM_GNU_TOOLCHAIN_HOST := darwin-$(subst aarch64,arm64,$(ARM_GNU_TOOLCHAIN_HOST_ARCH))
else
ARM_GNU_TOOLCHAIN_HOST := $(ARM_GNU_TOOLCHAIN_HOST_ARCH)
endif

CROSS_COMPILE ?= $(abspath ../arm-gnu-toolchain-$(ARM_GNU_TOOLCHAIN_VERSION)-$(ARM_GNU_TOOLCHAIN_HOST)-arm-none-eabi/bin/arm-none-eabi-)
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
CONFIGS := SAM4E SAME51 SAME70 SAMC21 RP2040 STM32H5 STM32H7

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
-include Makefiles/STM32H5.mk
-include Makefiles/STM32H7.mk

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
