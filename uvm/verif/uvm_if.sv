interface adder_if(input logic clk);

    logic [3:0] A, B;
    logic sub;
    logic [3:0] Result;
    logic Cout;

    /*
    SOS: Verilator does not support modports with clocking blocks, so we use
    the clocking blocks directly (vif.driver_cb, vif.monitor_cb) rather than modports.
    */

    clocking driver_cb @(posedge clk);
        default input #1ns output #1ns;
        output A, B, sub;
        input  Result, Cout;
    endclocking

    clocking monitor_cb @(posedge clk);
        default input #1ns output #1ns;
        input A, B, sub;
        input Result, Cout;
    endclocking

    modport driver_mp  (clocking driver_cb);
    modport monitor_mp (clocking monitor_cb);

endinterface
