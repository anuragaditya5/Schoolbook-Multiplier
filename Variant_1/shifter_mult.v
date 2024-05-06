`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2024 19:25:09
// Design Name: 
// Module Name: shifter_mult
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


module shifter_mult(Ri, s, a, result,a_mul_2,a_mul_3,a_mul_4,a_mul_5);

input [12:0] Ri, a;
input [3:0] s;
output [12:0] result;
input [12:0] a_mul_2,a_mul_3,a_mul_4,a_mul_5;

//wire [12:0] a_mul_3 = a + {a[11:0], 1'b0};
//wire [12:0] a_mul_5 = a + {a[10:0], 2'b0};
//wire [12:0] a_mul_2 = {a[11:0],1'b0};
//wire [12:0] a_mul_4 = {a[10:0],2'b0};


wire [12:0] a_mul_s = s[2:0] == 3'd0 ? 13'd0
					: s[2:0] == 3'd1 ? a
					: s[2:0] == 3'd2 ? a_mul_2
					: s[2:0] == 3'd3 ? a_mul_3
					: s[2:0] == 3'd4 ? a_mul_4
					: a_mul_5;

					

					
wire [12:0] result = s[3] ? Ri - a_mul_s : Ri + a_mul_s;





endmodule
