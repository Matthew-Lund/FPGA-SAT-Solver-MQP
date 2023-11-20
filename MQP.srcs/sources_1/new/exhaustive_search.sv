`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 10:22:49 AM
// Design Name: 
// Module Name: exhaustive_search
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


module exhaustive_search(
    //input clk, reset_n,
    input [4:0] sw,
    output [5:0] led
    );
    
    // Define packed struct for equation coefficients
    typedef struct packed {
        logic [15:0] coefficient;
    } EquationCoeff;
    
    //16 equations with 15 coefficients + RHS
    EquationCoeff EQ_Matrix [0:15];   //X1 + X2 + X3 + X4 + X5 + X1X2 + X1X3 + X1X4 + X1X5 + X2X3 + X2X4 + X2X5 + X3X4 + X3X5 + X4X5 = RHS
    
    wire X1, X2, X3 ,X4 ,X5 ,X1X2, X1X3, X1X4, X1X5, X2X3, X2X4, X2X5, X3X4, X3X5, X4X5;
    wire [4:0] Terms = sw[4:0];
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
    
    wire [14:0] term_string = {X1, X2, X3, X4 ,X5, X1X2, X1X3, X1X4, X1X5, X2X3, X2X4, X2X5, X3X4, X3X5, X4X5}; //easier for computation
    
    //Equations
    assign EQ_Matrix[0].coefficient = 16'b01001_1011_001_11_0_1;    //X2 + X5 + X1X2 + X1X4 + X1X5 + X2X5 + X3X4 + X3X5 = 1
    assign EQ_Matrix[1].coefficient = 16'b10110_0001_101_01_1_0;    //good
    assign EQ_Matrix[2].coefficient = 16'b11001_1010_010_10_0_1;    //good
    assign EQ_Matrix[3].coefficient = 16'b11110_1100_111_00_1_0;
    assign EQ_Matrix[4].coefficient = 16'b01011_0011_011_10_1_0;
    assign EQ_Matrix[5].coefficient = 16'b01000_0100_110_01_0_0;
    assign EQ_Matrix[6].coefficient = 16'b00000_0101_101_01_0_1;
    assign EQ_Matrix[7].coefficient = 16'b01101_1001_111_01_1_0;
    assign EQ_Matrix[8].coefficient = 16'b00100_0100_101_01_0_1;
    assign EQ_Matrix[9].coefficient = 16'b11100_0000_100_00_1_0;
    assign EQ_Matrix[10].coefficient = 16'b10110_1000_101_10_1_1;
    assign EQ_Matrix[11].coefficient = 16'b00101_1111_100_00_1_0;
    assign EQ_Matrix[12].coefficient = 16'b11111_1011_010_00_0_0;
    assign EQ_Matrix[13].coefficient = 16'b01101_0011_101_01_0_0;
    assign EQ_Matrix[14].coefficient = 16'b00001_0010_001_00_0_1;
    assign EQ_Matrix[15].coefficient = 16'b10100_0111_100_11_0_1;
    
    //XOR all coefficients together
    wire [15:0] EQ_XOR = (EQ_Matrix[0].coefficient ^ EQ_Matrix[1].coefficient ^ EQ_Matrix[2].coefficient ^ EQ_Matrix[3].coefficient ^
                          EQ_Matrix[4].coefficient ^ EQ_Matrix[5].coefficient ^ EQ_Matrix[6].coefficient ^ EQ_Matrix[7].coefficient ^
                          EQ_Matrix[8].coefficient ^ EQ_Matrix[9].coefficient ^ EQ_Matrix[10].coefficient ^ EQ_Matrix[11].coefficient ^
                          EQ_Matrix[12].coefficient ^ EQ_Matrix[13].coefficient ^ EQ_Matrix[14].coefficient ^ EQ_Matrix[15].coefficient);
    
    //AND all coefficients and terms together
    wire [14:0] EQ_AND = EQ_XOR[15:1] & term_string;
    
    //XOR EQ_AND together
    wire EQ_SUM = (EQ_AND[14] ^ EQ_AND[13] ^ EQ_AND[12] ^ EQ_AND[11] ^ EQ_AND[10]
                     ^ EQ_AND[9] ^ EQ_AND[8] ^ EQ_AND[7] ^ EQ_AND[6] ^ EQ_AND[5]
                      ^ EQ_AND[4] ^ EQ_AND[3] ^ EQ_AND[2] ^ EQ_AND[1] ^ EQ_AND[0]);
    
    //Check to see if sum = RHS of XOR'd equations
    wire solution = (EQ_SUM == EQ_XOR[0]) ? 1'b1 : 1'b0;
    
    assign led = (solution) ? {1'b0,Terms[4:0]} : 6'b1_00000;    //display the solution on the LEDs
    
    
    initial begin 
        $display("Solving System of Equations");
        $display("Equation 1: %b", EQ_Matrix[0].coefficient);
        $display("Equation 2: %b", EQ_Matrix[1].coefficient);
        $display("Equation 3: %b", EQ_Matrix[2].coefficient);
        $display("Equation 4: %b", EQ_Matrix[3].coefficient);
        $display("Equation 5: %b", EQ_Matrix[4].coefficient);
        $display("Equation 6: %b", EQ_Matrix[5].coefficient);
        $display("Equation 7: %b", EQ_Matrix[6].coefficient);
        $display("Equation 8: %b", EQ_Matrix[7].coefficient);
        $display("Equation 9: %b", EQ_Matrix[8].coefficient);
        $display("Equation 10: %b", EQ_Matrix[9].coefficient);
        $display("Equation 11: %b", EQ_Matrix[10].coefficient);
        $display("Equation 12: %b", EQ_Matrix[11].coefficient);
        $display("Equation 13: %b", EQ_Matrix[12].coefficient);
        $display("Equation 14: %b", EQ_Matrix[13].coefficient);
        $display("Equation 15: %b", EQ_Matrix[14].coefficient);
        $display("Equation 16: %b", EQ_Matrix[15].coefficient);
    end
    
    always @(*) begin
        if(solution) begin
            $display("Solution Found: X1 = %b, X2 = %b, X3 = %b, X4 = %b, X5 = %b", Terms[0], Terms[1], Terms[2], Terms[3], Terms[4]); 
        end
        else begin
            $display("Solution not found at this state");
        end
    end
    
endmodule
