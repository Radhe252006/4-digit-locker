# Run from the project root in Vivado Tcl Console:
# source scripts/create_project.tcl
set project_name "four_digit_locker"
set project_dir  [file normalize "./vivado_project"]

# Change this to match your exact Artix-7 device / board.
# Example part only; verify against your board before use.
set fpga_part "xc7a35tcpg236-1"

create_project $project_name $project_dir -part $fpga_part -force
add_files [glob ./rtl/*.v]
add_files -fileset sim_1 [glob ./testbench/*.v]
add_files -fileset constrs_1 ./constraints/artix7_template.xdc
set_property top locker_top [current_fileset]
set_property top tb_locker_controller [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
puts "Project created. Confirm FPGA part and complete the XDC pin assignments."
