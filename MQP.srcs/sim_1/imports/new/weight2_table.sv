//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 02:07:07 PM
// Design Name: 
// Module Name: weight2_table
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module weight2_table(

    );
    reg [4:0] eq1_count, eq2_count;   //iterate for loop
    reg [2:0] RHS;  //for equations
    wire RHS1, RHS2;
    assign {RHS2, RHS1} = RHS[1:0];
    reg [1:0] Rest;   //for equations
    wire [6:0] eq1_co, eq2_co;  //output of lut
    integer sys_num, solutions_num; //for # of systems and solutions per system
    reg [4:0] terms;    //for iterating through X1-X4
    wire solved;    //for saying if solution
    
    //Equations
    wire[8:0] eq1, eq2;
    assign eq1 = {eq1_co, Rest[0], RHS1};
    assign eq2 = {eq2_co, Rest[0], RHS2};
    
    weight2_lut eq1_coefficient(
        .counter(eq1_count),
        .coeff(eq1_co)
    );
    
    weight2_lut eq2_coefficient(
        .counter(eq2_count),
        .coeff(eq2_co)
    );
    
    solver algorithm(
        .terms(terms[3:0]),
        .Co_1(eq1),
        .Co_2(eq2),
        .solved(solved)
    );
    
    initial begin
        eq1_count = 0;
        eq2_count = 1; //avoid "squared" positions
        RHS = 3'b000;
        Rest = 2'b00;
        sys_num = 0;
        solutions_num = 0;
        terms = 0;
        #20;
        while(Rest[1] != 1'b1) begin
            while(RHS[2] != 1'b1) begin
                while(eq1_count <= 18) begin
                    while(eq2_count <= 19) begin
                        sys_num = sys_num + 1;
                        $display("System # %d", sys_num);
                        $display("EQ1 : %b", eq1);
                        $display("EQ2 : %b", eq2);
                        while(terms[4] != 1) begin
                            if(solved) begin
                                solutions_num = solutions_num + 1;
                                $display("Solution : X1 = %b , X2 = %b , X3 = %b  ,X4 = %b ", terms[0], terms[1], terms[2], terms[3]);
                            end
                            #5 terms = terms + 1;
                        end
                        terms = 0;
                        solutions_num = 0;
                        eq2_count = eq2_count + 1'b1;
                    end
                    eq1_count = eq1_count + 1'b1;
                    eq2_count = eq1_count + 1'b1;
                end
                RHS = RHS + 1'b1;
                eq1_count = 0;
                eq2_count = 1;
            end
            Rest = Rest + 1'b1;
            RHS = 3'b000;
            eq1_count = 0;
            eq2_count = 1;
        end
        
        $stop;
    end 
    
    
endmodule
