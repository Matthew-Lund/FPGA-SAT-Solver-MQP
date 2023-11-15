`timescale 1ns / 1ps

module full_test();
    parameter length = 7;   //7 Coefficients
    wire [6:0] weight2_max = {2'b11, {(7-2){1'b0}} };

    reg [(length-1):0] eq1_coeff, eq2_coeff;
    reg [128:0] sys_num;

    wire weightcheck_eq1, weightcheck_eq2;

    reg Rest;

    reg [2:0] RHS;
    wire RHS_eq1, RHS_eq2;
    assign RHS_eq1 = RHS[0];
    assign RHS_eq2 = RHS[1];
    reg [4:0] terms;
    wire solved;
    reg [7:0] solutions_num;

    wire [(length+1):0] eq1, eq2;

    hamming #(.length(length)) h1(
        .counter(eq1_coeff),
        .flag2(weightcheck_eq1)
    );

    hamming #(.length(length)) h2(
        .counter(eq2_coeff),
        .flag2(weightcheck_eq2)
    );

    solver solving(
        .terms(terms[3:0]),
        .Co_1(eq1),
        .Co_2(eq2),
        .solved(solved)
    );

    reg first_run;
    reg [(length-1):0] eq_combinations [8:0][8:0];
    
    assign eq1 = {eq1_coeff, Rest, RHS_eq1};
    assign eq2 = {eq2_coeff, Rest, RHS_eq2};

    initial begin
        sys_num = 0;
        RHS = 0;
        first_run = 1;
        Rest = 0;
        
        repeat(2) begin
            while(RHS < 4) begin
                while(eq1_coeff <= weight2_max) begin
                    while(eq2_coeff <= weight2_max) begin
                        if(weightcheck_eq1 && weightcheck_eq2 && eq1[length+1:2] != eq2[length+1:2] && eq_combinations[eq1][eq2] == 0) begin
                            eq_combinations[eq1][eq2] = 1;
                            sys_num = sys_num + 1;
                            $display("System # %d Found!", sys_num);
                            $display("eq1 = %b", eq1);
                            $display("eq2 = %b", eq2);
                            $display("");
                            terms = 5'b0_0000;
                            solutions_num = 8'd0;
                            
                            while(terms[4] == 0) begin
                                if(solved) begin
                                    $display("Solution Found! X1 = %b, X2 = %b, X3 = %b, X4 = %b", terms[0], terms[1], terms[2], terms[3]);
                                    solutions_num = solutions_num + 1;
                                end
                                #10 terms = terms + 5'b1;
                            end
                            $display("Number of solutions: %d", solutions_num);
                            $display("");
                            terms = 5'b0_0000;
                            solutions_num = 8'd0;
                        end
                        #10 eq2_coeff = eq2_coeff + 1;
                    end
                    eq2_coeff = 0;
                    #10 eq1_coeff = eq1_coeff + 1;
                end
                eq1_coeff = 0;
                if(first_run) begin
                    RHS = 0;
                    first_run = 0;
                end
                else begin
                    #10 RHS = RHS + 1;
                end
            end
            RHS = 0;
            if(Rest) begin
                $stop;
            end
            Rest = Rest + 1;
        end
    end
endmodule
