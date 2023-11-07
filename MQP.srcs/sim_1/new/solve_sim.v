`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2023 02:58:31 PM
// Design Name: 
// Module Name: solve_sim
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


module solve_sim();
    
    reg [4:0] terms;
    reg [8:0] eq1, eq2;
    wire solved;
    reg [7:0] solutions_num;
    
    solver uut(
        .terms(terms[3:0]),
        .Co_1(eq1),
        .Co_2(eq2),
        .solved(solved)
    );
    
    initial begin
        $display("Testing 2 Systems of Equations X1 + X2 + X3 + X1X2 + X2X3 + X3X4 + Rest = RHS");
        //Set all to 0 initially 
        eq1 = 9'b0000000_00;
        eq2 = 9'b0000000_00;
        terms = 5'b0_0000;
        solutions_num = 8'd0;
        
        #50;
        
        $display("2 Different Linear Terms, Rest = 0");
        eq1 = 9'b1010000_00;
        eq2 = 9'b0101000_01;
        while(terms[4] == 1'b0) begin
            if(solved) begin
                $display("Solution Found! X1 = %b, X2 = %b, X3 = %b, X4 = %b", terms[0], terms[1], terms[2], terms[3]);
                solutions_num <= solutions_num + 1;
            end
            #10 terms <= terms + 5'b1;
        end
        $display("Number of solutions: %d", solutions_num);
        eq1 = 9'b0000000_00;
        eq2 = 9'b0000000_00;
        terms = 5'b0_0000;
        solutions_num = 8'd0;
        
        #50;
        
        $display("2 Different Linear Terms, Rest = 1");
        eq1 = 9'b1100000_11;
        eq2 = 9'b0011000_10;
        while(terms[4] == 1'b0) begin
            if(solved) begin
                $display("Solution Found! X1 = %b, X2 = %b, X3 = %b, X4 = %b", terms[0], terms[1], terms[2], terms[3]);
                solutions_num <= solutions_num + 1;
            end
            #10 terms <= terms + 5'b1;
        end
        $display("Number of solutions: %d", solutions_num);
        eq1 = 9'b0000000_00;
        eq2 = 9'b0000000_00;
        terms = 5'b0_0000;
        solutions_num = 8'd0;
                
        #50;
        
        $display("1 Different Linear Term, 1 Different Quadratic w/ shared Term, Rest = 0");
        eq1 = 9'b1000100_01;
        eq2 = 9'b0010010_00;
        while(terms[4] == 1'b0) begin
            if(solved) begin
                $display("Solution Found! X1 = %b, X2 = %b, X3 = %b, X4 = %b", terms[0], terms[1], terms[2], terms[3]);
                solutions_num <= solutions_num + 1;
            end
            #10 terms <= terms + 5'b1;
        end
        $display("Number of solutions: %d", solutions_num);
        eq1 = 9'b0000000_00;
        eq2 = 9'b0000000_00;
        terms = 5'b0_0000;
        solutions_num = 8'd0;
        $stop;
    end
    
endmodule
