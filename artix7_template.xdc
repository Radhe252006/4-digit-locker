# Artix-7 4-Digit Locker - XDC TEMPLATE
# IMPORTANT:
# 1. Select the exact FPGA part / board in Vivado.
# 2. Replace every <...> placeholder with pins from your board master XDC.
# 3. Set I/O standards to match the board (commonly LVCMOS33).
# 4. Do NOT program the FPGA with unresolved placeholders.
#
# Example clock constraint (replace port/pin/period as appropriate):
# set_property PACKAGE_PIN <CLK_PIN> [get_ports clk]
# set_property IOSTANDARD LVCMOS33 [get_ports clk]
# create_clock -period 10.000 -name sys_clk [get_ports clk]
#
# Reset
# set_property PACKAGE_PIN <RESET_PIN> [get_ports reset]
# set_property IOSTANDARD LVCMOS33 [get_ports reset]
#
# Keypad rows (inputs, active-low)
# set_property PACKAGE_PIN <ROW0_PIN> [get_ports {keypad_row_n[0]}]
# set_property PACKAGE_PIN <ROW1_PIN> [get_ports {keypad_row_n[1]}]
# set_property PACKAGE_PIN <ROW2_PIN> [get_ports {keypad_row_n[2]}]
# set_property PACKAGE_PIN <ROW3_PIN> [get_ports {keypad_row_n[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_row_n[*]}]
#
# Keypad columns (outputs, active-low)
# set_property PACKAGE_PIN <COL0_PIN> [get_ports {keypad_col_n[0]}]
# set_property PACKAGE_PIN <COL1_PIN> [get_ports {keypad_col_n[1]}]
# set_property PACKAGE_PIN <COL2_PIN> [get_ports {keypad_col_n[2]}]
# set_property PACKAGE_PIN <COL3_PIN> [get_ports {keypad_col_n[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {keypad_col_n[*]}]
#
# Seven-segment segments and digit enables
# set_property PACKAGE_PIN <SEG_A_PIN> [get_ports {seg_n[7]}]
# set_property PACKAGE_PIN <SEG_B_PIN> [get_ports {seg_n[6]}]
# set_property PACKAGE_PIN <SEG_C_PIN> [get_ports {seg_n[5]}]
# set_property PACKAGE_PIN <SEG_D_PIN> [get_ports {seg_n[4]}]
# set_property PACKAGE_PIN <SEG_E_PIN> [get_ports {seg_n[3]}]
# set_property PACKAGE_PIN <SEG_F_PIN> [get_ports {seg_n[2]}]
# set_property PACKAGE_PIN <SEG_G_PIN> [get_ports {seg_n[1]}]
# set_property PACKAGE_PIN <SEG_DP_PIN> [get_ports {seg_n[0]}]
# set_property PACKAGE_PIN <AN0_PIN> [get_ports {an_n[0]}]
# set_property PACKAGE_PIN <AN1_PIN> [get_ports {an_n[1]}]
# set_property PACKAGE_PIN <AN2_PIN> [get_ports {an_n[2]}]
# set_property PACKAGE_PIN <AN3_PIN> [get_ports {an_n[3]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {seg_n[*]}]
# set_property IOSTANDARD LVCMOS33 [get_ports {an_n[*]}]
#
# LEDs
# set_property PACKAGE_PIN <UNLOCK_LED_PIN> [get_ports unlock_led]
# set_property PACKAGE_PIN <ERROR_LED_PIN> [get_ports error_led]
# set_property IOSTANDARD LVCMOS33 [get_ports {unlock_led error_led}]
