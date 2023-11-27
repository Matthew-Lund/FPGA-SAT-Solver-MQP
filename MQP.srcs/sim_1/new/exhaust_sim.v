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
`timescale 1ns / 1ps


module exhaust_sim();
    reg [4:0] terms;
    wire [5:0] good_out;
    
    exhaustive_search uut(
    .sw(terms),
    .led(good_out)
    );
    
    initial begin
        terms <= 5'b00000;
        repeat(31) begin    //go until 5'b11111
                if(terms == 5'b11111) begin
                $stop;
                end
                #10 terms <= terms + 1'b1; 
        end
    end
endmodule
