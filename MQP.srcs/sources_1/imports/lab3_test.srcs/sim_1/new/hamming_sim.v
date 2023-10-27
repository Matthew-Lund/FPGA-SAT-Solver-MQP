`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2023 03:27:36 PM
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


module hamming_sim();
        
        parameter length = 5;   //X-bit # of total terms(linear + quad)
        /*reg [length-1:0] counter;
        wire [length-1:0] weight; 
        reg flag;
        
        hamming #(.length(length)) uut(
        .counter(counter),
        .weight(weight)
        );
        
        initial begin
            counter = 0;
            while(counter < {(length){1'b1}} )begin //Counts up to all 1's in the counter (concatenation to help make it all ones of length)
                #20;
                if(weight > 1 && weight < 3) begin
                    flag = 1'b1;    //Says which one has weight of 2 in waveform simulations
                    $display("binary = %b, decimal = %d", counter, counter);    //Tells us what numbers have weight of 2
                end
                else begin
                    flag = 1'b0;
                end
                #5 counter = counter + 1;
            end 
        end  */

wire [(length-1):0] weight2_max = {2'b11,  {(length-2){1'b0}} };

reg [(length-1):0] eq1_coeff, eq2_coeff;
reg [128:0] sys_num;

wire weightcheck_eq1, weightcheck_eq2;

reg Rest;

reg [2:0] RHS;
wire RHS_eq1, RHS_eq2;
assign RHS_eq1 = RHS[0];
assign RHS_eq2 = RHS[1];


wire [(length+1):0] eq1, eq2;

hamming #(.length(length)) h1(
	.counter(eq1_coeff),
	.flag2(weightcheck_eq1)
);


hamming #(.length(length)) h2(
	.counter(eq2_coeff),
	.flag2(weightcheck_eq2)
);



assign eq1 = {eq1_coeff, Rest, RHS_eq1};
assign eq2 = {eq2_coeff, Rest, RHS_eq2};

    initial begin
    sys_num = 0;
    RHS = 2'b00;
    Rest = 1'b0;
    repeat(2) begin	//changes rest
    
        while(RHS < 3'b100) begin //changes RHS
    
            while(eq1_coeff < weight2_max + 1) begin //changes eq1 coeff
    
                while(eq2_coeff <= weight2_max + 1) begin	//changes eq2 coeff
                    if(weightcheck_eq1 && weightcheck_eq2)begin
                        sys_num = sys_num + 1;
                        $display("System # %d Found!", sys_num);
                        $display("eq1 = %b", eq1);
                        $display("eq2 = %b", eq2);
                        $display("");
                    end
                    #10 eq2_coeff = eq2_coeff + 1'b1;
                end
    
                eq2_coeff = 0;
                #10 eq1_coeff = eq1_coeff + 1'b1;
            end
    
            eq1_coeff = 0;
            #10 RHS = RHS + 3'b001;
        end
    
        RHS = 2'b00;
        if(Rest) begin
           $stop;
        end
    
        Rest = Rest + 1'b1;
    end
end
endmodule
