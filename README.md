# 4-Digit Digital Locker — Xilinx Vivado / Artix-7

A Verilog HDL project for a password-protected digital locker using an Artix-7 FPGA.

## Features

- 4x4 matrix keypad input
- Default password: `1234`
- `*` clears the entered digits and returns the locker to locked state
- `#` submits the password
- Four-digit multiplexed seven-segment display
- Unlock and error LEDs
- Controller testbench

## Hardware assumptions

This is a board-independent RTL design. The example clock frequency is 100 MHz.
The XDC file is a **template**, not a ready-to-program pin map. You must use the
master XDC for your exact Artix-7 board and fill in every pin assignment.

Expected external hardware:
- Artix-7 FPGA board
- 4x4 matrix keypad
- Four-digit seven-segment display compatible with active-low segment/anode signals
- Two LEDs
- Active-high reset input

The design assumes active-low keypad row/column signals and a common-anode style
seven-segment display interface. If your board has common-cathode display wiring,
invert/adapt the display outputs.

## Keypad layout

|     | Column 0 | Column 1 | Column 2 | Column 3 |
|-----|----------|----------|----------|----------|
| Row 0 | 1 | 2 | 3 | A |
| Row 1 | 4 | 5 | 6 | B |
| Row 2 | 7 | 8 | 9 | C |
| Row 3 | * | 0 | # | D |

Only numeric keys are accepted as password digits. `*` is clear and `#` is submit.

## Password behavior

1. Enter four numeric digits.
2. Press `#` to compare them with the configured password.
3. Correct password lights `unlock_led`.
4. Incorrect password lights `error_led`.
5. Press `*` to clear the entry and relock.

The password is set in `locker_top.v` through the `PASSWORD` parameter
(default `16'h1234`). Change it to another packed BCD value if required:
`16'h2580` represents password 2580.

## Repository structure

```text
4_digit_locker_artix7/
├── rtl/
│   ├── keypad_scanner.v
│   ├── locker_controller.v
│   ├── sevenseg_mux.v
│   └── locker_top.v
├── testbench/
│   └── tb_locker_controller.v
├── constraints/
│   └── artix7_template.xdc
├── scripts/
│   └── create_project.tcl
├── README.md
└── .gitignore
```

## Open in Vivado

1. Open Vivado.
2. Open **Tools → Tcl Console**.
3. Change directory to this repository root.
4. Run: `source scripts/create_project.tcl`
5. Confirm the selected FPGA part matches your board.
6. Edit `constraints/artix7_template.xdc` using your board's master XDC.
7. Run **Run Synthesis**, **Run Implementation**, then **Generate Bitstream**.

The TCL script uses `xc7a35tcpg236-1` as an example part only. Replace it with
the exact device on your board before relying on the generated project.

## Simulation

Using Vivado:
1. Add `testbench/tb_locker_controller.v` to Simulation Sources.
2. Set `tb_locker_controller` as simulation top.
3. Run Behavioral Simulation.

The testbench checks a correct password and an incorrect password.

With Icarus Verilog installed, from the repository root:

```bash
iverilog -g2012 -o locker_tb rtl/locker_controller.v testbench/tb_locker_controller.v
vvp locker_tb
```

Expected messages include:
- `PASS: correct password unlocks`
- `PASS: wrong password sets error`
- `All locker controller tests passed.`

## GitHub

```bash
git init
git add .
git commit -m "Add Artix-7 four digit digital locker"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```

## Important engineering notes

- This is an educational FPGA demonstration, not a secure commercial lock.
- The current keypad scanner is a simple scan-and-edge detector; physical keypad
  bounce and simultaneous key presses may require additional debouncing/ghost-key
  handling for a production design.
- The display polarity and pin mapping depend on the board.
- The XDC template intentionally contains no fabricated package pin numbers.
