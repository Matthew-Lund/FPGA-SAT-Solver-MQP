`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2023 05:41:37 PM
// Design Name: 
// Module Name: lfsr16
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


module lfsr16 #(parameter START = 16'b1011_0110_1001_0010)
    (  
    input clk,  //From Top
    input reset_n,  //From Top
    input [2:0] STATE,    //Takes in State from FSM
    output reg [15:0] lfsr_out  //outputs to FSM
    );
    
    parameter GEN = 3'b010; //For starting LFSR stuff
    reg [15:0] lfsr_temp;
    always @ (posedge clk) begin
        if(reset_n == 1'b0) begin
            lfsr_temp <= START;
            lfsr_out <= 0;
        end
        else begin
            case(STATE)
                GEN: begin
                lfsr_temp <= lfsr_temp << 1;
                lfsr_temp[0] <= lfsr_temp[10] ^ lfsr_temp[12] ^ lfsr_temp[13] ^ lfsr_temp[15];  //x^16 + x^14 + x^13 + x^11 + 1 (maximum polynomial)
                lfsr_out <= lfsr_temp[15:0];
                end
                default: begin 
                    lfsr_temp <= START;
                    lfsr_out <= 0;
                end
            endcase
        end
    end
endmodule
