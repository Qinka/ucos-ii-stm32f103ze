## require for CMake
cmake_minimum_required(VERSION 3.3)

## build system set up
set (CMAKE_SYSTEM_NAME      Generic)
set (CMAKE_SYSTEM_PROCESSOR arm)
set (CMAKE_CROSSCOMPILING   TRUE)

## project
project(ucos)

## languagse
enable_language(C ASM)

## config the ucos
set(UCOS_PATH_CONFIG "cmake")
include("${UCOS_PATH_CONFIG}/config.cmake")

## for platform
if (CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
  if (NOT (DEFINED "EXE_IGNORE"))
    set (EXE_POSTFIX ".exe") 
  endif (NOT (DEFINED "EXE_IGNORE"))
endif (CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")


## add include path
include_directories (include)

## add source files
#if(DEFINED UCOS_DEBUG_WATCH_SRC_FILE)
  variable_watch(UCOS_SRC_FILE)
#endif (DEFINED UCOS_DEBUG_WATCH_SRC_FILE)
## start up
set (UCOS_SRC_FILE "source/boot.s" "port/os_cpu_a.s")
## initialzation
aux_source_directory(source UCOS_SRC_FILE)
aux_source_directory(port UCOS_SRC_FILE)
aux_source_directory(firmware UCOS_SRC_FILE)
## to build library
add_library(ucos STATIC ${UCOS_SRC_FILE})
## install files
## target
install(TARGETS ucos DESTINATION lib)
## link script
install(FILES ucos.ld DESTINATION share/ucos)
## include files
install(DIRECTORY include DESTINATION include)