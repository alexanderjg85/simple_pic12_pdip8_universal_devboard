# simple_pic12_pdip8_universal_devboard
A simple development board with an LED and GPIOs on Pin headers. Includes an ICSP Header and selectable dual power supply with a screw terminal

## Project Structure
- **/hardware**: Contains the KiCad schematic and PCB layout files.
- **/firmware**: Contains the Microchip MPLAB  C/ASM source code.

## Programming Notes
- Designed for all **PIC12 8-PDIP Variants with Flashmemory** microcontrollers.
- Programmed using **Microchip MPLAB** and an **PicKit 2/3** programmer. 
- *Note:* The PicKit Programmer can power the board. Make sure to choose appropriate Voltage 3.3 V or 5V and make sure that the board is jumpered correctly, if powered by external power supply. 

## License / Lizenz

This project is dual-licensed / Dieses Projekt ist dual-lizenziert:

* **Hardware (Schematic, PCB Layout):** Licensed under the [CERN Open Hardware Licence Version 2 - Permissive (CERN-OHL-P)](LICENSE_HARDWARE.md).
* **Software (Firmware, Example Code):** Licensed under the [MIT License](LICENSE).
