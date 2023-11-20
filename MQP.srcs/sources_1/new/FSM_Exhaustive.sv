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


module FSM_Exhaustive #(parameter START = 16'b1011_0110_1001_0010)//Can manipulate # of equations in top-level
    (
    input btnC,
    input clk,
    input reset_n,
    output [5:0] LED,  //top level
    output reg [2:0] STATE
    );
        // Define packed struct for equation coefficients
    typedef struct packed {
        logic [15:0] coefficient;
    } EquationCoeff;
    
    parameter eq_num = 16;
    
    //clock divider to allow lfsr time to update
    reg [5:0] slow_clk;
    parameter tick_max = eq_num * 2;
    reg sclk;
    always @(posedge clk) begin
        if(reset_n == 1'b0) begin
            slow_clk <= 5'b00000;
            sclk <= 1'b0;
        end
        else begin
            if(slow_clk == eq_num) begin
                sclk <= 1'b1;
            end
            else if(slow_clk == eq_num * 2) begin
                sclk <= 1'b0;
                slow_clk <= 0;
            end
            slow_clk <= slow_clk + 1;
        end
    end
    
    //Counting Registers and # of Equations
    reg[5:0] eq_counter_gen, eq_counter_solve, eq_counter_ready;
    
    //for lfsr 
   wire [15:0] lfsr_eq;   //output of lfsr16
   logic [15:0] lfsr_out[eq_num-1:0];
   lfsr16 #(.START(START)) lfsr(
        .clk(clk),
        .reset_n(reset_n),
        .lfsr_out(lfsr_out)
   );
    //FSM States
    reg [2:0] STATE_N ;  //next state
    parameter INIT = 3'b000;
    parameter GEN = 3'b001;
    parameter READY = 3'b010;
    parameter SOLVE = 3'b011;
    parameter DONE = 3'b100;
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
    
    wire [14:0] term_string = {X1, X2, X3, X4 ,X5, X1X2, X1X3, X1X4, X1X5, X2X3, X2X4, X2X5, X3X4, X3X5, X4X5}; //easier for computation
    reg temp_matrix[eq_num-1:0][1:0];
    
    reg [10:0] solutions_num;
    
    EquationCoeff EQ_Matrix [0:(eq_num-1)];   //X1 + X2 + X3 + X4 + X5 + X1X2 + X1X3 + X1X4 + X1X5 + X2X3 + X2X4 + X2X5 + X3X4 + X3X5 + X4X5 = RHS
   
    
    //for temp matrix and solving
    always @(*) begin
        if(STATE == SOLVE) begin
            if(eq_counter_solve < eq_num) begin
                temp_matrix[eq_counter_solve][0] = EQ_Matrix[eq_counter_solve].coefficient[15:1] & term_string[14:0];
                         
                temp_matrix[eq_counter_solve][1] = EQ_Matrix[eq_counter_solve].coefficient[0];// Set all [1] values to RHS 
                solved = (solved && (temp_matrix[eq_counter_solve][0] == temp_matrix[eq_counter_solve][1])) ? 1'b1 : 1'b0;
                eq_counter_solve = eq_counter_solve + 1; 
            end

        /* && (temp_matrix[1][0] == temp_matrix[1][1]) 
        && (temp_matrix[2][0] == temp_matrix[2][1]) && (temp_matrix[3][0] == temp_matrix[3][1])
         && (temp_matrix[4][0] == temp_matrix[4][1]) && (temp_matrix[5][0] == temp_matrix[5][1]) 
         && (temp_matrix[6][0] == temp_matrix[6][1]) && (temp_matrix[7][0] == temp_matrix[7][1]) 
         && (temp_matrix[8][0] == temp_matrix[8][1]) && (temp_matrix[9][0] == temp_matrix[9][1])*/ 

        end
    end
    
 
 always @ (posedge sclk) begin   //Combinational
 
     if(reset_n == 1'b0) begin
        STATE <= INIT;
    end
    else begin
        STATE <= STATE_N;
     
        case(STATE)
        
            WAIT: begin
                    STATE_N <= (btnC) ? INIT : WAIT;
            end
            
            INIT: begin 
                Terms <= 0;
                eq_counter_solve <= 0;
                eq_counter_gen <= 0;
                eq_counter_ready <= 0;
                solutions_num <= 0;
                //STATE_N <= (btnC) ? GEN : INIT;
                STATE_N <= GEN;
            end
            
            GEN: begin  //Generate System of Equations
                $display("Generating System of Equations");
                EQ_Matrix <= lfsr_out;
                /*while(eq_counter_gen < eq_num) begin //Create random coefficients
                        EQ_Matrix[eq_counter_gen][15:0] <= lfsr_out[eq_counter_gen];
                        eq_counter_gen <= eq_counter_gen + 1'b1;
                end*/
                $display("System of Equations Generated!");
                STATE_N <= READY;
            end
            
           READY: begin
                $display("EQ 1 : %b", EQ_Matrix[0].coefficient);                
                $display("EQ 2 : %b", EQ_Matrix[1].coefficient);
                $display("EQ 3 : %b", EQ_Matrix[2].coefficient);
                $display("EQ 4 : %b", EQ_Matrix[3].coefficient);
                $display("EQ 5 : %b", EQ_Matrix[4].coefficient);
                $display("EQ 6 : %b", EQ_Matrix[5].coefficient);
                $display("EQ 7 : %b", EQ_Matrix[6].coefficient);
                $display("EQ 8 : %b", EQ_Matrix[7].coefficient);
                $display("EQ 9 : %b", EQ_Matrix[8].coefficient);
                $display("EQ 10 : %b", EQ_Matrix[9].coefficient);
                $display("EQ 11 : %b", EQ_Matrix[10].coefficient);
                $display("EQ 12 : %b", EQ_Matrix[11].coefficient);
                $display("EQ 13 : %b", EQ_Matrix[12].coefficient);
                $display("EQ 14 : %b", EQ_Matrix[13].coefficient);
                $display("EQ 15 : %b", EQ_Matrix[14].coefficient);
                $display("EQ 16 : %b", EQ_Matrix[15].coefficient);
                STATE_N <=  SOLVE;
                end
            
            SOLVE: begin
                $display("Terms: X1 = %b, X2 = %b, X3 = %b, X4 = %b, X5 = %b", Terms[0], Terms[1], Terms[2], Terms[3], Terms[4]);
                if(solved == 1'b1) begin
                    $display("Solution Found!");
                    solutions_num <= solutions_num + 1;
                end
                else if(solved == 1'b0)begin
                    $display("No Solution at This Value");
                end
                Terms <= Terms + 1'b1;
                $display("");
                STATE_N <= (Terms == 6'b0_11111) ? DONE : SOLVE;
            end
            
            DONE: begin
                $display("Total Number of Solutions: %d", solutions_num);
                $display("Press BtnC to restart");
                    STATE_N <= WAIT;
                
            end
            
            default: begin 
                STATE <= INIT;
            end
        endcase
    end
 end  
  
  assign LED[4:0] = (STATE == SOLVE) ? Terms[4:0] : 5'b0000;
  assign LED[5] = Terms[5];
endmodule