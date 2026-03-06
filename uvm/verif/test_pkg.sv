package test_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class simple_test extends uvm_test;
    `uvm_component_utils(simple_test)

    function new(string name = "simple_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("SMOKE", "UVM is alive -- Hello from simple_test!", UVM_LOW)
      #100ns;
      phase.drop_objection(this);
    endtask

  endclass
endpackage
