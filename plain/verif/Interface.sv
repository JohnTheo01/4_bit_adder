interface adder_if(input logic clk);

    logic [3:0] A, B;
    logic sub;
    logic [3:0] Result;
    logic Cout;

    /*

    SOS: Verilator does not support modports with clocking blocks, so we will use the interface signals directly in the driver and monitor instead of using modports.
    */
    
     // Clocking block για τον Driver: Οδηγεί τις εισόδους του DUT
    clocking driver_cb @(posedge clk);
        default input #1ns output #1ns; 
        output A, B, sub;         // Ο Driver ΒΓΑΖΕΙ τιμές προς το DUT
        input  Result, Cout;      // Ο Driver ΔΙΑΒΑΖΕΙ (προαιρετικά) τις εξόδους
    endclocking

    // Clocking block για τον Monitor: Διαβάζει τα πάντα
    clocking monitor_cb @(posedge clk);
        default input #1ns output #1ns;
        input A, B, sub;          // Ο Monitor ΔΙΑΒΑΖΕΙ τις εισόδους
        input Result, Cout;       // Ο Monitor ΔΙΑΒΑΖΕΙ τις εξόδους
    endclocking

    // Modports που χρησιμοποιούν τα clocking blocks
    modport driver_mp (clocking driver_cb);
    modport monitor_mp (clocking monitor_cb);
    

    // Modport για driver: υποδηλώνει ότι ο driver οδηγεί τα σήματα εισόδου
    // modport driver_mp (
    //     output A, B, sub,
    //     input  Result, Cout   // αν θέλει να διαβάζει εξόδους (προαιρετικά)
    // );

    // Modport για monitor: διαβάζει όλα τα σήματα
   
    // Modport για DUT: τα σήματα όπως συνδέονται
    // modport dut_mp (
    //     input  A, B, sub,
    //     output Result, Cout
    // );

endinterface