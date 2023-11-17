`timescale 1ns / 1ps
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
        eq1_count <= 0;
        eq2_count <= 1;
        RHS <= 3'b000;
        Rest <= 2'b00;
        sys_num <= 0;
        solutions_num <= 0;
        #200;            
        while(eq1_count <= 5'd19) begin //loop over only 0-19
            if(eq1_count == 5'd0 && eq2_count >= 5'd19) begin
               eq1_count <= eq1_count + 1'b1; 
               eq2_count <= eq1_count;  //to prevent overlap of equations
            end
            while(eq2_count <= 5'd19)begin //loop over only 0-19 
               
               if(eq1_co != eq2_co) begin//only unique combinations 
                    
                    sys_num <= sys_num + 1;
                    $display("System # %d", sys_num + 1);
                    $display("eq1 : %b", eq1);
                    $display("eq2 : %b", eq2);
                    terms <= 5'b0_0000;   
                        while(terms[4] == 1'b0) begin   //iterate through terms 
                            if(solved) begin
                                $display("Solution Found! X1 = %b, X2 = %b, X3 = %b, X4 = %b", terms[0], terms[1], terms[2], terms[3]);
                                solutions_num <= solutions_num + 1;
                            end
                            
                            #10 terms <= terms + 1'b1;
                        end
                        
                    $display("# of solutions : %d", solutions_num);
                    $display("");
                    terms <= 5'b0_0000;
                    solutions_num <= 0;
                        
               end
               
               #10 eq2_count <= eq2_count + 5'b1;
               
            end
            
        end
        eq1_count <= 1;
        eq2_count <= 1;
        RHS <= 2'b01;
        $stop;
    end
    
    
endmodule
