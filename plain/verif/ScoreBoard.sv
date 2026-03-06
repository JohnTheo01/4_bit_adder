class ScoreBoard;

    std::mailbox #(Transaction) mon2scr_mbx;

    int score;
    int total_tests;

    function new(std::mailbox #(Transaction) mon2scr_mbx);
        this.mon2scr_mbx = mon2scr_mbx;
        score = 0;
        total_tests = 0;
    endfunction

    function void update_score(int score_increment);
        score += score_increment;
        total_tests++;
    endfunction

    function real get_score_percentage();
        if (total_tests == 0) return 0.0;
        return (score / total_tests) * 100.0;
    endfunction

    function void display_final_score();
        real percentage = get_score_percentage();
        $display("[SCOREBOARD] Final Score: %0d/%0d (%.2f%%)", score, total_tests, percentage);
    endfunction


    function void build();
        // In this simple example, we don't have any complex build steps, but this is where you would set up any necessary connections or configurations for the scoreboard.
        $display("ScoreBoard: Build phase complete.");
    endfunction

    task run();
        Transaction tr;
        logic [3:0] exp_Result;
        logic exp_Cout;
        forever begin 

            mon2scr_mbx.get(tr);

            tr.expected_output(exp_Result, exp_Cout);

            if (exp_Result == tr.Result && exp_Cout == tr.Cout) begin
                $write("[SCOREBOARD] PASS! Time = %t", $time);
                tr.display();
                update_score(1);
            end else begin 
                $display("[SCOREBOARD] FAIL! Time = %t", $time);
                tr.display();
                $display("Expected: Result=%b, Cout=%b", exp_Result, exp_Cout);
                update_score(0);
            end

        end
    endtask

    function void wrapup();
        $display("ScoreBoard: Wrap-up complete.");
    endfunction


endclass