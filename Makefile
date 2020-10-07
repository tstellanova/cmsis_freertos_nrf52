# ------------------------------------------------
# Generic Makefile (based on gcc)
#
# ChangeLog :
#	2017-02-10 - Several enhancements + project update mode
#   2015-07-22 - first version
# ------------------------------------------------

# To use this makefile standalone use eg  
# `BUILD_DIR=/build make`
# `BUILD_DIR=./build make clean`

######################################
# target
######################################
TARGET = cmsis_freertos_nrf52

LIB_OUTFILE  = libcmsis_rtos2.a


######################################
# building variables
######################################
## debug build?
#DEBUG = 1
## optimization
#OPT = -Og


#######################################
# paths
#######################################
# Build path
#BUILD_DIR = build

######################################
# source
######################################

# freertosk-specific sources
RTOS_SOURCES = \
freertosk/croutine.c \
freertosk/event_groups.c \
freertosk/list.c \
freertosk/queue.c \
freertosk/stream_buffer.c \
freertosk/tasks.c \
freertosk/timers.c \
freertosk/portable/MemMang/heap_4.c \
freertosk/portable/GCC/ARM_CM4F/port.c \
CMSIS/nrf52/port_cmsis.c \
CMSIS_RTOS_V2/cmsis_os2.c \
CMSIS/nrf52/port.c



#freertosk/portable/CMSIS/nrf52/port_cmsis.c \
#freertosk/portable/GCC/nrf52/port.c



#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
AR = $(GCC_PATH)/$(PREFIX)ar
RANLIB = $(GCC_PATH)/$(PREFIX)ranlib
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
AR = $(PREFIX)ar
RANLIB = $(PREFIX)ranlib
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS = \
-DNRF52832_XXAA

# NRF52832_XXAA
# NRF52840_XXAA

# AS includes
AS_INCLUDES = 


# C includes
C_INCLUDES =  \
-Ifreertosk/include \
-ICMSIS_RTOS_V2 \
-Iconfig \
-Ifreertosk/portable/GCC/ARM_CM4F \
-Ifreertosk/portable/CMSIS/nrf52 \
-Inordic/softdevice/s140_nrf52_6.1.1_API/include \
-Inordic/nrfx/mdk \
-ICMSIS/Include

# -Inordic/softdevice/s132_nrf52_6.1.1_API/include \
# -Inordic/softdevice/s140_nrf52_6.1.1_API/include \

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 


# default action: build all
slib: $(BUILD_DIR)/$(LIB_OUTFILE)
all:  slib

#######################################
# build the application
#######################################

# list of library objects
LIB_OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(RTOS_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(RTOS_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

# Build library output file from objects
$(BUILD_DIR)/$(LIB_OUTFILE): $(LIB_OBJECTS) Makefile
	$(AR) ru $@ $^
	$(RANLIB) $@
	$(info $$LIB_OBJECTS is [${LIB_OBJECTS}])
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)
  
#######################################

# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
