# FreeRTOS kernel for the Duet3D firmware, built for DUET_MCU, which the consuming project's
# toolchain file sets along with the core's code generation flags.
#
#   DUET_MCU          SAME70 or SAME5x
#   DUET_PART_DEFINE  the macro naming the MCU part, e.g. __SAME70Q20B__
#
# Target: Duet::FreeRTOS. Linking it also defines RTOS for the consumer, which is how the other
# Duet libraries and the firmware select their FreeRTOS code paths.

cmake_minimum_required(VERSION 3.25)
project(FreeRTOS LANGUAGES C)

# The GCC port is chosen by Cortex core
if(DUET_MCU STREQUAL "SAME70")
    set(_port portable/GCC/ARM_CM7/r0p1)
elseif(DUET_MCU STREQUAL "SAME5x")
    set(_port portable/GCC/ARM_CM4F)
else()
    message(FATAL_ERROR "FreeRTOS: unsupported DUET_MCU '${DUET_MCU}'")
endif()

add_library(FreeRTOS STATIC
    src/tasks.c
    src/queue.c
    src/list.c
    src/timers.c
    src/event_groups.c
    src/stream_buffer.c
    src/${_port}/port.c)
add_library(Duet::FreeRTOS ALIAS FreeRTOS)

set_target_properties(FreeRTOS PROPERTIES C_STANDARD 99 C_EXTENSIONS ON)

target_include_directories(FreeRTOS PUBLIC src/include src/${_port})
target_compile_definitions(FreeRTOS
    PRIVATE ${DUET_PART_DEFINE} noexcept=
    INTERFACE RTOS)

target_compile_options(FreeRTOS PRIVATE
    -fno-math-errno
    -fsingle-precision-constant
    -Wall
    -Wundef
    -Wdouble-promotion
    -fstack-usage
    -fdump-rtl-expand
    # __FILE__ relative to the library root, so the image does not depend on the checkout location
    -fmacro-prefix-map=${CMAKE_CURRENT_SOURCE_DIR}/=)
