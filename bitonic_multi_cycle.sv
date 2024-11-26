`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date: 07.11.2024 16:16:36
// Module Name: BitonicMultiCycle
// Author: Kadyrin Vadim 466066, group 4119, 2024
// 
//////////////////////////////////////////////////////////////////////////////////

module BitonicMultiCycle #(parameter LIST_SIZE = 8, parameter LIST_VALUE_BIT_COUNT = 32) (         
    input  [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] original_list_i
    , output [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] sorted_list_o        
    , input clk_i
    , input rst_i    
);

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] buffer;
reg [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] sorted_list_reg;
logic [3:0] stage = 0;

assign sorted_list_o = sorted_list_reg;

function automatic void compare_and_swap(    
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

always @(posedge clk_i) begin    
    if (rst_i) begin
        stage <= 0;
        buffer <= original_list_i;
    end else if (stage == 5) begin 
        stage <= 0;
        buffer <= original_list_i;
        sorted_list_reg <= buffer;
    end else begin 
        stage <= stage + 1;
    end
end

always @* begin    
    case (stage)            
        ///////////////////////
        // STAGE 1
        ///////////////////////

        // STAGE 1
        0: begin            
            compare_and_swap(buffer[0], buffer[1]); // # -> 
            compare_and_swap(buffer[3], buffer[2]); // # <-            
            compare_and_swap(buffer[4], buffer[5]); // # ->
            compare_and_swap(buffer[7], buffer[6]); // # <-         
        end

        ///////////////////////
        // STAGE 1
        ///////////////////////

        // STAGE 2.1
        1: begin            
            compare_and_swap(buffer[0], buffer[2]); // # ->
            compare_and_swap(buffer[1], buffer[3]); // # ->            
            compare_and_swap(buffer[6], buffer[4]); // # <-
            compare_and_swap(buffer[7], buffer[5]); // # <-        
        end

        // STAGE 2.2
        2: begin
            compare_and_swap(buffer[0], buffer[1]); // # ->            
            compare_and_swap(buffer[2], buffer[3]); // # ->
            compare_and_swap(buffer[5], buffer[4]); // # <-            
            compare_and_swap(buffer[7], buffer[6]); // # <- 
        end        

        ///////////////////////
        // STAGE 3 
        ///////////////////////

        // STAGE 3.1        
        3: begin
            compare_and_swap(buffer[0], buffer[4]); // # ->            
            compare_and_swap(buffer[1], buffer[5]); // # ->
            compare_and_swap(buffer[2], buffer[6]); // # ->            
            compare_and_swap(buffer[3], buffer[7]); // # ->
        end   

        // STAGE 3.2
        4: begin            
            compare_and_swap(buffer[0], buffer[2]); // # ->
            compare_and_swap(buffer[1], buffer[3]); // # ->            
            compare_and_swap(buffer[4], buffer[6]); // # ->
            compare_and_swap(buffer[5], buffer[7]); // # ->        
        end

        // STAGE 3.3
        5: begin
            compare_and_swap(buffer[0], buffer[1]); // # ->            
            compare_and_swap(buffer[2], buffer[3]); // # ->
            compare_and_swap(buffer[4], buffer[5]); // # ->            
            compare_and_swap(buffer[6], buffer[7]); // # -> 
        end    
    endcase
end 
endmodule
