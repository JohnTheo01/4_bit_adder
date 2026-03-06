import std::*;

class Environment;

    std::mailbox #(Transaction) gen2dr_mbx;
    std::mailbox #(Transaction) mon2scr_mbx;

    virtual adder_if vif;

    event gen2dr_hs; // Handshake event between Generator and Driver

    Generator generator;
    Driver driver;
    Monitor monitor;
    ScoreBoard scoreboard;


   function new(virtual adder_if vif);

        this.vif = vif;

        gen2dr_mbx = new();
        mon2scr_mbx = new();

        generator = new(gen2dr_mbx, gen2dr_hs);
        driver = new(vif, gen2dr_mbx, gen2dr_hs);

        monitor = new(vif, mon2scr_mbx);
        scoreboard = new(mon2scr_mbx);

        $display("\n[Environment]: Constructor complete.");

    endfunction


    function void build();
        this.generator.build();
        this.driver.build();
        this.monitor.build();
        this.scoreboard.build();

        $display("\n[Environment]: Build phase complete.");
        $display("Generator handle: %0d", generator);
        $display("Driver handle: %0d", driver);
        $display("Monitor handle: %0d", monitor);
        $display("Scoreboard handle: %0d\n", scoreboard);
    endfunction


    task run();
        fork
            generator.run();
            driver.run();
            monitor.run();
            scoreboard.run();
        join_none
    endtask   

    task wrapup();
        generator.wrapup();
        driver.wrapup();
        monitor.wrapup();
        scoreboard.wrapup();
    endtask


endclass