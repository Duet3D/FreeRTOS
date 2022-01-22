# FreeRTOS

Underlying RTOS adapted for RepRapFirmware and Duet3Expansion firmware.

## Build instructions

To build this project, import it into Eclipse Mars 2, select the desired configuration (SAM3X, SAM4E, etc.), and press Build. The build depends on the Eclipse workspace
variable 'ArmGccPath" being set to the directory where your arm-none-eabi-g++ compiler resides. For example C:\Program Files (x86)\GNU Tools ARM Embedded\7 2018-q2-update\bin" on Windows.

To set it, go to Windows -> Preferences -> C/C++ -> Build -> Build Variables and click "Add..."

## Bug reports

Please use the [forum](https://forum.duet3d.com) for support requests or the [RepRapFirmware](https://github.com/Duet3D/RepRapFirmware) GitHub repository for feature requests and bug reports.
