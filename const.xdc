## ===============================
## Clock
## ===============================
set_property PACKAGE_PIN W5 [get_ports CLK100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]
create_clock -add -name sys_clk -period 10.00 -waveform {0 5} [get_ports CLK100MHZ]


## ===============================
## Reset Button (Center)
## ===============================
set_property PACKAGE_PIN U18 [get_ports CPU_RESET]
set_property IOSTANDARD LVCMOS33 [get_ports CPU_RESET]


## ===============================
## Push Buttons
## ===============================
# BTNU (Write)
set_property PACKAGE_PIN T18 [get_ports BTNU]
set_property IOSTANDARD LVCMOS33 [get_ports BTNU]

# BTND (Read)
set_property PACKAGE_PIN W19 [get_ports BTND]
set_property IOSTANDARD LVCMOS33 [get_ports BTND]


## ===============================
## Switches (SW[7:0])
## ===============================
set_property PACKAGE_PIN V17 [get_ports {SW[0]}]
set_property PACKAGE_PIN V16 [get_ports {SW[1]}]
set_property PACKAGE_PIN W16 [get_ports {SW[2]}]
set_property PACKAGE_PIN W17 [get_ports {SW[3]}]
set_property PACKAGE_PIN W15 [get_ports {SW[4]}]
set_property PACKAGE_PIN V15 [get_ports {SW[5]}]
set_property PACKAGE_PIN W14 [get_ports {SW[6]}]
set_property PACKAGE_PIN W13 [get_ports {SW[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports SW[*]]


## ===============================
## LEDs (led[1:0])
## ===============================
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports led[*]]


## ===============================
## 7-Segment Display
## ===============================

# Segments (Active Low)
set_property PACKAGE_PIN W7  [get_ports {seg[0]}]
set_property PACKAGE_PIN W6  [get_ports {seg[1]}]
set_property PACKAGE_PIN U8  [get_ports {seg[2]}]
set_property PACKAGE_PIN V8  [get_ports {seg[3]}]
set_property PACKAGE_PIN U5  [get_ports {seg[4]}]
set_property PACKAGE_PIN V5  [get_ports {seg[5]}]
set_property PACKAGE_PIN U7  [get_ports {seg[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports seg[*]]


# Anodes (Active Low)
set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports an[*]]
