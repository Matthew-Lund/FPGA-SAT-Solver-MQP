`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2023 10:44:35 AM
// Design Name: 
// Module Name: SysMake
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


module SysMake #(parameter length = 5)(
    input [length-1:0] eq1_co, eq2_co,  //To account for index @ 0
    input [1:0] RHS,    //RHS for eq1 and eq2 can be same or diff (represent with 2 bits)
    input Rest, //Should be same for both equations
    output reg [length+1:0] eq1, eq2    //Coefficients + Rest + RHS representation
    );
    
    //To check if 
    wire weightcheck_eq1, weightcheck_eq2;
        
    hamming #(.length(length)) h1(
        .counter(eq1_co),
        .flag2(weightcheck_eq1)
    );
    
    hamming #(.length(length)) h2(
        .counter(eq2_co),
        .flag2(weightcheck_eq2)
    );
    
    always @  (eq1_co, eq2_co, RHS, Rest) begin
        if(weightcheck_eq1 && weightcheck_eq2) begin
             eq1 = {eq1_co, Rest, RHS[0]};  //Use first bit of RHS for eq1
             eq2 = {eq2_co, Rest, RHS[1]};  //Second bit of RHS for eq2
         end
        else begin
            eq1 = eq1;
            eq2 = eq2;
        end
     end
    
endmodule
