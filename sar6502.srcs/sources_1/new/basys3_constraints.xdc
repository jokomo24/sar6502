# Basys 3 FPGA Constraints for sar6502 CPU Test
# This file contains pin assignments and timing constraints for the Basys 3 board
# with the sar6502 CPU as an internal module

# ============================================================================
# CLOCK CONSTRAINTS
# ============================================================================

# 100MHz system clock from Basys 3
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

# 14MHz CPU clock (generated internally from 100MHz)
# The phi2 signal has a period of 70ns (14.286MHz)
# Since this is generated internally, we'll create a virtual clock for timing analysis
create_clock -period 70.000 -name phi2 -waveform {0.000 35.000}

# ============================================================================
# PIN ASSIGNMENTS
# ============================================================================

# System Clock (100MHz)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Push Buttons
set_property PACKAGE_PIN U18 [get_ports btnC]  ;# Center button (reset)
# set_property PACKAGE_PIN T18 [get_ports btnU]  ;# Up button
# set_property PACKAGE_PIN W19 [get_ports btnL]  ;# Left button
# set_property PACKAGE_PIN T17 [get_ports btnR]  ;# Right button
# set_property PACKAGE_PIN U17 [get_ports btnD]  ;# Down button

# LEDs
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports {led[0]}]
set_property -dict { PACKAGE_PIN E19   IOSTANDARD LVCMOS33 } [get_ports {led[1]}]
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports {led[2]}]
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports {led[3]}]
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports {led[4]}]
set_property -dict { PACKAGE_PIN U15   IOSTANDARD LVCMOS33 } [get_ports {led[5]}]
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports {led[6]}]
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports {led[7]}]
# set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports {led[8]}]
# set_property -dict { PACKAGE_PIN V3    IOSTANDARD LVCMOS33 } [get_ports {led[9]}]
# set_property -dict { PACKAGE_PIN W3    IOSTANDARD LVCMOS33 } [get_ports {led[10]}]
# set_property -dict { PACKAGE_PIN U3    IOSTANDARD LVCMOS33 } [get_ports {led[11]}]
# set_property -dict { PACKAGE_PIN P3    IOSTANDARD LVCMOS33 } [get_ports {led[12]}]
# set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports {led[13]}]
# set_property -dict { PACKAGE_PIN P1    IOSTANDARD LVCMOS33 } [get_ports {led[14]}]
# set_property -dict { PACKAGE_PIN L1    IOSTANDARD LVCMOS33 } [get_ports {led[15]}]

# 7-Segment Display
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]  ;# A
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]  ;# B
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]  ;# C
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]  ;# D
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]  ;# E
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]  ;# F
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]  ;# G
set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports {seg[7]}]  ;# DP

# Anodes
set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {an[0]}]
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {an[3]}]

# Switches (unused but included for completeness)
# set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports {sw[0]}]
# set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports {sw[1]}]
# set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports {sw[2]}]
# set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports {sw[3]}]
# set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33 } [get_ports {sw[4]}]
# set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports {sw[5]}]
# set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports {sw[6]}]
# set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports {sw[7]}]
# set_property -dict { PACKAGE_PIN V2    IOSTANDARD LVCMOS33 } [get_ports {sw[8]}]
# set_property -dict { PACKAGE_PIN T3    IOSTANDARD LVCMOS33 } [get_ports {sw[9]}]
# set_property -dict { PACKAGE_PIN T2    IOSTANDARD LVCMOS33 } [get_ports {sw[10]}]
# set_property -dict { PACKAGE_PIN R3    IOSTANDARD LVCMOS33 } [get_ports {sw[11]}]
# set_property -dict { PACKAGE_PIN W2    IOSTANDARD LVCMOS33 } [get_ports {sw[12]}]
# set_property -dict { PACKAGE_PIN U1    IOSTANDARD LVCMOS33 } [get_ports {sw[13]}]
# set_property -dict { PACKAGE_PIN T1    IOSTANDARD LVCMOS33 } [get_ports {sw[14]}]
# set_property -dict { PACKAGE_PIN R2    IOSTANDARD LVCMOS33 } [get_ports {sw[15]}]

# USB-RS232 Interface (unused but included for constraints compatibility)
# set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports uart_rx] ;# Sch name = RsRx
# set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports uart_tx] ;# Sch name = RsTx

# ============================================================================
# TIMING CONSTRAINTS FOR INTERNAL CPU SIGNALS
# ============================================================================

# These constraints ensure proper setup and hold times for the internal CPU
# signals that interface with the memory and I/O logic

# Input delays for CPU data bus (from memory/I/O to CPU)
set_input_delay -clock [get_clocks phi2] -clock_fall -min -add_delay 10.000 [get_pins basys3_top/cpu/data_in[*]/D]
set_input_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 60.000 [get_pins basys3_top/cpu/data_in[*]/D]

# Input delay for CPU reset signal
set_input_delay -clock [get_clocks phi2] -clock_fall -min -add_delay 10.000 [get_pins basys3_top/cpu/RES/D]
set_input_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 60.000 [get_pins basys3_top/cpu/RES/D]

# Output delays for CPU address bus (from CPU to memory/I/O)
set_output_delay -clock [get_clocks phi2] -clock_fall -min -add_delay -1.000 [get_pins basys3_top/cpu/address[*]/Q]
set_output_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 41.000 [get_pins basys3_top/cpu/address[*]/Q]

# Output delays for CPU data bus (from CPU to memory/I/O)
set_output_delay -clock [get_clocks phi2] -clock_fall -min -add_delay -1.000 [get_pins basys3_top/cpu/data_out[*]/Q]
set_output_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 11.000 [get_pins basys3_top/cpu/data_out[*]/Q]

# Output delays for CPU control signals
set_output_delay -clock [get_clocks phi2] -clock_fall -min -add_delay -1.000 [get_pins basys3_top/cpu/ML/Q]
set_output_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 41.000 [get_pins basys3_top/cpu/ML/Q]

set_output_delay -clock [get_clocks phi2] -clock_fall -min -add_delay -1.000 [get_pins basys3_top/cpu/VP/Q]
set_output_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 41.000 [get_pins basys3_top/cpu/VP/Q]

set_output_delay -clock [get_clocks phi2] -clock_fall -min -add_delay -1.000 [get_pins basys3_top/cpu/rW/Q]
set_output_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 41.000 [get_pins basys3_top/cpu/rW/Q]

set_output_delay -clock [get_clocks phi2] -clock_fall -min -add_delay -1.000 [get_pins basys3_top/cpu/sync/Q]
set_output_delay -clock [get_clocks phi2] -clock_fall -max -add_delay 41.000 [get_pins basys3_top/cpu/sync/Q]

# ============================================================================
# FALSE PATHS
# ============================================================================

# Reset button is asynchronous, so it doesn't need timing analysis
set_false_path -from [get_ports btnC]

# 7-segment display refresh is independent of CPU timing
set_false_path -from [get_pins basys3_top/display_counter_reg[*]/Q] -to [get_pins basys3_top/seg_reg[*]/D]

# ============================================================================
# MULTICYCLE PATHS
# ============================================================================

# Memory access can take multiple cycles if needed
# set_multicycle_path -setup 2 -from [get_clocks phi2] -to [get_clocks phi2] -through [get_pins basys3_top/memory[*]]

# ============================================================================
# CLOCK GROUPS
# ============================================================================

# Define clock groups to prevent cross-clock timing analysis where not needed
# The phi2 clock is derived from clk but has different timing requirements
set_clock_groups -asynchronous -group [get_clocks clk] -group [get_clocks phi2]

# ============================================================================
# CONFIGURATION OPTIONS
# ============================================================================

# Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

# SPI configuration mode options for QSPI boot, can be used for all designs
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design] 