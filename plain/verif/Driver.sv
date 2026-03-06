class Driver;

    virtual adder_if vif;
    std::mailbox #(Transaction) gen2dr_mbx;


    event gen2dr_hs; // Handshake event between Generator and Driver


    function new(virtual adder_if vif, std::mailbox #(Transaction) gen2dr_mbx, event gen2dr_hs);
        this.vif = vif;
        this.gen2dr_mbx = gen2dr_mbx;
        this.gen2dr_hs = gen2dr_hs;
    endfunction

    function void build();
        // In this simple example, we don't have any complex build steps, but this is where you would set up any necessary connections or configurations for the driver.
        $display("Driver: Build phase complete.");
    endfunction

    task run();

        Transaction tr;
        $display("Driver: Starting run phase.");

        forever begin 
            gen2dr_mbx.get(tr);

            if (tr == null) begin
                $error("Driver: Received null transaction, skipping.");
                continue;
            end

            @(vif.driver_cb); // Wait for the clock edge to drive the signals
            vif.driver_cb.A <= tr.A;
            vif.driver_cb.B <= tr.B;
            vif.driver_cb.sub <= tr.sub;
            -> gen2dr_hs; // Signal the handshake event to the Generator


        end

    endtask

    function void wrapup();
        $display("Driver: Wrap-up complete.");
    endfunction


endclass