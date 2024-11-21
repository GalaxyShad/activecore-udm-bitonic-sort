`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date: 07.11.2024 16:16:36
// Module Name: bitonic_comb
// Author: Kadyrin Vadim 466066, group 4119, 2024
// 
//////////////////////////////////////////////////////////////////////////////////

module BitonicComb #(parameter LIST_SIZE = 8, parameter LIST_VALUE_BIT_COUNT = 32) (
          input  [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] original_list_i
        , output [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] sorted_list_o
    );
    
localparam UINT32_SIZE = 32;

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] buffer_list;

assign sorted_list_o = buffer_list;

function void compare_and_swap(
    inout logic [LIST_VALUE_BIT_COUNT-1:0] a,
    inout logic [LIST_VALUE_BIT_COUNT-1:0] b
);
    logic[LIST_VALUE_BIT_COUNT-1:0] temp;
    if (a > b) begin
        temp = a;
        a = b;
        b = temp;
    end
endfunction

always_comb begin
    // copy to buffer
    buffer_list = original_list_i;
    
    // # =========================
    // # stage 1
    // # =========================
    
    compare_and_swap(buffer_list[0], buffer_list[1]); // # -> 
    compare_and_swap(buffer_list[3], buffer_list[2]); // # <-
    compare_and_swap(buffer_list[4], buffer_list[5]); // # ->
    compare_and_swap(buffer_list[7], buffer_list[6]); // # <- 
        
    // # =========================
    // # stage 2
    // # =========================
    compare_and_swap(buffer_list[0], buffer_list[2]); // # ->
    compare_and_swap(buffer_list[1], buffer_list[3]); // # ->
    compare_and_swap(buffer_list[6], buffer_list[4]); // # <-
    compare_and_swap(buffer_list[7], buffer_list[5]); // # <-
    
    compare_and_swap(buffer_list[0], buffer_list[1]); // # ->
    compare_and_swap(buffer_list[2], buffer_list[3]); // # ->
    compare_and_swap(buffer_list[5], buffer_list[4]); // # <-
    compare_and_swap(buffer_list[7], buffer_list[6]); // # <-
        
    // # =========================
    // # stage 3
    // # =========================
    compare_and_swap(buffer_list[0], buffer_list[4]); // # ->
    compare_and_swap(buffer_list[1], buffer_list[5]); // # ->
    compare_and_swap(buffer_list[2], buffer_list[6]); // # ->
    compare_and_swap(buffer_list[3], buffer_list[7]); // # ->
    
    compare_and_swap(buffer_list[0], buffer_list[2]); // # ->
    compare_and_swap(buffer_list[1], buffer_list[3]); // # ->
    compare_and_swap(buffer_list[4], buffer_list[6]); // # ->
    compare_and_swap(buffer_list[5], buffer_list[7]); // # ->
    
    compare_and_swap(buffer_list[0], buffer_list[1]); // # ->
    compare_and_swap(buffer_list[2], buffer_list[3]); // # ->
    compare_and_swap(buffer_list[4], buffer_list[5]); // # ->
    compare_and_swap(buffer_list[6], buffer_list[7]); // # ->
end

endmodule
