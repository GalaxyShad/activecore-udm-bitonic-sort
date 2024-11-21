`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date: 21.11.2024 02:16:36
// Module Name: BitonicPipe
// Author: Kadyrin Vadim 466066, group 4119, 2024
//
//////////////////////////////////////////////////////////////////////////////////

module BitonicPipe #(parameter LIST_SIZE = 8, parameter LIST_VALUE_BIT_COUNT = 32) (
    input  [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] original_list_i,
    output [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] sorted_list_o,
    input clk_i,
    input rst_i
);

// ---------------------------------------------------------- //

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

// ---------------------------------------------------------- //

///////////////////////
// BUFFERS
///////////////////////

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_input;

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_1;
logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_1_comb;

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_2_1;
logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_2_1_comb;

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_2_2;
logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_2_2_comb;

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_3_1;
logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_3_1_comb;

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_3_2;
logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_3_2_comb;

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_3_3;
logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_3_3_comb;

logic [LIST_SIZE-1:0][LIST_VALUE_BIT_COUNT-1:0] bg_stage_output;

// ---------------------------------------------------------- //

///////////////////////
// STAGE INPUT (0)
///////////////////////

// writing to regs
always @(posedge clk_i) begin
    bg_stage_input <= original_list_i;
end

// ---------------------------------------------------------- //

///////////////////////
// STAGE 1 (1)
///////////////////////

// writing to regs
always @(posedge clk_i) begin
    bg_stage_1 <= bg_stage_input;
end

always_comb begin
    bg_stage_1_comb = bg_stage_1;
    compare_and_swap(bg_stage_1_comb[0], bg_stage_1_comb[1]); // # ->
    compare_and_swap(bg_stage_1_comb[3], bg_stage_1_comb[2]); // # <-
    compare_and_swap(bg_stage_1_comb[4], bg_stage_1_comb[5]); // # ->
    compare_and_swap(bg_stage_1_comb[7], bg_stage_1_comb[6]); // # <-
end

// ---------------------------------------------------------- //

///////////////////////
// STAGE 2.1 (2)
///////////////////////

// writing to regs
always @(posedge clk_i) begin
    bg_stage_2_1 <= bg_stage_1_comb;
end

always_comb begin
    bg_stage_2_1_comb = bg_stage_2_1;
    compare_and_swap(bg_stage_2_1_comb[0], bg_stage_2_1_comb[2]); // # ->
    compare_and_swap(bg_stage_2_1_comb[1], bg_stage_2_1_comb[3]); // # ->
    compare_and_swap(bg_stage_2_1_comb[6], bg_stage_2_1_comb[4]); // # <-
    compare_and_swap(bg_stage_2_1_comb[7], bg_stage_2_1_comb[5]); // # <-
end

///////////////////////
// STAGE 2.2 (3)
///////////////////////

// writing to regs
always @(posedge clk_i) begin
    bg_stage_2_2 <= bg_stage_2_1_comb;
end

always_comb begin
    bg_stage_2_2_comb = bg_stage_2_2;
    compare_and_swap(bg_stage_2_2_comb[0], bg_stage_2_2_comb[1]); // # ->
    compare_and_swap(bg_stage_2_2_comb[2], bg_stage_2_2_comb[3]); // # ->
    compare_and_swap(bg_stage_2_2_comb[5], bg_stage_2_2_comb[4]); // # <-
    compare_and_swap(bg_stage_2_2_comb[7], bg_stage_2_2_comb[6]); // # <-
end

// ---------------------------------------------------------- //

///////////////////////
// STAGE 3.1 (4)
///////////////////////

// writing to regs
always @(posedge clk_i) begin
    bg_stage_3_1 <= bg_stage_2_2_comb;
end

always_comb begin
    bg_stage_3_1_comb = bg_stage_3_1;
    compare_and_swap(bg_stage_3_1_comb[0], bg_stage_3_1_comb[4]); // # ->
    compare_and_swap(bg_stage_3_1_comb[1], bg_stage_3_1_comb[5]); // # ->
    compare_and_swap(bg_stage_3_1_comb[2], bg_stage_3_1_comb[6]); // # ->
    compare_and_swap(bg_stage_3_1_comb[3], bg_stage_3_1_comb[7]); // # ->
end

///////////////////////
// STAGE 3.2 (5)
///////////////////////

// writing to regs
always @(posedge clk_i) begin
    bg_stage_3_2 <= bg_stage_3_1_comb;
end

always_comb begin
    bg_stage_3_2_comb = bg_stage_3_2;
    compare_and_swap(bg_stage_3_2_comb[0], bg_stage_3_2_comb[2]); // # ->
    compare_and_swap(bg_stage_3_2_comb[1], bg_stage_3_2_comb[3]); // # ->
    compare_and_swap(bg_stage_3_2_comb[4], bg_stage_3_2_comb[6]); // # ->
    compare_and_swap(bg_stage_3_2_comb[5], bg_stage_3_2_comb[7]); // # ->
end

///////////////////////
// STAGE 3.3 (6)
///////////////////////

// writing to regs
always @(posedge clk_i) begin
    bg_stage_3_3 <= bg_stage_3_2_comb;
end

always_comb begin
    bg_stage_3_3_comb = bg_stage_3_3;
    compare_and_swap(bg_stage_3_3_comb[0], bg_stage_3_3_comb[1]); // # ->
    compare_and_swap(bg_stage_3_3_comb[2], bg_stage_3_3_comb[3]); // # ->
    compare_and_swap(bg_stage_3_3_comb[4], bg_stage_3_3_comb[5]); // # ->
    compare_and_swap(bg_stage_3_3_comb[6], bg_stage_3_3_comb[7]); // # ->
end

// ---------------------------------------------------------- //

///////////////////////
// Copy to output
///////////////////////

always @(posedge clk_i) begin
    bg_stage_output <= bg_stage_3_3_comb;
end

assign sorted_list_o = bg_stage_output;

endmodule
