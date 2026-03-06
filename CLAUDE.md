# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a 4-bit adder/subtractor digital design project with two verification approaches:
- `plain/` — SystemVerilog testbench using plain OOP (no UVM framework)
- `uvm/` — UVM-based testbench (in progress; only DUT and Makefile exist so far)

The DUT (`src/4_bit_adder.v`) is a ripple-carry adder/subtractor: it XORs B with the `sub` control signal to form 2's complement, then computes `{Cout, Result} = A + b_inv + sub`.

## Build & Run

All commands are run from within `plain/` or `uvm/`:

```bash
# Build and run simulation
make

# Build only (compile, no run)
make build

# Run only (existing binary)
make run

# Clean build artifacts
make clean
```

The simulator is **Verilator**. The binary is compiled to `obj_dir/Vtop`.

To run with a different random seed (commented out in Makefile):
```bash
./obj_dir/Vtop +verilator+seed+<seed_value>
```

## Testbench Architecture (plain/)

The testbench follows a layered OOP structure inspired by UVM but without the framework:

```
top.sv           — Instantiates DUT, interface, and test program
tb_main.sv       — `program test`: creates and runs Environment
Environment.sv   — Wires up all components; owns mailboxes and events
  Generator.sv   — Randomizes Transaction objects; sends via gen2dr_mbx
  Driver.sv      — Gets transactions from mailbox; drives DUT via clocking block
  Monitor.sv     — Samples DUT outputs each clock; sends to mon2scr_mbx
  ScoreBoard.sv  — Receives from monitor; calls Transaction.expected_output() to check
  Transaction.sv — Data object: rand inputs (A, B, sub) + outputs (Result, Cout)
Interface.sv     — adder_if: defines driver_cb and monitor_cb clocking blocks
```

**Data flow:** Generator -> `gen2dr_mbx` -> Driver -> DUT -> Monitor -> `mon2scr_mbx` -> ScoreBoard

**Handshake:** `gen2dr_hs` event synchronizes Generator and Driver (Generator waits for Driver to consume before producing next).

**Key Verilator note** (documented in Interface.sv): Verilator does not support modports with clocking blocks, so components use the clocking blocks directly (`vif.driver_cb`, `vif.monitor_cb`) rather than modports.

## File Locations

- DUT source: `plain/src/4_bit_adder.v` and `uvm/src/4_bit_adder.v` (identical)
- Verification components: `plain/verif/*.sv`
- Verilator build output: `plain/obj_dir/` (generated, not source-controlled)
