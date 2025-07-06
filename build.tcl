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

# Add constraints file
set constraints_file "${verilog_dir}/basys3_constraints.xdc"
if {[file exists $constraints_file]} {
    add_files -fileset constrs_1 $constraints_file
    puts "Added constraints file: $constraints_file"
} else {
    puts "WARNING: Constraints file not found at: $constraints_file"
}

# Create Block RAM IP core
puts "Creating Block RAM IP core..."
set tcl_script "${project}.srcs/sources_1/new/${ip_name}.tcl"
if {[catch {source $tcl_script} result]} {
    puts "ERROR: Failed to create Block RAM IP core: $result"
    exit 1
}
puts "Block RAM IP core created successfully."

# Add IP core to the project
add_files -norecurse [get_files *.xci]
puts "Added IP core files to project"

# Ensure IP core is properly configured
set_property generate_synth_checkpoint true [get_files *.xci]
puts "Set IP core to generate synthesis checkpoint"

# Add the IP core to the project
puts "Adding IP core to project..."
# Generate the IP core
generate_target all [get_ips ${ip_name}]

# IP generation is handled by generate_target
puts "IP generation completed."

# Small delay to ensure files are written
after 1000

# Check if IP core was created successfully
if {[get_ips ${ip_name}] == ""} {
    puts "ERROR: IP core ${ip_name} was not created successfully"
    exit 1
} else {
    puts "IP core ${ip_name} found successfully"
}

# Check if generated files exist
set synth_file "${project}.gen/sources_1/ip/${ip_name}/synth/${ip_name}.vhd"
if {[file exists $synth_file]} {
    puts "Synthesis file found: $synth_file"
    # Explicitly add the synthesis file to the project
    add_files -norecurse $synth_file
    puts "Added synthesis file to project"
} else {
    puts "WARNING: Synthesis file not found: $synth_file"
}

# IP core files are automatically managed by Vivado
puts "IP core files are automatically managed by Vivado"

# Update the project
update_compile_order -fileset sources_1

# Set the top module
set_property top $top_module [current_fileset]

# Ensure IP core is in synthesis fileset
set_property USED_IN_SYNTHESIS true [get_files *.xci]
puts "Set IP core for synthesis use"

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