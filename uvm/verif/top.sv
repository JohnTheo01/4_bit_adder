`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
import test_pkg::*;

module top;

  logic clk = 0;
  always #5ns clk = ~clk;

  adder_if vif(clk);

  adder_subtractor_4bit dut(
    .A(vif.A), .B(vif.B), .sub(vif.sub),
    .Result(vif.Result), .Cout(vif.Cout)
  );

  initial begin
    uvm_config_db #(virtual adder_if)::set(null, "*", "vif", vif);
    run_test("simple_test");
  end

endmodule
