`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2023 07:41:28 PM
// Design Name: 
// Module Name: FSM_Exhaustive
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


module FSM_Exhaustive #(parameter START = 16'b1011_0110_1001_0010)//Hard-coded seed for lfsr
    (
    input btnC,
    input clk,
    input reset_n,
    output [5:0] LED   //top level
    );
        // Define packed struct for equation coefficients
    typedef struct packed {
        logic [15:0] coefficient;
    } EquationCoeff;
    
    //Counting Registers and # of Equations
    reg [3:0] eq_counter_gen, eq_counter_solve;
    parameter equations = 10;
    
    //for lfsr 
    wire [15:0] lfsr_eq;   //output of lfsr16
    //FSM States
    reg [2:0] STATE, STATE_N, STATE_P;  //next state
    parameter INIT = 3'b000;
    parameter EQ_NUM = 3'b001;
    parameter GEN = 3'b010;
    parameter READY = 3'b011;
    parameter SOLVE = 3'b100;
    parameter DONE = 3'b101;
    parameter WAIT = 3'b111;
    
    reg[5:0] Terms; //X1, X2, X3, X4, X5;
    reg solved;
    
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

    reg temp_matrix[equations-1:0][1:0];
    
    reg [10:0] solutions_num;
    
    EquationCoeff EQ_Matrix [0:(equations-1)];   //X1 + X2 + X3 + X4 + X5 + X1X2 + X1X3 + X1X4 + X1X5 + X2X3 + X2X4 + X2X5 + X3X4 + X3X5 + X4X5 = RHS
   
   //lfsr instantiation 
    lfsr16 #(.START(START)) lfsr(
        .clk(clk),
        .reset_n(reset_n),
        .STATE(STATE),
        .lfsr_out(lfsr_eq)
    );
    
    //for temp matrix and solving
    always @(*) begin
        if(STATE == SOLVE) begin
            if(eq_counter_solve < equations) begin
                temp_matrix[eq_counter_solve][0] = (X1&EQ_Matrix[eq_counter_solve][15]) ^(X2&EQ_Matrix[eq_counter_solve][14]) ^(X3&EQ_Matrix[eq_counter_solve][13])
                     ^(X4&EQ_Matrix[eq_counter_solve][12]) ^(X5&EQ_Matrix[eq_counter_solve][11]) ^(X1X2&EQ_Matrix[eq_counter_solve][10]) ^(X1X3&EQ_Matrix[eq_counter_solve][9]) 
                     ^(X1X4&EQ_Matrix[eq_counter_solve][8]) ^(X1X5&EQ_Matrix[eq_counter_solve][7]) ^(X2X3&EQ_Matrix[eq_counter_solve][6]) ^(X2X4&EQ_Matrix[eq_counter_solve][5]) 
                     ^(X2X5&EQ_Matrix[eq_counter_solve][4]) ^(X3X4&EQ_Matrix[eq_counter_solve][3]) ^(X3X5&EQ_Matrix[eq_counter_solve][2]) ^(X4X5&EQ_Matrix[eq_counter_solve][1]);
                 
                temp_matrix[eq_counter_solve][1] <= EQ_Matrix[eq_counter_solve][0];// Set all [1] values to RHS 
                eq_counter_solve <= eq_counter_solve + 1; 
            end
            solved <= ( (temp_matrix[0][0] == temp_matrix[1][0]) && (temp_matrix[0][1] == temp_matrix[1][1]) && (temp_matrix[0][2] == temp_matrix[1][2]) && (temp_matrix[0][3] == temp_matrix[1][3])
             && (temp_matrix[0][4] == temp_matrix[1][4]) && (temp_matrix[0][5] == temp_matrix[1][5]) && (temp_matrix[0][6] == temp_matrix[1][6]) && (temp_matrix[0][7] == temp_matrix[1][7]) && 
             (temp_matrix[0][8] == temp_matrix[1][8]) && (temp_matrix[0][9] == temp_matrix[1][9]) ) ? 1'b1 : 1'b0;
        end
    end
    
 always @(posedge clk) begin
    if(reset_n == 1'b0) begin
        STATE <= INIT;

    end
    else begin
        STATE <= STATE_N;
        if(STATE != WAIT) begin
            STATE_P <= STATE;
        end
        
    end
 end 
 
 
 always @ * begin   //Combinational
    case(STATE)
    
        WAIT: begin
            if(STATE_P == DONE) begin
                STATE_N <= (btnC) ? INIT : WAIT;
            end
            STATE_N <= (btnC) ? STATE_P + 3'b001 : WAIT;
        end
        
        INIT: begin 
            Terms <= 0;
            eq_counter_solve <= 0;
            eq_counter_gen <= 0;
            solutions_num <= 0;
            $display("Solving for a Quadratic System of 10 Equations!");
            //STATE_N <= (btnC) ? GEN : INIT;
            STATE <= GEN;
        end
        
        GEN: begin  //Generate System of Equations
            if(eq_counter_gen < equations) begin
                    EQ_Matrix[eq_counter_gen] <= lfsr_eq[15:0];  //Create random coefficients
                    eq_counter_gen <= eq_counter_gen + 1'b1;
            end
            STATE <= (eq_counter_gen == equations) ? READY : GEN;
        end
        
        READY: begin
            $display("System of Equations Generated! Press BtnC to Solve");
           /* $display("EQ 1: %b", EQ_Matrix[0][15:0]);
            $display("EQ 2: %b", EQ_Matrix[1][15:0]);
            $display("EQ 3: %b", EQ_Matrix[2][15:0]);
            $display("EQ 4: %b", EQ_Matrix[3][15:0]);
            $display("EQ 5: %b", EQ_Matrix[4][15:0]);
            $display("EQ 6: %b", EQ_Matrix[5]);
            $display("EQ 7: %b", EQ_Matrix[6]);
            $display("EQ 8: %b", EQ_Matrix[7]);
            $display("EQ 9: %b", EQ_Matrix[8]);
            $display("EQ 10: %b", EQ_Matrix[9]);*/
            if(btnC) begin
                STATE <= SOLVE;
            end
        end
        
        SOLVE: begin
            if(Terms < 6'b1_00000) begin
                    if(solved == 1'b1) begin
                    $display("Solution Found! X1 = %b, X2 = %b, X3 = %b, X4 = %b, X5 = %b", Terms[0], Terms[1], Terms[2], Terms[3], Terms[4]);
                    solutions_num <= solutions_num + 1;
                    end
                    Terms <= Terms + 1'b1;
            end
            STATE <= (Terms == 6'b1_00000) ? DONE : SOLVE;
        end
        
        DONE: begin
            $display("Total Number of Solutions: %d", solutions_num);
            $display("Press BtnC to restart");
            if(btnC) begin
                STATE <= INIT;
            end
        end
        
        default: begin 
            STATE <= INIT;
        end
    endcase
  end  
  
  assign LED[4:0] = (STATE == SOLVE) ? Terms[4:0] : 5'b0000;
  assign LED[5] = Terms[5];
endmodule
