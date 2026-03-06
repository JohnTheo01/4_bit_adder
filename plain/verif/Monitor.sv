class Monitor;

    Transaction tr;

    virtual adder_if vif;
    std::mailbox #(Transaction) mon2scr_mbx;

    function new(virtual adder_if vif, std::mailbox #(Transaction) mon2scr_mbx);
        this.vif = vif;
        this.mon2scr_mbx = mon2scr_mbx;
    endfunction

    function void build();
        // In this simple example, we don't have any complex build steps, but this is where you would set up any necessary connections or configurations for the monitor.
        $display("Monitor: Build phase complete.");
    endfunction

    task run();
        
        $display("Monitor: Starting run phase.");

        forever begin @(vif.monitor_cb) // Wait for the clock edge to sample the signals;

            tr = new();
            tr.A = vif.monitor_cb.A;
            tr.B = vif.monitor_cb.B;
            tr.sub = vif.monitor_cb.sub;

            tr.Result = vif.monitor_cb.Result;
            tr.Cout = vif.monitor_cb.Cout;

            // $display("Monitor: Captured transaction - A=%b, B=%b, sub=%b, Result=%b, Cout=%b", tr.A, tr.B, tr.sub, tr.Result, tr.Cout);


            mon2scr_mbx.put(tr);

        end

    endtask

    function void wrapup();
        $display("Monitor: Wrap-up complete.");
    endfunction

endclass 