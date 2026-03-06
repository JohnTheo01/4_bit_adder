`timescale 1ns/1ps

module top;

    logic clk = 0;
    always #5ns clk = ~clk;

    adder_if vif(clk);


    adder_subtractor_4bit dut(
        .A(vif.A),
        .B(vif.B),
        .sub(vif.sub),
        .Result(vif.Result),
        .Cout(vif.Cout)
    );


    test test_inst(
        .vif(vif)
    );
    // initial begin
    //     $display("Starting simulation...");
    //     #1000ns; // Run the simulation for a specified time (adjust as needed)
    //     $display("Simulation finished.");
    //     $finish();
    // end

endmodule