# Basys 3 Setup for sar6502 CPU Test

This document describes how to set up and run the sar6502 CPU test on the Basys 3 FPGA.

## Overview

The test setup includes:
- A top-level module (`basys3_top.sv`) that wraps the sar6502 CPU
- A Block RAM IP core initialized with the test program
- A simple test program that displays CPU status on LEDs and 7-segment displays
- Proper timing constraints for the Basys 3 FPGA
- Memory initialization from assembly source

## Files Created

1. **`basys3_top.sv`** - Top-level module for Basys 3
2. **`basys3_constraints.xdc`** - Pin assignments and timing constraints
3. **`basys3_test.asm`** - 6502 assembly test program
4. **`basys3_test.mem`** - Memory initialization file
5. **`basys3_test.coe`** - COE file for Block Memory Generator
6. **`basys3_test_bram.tcl`** - TCL script to create Block RAM IP core
7. **`setup_basys3_project.tcl`** - Complete project setup script

## Vivado Project Setup

### Option 1: Automated Setup (Recommended)
1. Open Vivado and open your project
2. In the TCL console, run:
   ```tcl
   source setup_basys3_project.tcl
   ```

### Option 2: Manual Setup
1. **Add Source Files** to your Vivado project:
   - `sar6502.srcs/sources_1/new/basys3_top.sv` (set as top-level)
   - All existing CPU source files (alu.sv, bus_sources.sv, etc.)

2. **Add Constraints**:
   - `sar6502.srcs/sources_1/new/basys3_constraints.xdc`

3. **Create Block RAM IP Core**:
   - In TCL console: `source sar6502.srcs/sources_1/new/basys3_test_bram.tcl`

4. **Set Top-Level Module**:
   - Set `basys3_top` as the top-level module in your Vivado project

## Building the Test Program

To rebuild the test program after making changes:

```bash
cd programs
./build_rom_65c02.sh basys3_test
```

This will:
1. Assemble the 6502 code
2. Generate .mem, .coe, and BRAM TCL files
3. Copy files to the Vivado source directory
4. Create a TCL script for the Block RAM IP core

## Memory Architecture

The system uses a Block RAM IP core for program storage:
- **Address Range**: 0xE000 - 0xFFFF (8KB)
- **Memory Type**: Single-Port ROM
- **Data Width**: 8 bits
- **Initialization**: From COE file generated from assembly

## Physical Testing

### Hardware Setup
1. Connect the Basys 3 to your computer
2. Power on the board
3. Program the FPGA with the generated bitstream

### Expected Behavior
- **LEDs 0-7**: Controlled by the CPU test program (displays status)
- **LEDs 8-15**: Show CPU status signals (sync, ml, vp, incompatible, address bits)
- **7-segment display**: Shows CPU address and data bus values
- **Center button (btnC)**: Reset button

### Test Program Operation
The test program:
1. Initializes the stack and I/O
2. Enters a main loop that:
   - Reads CPU status and displays it on LEDs
   - Displays patterns on the 7-segment display
   - Includes delay loops for visible timing
   - Continuously loops to show the CPU is running

## Timing Considerations

- **System Clock**: 100MHz (Basys 3 default)
- **CPU Clock**: ~14.286MHz (100MHz / 7)
- **Reset**: Debounced button with power-on reset
- **Memory Access**: Single-cycle synchronous via Block RAM

## Troubleshooting

### Common Issues
1. **BRAM not created**: Run the BRAM TCL script manually
2. **Timing violations**: Check that constraints are properly applied
3. **No output**: Verify reset is working and CPU is starting from correct address
4. **Memory not loading**: Ensure COE file is in the correct location

### Debugging
- Use the LEDs to monitor CPU status
- 7-segment display shows address and data bus activity
- Reset button can restart the CPU if needed

## Modifying the Test

To modify the test program:
1. Edit `programs/basys3_test.asm`
2. Run `./build_rom_65c02.sh basys3_test`
3. In Vivado, regenerate the BRAM IP core:
   ```tcl
   source sar6502.srcs/sources_1/new/basys3_test_bram.tcl
   ```
4. Re-synthesize in Vivado

## I/O Addresses

The test program uses these I/O addresses:
- `$0200`: LED output
- `$0201`: 7-segment display
- `$0202`: 7-segment anodes
- `$0203`: CPU status readback

## Block RAM IP Core Details

The BRAM IP core is configured as:
- **Memory Type**: Single-Port ROM
- **Port A Width**: 8 bits
- **Port A Depth**: 8192 locations
- **Enable**: Always enabled
- **Initialization**: From COE file
- **Fill**: Remaining locations filled with 0x00 