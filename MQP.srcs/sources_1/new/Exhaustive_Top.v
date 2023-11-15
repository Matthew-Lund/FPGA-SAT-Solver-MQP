`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2023 06:16:29 PM
// Design Name: 
// Module Name: Exhaustive_Top
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


module Exhaustive_Top(  //System of 5 Linear Terms, 10 equations
    input clk,    
    input btnc,
    input btnu,
    output [5:0] led
    );
    
    //Necessary wires/regs/params
    wire [2:0] STATE;
    parameter START = 16'b1011_0110_1001_0010; //seed variable for lfsr in fsm
    wire [15:0] lfsr_out;
    wire clk_out, reset_n;
    wire btnc_debounce;
    //instantiations 
    
    clk_wiz_0 clock(
        .clk_in1(clk),
        .clk_out1(clk_out),
        .resetn(btnu),
        .locked(reset_n)
    );
    
    debounce btnC_debounce (
    .in(btnc),
    .out(btnc_debounce),
    .clk(clk_out),
    .reset_n(reset_n)
    );
    
    
    FSM_Exhaustive #(.START(START)) fsm( // # of equations hard-coded to 10 and linear terms to X1-X5
    .btnC(btnc_debounce),
    .clk(clk_out),
    .reset_n(reset_n),
    .LED(led[5:0])
    );
    
    
endmodule
