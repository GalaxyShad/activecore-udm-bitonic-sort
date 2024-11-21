`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date: 21.11.2024 02:16:36
// Module Name: BitonicPipe
// Author: Kadyrin Vadim 466066, group 4119, 2024
// 
//////////////////////////////////////////////////////////////////////////////////

module BitonicPipe #(parameter LIST_SIZE = 8, parameter LIST_VALUE_BIT_COUNT = 32) (         
    input  [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] original_list_i
    , output [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] sorted_list_o        
    , input clk_i
    , input rst_i    
);

 
endmodule
