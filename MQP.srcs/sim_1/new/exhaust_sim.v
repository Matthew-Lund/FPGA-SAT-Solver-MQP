`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2023 07:26:00 PM
// Design Name: 
// Module Name: exhaust_sim
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


module exhaust_sim();
    reg clk, reset_n, btnC;
    wire [5:0] LED;
    wire [2:0] STATE;
    
    parameter START = 16'b1011_0110_1001_0010;
    parameter INIT = 3'b000;
    parameter EQ_NUM = 3'b001;
    parameter GEN = 3'b010;
    parameter READY = 3'b011;
    parameter SOLVE = 3'b100;
    parameter DONE = 3'b101;
    parameter WAIT = 3'b111;
    
    FSM_Exhaustive #(.START(START)) fsm( // # of equations hard-coded to 10 and linear terms to X1-X5
        .btnC(btnC),
        .clk(clk),
        .reset_n(reset_n),
        .LED(LED[5:0]),
        .STATE(STATE[2:0])
    );
    
    always begin
        #20 clk = !clk;
    end
    
    initial begin
        btnC = 0;
        clk = 0;
        reset_n = 0;
        #100 reset_n = 1;
        wait(STATE == READY);
        wait(STATE == WAIT);
        #20;
        $stop;
        #10 btnC = 1'b1;
        #5 btnC = 1'b0;
        #200;
        #25 btnC = 1;
        #20 btnC = 0;
        if(LED[5]) begin
            #200;
            $stop;
        end
    end
endmodule
