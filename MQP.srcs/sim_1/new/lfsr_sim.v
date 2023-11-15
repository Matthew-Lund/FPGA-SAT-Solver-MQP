`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2023 07:57:27 PM
// Design Name: 
// Module Name: lfsr_sim
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


module lfsr_sim(
    );
    
    reg clk, reset_n;
    reg [2:0] STATE;
    wire [15:0] lfsr_out;
    parameter START = 16'b1011_0110_1001_0010;
    
    lfsr16 #(.START(START)) uut(
        .clk(clk),
        .reset_n(reset_n),
        .STATE(STATE),
        .lfsr_out(lfsr_out)
    );
    
    always begin
        #15 clk = !clk;
    end
    
    initial begin
        clk = 0;
        reset_n = 0;
        STATE = 3'b000;
        #150 reset_n = 1;
        STATE = 3'b010;
        repeat(15)begin
            #30 $display("Out: %b", lfsr_out);
        end
        $stop;
    end
    
    
endmodule
