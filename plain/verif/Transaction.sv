class Transaction;

    rand logic [3:0] A, B;
    rand logic sub;
    logic [3:0] Result;
    logic Cout;

    function new();
        Result = 0;
        Cout = 0;
    endfunction

    function void build();
        // Randomize the transaction values
        // assert(this.randomize() != 0) 
        //     else $fatal("Randomization failed for Transaction");
        if (this.randomize() != 0) 
            $display("DEBUG: Randomization OK - A =%d", A);
        else 
            $fatal("Randomization failed");
    
    endfunction

    function void display();
        $display("\tTransaction: A=%b, B=%b, sub=%b, Result=%b, Cout=%b", A, B, sub, Result, Cout);
    endfunction


    function void expected_output(output bit [3:0] Result, output bit Cout);
        if (sub) begin
           {Cout, Result} = {1'b0, A} + {1'b0, ~B} + 5'd1;
        end else begin
            {Cout, Result} = {1'b0, A} + {1'b0, B};
        end
    endfunction

    task wrapup();
        $display("Transaction: Wrap-up complete.");
    endtask

endclass
