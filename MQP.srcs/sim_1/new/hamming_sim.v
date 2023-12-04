`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 11:22:39 AM
// Design Name: 
// Module Name: hamming_sim
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


module hamming_sim(

    );
    
    parameter length = 7;
    parameter weight = 3;
    
    reg [length-1:0] counter;
    wire flag;
    
    hamming #(.length(length), .weight(weight)) uut(
        .counter(counter),
        .flag2(flag)
    );
    
    initial begin
        counter = 0;
        while(counter < 7'b1111111) begin
            #5 counter = counter + 1'b1;
             if(flag == 1'b1) begin
                $display("%b", counter);
            end
        end
        $stop;
    end
    
endmodule
