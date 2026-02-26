# Synchronous FIFO (FPGA Implementation – Verilog)

A parameterized Synchronous FIFO designed in Verilog and implemented on FPGA. The project demonstrates reliable buffered data transfer using a single clock domain, with full/empty detection and real-time visualization on FPGA hardware.

📌 **Overview**

This design implements an 8-bit wide, 16-depth synchronous FIFO using:

• Single clock domain

• Separate read/write pointers

• Occupancy counter for full/empty detection

• Safe simultaneous read/write handling

The design is integrated on FPGA (Basys3) with button-controlled inputs and 7-segment display output.

⚙️ **Features**

• Parameterized data width and depth

• Synchronous read and write operations

• Full and Empty flag generation

• Pointer-based circular buffer implementation

• Debounced push-button inputs (FPGA)

• LED indicators for status signals

• 7-Segment display for FIFO data visualization

🧠 **Architecture**

**Core FIFO Logic:**

• Memory array for storage

• Write pointer (increments on valid write)

• Read pointer (increments on valid read)

• Counter to track number of stored elements

• Full when counter = depth

• Empty when counter = 0

**FPGA Integration:**

• Button debounce and edge detection

• LED status display (Full / Empty)

• Binary-to-BCD conversion

• 7-segment multiplexed display driver

🛠️ **Tools Used**

• Verilog HDL

• Xilinx Vivado

• Basys3 FPGA Board

🧪 **Working Principle**

• Data is written into FIFO when **wr_en** is high and FIFO is not full

• Data is read when **rd_en** is high and FIFO is not empty

• Both operations can occur in the same clock cycle

• Status flags update synchronously

🎯 **Learning Outcomes**

• FIFO architecture design

• Pointer-based circular buffering

• Full/Empty detection techniques

• FPGA interfacing (buttons, LEDs, 7-seg)

• Hardware debugging and validation
