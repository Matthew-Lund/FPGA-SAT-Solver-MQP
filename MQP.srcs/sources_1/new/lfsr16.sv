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
    output logic [15:0] lfsr_out [9:0]
    );
    reg [15:0] lfsr_struct;  //outputs to FSM
    reg [4:0] counter;
    parameter GEN = 3'b010; //For starting LFSR stuff
    reg [15:0] lfsr_temp;
    always @ (posedge clk) begin
        if(reset_n == 1'b0) begin
            lfsr_temp <= START;
            lfsr_struct <= 0;
            counter <= 5'b11111;
        end
        else begin
            lfsr_out[0] <= START << 0;
            lfsr_temp <= lfsr_temp << 1;
            lfsr_temp[0] <= lfsr_temp[10] ^ lfsr_temp[12] ^ lfsr_temp[13] ^ lfsr_temp[15];  //x^16 + x^14 + x^13 + x^11 + 1 (maximum polynomial)
            lfsr_struct <= lfsr_temp[15:0];
            counter <= counter + 1;
            lfsr_out[counter[4:0]] <= lfsr_struct;
        end
    end
    
    
endmodule