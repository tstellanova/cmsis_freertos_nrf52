# cmsis_freertos_nrf52

Builds FreeRTOS as a static library, 
intended to be invoked from the embedded rust
[freertos-sys crate](https://github.com/tstellanova/freertos-sys)

Creates a static FreeRTOS library for use with nrf52xx.
This provides the API described in `cmsis_os2.h` -- in other words, 
the CMSIS RTOS v2 API. 

Tested with nrf52-dK

## License

BSD-3 Clause for the build wrapper (see LICENSE file).
Portions copyright their respective owners (see other license files included with sources).






