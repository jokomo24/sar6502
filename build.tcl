# build.tcl - Run with: vivado -mode batch -source build.tcl

# Project settings
set project "sar6502"
set top_module "basys3_top"
set part xc7a35tcpg236-1
set ip_name "basys3_test_bram"

set verilog_dir "${project}.srcs/sources_1/new"
if { ![file exists $verilog_dir] } {
    puts "ERROR: RTL directory not found at: $verilog_dir"
    exit 1
}

# Add the source files to the project
set src_files [glob -nocomplain "$verilog_dir/*.v" "$verilog_dir/*.sv"]
if {[llength $src_files] == 0} {
    puts "ERROR: No Verilog/SystemVerilog source files found in $verilog_dir"
    exit 1
}
add_files $src_files

# Create Block RAM IP core
puts "Creating Block RAM IP core..."
set tcl_script "${project}.srcs/sources_1/new/${ip_name}.tcl"
if {[catch {source $tcl_script} result]} {
    puts "ERROR: Failed to create Block RAM IP core: $result"
    exit 1
}
puts "Block RAM IP core created successfully."

# Add the IP core to the project
puts "Adding IP core to project..."
# Generate the IP cor
generate_target all [get_ips ${ip_name}]

# Update the project
update_compile_order -fileset sources_1

# Synthesis and implementation
synth_design -top $top_module -part $part
opt_design
place_design
route_design

# Output bitstream
set bitstream_dir "${project}.runs/impl_1"
if { ![file exists $bitstream_dir] } {
    puts "ERROR: Implementation directory not found at: $bitstream_dir"
    exit 1
}
set bitstream_out "${bitstream_dir}/${top_module}.bit"
write_bitstream -force $bitstream_out

puts "INFO: Bitstream written to: $bitstream_out"