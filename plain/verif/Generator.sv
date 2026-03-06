class Generator;

    Transaction tr;
    std::mailbox #(Transaction) gen2dr_mbx;

    event gen2dr_hs; // Handshake event between Generator and Driver

    function new(std::mailbox #(Transaction) gen2dr_mbx, event gen2dr_hs);
        this.gen2dr_mbx = gen2dr_mbx;
        this.gen2dr_hs = gen2dr_hs;
    endfunction

    function void build();
        $display("Generator: Build phase complete.");
    endfunction

    task run();

        forever begin : generator_loop

            this.tr = new();

            // this.tr.build();

            assert(this.tr.randomize() != 0) 
                else $fatal("Randomization failed for Transaction");

            // this.tr.display();

            gen2dr_mbx.put(this.tr);
            @(gen2dr_hs); // Wait for the handshake event from the Driver
        end

    endtask

    function void display();
        $display("Generator: tr.A=%b, tr.B=%b, tr.sub=%b", tr.A, tr.B, tr.sub);
    endfunction


    task wrapup();
        this.tr.wrapup();
        $display("Generator: Wrap-up complete.");
    endtask

endclass