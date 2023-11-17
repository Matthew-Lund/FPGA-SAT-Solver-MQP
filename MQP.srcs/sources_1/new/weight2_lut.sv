`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 02:02:00 PM
// Design Name: 
// Module Name: weight2_lut
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


module weight2_lut(
    input [4:0] counter,
    output reg [6:0] coeff
    );
    
    always @ (counter) begin
        case(counter)
            5'd0: coeff <= 7'd3;
            5'd1: coeff <= 7'd5;
            5'd2: coeff <= 7'd6;
            5'd3: coeff <= 7'd9;
            5'd4: coeff <= 7'd10;
            5'd5: coeff <= 7'd12;
            5'd6: coeff <= 7'd17;
            5'd7: coeff <= 7'd18;
            5'd8: coeff <= 7'd20;
            5'd9: coeff <= 7'd24;
            5'd10: coeff <= 7'd33;
            5'd11: coeff <= 7'd34;
            5'd12: coeff <= 7'd40;
            5'd13: coeff <= 7'd48;
            5'd14: coeff <= 7'd65;
            5'd15: coeff <= 7'd66;
            5'd16: coeff <= 7'd68;
            5'd17: coeff <= 7'd72;
            5'd18: coeff <= 7'd80;
            5'd19: coeff <= 7'd96;
            default: coeff <= 7'd3;
        endcase
    end
endmodule
