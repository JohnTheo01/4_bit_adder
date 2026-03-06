# 4-bit Adder/Subtractor — Plain SystemVerilog Testbench

> **Educational project.** This testbench is intentionally structured to mirror UVM concepts (Environment, Generator, Driver, Monitor, ScoreBoard, Transaction) so that it can be straightforwardly transitioned into a full UVM-based testbench. The `uvm/` sibling directory is the intended target for that migration.

A 4-bit ripple-carry adder/subtractor with a layered OOP verification environment written in SystemVerilog, simulated with Verilator.

## DUT

`src/4_bit_adder.v` implements a 4-bit adder/subtractor:

- `sub = 0`: computes `{Cout, Result} = A + B`
- `sub = 1`: computes `{Cout, Result} = A - B` (via 2's complement: XOR B with `sub`, then add with carry-in = 1)

| Port     | Width | Direction | Description                  |
|----------|-------|-----------|------------------------------|
| `A`      | 4     | input     | First operand                |
| `B`      | 4     | input     | Second operand               |
| `sub`    | 1     | input     | 0 = add, 1 = subtract        |
| `Result` | 4     | output    | 4-bit result                 |
| `Cout`   | 1     | output    | Carry-out / borrow indicator |

## Testbench Architecture

The testbench follows a UVM-inspired layered structure without using the UVM framework.

```
top.sv
└── tb_main.sv (program test)
    └── Environment
        ├── Generator  ──[gen2dr_mbx]──> Driver ──> DUT (via Interface clocking block)
        └── Monitor <── DUT            Monitor ──[mon2scr_mbx]──> ScoreBoard
```

### Components

| Component      | File               | Role |
|----------------|--------------------|------|
| `adder_if`     | `Interface.sv`     | SystemVerilog interface with `driver_cb` and `monitor_cb` clocking blocks |
| `Transaction`  | `Transaction.sv`   | Randomizable data object; also computes expected output |
| `Generator`    | `Generator.sv`     | Continuously randomizes and sends `Transaction` objects to the Driver |
| `Driver`       | `Driver.sv`        | Drives DUT inputs via `driver_cb` clocking block each clock cycle |
| `Monitor`      | `Monitor.sv`       | Samples all DUT signals on `monitor_cb`; forwards to ScoreBoard |
| `ScoreBoard`   | `ScoreBoard.sv`    | Compares DUT output against `Transaction.expected_output()`; tracks pass/fail score |
| `Environment`  | `Environment.sv`   | Instantiates and connects all components; owns mailboxes and handshake event |

### Communication

- **`gen2dr_mbx`** (`mailbox<Transaction>`): carries transactions from Generator to Driver
- **`mon2scr_mbx`** (`mailbox<Transaction>`): carries sampled transactions from Monitor to ScoreBoard
- **`gen2dr_hs`** (`event`): handshake that makes the Generator wait until the Driver has consumed a transaction before producing the next

## Build & Run

Requires [Verilator](https://www.veripool.org/verilator/) to be installed.

```bash
# Build and run
make

# Build only
make top

# Clean build artifacts
make clean
```

The simulation runs for 1000 ns after the environment starts. The ScoreBoard prints a `PASS`/`FAIL` line for each transaction and a final score summary at wrap-up.

## Notes

- Verilator does not support modports combined with clocking blocks, so the Driver and Monitor reference clocking blocks directly (`vif.driver_cb`, `vif.monitor_cb`) rather than through modports.
- To run with a fixed random seed: `./obj_dir/Vtop +verilator+seed+<value>`
