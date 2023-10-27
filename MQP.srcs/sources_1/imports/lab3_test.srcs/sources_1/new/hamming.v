`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2023 03:11:01 PM
// Design Name: 
// Module Name: hamming
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


module hamming #(parameter length = 7)( //Defines how many bits long testing      
    input [length-1:0] counter, //arrays start @ 0
    output flag2
    );
    
    integer i;
    reg [length -1:0] weight;
    
    always @ (counter) begin
        weight = 0;
        for(i = 0; i <= length; i = i + 1)begin
            if(counter[i] == 1'b1) begin
                weight = weight + counter[i];
            end
        end
    end
    
    assign flag2 = (weight > 1 && weight < 3) ? 1'b1 : 1'b0;
    
endmodule
