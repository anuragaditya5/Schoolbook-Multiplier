`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2024 19:58:44
// Design Name: 
// Module Name: scb_mul_top
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


module scb_mul_top(clk ,rst,start ,done,secret_count_to_bram,s_4,count_to_data,d_13,final_result);
    input clk,rst;
    input start;
    input [3:0] s_4;
    input [12:0] d_13;
 
    output reg done;
    output [6:0] secret_count_to_bram;
     output [6:0] count_to_data;
     output [3327:0] final_result;
     assign final_result = acc;
     
    reg shift_secret;
    reg [3:0]state;
      reg load_secret;
      
reg [1023:0] secret;
reg [3327:0] acc;
wire [3327:0] result;

reg acc_load;
reg computing_ongoing;

wire [12:0] a_coeff_w;
assign a_coeff_w = d_13;

wire [1023:0]secret_w;
wire [3327:0] acc_w;

  parallel_macs MAC_256 (.acc(acc_w), .secret(secret_w), .a_coeff(a_coeff_w), .result(result) );



assign acc_w = acc;
assign secret_w = secret;

always @(posedge clk) begin
    if (rst) begin
    acc <= 3328'd0;
    end
    
    else if (acc_load) begin
    acc <= result;
    
    end


end
 

 
    
    always @(posedge clk) begin
        if(rst) begin
        secret <= 1024'd0;
        
        end
	else if (load_secret)
	begin
		secret[511:0] <= {s_4,secret[511:4]};    
		//$display("Input secret: %h\n", secret[511:0]);
		//$display("Input secret: %h\n", s_4);
		
     end   
	else if (shift_secret)
		begin
			secret <= {secret[1019:0], secret[1023:1020] ^ 4'b1000}; // xor with 1000 to flip the sign  
			//secret <= {secret[1019:0], 4'b0000}; // xor with 1000 to flip the sign  
		end
	else
	   begin
	       secret <= secret;
	   end	
    
    end
     
     reg [7:0]count_of_secret,count_of_data;
     
     
     assign secret_count_to_bram = count_of_secret[6:0];
     assign count_to_data = count_of_data [6:0];
     
     reg secret_polynomial_loaded;
     always @(posedge clk) begin
        if(rst) begin
            state <= 4'd0;
            shift_secret <=0;
            count_of_secret <= 8'd0;
            count_of_data <= 8'd0;
            load_secret <= 1'b0;
            acc_load <=0;
            secret_polynomial_loaded <=0;
            done <=0;
        end
        else if (start==1) begin
        
        	case(state)
		0: begin  
				 load_secret <= 1'b0;
				 if (secret_polynomial_loaded ==0) begin
				    state <=1;
				 end else begin
				 state <=3;
				 end
				 
				
				
		   end
		1: begin 
		       load_secret <= 1'b1;
		       //$display("Laoding of secret started at : %0t",$time);
				if(count_of_secret==128) begin
				    state<=2;
				    
				   // done <=1;
				end else begin
				count_of_secret <= count_of_secret  + 1;   
				done <=0;
				end
		   end		
		2: begin 
			secret_polynomial_loaded<=1;
			//$display("Laoding of secret done at : %0t",$time);
			load_secret <= 1'b0;
			state <= 3;
		   end
		3: begin 
			 computing_ongoing <= 1;
			 count_of_data <= 8'd0;
			 //acc_load <=0;
			 //acc_load <=1;
			 state<= 4;
//			$display("Laoding of data will start at next cycle : %0t and value of acc[12:0]  is: %0d ",$time,acc[12:0]);
	
		   end
		4: begin 
		shift_secret <=0;
		acc_load <=1; 
		if(count_of_data==128) begin
				    state<=6;
				end else begin
				count_of_data <= count_of_data  + 1;   
				done <=0;
				end
      $display("Loading of data started at : %0t and value of acc_0  is : %0d ",$time,acc[12:0]);
      $display("Laoding of data started at : %0t and value of acc_1  is : %0d ",$time,acc[25:13]);
      $display("Laoding of data started at : %0t and value of acc_2  is : %0d ",$time,acc[38:26]);
      $display("Laoding of data started at : %0t and value of acc_3  is : %0d ",$time,acc[51:39]);
      $display("Laoding of data started at : %0t and value of acc_4  is : %0d ",$time,acc[64:52]);
      $display("Laoding of data started at : %0t and value of acc_5  is : %0d ",$time,acc[77:65]);
      $display("Laoding of data started at : %0t and value of acc_6  is : %0d ",$time,acc[90:78]);
      $display("Laoding of data started at : %0t and value of acc_7  is : %0d ",$time,acc[103:91]);
      $display("Laoding of data started at : %0t and value of acc_8  is : %0d ",$time,acc[116:104]);
      
      state<= 5;
      
		   end
		5: begin 
			computing_ongoing <= 1;
				 acc_load <=0;
				 shift_secret<=1;
				done <=0;
			
				if(count_of_data==128) begin
				    state<=6;
				  end else begin
				  state<=4;
				  
				  end
		   end
		6: begin 
			computing_ongoing <= 0;
				 acc_load <=0;
				 shift_secret<=0;
				done <=1;	
				state<=6;
				
			
		   end
			
				
		default: begin
				state <=0;
		   end			
	endcase
        
 
        end
     
     
     end
     
     
   
endmodule
