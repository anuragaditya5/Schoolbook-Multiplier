`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2024 19:34:17
// Design Name: 
// Module Name: parallel_macs
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


module parallel_macs(acc, secret, a_coeff, result);
input [3327:0] acc;
input [1023:0] secret; // 256 * 4 =1024
input [12:0] a_coeff;
output [3327:0] result; // 256 *13 = 3328
    
    genvar g;
  
  //full_adder fa0(A[0], B[0], Cin, S[0], Cout[0]);
  //shifter_mult sm0(acc[12:0], secret[3:0], a_coeff, result[12:0]);
  generate  // This will instantial full_adder SIZE-1 times
    for(g = 0; g<256; g=g+1) begin :macs
      shifter_mult sm(acc[((13*g)+ 12):(13*g)], secret[((4*g)+3 ):(4*g)], a_coeff, result[((13*g)+ 12):(13*g)]);
    end
  endgenerate
    
        
endmodule
