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


module weight3_lut(
    input [4:0] counter,
    output reg [6:0] coeff
    );
    
    always @ (counter) begin
        case(counter)
            5'd0: coeff <= 7'd7;
            5'd1: coeff <= 7'd11;
            5'd2: coeff <= 7'd13;
            5'd3: coeff <= 7'd14;
            5'd4: coeff <= 7'd19;
            5'd5: coeff <= 7'd21;
            5'd6: coeff <= 7'd22;
            5'd7: coeff <= 7'd25;
            5'd8: coeff <= 7'd26;
            5'd9: coeff <= 7'd28;
            5'd10: coeff <= 7'd35;
            5'd11: coeff <= 7'd37;
            5'd12: coeff <= 7'd38;
            5'd13: coeff <= 7'd41;
            5'd14: coeff <= 7'd42;
            5'd15: coeff <= 7'd44;
            5'd16: coeff <= 7'd49;
            5'd17: coeff <= 7'd50;
            5'd18: coeff <= 7'd52;
            5'd19: coeff <= 7'd56;
            5'd20: coeff <= 7'd67;
            5'd21: coeff <= 7'd69;
            5'd22: coeff <= 7'd70;
            5'd23: coeff <= 7'd73;
            5'd24: coeff <= 7'd74;
            5'd25: coeff <= 7'd76;
            5'd26: coeff <= 7'd81;
            5'd27: coeff <= 7'd82;
            5'd28: coeff <= 7'd84;
            5'd29: coeff <= 7'd88;
            5'd30: coeff <= 7'd97;
            5'd31: coeff <= 7'd98;
            5'd32: coeff <= 7'd100;
            5'd33: coeff <= 7'd104;
            5'd34: coeff <= 7'd112;
            default: coeff <= 7'd3;
        endcase
    end
endmodule
