# APB-to-SPI Bridge (Verilog)

## Overview

The APB-to-SPI Bridge enables communication between an Advanced Peripheral Bus (APB) master and an SPI peripheral. The bridge converts APB read/write transactions into corresponding SPI transfers, allowing processors or microcontrollers connected through APB to communicate with SPI-based devices such as sensors, EEPROMs, ADCs, DACs, and Flash memories.

## Project Objectives

* Implement an APB-compliant slave interface.
* Convert APB transactions into SPI transfers.
* Support SPI data transmission and reception.
* Provide configurable SPI clock generation.
* Verify correct protocol operation through simulation.

## Features

* APB slave interface
* SPI master controller
* Read and write transaction support
* Serial data transmission (MOSI)
* Serial data reception (MISO)
* SPI clock (SCLK) generation
* Chip Select (CS) control
* Finite State Machine (FSM)-based design
* Fully synthesizable RTL


## APB Interface Signals

| Signal  | Direction | Description       |
| ------- | --------- | ----------------- |
| PCLK    | Input     | APB clock         |
| PRESETn | Input     | Active-low reset  |
| PSEL    | Input     | Peripheral select |
| PENABLE | Input     | Enable signal     |
| PWRITE  | Input     | Write control     |
| PADDR   | Input     | Address bus       |
| PWDATA  | Input     | Write data        |
| PRDATA  | Output    | Read data         |
| PREADY  | Output    | Transfer complete |
| PSLVERR | Output    | Error indication  |

## SPI Interface Signals

| Signal | Direction | Description         |
| ------ | --------- | ------------------- |
| SCLK   | Output    | SPI serial clock    |
| MOSI   | Output    | Master Out Slave In |
| MISO   | Input     | Master In Slave Out |
| CS     | Output    | Chip Select         |

## Functional Flow

1. APB master initiates a read or write transaction.
2. The bridge decodes the APB control signals.
3. Write data is loaded into the SPI transmit register.
4. SPI clock and chip-select are generated.
5. Data is transferred serially over MOSI.
6. Incoming data is sampled from MISO.
7. Read data is returned to the APB master.
8. The APB transaction completes by asserting `PREADY`.

## Expected Results

* Correct APB protocol operation.
* Accurate SPI data transmission and reception.
* Proper SCLK generation.
* Correct Chip Select timing.
* Successful completion of APB read and write transactions.

## Applications

* Sensor interfaces
* EEPROM communication
* SPI Flash memory access
* ADC/DAC interfacing
* Embedded SoC peripherals
* Microcontroller-based systems

## Future Enhancements

* Support all SPI modes (Mode 0–3).
* Configurable clock divider.
* FIFO for transmit and receive data.
* Interrupt generation.
* Multiple chip-select outputs.
* UVM-based verification environment.
* SystemVerilog Assertions (SVA).
* Functional coverage.

## Author

Gurram Naga Kushwanth
