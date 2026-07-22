# FreeRTOS as a reusable CMake component.
#
# include() this module, then call freertos_add_library() once per MCU you need. Each call creates
# an independent STATIC library target that builds into the *consuming* project's build tree, so
# two firmwares (or a Debug and a Release configuration) never share or clobber each other's object
# files the way the old per-config in-tree build directories did.
#
#   freertos_add_library(
#       TARGET   <name>              # created target, e.g. freertos_same70
#       MCU      <SAME70|SAME51|SAMC21>
#       ARCH     <interface target>  # carries -mcpu/-mfpu/... ; see the firmware's duet_define_arch
#       [CONFIG_DIR <dir>]           # extra include dir searched first for FreeRTOSConfig.h
#   )

set(FREERTOS_DIR "${CMAKE_CURRENT_LIST_DIR}")
set(FREERTOS_LIBRARY_FLAGS)
set(FREERTOS_LIBRARY_ARGS
    "CONFIG_DIR"  # extra include dir searched first for FreeRTOSConfig.h
)

include("${LIBRARIES_DIR}/LibraryUtils.cmake")

# The FreeRTOS GCC port is chosen by Cortex core, not by the specific part number.
function(get_port_dir MCU OUT_PORT)
    if(MCU STREQUAL "SAME70")
        set(${OUT_PORT} "portable/GCC/ARM_CM7/r0p1" PARENT_SCOPE)
    elseif(MCU STREQUAL "SAME51")
        set(${OUT_PORT} "portable/GCC/ARM_CM4F" PARENT_SCOPE)
    elseif(MCU STREQUAL "SAME4E")
        set(${OUT_PORT} "portable/GCC/ARM_CM4F" PARENT_SCOPE)
    elseif(MCU STREQUAL "SAMC21")
        set(${OUT_PORT} "portable/GCC/ARM_CM0" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "get_port_dir: unsupported MCU '${MCU}'")
    endif()
endfunction()

function(freertos_add_interface OUT_TARGET)
    cmake_parse_arguments(PARSE_ARGV 1 ARG "${FREERTOS_LIBRARY_FLAGS}" "${DEFAULT_INTERFACE_ARGS};${FREERTOS_LIBRARY_ARGS}" "")
    if(ARG_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "freertos_add_interface: unknown arguments: ${ARG_UNPARSED_ARGUMENTS}")
    endif()

    get_enabled_features(_enabled_features ${FREERTOS_LIBRARY_FLAGS})
    make_library_name(_target "FreeRTOS" INTERFACE ${ARG_MCU} ${_enabled_features})
    set(${OUT_TARGET} "${_target}" PARENT_SCOPE)
    if(TARGET ${_target})
        return()  # already built for this MCU and feature set
    endif()

    get_port_dir(${ARG_MCU} _port)

    add_library(${_target} INTERFACE)
    target_include_directories(${_target} INTERFACE
        ${ARG_CONFIG_DIR}                 # consumer's FreeRTOSConfig.h override, if any
        "${FREERTOS_DIR}/src/include"
        "${FREERTOS_DIR}/src/${_port}"
    )
    target_compile_definitions(${_target} INTERFACE RTOS)
endfunction()

function(freertos_add_library OUT_TARGET)
    cmake_parse_arguments(PARSE_ARGV 0 ARG "${FREERTOS_LIBRARY_FLAGS}" "${DEFAULT_LIBRARY_ARGS};${FREERTOS_LIBRARY_ARGS}" "")

    get_enabled_features(_enabled_features ${FREERTOS_LIBRARY_FLAGS})
    make_library_name(_target "FreeRTOS" STATIC ${ARG_MCU} ${_enabled_features})
    set(${OUT_TARGET} "${_target}" PARENT_SCOPE)
    if(TARGET ${_target})
        return()  # already built for this MCU and feature set
    endif()

    set(_src "${FREERTOS_DIR}/src")

    get_port_dir(${ARG_MCU} _port)

    add_library(${_target} STATIC
        "${_src}/tasks.c"
        "${_src}/queue.c"
        "${_src}/list.c"
        "${_src}/timers.c"
        "${_src}/event_groups.c"
        "${_src}/stream_buffer.c"
        "${_src}/${_port}/port.c"
    )

    target_link_libraries(${_target} PUBLIC I_${_target}) # link interface target

    target_compile_definitions(${_target} PRIVATE noexcept=)

    target_compile_options(${_target} PRIVATE
        $<$<COMPILE_LANGUAGE:C>:-std=gnu99>
        -ffunction-sections -fdata-sections -nostdlib
        -Wall -Wundef -Wdouble-promotion -fsingle-precision-constant
        $<$<NOT:$<CONFIG:Debug>>:-O2>
        $<$<CONFIG:Debug>:-Og;-g3>)

    target_link_libraries(${_target} PRIVATE ${ARG_ARCH})
endfunction()
