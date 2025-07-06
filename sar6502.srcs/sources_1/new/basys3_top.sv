`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Some Assembly Required
// Engineer: Shachar Shemesh
// 
// Create Date: 02/23/2022 05:40:43 AM
// Design Name: basys3_top
// Module Name: basys3_top
// Project Name: CompuSAR
// Target Devices: Basys 3 FPGA
// Tool Versions: 
// Description: Top-level module for Basys 3 physical testing of sar6502 CPU
// 
// Dependencies: sar6502.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
// License:
//   Copyright (C) 2022.
//   Copyright owners listed in AUTHORS file.
//
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation; either version 2 of the License, or
//   (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR ANY PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with this program; if not, write to the Free Software
//   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
//////////////////////////////////////////////////////////////////////////////////

module basys3_top(
    input wire clk,           // 100MHz system clock
    input wire btnC,          // Center button for reset
    // input wire btnU,          // Up button (unused)
    // input wire btnL,          // Left button (unused)
    // input wire btnR,          // Right button (unused)
    // input wire btnD,          // Down button (unused)
    
    output reg [15:0] led,   // 16 LEDs for status display
    output reg [6:0] seg,    // 7-segment display segments
    output reg [3:0] an      // 7-segment display anodes
    
    // input wire [15:0] sw      // 16 switches (unused)
);

// Clock generation for 14MHz CPU clock (100MHz / 7 ≈ 14.286MHz)
localparam CLK_DIV = 7;
logic [2:0] clk_counter = 0;
logic phi2 = 0;

always_ff @(posedge clk) begin
    clk_counter <= clk_counter + 1;
    if (clk_counter == (CLK_DIV/2 - 1)) begin
        phi2 <= ~phi2;
        clk_counter <= 0;
    end
end

// Reset generation
logic reset_n;
logic reset_debounced;
logic [19:0] reset_counter = 0;

// Debounce reset button and generate power-on reset
always_ff @(posedge clk) begin
    reset_debounced <= btnC;
    
    if (reset_counter < 20'hFFFFF) begin
        reset_counter <= reset_counter + 1;
        reset_n <= 0;
    end else if (!reset_debounced) begin
        reset_n <= 0;
    end else begin
        reset_n <= 1;
    end
end

// CPU signals
logic [15:0] cpu_address;
logic [7:0] cpu_data_in, cpu_data_out;
logic cpu_rw, cpu_vp, cpu_ml, cpu_sync, cpu_incompatible;

// I/O addresses
localparam IO_LED_ADDR = 16'h0200;      // LED output
localparam IO_SEG_ADDR = 16'h0201;      // 7-segment display
localparam IO_AN_ADDR = 16'h0202;       // 7-segment anodes
localparam IO_STATUS_ADDR = 16'h0203;   // Status display

// Memory address decoding
logic bram_select;
logic [12:0] bram_address;  // 13-bit address for 8K BRAM

// BRAM is mapped to addresses 0xE000-0xFFFF (8KB)
assign bram_select = (cpu_address >= 16'hE000) && (cpu_address <= 16'hFFFF);
assign bram_address = cpu_address[12:0];  // Use lower 13 bits

// CPU instance
sar6502#(.CPU_VARIANT(2)) cpu(
    .phi2(phi2),
    .data_in(cpu_data_in),
    .RES(reset_n),
    .rdy(1'b1),              // Always ready
    .IRQ(1'b1),              // No interrupts
    .NMI(1'b1),              // No NMI
    .SO(1'b0),               // No set overflow
    .address(cpu_address),
    .data_out(cpu_data_out),
    .rW(cpu_rw),
    .VP(cpu_vp),
    .ML(cpu_ml),
    .sync(cpu_sync),
    .incompatible(cpu_incompatible)
);

// Instantiate Block RAM IP for program/data memory
logic [7:0] bram_data_out;
basys3_test_bram bram_inst (
    .clka(phi2),
    .addra(bram_address),    // Use 13-bit address
    .douta(bram_data_out)
);

// Memory and I/O data multiplexing
always_comb begin
    if (bram_select) begin
        cpu_data_in = bram_data_out;
    end else if (cpu_address == IO_STATUS_ADDR) begin
        // Read CPU status for debugging
        cpu_data_in = {cpu_sync, cpu_ml, cpu_vp, cpu_incompatible, 
                      cpu_address[15:12]};
    end else begin
        cpu_data_in = 8'h00;  // Default for unmapped addresses
    end
end

// I/O handling (LEDs, 7-seg, etc.)
always_ff @(posedge phi2) begin
    if (!reset_n) begin
        led <= 16'h0000;
        seg <= 7'b1111111;  // All segments off
        an <= 4'b1111;      // All anodes off
    end else begin
        if (!cpu_rw) begin  // Write cycle
            if (cpu_address == IO_LED_ADDR) begin
                led[7:0] <= cpu_data_out;
            end else if (cpu_address == IO_SEG_ADDR) begin
                seg <= cpu_data_out[6:0];
            end else if (cpu_address == IO_AN_ADDR) begin
                an <= cpu_data_out[3:0];
            end
        end
    end
end

// Initialize upper LEDs with CPU status
always_comb begin
    led[15:8] = {cpu_sync, cpu_ml, cpu_vp, cpu_incompatible, 
                 cpu_address[15:12]};
end

// 7-segment display driver
logic [3:0] display_value;
logic [1:0] display_counter = 0;

always_ff @(posedge clk) begin
    display_counter <= display_counter + 1;
end

// Display different values on each digit
always_comb begin
    case (display_counter)
        2'b00: display_value = cpu_address[3:0];    // Address low nibble
        2'b01: display_value = cpu_address[7:4];    // Address high nibble
        2'b10: display_value = cpu_data_out[3:0];   // Data low nibble
        2'b11: display_value = cpu_data_out[7:4];   // Data high nibble
    endcase
end

// 7-segment decoder
logic [6:0] seg_out;
always_comb begin
    case (display_value)
        4'h0: seg_out = 7'b1000000; // 0
        4'h1: seg_out = 7'b1111001; // 1
        4'h2: seg_out = 7'b0100100; // 2
        4'h3: seg_out = 7'b0110000; // 3
        4'h4: seg_out = 7'b0011001; // 4
        4'h5: seg_out = 7'b0010010; // 5
        4'h6: seg_out = 7'b0000010; // 6
        4'h7: seg_out = 7'b1111000; // 7
        4'h8: seg_out = 7'b0000000; // 8
        4'h9: seg_out = 7'b0010000; // 9
        4'hA: seg_out = 7'b0001000; // A
        4'hB: seg_out = 7'b0000011; // b
        4'hC: seg_out = 7'b1000110; // C
        4'hD: seg_out = 7'b0100001; // d
        4'hE: seg_out = 7'b0000110; // E
        4'hF: seg_out = 7'b0001110; // F
        default: seg_out = 7'b1111111; // Off
    endcase
end

// Anode selection
logic [3:0] an_out;
always_comb begin
    case (display_counter)
        2'b00: an_out = 4'b1110; // Rightmost digit
        2'b01: an_out = 4'b1101; // Second from right
        2'b10: an_out = 4'b1011; // Second from left
        2'b11: an_out = 4'b0111; // Leftmost digit
    endcase
end

endmodule 