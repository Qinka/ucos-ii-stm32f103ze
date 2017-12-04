## cross compiler prefix
set (UCOS_ARM_PREFIX "arm-unknown-eabi-" CACHE STRING "The cross compiler prefix")


## compiler macro
## debug
option(UCOS_CONFIG_DEBUG "Turn on debug" ON)
if (${UCOS_CONFIG_DEBUG})
  set(INNER_UCOS_CONFIG_BUG " -g ")
else (${UCOS_CONFIG_DEBUG})
  set(INNER_UCOS_CONFIG_BUG " ")
endif (${UCOS_CONFIG_DEBUG})
## device type
set (UCOS_CONFIG_DEV "STM32F10X_HD" CACHE string "the kind of device")
## config compiling
## set up compiler
set (CMAKE_C_COMPILER   "${UCOS_ARM_PREFIX}gcc")
set (CMAKE_CXX_COMPILER "${UCOS_ARM_PREFIX}g++")
set (CMAKE_C_FLAGS      "$ENV{CCFLAGS} ${INNER_UCOS_CONFIG_BUG}  -mcpu=cortex-m3 -mthumb -nostdlib")
set (CMAKE_ASM_FLAGS      "$ENV{CCFLAGS} ${INNER_UCOS_CONFIG_BUG}  -mcpu=cortex-m3 -mthumb -nostdlib")
add_definitions("-D${UCOS_CONFIG_DEV}")
set (CMAKE_ASM_COMPILER "${UCOS_ARM_PREFIX}gcc")
set (CMAKE_AR "${UCOS_ARM_PREFIX}ar")
set (CMAKE_RANLIB "${UCOS_ARM_PREFIX}ranlib")