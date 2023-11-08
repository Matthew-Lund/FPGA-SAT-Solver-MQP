`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2023 10:42:36 AM
// Design Name: 
// Module Name: Solver_Example
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
module solver(
    input [3:0] terms,
    input [8:0] Co_1, Co_2,
    output solved
    );
    
    wire X1, X2, X3, X4;
    assign {X4, X3, X2, X1} = terms[3:0];
    
    //X1 + X2 + X3 + X1X2 + X2X3 + X3X4 + Rest = RHS
    //7 Terms + Rest + RHS = 9 Bit long Equations
    
    wire X1X2 = X1 & X2;
    wire X2X3 = X2 & X3;
    wire X3X4 = X4 & X3;
    
    wire result_1 = (X1 & Co_1[8]) ^ (X2 & Co_1[7]) ^ (X3 & Co_1[6]) ^(X4 * Co_1[5]) ^(X1X2 & Co_1[4]) ^(X2X3 & Co_1[3]) ^(X3X4 & Co_1[2]) ^ Co_1[1];
    wire result_2 = (X1 & Co_2[8]) ^ (X2 & Co_2[7]) ^ (X3 & Co_2[6]) ^(X4 * Co_2[5]) ^(X1X2 & Co_2[4]) ^(X2X3 & Co_2[3]) ^(X3X4 & Co_2[2]) ^ Co_2[1];
    
    assign solved = ( (result_1 == Co_1[0]) && (result_2 == Co_2[0]) ) ? 1'b1 : 1'b0;
    
endmodule