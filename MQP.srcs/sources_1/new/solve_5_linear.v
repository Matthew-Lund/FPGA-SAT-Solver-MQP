`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2023 08:16:06 PM
// Design Name: 
// Module Name: solve_5_linear
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


module solve_5_linear #(parameter eq_num = 5)(
    input [4:0] Terms,
    input EQ_Matrix[15:0][eq_num-1:0],  //2D Array
    output Solution
    );
    
    wire X1, X2, X3 ,X4 ,X5 ,X1X2, X1X3, X1X4, X1X5, X2X3, X2X4, X2X5, X3X4, X3X5, X4X5;
    
    assign X1 = Terms[0];    //Assign Linear Terms 
    assign X2 = Terms[1];
    assign X3 = Terms[2];
    assign X4 = Terms[3];
    assign X5 = Terms[4];
    
    //Assigning Quad Terms
    assign X1X2 = X1 & X2;
    assign X1X3 = X1 & X3;
    assign X1X4 = X1 & X4;
    assign X1X5 = X1 & X5;
    assign X2X3 = X2 & X3;
    assign X2X4 = X2 & X4;
    assign X2X5 = X2 & X5;
    assign X3X4 = X3 & X4;
    assign X3X5 = X3 & X5;
    assign X4X5 = X4 & X5;

    reg temp_matrix[1:0][eq_num-1:0];
    
    reg[4:0] eq_counter;
    always @ * begin
        while(eq_counter < eq_num) begin
        temp_matrix[0][eq_counter] = (X1&EQ_Matrix[15][eq_counter]) ^(X2&EQ_Matrix[14][eq_counter]) ^(X3&EQ_Matrix[13][eq_counter]) ^(X4&EQ_Matrix[12][eq_counter]) ^(X5&EQ_Matrix[11][eq_counter]) ^(X1X2&EQ_Matrix[10][eq_counter]) ^(X1X3&EQ_Matrix[9][eq_counter]) ^(X1X4&EQ_Matrix[8][eq_counter]) ^(X1X5&EQ_Matrix[7][eq_counter]) ^(X2X3&EQ_Matrix[6][eq_counter]) ^(X2X4&EQ_Matrix[5][eq_counter]) ^(X2X5&EQ_Matrix[4][eq_counter]) ^(X3X4&EQ_Matrix[3][eq_counter]) ^(X3X5&EQ_Matrix[2][eq_counter]) ^(X4X5&EQ_Matrix[1][eq_counter]);
        temp_matrix[1][eq_num-1:0] <= EQ_Matrix[0][eq_num-1:0];// Set all [1] values to RHS
        eq_counter <= eq_counter + 1; 
        end
    end
    
    assign Solution = (temp_matrix[0] == temp_matrix[1]) ? 1'b1 : 1'b0;
    
endmodule
