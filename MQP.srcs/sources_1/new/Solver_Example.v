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


module Solver_Example #(parameter length = 5)(
    input [3:0] Terms,
    output Solved
    );
    
    wire X1, X2, X3, X4;
    assign {X4, X3, X2, X1} = Terms[3:0];
    
    
endmodule
