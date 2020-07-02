cmake_minimum_required(VERSION 3.10)
project(FreeRTOS)

set(srcs
    "src/event_groups.c"
    "src/list.c"
    "src/queue.c"
    "src/stream_buffer.c"
    "src/tasks.c"
    "src/timers.c"
)

add_library(FreeRTOS ${srcs})
target_include_directories(FreeRTOS PUBLIC "src/include")

if(BOARD STREQUAL "DuetNG") # SAM4E8E, Cortex-M4F
    target_include_directories(FreeRTOS PUBLIC "src/portable/GCC/ARM_CM4F")
    target_sources(FreeRTOS PRIVATE "src/portable/GCC/ARM_CM4F/port.c")
elseif(BOARD STREQUAL "DuetM")
    target_include_directories(FreeRTOS PUBLIC "src/portable/GCC/ARM_CM3")
    target_sources(FreeRTOS PRIVATE "src/portable/GCC/ARM_CM3/port.c")
endif()