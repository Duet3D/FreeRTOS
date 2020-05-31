/*
 * FreeRTOS Kernel V10.0.0
 * Copyright (C) 2017 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software. If you wish to use our Amazon
 * FreeRTOS name, please do so in a fair use way that does not cause confusion.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://www.FreeRTOS.org
 * http://aws.amazon.com/freertos
 *
 * 1 tab == 4 spaces!
 */


#ifndef FREERTOS_CONFIG_H
#define FREERTOS_CONFIG_H

#ifdef __cplusplus
# define NOEXCEPT	noexcept
#else
# define NOEXCEPT
#endif

/*-----------------------------------------------------------
 * Application specific definitions.
 *
 * These definitions should be adjusted for your particular hardware and
 * application requirements.
 *
 * THESE PARAMETERS ARE DESCRIBED WITHIN THE 'CONFIGURATION' SECTION OF THE
 * FreeRTOS API DOCUMENTATION AVAILABLE ON THE FreeRTOS.org WEB SITE.
 *
 * See http://www.freertos.org/a00110.html.
 *----------------------------------------------------------*/

extern uint32_t SystemCoreClock;

#define configSUPPORT_STATIC_ALLOCATION			1
#define configSUPPORT_DYNAMIC_ALLOCATION 		0

#define configUSE_PREEMPTION					1

#if defined(__SAME51N19A__) || defined(__SAME70Q21__) || defined(__SAME70Q20B__) || defined(__SAME70Q21B__) || defined(__SAM4E8E__) || defined(__SAM4S8C__) || defined(__SAM3X8E__)
# define configUSE_PORT_OPTIMISED_TASK_SELECTION	1
#else
# define configUSE_PORT_OPTIMISED_TASK_SELECTION	0
#endif

#define configUSE_QUEUE_SETS					1
#define configUSE_IDLE_HOOK						0
#define configUSE_TICK_HOOK						1
#define configCPU_CLOCK_HZ						( SystemCoreClock )
#define configTICK_RATE_HZ						( 1000 )
#define configMAX_PRIORITIES					( 5 )
#define configMINIMAL_STACK_SIZE				( ( unsigned short ) 120 )
#define configTOTAL_HEAP_SIZE					( ( size_t ) ( 1024 ) )
#define configMAX_TASK_NAME_LEN					( 10 )
#define configUSE_TRACE_FACILITY				1
#define configUSE_16_BIT_TICKS					0
#define configIDLE_SHOULD_YIELD					1
#define configUSE_MUTEXES						1
#define configQUEUE_REGISTRY_SIZE				8
#define configCHECK_FOR_STACK_OVERFLOW			2
#define configUSE_RECURSIVE_MUTEXES				1
#define configUSE_MALLOC_FAILED_HOOK			1
#define configUSE_APPLICATION_TASK_TAG			0
#define configUSE_COUNTING_SEMAPHORES			1
#define configUSE_NEWLIB_REENTRANT 				0	// We'd like to use 1 but that makes the tasks too big because struct _reent is so large

/* The full demo always has tasks to run so the tick will never be turned off.
The blinky demo will use the default tickless idle implementation to turn the
tick off. */
#define configUSE_TICKLESS_IDLE					0

/* Run time stats gathering definitions. */
void vConfigureTimerForRunTimeStats( void );
uint32_t ulGetRunTimeCounterValue( void );
#define configGENERATE_RUN_TIME_STATS	0
#define portCONFIGURE_TIMER_FOR_RUN_TIME_STATS()	(void)0
#define portGET_RUN_TIME_COUNTER_VALUE()			(0)

/* This demo makes use of one or more example stats formatting functions.  These
format the raw data provided by the uxTaskGetSystemState() function in to human
readable ASCII form.  See the notes in the implementation of vTaskList() within
FreeRTOS/Source/tasks.c for limitations. */
#define configUSE_STATS_FORMATTING_FUNCTIONS	0

/* Co-routine definitions. */
#define configUSE_CO_ROUTINES 			0
#define configMAX_CO_ROUTINE_PRIORITIES ( 2 )

/* Software timer definitions. */
#define configUSE_TIMERS				0
#define configTIMER_TASK_PRIORITY		( 2 )
#define configTIMER_QUEUE_LENGTH		5
#define configTIMER_TASK_STACK_DEPTH	( configMINIMAL_STACK_SIZE )

/* Set the following definitions to 1 to include the API function, or zero
to exclude the API function. */
#define INCLUDE_vTaskPrioritySet		1
#define INCLUDE_uxTaskPriorityGet		1
#define INCLUDE_vTaskDelete				1
#define INCLUDE_vTaskSuspend			1
#define INCLUDE_vTaskDelayUntil			1
#define INCLUDE_vTaskDelay				1
#define INCLUDE_eTaskGetState			1
#define INCLUDE_xTimerPendFunctionCall	0
#define INCLUDE_uxTaskGetStackHighWaterMark	1
#define INCLUDE_xQueueGetMutexHolder	1
#define INCLUDE_xTaskGetSchedulerState	1

/* Cortex-M specific definitions. */
#ifdef __NVIC_PRIO_BITS
	/* __NVIC_PRIO_BITS will be specified when CMSIS is being used. */
	#define configPRIO_BITS       		__NVIC_PRIO_BITS
#elif defined(__SAME51N19A__) || defined(__SAME70Q21__) || defined(__SAME70Q20B__) || defined(__SAME70Q21B__) || defined(__SAME54P20A__)
	#define configPRIO_BITS       		3        /* 7 priority levels */
#elif defined(__SAM4E8E__) || defined(__SAM4S8C__) || defined(__SAM3X8E__)
	#define configPRIO_BITS       		4        /* 15 priority levels */
#elif defined(__SAMC21G18A__)
#	define configPRIO_BITS       		2        /* 4 priority levels */
#else
	#error Unknown value for configPRIO_BITS
#endif

/* The lowest interrupt priority that can be used in a call to a "set priority"
function. */
#define configLIBRARY_LOWEST_INTERRUPT_PRIORITY			0xf

/* The highest interrupt priority that can be used by any interrupt service
routine that makes calls to interrupt safe FreeRTOS API functions.  DO NOT CALL
INTERRUPT SAFE FREERTOS API FUNCTIONS FROM ANY INTERRUPT THAT HAS A HIGHER
PRIORITY THAN THIS! (higher priorities are lower numeric values. */
#if configPRIO_BITS == 2
# define configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY	1	// 0 is for high priority interrupts that can't make system calls, 1-3 can make system calls
#elif configPRIO_BITS == 3
# define configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY	3	// 0-2 are for high priority interrupts that can't make system calls, 3-7 can make system calls
#else
# define configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY	5	// 0-4 are for high priority interrupts that can't make system calls, 5-15 can make system calls
#endif

/* Interrupt priorities used by the kernel port layer itself.  These are generic
to all Cortex-M ports, and do not rely on any particular library functions. */
#define configKERNEL_INTERRUPT_PRIORITY 		( configLIBRARY_LOWEST_INTERRUPT_PRIORITY << (8 - configPRIO_BITS) )
/* !!!! configMAX_SYSCALL_INTERRUPT_PRIORITY must not be set to zero !!!!
See http://www.FreeRTOS.org/RTOS-Cortex-M3-M4.html. */
#define configMAX_SYSCALL_INTERRUPT_PRIORITY 	( configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY << (8 - configPRIO_BITS) )

/* Normal assert() semantics without relying on the provision of an assert.h
header file. */
extern void vAssertCalled( uint32_t ulLine, const char *pcFile ) NOEXCEPT;
#define configASSERT( x ) if( ( x ) == 0 ) vAssertCalled( __LINE__, __FILE__ )

/* Definitions that map the FreeRTOS port interrupt handlers to their CMSIS
standard names. */
#define xPortPendSVHandler PendSV_Handler
#define vPortSVCHandler SVC_Handler
#define xPortSysTickHandler SysTick_Handler

/* The priority used by the Ethernet MAC driver interrupt. */
#define configMAC_INTERRUPT_PRIORITY	( configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY )

/* Dimensions a buffer that can be used by the FreeRTOS+CLI command
interpreter.  See the FreeRTOS+CLI documentation for more information:
http://www.FreeRTOS.org/FreeRTOS-Plus/FreeRTOS_Plus_CLI/ */
#define configCOMMAND_INT_MAX_OUTPUT_SIZE		1024

/* If configINCLUDE_DEMO_DEBUG_STATS is set to one, then a few basic IP trace
macros are defined to gather some UDP stack statistics that can then be viewed
through the CLI interface. */
#define configINCLUDE_DEMO_DEBUG_STATS 0

#endif /* FREERTOS_CONFIG_H */
