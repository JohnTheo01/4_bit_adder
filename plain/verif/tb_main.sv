program test(adder_if vif);

    Environment env;

    initial begin
        env = new(vif);

        env.build();
        
        env.run();


        #1000ns; // Run the simulation for a certain time

        env.wrapup();
        $finish;
    end
    
endprogram