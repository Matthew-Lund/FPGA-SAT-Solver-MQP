`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2023 12:35:03 PM
// Design Name: 
// Module Name: debounce
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


module debounce(
    input in,
    output reg out,
    input clk,
    input reset_n
    );
    reg [27:0] count; //counter
    reg previous;//for storing previous input to compare
    parameter MAX_COUNT=10000000; //10 msec

    wire clk_2Hz;
    assign clk_2Hz = count==MAX_COUNT; //reset on max count

    always @ (posedge clk) begin
    if(in!=previous)begin //if input changes, counter is cleared
        count<=25'd0;
        previous<=in; //if new input is not the same as previous, rest clock and change
    
    end
      if(reset_n==1'b0)begin //reset
          count<=27'b0;
          out<=in; //reset so output is now equal to input
        end
      else begin
      if(clk_2Hz)begin//counter terminal count
        count<=27'b0; //reset counter
        out<=in; //output is now equal to input on the clock edge
       
      end  
      else begin
        count<=count+27'd1; //count
      end
        previous<=in; //assign the previous state to the current input if nothing else
     end//else
    end//alaways
endmodule
